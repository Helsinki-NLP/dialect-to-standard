#! /bin/bash -l

#SBATCH -J csmt
#SBATCH -o csmt.%j.out
#SBATCH -e csmt.%j.err
#SBATCH -p small
#SBATCH -n 1
#SBATCH -N 1
#SBATCH --cpus-per-task 8
#SBATCH --mem-per-cpu=20G
#SBATCH -t 72:00:00

set -e
module use -a /projappl/nlpl/software/modules/etc/

for LG in archimob1; do
	module load nlpl-efmaral
	echo $LG "Alignment (eflomal)"
	align_eflomal.py -s $LG/train.src -t $LG/train.tgt -f $LG/train.fwd -r $LG/train.rev
	atools -c grow-diag-final-and -i"$LG/train.fwd" -j"$LG/train.rev" > $LG/train.sym

	module load nlpl-moses
	MOSESSCRIPTS=/projappl/nlpl/software/modules/moses/4.0.1-3990724/moses/scripts
	MOSESBIN=/projappl/nlpl/software/modules/moses/4.0.1-3990724/moses/bin
	NTHR=6
	NGRAM=10

	echo $LG "LM"
	lmplz -o $NGRAM --discount_fallback -T $PWD/tmp < $LG/train.lm1.tgt 1> $LG/lm.arpa 2>> $LG/training.log
	build_binary $LG/lm.arpa $LG/lm.blm >> $LG/training.log 2>&1

	echo $LG "Moses"
	mkdir -p $LG/model
	train-model.perl --first-step 4 -root-dir $LG -corpus $LG/train -f src -e tgt --max-phrase-length $NGRAM --alignment-file $LG/train --alignment sym -lm 0:$NGRAM:$PWD/$LG/lm.blm:8 -cores $NTHR >> $LG/training.log 2>&1
	python3 ../fixDistortion.py < $LG/model/moses.ini > $LG/model/moses_mod.ini

	echo $LG "MERT"
	$MOSESSCRIPTS/training/mert-moses.pl $LG/dev.src $LG/dev.tgt $MOSESBIN/moses $PWD/$LG/model/moses_mod.ini --mertdir $MOSESBIN --working-dir $PWD/$LG/mert-work/ --mertargs="--sctype WER" --decoder-flags="-threads $NTHR" 1>> $LG/training.log 2> $LG/mert.log

	echo $LG "Predict"
	moses -dl 0 -threads $NTHR -f $LG/mert-work/moses.ini < $LG/dev.src 1> $LG/dev_pred.tgt

	module load python-data
	export PYTHONPATH=/scratch/project_2005047/dialect-to-standard/pyenv3.10-edlib/lib/python3.10/site-packages/
	source ../../dialect-to-standard/pyenv3.10-edlib/bin/activate
	echo $LG "Align"
	python3 ../scripts/align.py $LG/dev.src $LG/dev_pred.tgt ../data/$LG/dev.norm $LG/dev_aligned.txt
	deactivate

	echo $LG "Done"
done
