#! /bin/bash -l

#SBATCH -J tf_ndc
#SBATCH -o tf_ndc.%j.out
#SBATCH -e tf_ndc.%j.err
#SBATCH --mem-per-cpu=12G
#SBATCH -p gpu
#SBATCH --gres=gpu:v100:1
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -t 72:00:00

module use -a /projappl/nlpl/software/modules/etc
module load nlpl-mttools
module load nlpl-opennmt-py

for LG in ndc1a ndc1b ndc1c ndc2a ndc2b ndc2c ndc3a ndc3b ndc3c; do
	onmt_translate -model $LG/model_best.pt -src ../data/$LG/test_unigram2000.src -output $LG/test_pred.tgt -replace_unk -max_length 1000 -min_length 1 -length_penalty wu -alpha 0.6
done
