# Conversion and evaluation scripts

## Data conversion

- `makeData.sh` calls `convert_sent.py` and `convert_3gram.py` to produce character-segmented training and test data (for SMT, TF, RNN).
- `makeRef.sh` calls `makeSentRef.py` (and analogously `makeTrigramRef.py`) to produce the reference translations for evaluation (1 sentence per line).
- `convert_csv.py` reformats the original file into CSV files with header for use with ByT5.

## Evaluation

`evaluate.sh` uses a variety of scripts to produce the different scores and baseline results:
- [sacrebleu](https://github.com/mjpost/sacrebleu) is used to obtain chrF scores.
- [`wer++.py`](https://github.com/nsmartinez/WERpp) is used to obtain WER and CER scores.
- `align.py` re-aligns the predictions with the source to produce verticalized files with one source word per row.
- `normEval.py` (from the [MultiLexNorm project](https://bitbucket.org/robvanderg/multilexnorm)) provides word-level accuracy, error reduction rate and LAI baseline scores.
- `baseline.py` (from the [MultiLexNorm project](https://bitbucket.org/robvanderg/multilexnorm)) is used to produce the MFR baseline.
