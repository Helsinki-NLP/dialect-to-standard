#! /bin/bash

echo "" > eval_results.txt

MODEL=smt-char

for LG in archimob1 gos1 skn1 ndc1 skn2 ndc2 skn3 ndc3; do
    for SPLIT in a b c ; do
        echo $LG $SPLIT
        echo $LG $SPLIT >> eval_results.txt

        # compute chrF, WER and CER
        echo "chrF" >> eval_results.txt
        sacrebleu ../processed_data/"$LG$SPLIT"/test.ref -m chrf < ../models/$MODEL/test_predictions/"$LG$SPLIT"/test_pred.tgt | jq -r .score >> eval_results.txt
        echo "WER" >> eval_results.txt
        python3 wer++.py ../models/$MODEL/test_predictions/"$LG$SPLIT"/test_pred.tgt ../processed_data/"$LG$SPLIT"/test.ref >> eval_results.txt
        echo "CER" >> eval_results.txt
        python3 wer++.py ../models/$MODEL/test_predictions/"$LG$SPLIT"/test_pred.tgt .../processed_data/"$LG$SPLIT"/test.ref >> eval_results.txt

        # realign on word level
        python3 align.py ../processed_data/"$LG$SPLIT"/test.src ../models/$MODEL/test_predictions/"$LG$SPLIT"/test_pred.tgt ../data/"$LG$SPLIT"/test.norm ../models/$MODEL/test_predictions/"$LG$SPLIT"/test_aligned.txt

        # word-level evaluation with normEval.py
        python3 normEval.py --gold ../data/"$LG$SPLIT"/test.norm --pred ../models/$MODEL/test_predictions/"$LG$SPLIT"/test_aligned.txt >> eval_results.txt
        echo "" >> eval_results.txt

	# MFR baseline:
	# python3 baseline.py --method mfr --train ../data/"$LG$SPLIT"/train.norm --dev ../data/"$LG$SPLIT"/test.norm --out mfr."$LG$SPLIT".test.pred >> eval_results.txt
    done
done

