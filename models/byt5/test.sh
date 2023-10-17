#! /bin/bash -l

#SBATCH -J translate_byt5
#SBATCH -o translate_byt5.%j.out
#SBATCH -e translate_byt5.%j.err
#SBATCH --mem-per-cpu=12G
#SBATCH -p gpu
#SBATCH --gres=gpu:v100:1
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -t 24:00:00

module load pytorch

for LG in skn2 ndc2 skn3 ndc3; do
	python3 trans.py $LG/train.csv $LG/dev.csv $LG/dev.src $LG/dev_pred.tgt $LG/outputs/simplet5-epoch-4*
	python3 trans.py $LG/train.csv $LG/dev.csv $LG/test.src $LG/test_pred.tgt $LG/outputs/simplet5-epoch-4*
done
