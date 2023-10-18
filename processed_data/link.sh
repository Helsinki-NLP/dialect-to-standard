#! /bin/bash

for LG in archimob1 gos1 skn1 skn2 skn3 ndc1 ndc2 ndc3; do
	for SPLIT in a b c; do
		mkdir "$LG$SPLIT"
		cd "$LG$SPLIT"
		ln -s ../../../dial-to-stand/data/"$LG$SPLIT"/train.src .
		ln -s ../../../dial-to-stand/data/"$LG$SPLIT"/train.tgt .
		ln -s ../../../dial-to-stand/data/"$LG$SPLIT"/dev.src .
		ln -s ../../../dial-to-stand/data/"$LG$SPLIT"/dev.tgt .
		ln -s ../../../dial-to-stand/data/"$LG$SPLIT"/dev.ref .
		ln -s ../../../dial-to-stand/data/"$LG$SPLIT"/test.src .
		ln -s ../../../dial-to-stand/data/"$LG$SPLIT"/test.tgt .
		ln -s ../../../dial-to-stand/data/"$LG$SPLIT"/test.ref .
		ln -s ../../../dial-to-stand/data/"$LG$SPLIT"/train_3gram.src .
		ln -s ../../../dial-to-stand/data/"$LG$SPLIT"/train_3gram.tgt .
		ln -s ../../../dial-to-stand/data/"$LG$SPLIT"/dev_3gram.src .
		ln -s ../../../dial-to-stand/data/"$LG$SPLIT"/dev_3gram.tgt .
		ln -s ../../../dial-to-stand/data/"$LG$SPLIT"/test_3gram.src .
		ln -s ../../../dial-to-stand/data/"$LG$SPLIT"/test_3gram.tgt .
		cd ..
	done
done

for LG in archimob1 gos1; do
        for SPLIT in a b c; do
		cd "$LG$SPLIT"
		ln -s ../../../dial-to-stand/data/"$LG$SPLIT"/train_unigram500.src .
                ln -s ../../../dial-to-stand/data/"$LG$SPLIT"/train_unigram500.tgt .
                ln -s ../../../dial-to-stand/data/"$LG$SPLIT"/dev_unigram500.src .
                ln -s ../../../dial-to-stand/data/"$LG$SPLIT"/dev_unigram500.tgt .
                ln -s ../../../dial-to-stand/data/"$LG$SPLIT"/test_unigram500.src .
                ln -s ../../../dial-to-stand/data/"$LG$SPLIT"/test_unigram500.tgt .
		cd ..
	done
done

for LG in ndc1 ndc2 ndc3; do
        for SPLIT in a b c; do
                cd "$LG$SPLIT"
                ln -s ../../../dial-to-stand/data/"$LG$SPLIT"/train_unigram2000.src .
                ln -s ../../../dial-to-stand/data/"$LG$SPLIT"/train_unigram2000.tgt .
                ln -s ../../../dial-to-stand/data/"$LG$SPLIT"/dev_unigram2000.src .
                ln -s ../../../dial-to-stand/data/"$LG$SPLIT"/dev_unigram2000.tgt .
                ln -s ../../../dial-to-stand/data/"$LG$SPLIT"/test_unigram2000.src .
                ln -s ../../../dial-to-stand/data/"$LG$SPLIT"/test_unigram2000.tgt .
                cd ..
        done
done

for LG in skn1 skn2 skn3; do
        for SPLIT in a b c; do
                cd "$LG$SPLIT"
                ln -s ../../../dial-to-stand/data/"$LG$SPLIT"/train_unigram200.src .
                ln -s ../../../dial-to-stand/data/"$LG$SPLIT"/train_unigram200.tgt .
                ln -s ../../../dial-to-stand/data/"$LG$SPLIT"/dev_unigram200.src .
                ln -s ../../../dial-to-stand/data/"$LG$SPLIT"/dev_unigram200.tgt .
                ln -s ../../../dial-to-stand/data/"$LG$SPLIT"/test_unigram200.src .
                ln -s ../../../dial-to-stand/data/"$LG$SPLIT"/test_unigram200.tgt .
                cd ..
        done
done
