#! /bin/bash -l

#SBATCH -J tf_archimob
#SBATCH -o tf_archimob.%j.out
#SBATCH -e tf_archimob.%j.err
#SBATCH --mem-per-cpu=12G
#SBATCH -p gpu
#SBATCH --gres=gpu:v100:1
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -t 72:00:00

module use -a /projappl/nlpl/software/modules/etc
module load nlpl-mttools
module load nlpl-opennmt-py

for LG in archimob1a archimob1b archimob1c gos1a gos1b gos1c; do
	onmt_translate -model $LG/model_best.pt -src ../data/$LG/test_unigram500.src -output $LG/test_pred.tgt -replace_unk -max_length 1000 -min_length 1 -length_penalty wu -alpha 0.6
done
