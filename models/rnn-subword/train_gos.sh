#! /bin/bash -l

#SBATCH -J rnn-gos
#SBATCH -o rnn-gos.%j.out
#SBATCH -e rnn-gos.%j.err
#SBATCH --mem-per-cpu=8G
#SBATCH -p gpu
#SBATCH --gres=gpu:v100:1
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -t 48:00:00

module use -a /projappl/nlpl/software/modules/etc
module load nlpl-mttools
module load nlpl-opennmt-py

for LG in gos1a gos1b; do
	echo $LG
	sed 's/LG/'"$LG"'/g' < config_archimob_gos.yaml > config_"$LG".yaml
	onmt_build_vocab -config config_"$LG".yaml -n_sample -1
	onmt_train -config config_"$LG".yaml 2> $LG/train.log
	BEST=`grep -Po 'Best model found at step \K(\d+)$' $LG/train.log`
	if [ -z "$BEST" ];
	then
		BEST=`ls -1v $LG/model_step* | tail -n 1 | grep -Po '\d{2,}'`
	fi
	echo $BEST
	cd $LG; ln -s model_step_"$BEST".pt model_best.pt; cd ../

	onmt_translate -model $LG/model_best.pt -src ../data/$LG/dev_unigram500.src -output $LG/dev_pred.tgt -replace_unk -max_length 1000 -min_length 1 -length_penalty wu -alpha 0.6
done
