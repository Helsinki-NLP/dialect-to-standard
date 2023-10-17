#! /bin/bash -l

#SBATCH -J train_byt5
#SBATCH -o train_byt5.%j.out
#SBATCH -e train_byt5.%j.err
#SBATCH --mem-per-cpu=12G
#SBATCH -p gpu
#SBATCH --gres=gpu:v100:1
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -t 72:00:00

module load pytorch

for LG in ndc2a ndc3a; do
	mkdir $LG
	python3 ../../scripts/convert_csv.py ../../data/$LG/train.norm $LG/train.csv
	python3 ../../scripts/convert_csv.py ../../data/$LG/dev.norm $LG/dev.csv
	python3 ../../scripts/convert_csv.py ../../data/$LG/test.norm $LG/test.csv
	cut -f 1 $LG/dev.csv > $LG/dev.src
	cut -f 1 $LG/test.csv > $LG/test.src
	sed -i '1d' $LG/dev.src
	sed -i '1d' $LG/test.src

	mkdir $LG/outputs
	python3 train.py $LG/train.csv $LG/dev.csv $LG/outputs
done

