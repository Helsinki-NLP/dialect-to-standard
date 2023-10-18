#! /bin/bash -l

#SBATCH -J testmoses
#SBATCH -o testmoses.%j.out
#SBATCH -e testmoses.%j.err
#SBATCH -p small
#SBATCH -n 1
#SBATCH -N 1
#SBATCH --cpus-per-task 8
#SBATCH --mem-per-cpu=12G
#SBATCH -t 24:00:00

module use -a /projappl/nlpl/software/modules/etc/
module load nlpl-moses
module load nlpl-mttools/

MOSESBIN=/projappl/nlpl/software/modules/moses/4.0-a89691f/moses/bin
NTHR=6

for LG in archimob1c; do
	echo $LG "Predict"
        $MOSESBIN/moses -dl 0 -threads $NTHR -f $LG/mert-work/moses.ini < $LG/test.src 1> $LG/test_pred.tgt

        module load python-data
        export PYTHONPATH=/scratch/project_2005047/dial-to-stand/pyenv3.10-edlib/lib/python3.10/site-packages/
        source ../pyenv3.10-edlib/bin/activate
        echo $LG "Align"
        spm_decode --model=../data/sentencepiece/$LG/best.unigram.model --input_format=piece < $LG/test_pred.tgt > $LG/test_pred_clean.tgt
        python3 ../../scripts/align.py ../data/$LG/test.src $LG/test_pred_clean.tgt ../data/$LG/test.norm $LG/test_aligned.txt --detokenized
        deactivate

        echo $LG "Done"
done
