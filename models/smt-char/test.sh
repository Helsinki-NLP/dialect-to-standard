#! /bin/bash -l

#SBATCH -J testmoses
#SBATCH -o testmoses.%j.out
#SBATCH -e testmoses.%j.err
#SBATCH -p small
#SBATCH -n 1
#SBATCH -N 1
#SBATCH --cpus-per-task 8
#SBATCH --mem-per-cpu=12G
#SBATCH -A project_2005047
#SBATCH --mail-user=olli.kuparinen@helsinki.fi
#SBATCH --mail-type=ALL
#SBATCH -t 24:00:00

module use -a /projappl/nlpl/software/modules/etc/
module load nlpl-moses

MOSESBIN=/projappl/nlpl/software/modules/moses/4.0-a89691f/moses/bin
NTHR=6
#NTHR=1

#for LG in archimob1 gos1 skn1 ndc1 skn2 ndc2; do
#gos1 skn1 ndc1 skn2 ndc2 
for LG in skn1c skn2c skn3c ndc1c ndc2c ndc3c gos1c archimob1c; do
	$MOSESBIN/moses -dl 0 -threads $NTHR -f $LG/mert-work/moses.ini < ../data/$LG/test.src 1> $LG/test_pred.tgt
 	#$MOSESBIN/moses -dl 0 -threads $NTHR -f all/mert-work/moses.ini < ../csmtdata/$LG/dev.src 1> all/dev_pred_"$LG".tgt
done

module load python-data
export PYTHONPATH=/scratch/project_2005047/dialect-to-standard/pyenv3.10-edlib/lib/python3.10/site-packages/
source ../../dialect-to-standard/pyenv3.10-edlib/bin/activate

#for LG in archimob1 gos1 skn1 ndc1 skn2 ndc2; do
#gos1 skn1 ndc1 skn2 ndc2 
for LG in skn1c skn2c skn3c ndc1c ndc2c ndc3c gos1c archimob1c; do
	echo $LG
	python3 ../align.py ../data/$LG/test.src $LG/test_pred.tgt ../data/$LG/test.norm $LG/test_aligned.txt
#	python3 ../align.py ../csmtdata/$LG/dev.src $LG/dev_pred.tgt ../splitdata/$LG/dev.norm $LG/dev_aligned.txt
done

deactivate
