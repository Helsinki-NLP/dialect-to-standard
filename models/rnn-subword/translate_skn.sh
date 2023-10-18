#! /bin/bash -l

#SBATCH -J rnn_skn
#SBATCH -o rnn_skn.%j.out
#SBATCH -e rnn_skn.%j.err
#SBATCH --mem-per-cpu=12G
#SBATCH -p gpu
#SBATCH --gres=gpu:v100:1
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -t 48:00:00

module use -a /projappl/nlpl/software/modules/etc
module load nlpl-mttools
module load nlpl-opennmt-py

for LG in skn1a skn1b skn1c skn2a skn2b skn2c skn3a skn3b skn3c; do
	onmt_translate -model $LG/model_best.pt -src ../data/$LG/test_unigram200.src -output $LG/test_pred.tgt -replace_unk -max_length 1000 -min_length 1 -length_penalty wu -alpha 0.6
done
