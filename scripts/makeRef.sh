for CORPUS in archimob1 gos1 skn1 skn2 skn3 ndc1 ndc2 ndc3; do
	for SPLIT in a b c; do
		for DATA in dev test; do
			echo $CORPUS $SPLIT
        		python3 makeSentRef.py < "$CORPUS""$SPLIT"/"$DATA".tgt > "$CORPUS""$SPLIT"/"$DATA".ref
		done
	done
done

