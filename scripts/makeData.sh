#! /bin/bash

#for LG in archimob1 gos1 skn1 ndc1 skn2 ndc2 skn3 ndc3; do
for LG in gos1; do
	for SPLIT in a b c; do
		for FILE in "$LG""$SPLIT"/*norm; do
			sed -i 's/_/ /g' $FILE
		done

		echo "$LG""$SPLIT"
		echo "sent"
        	python3 convert_sent.py --twt-data "$LG""$SPLIT"/train.norm --mode train --outprefix "$LG""$SPLIT"/train
        	python3 convert_sent.py --twt-data "$LG""$SPLIT"/dev.norm --mode dev --outprefix "$LG""$SPLIT"/dev
		python3 convert_sent.py --twt-data "$LG""$SPLIT"/test.norm --mode dev --outprefix "$LG""$SPLIT"/test
		
		echo "3gram"
		python3 convert_3gram.py "$LG""$SPLIT"/train.norm "$LG""$SPLIT"/train_3gram
		python3 convert_3gram.py "$LG""$SPLIT"/dev.norm "$LG""$SPLIT"/dev_3gram
		python3 convert_3gram.py "$LG""$SPLIT"/test.norm "$LG""$SPLIT"/test_3gram
	done
done
