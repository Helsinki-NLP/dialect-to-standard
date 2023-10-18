# Processed data for NMT experiments

### Full-sentence data with character segmentation

- Files `train.src|tgt`, `dev.src|tgt|ref`, `test.src|tgt|ref`
- Generated from the `.norm` files with the script `convert_sent.py`
- Used for SMT, TF and RNN models

### 3-word window data with character segmentation

- Files `train_3gram.src|tgt`, `dev_3gram.src|tgt`, `test_3gram.src|tgt`
- Generated from the `.norm` files with the script `convert_3gram.py`
- Used for TF and RNN models

### Full-sentence data with subword segmentation

- Files `train_unigram*00.src|tgt`, `dev_unigram*00.src|tgt`, `test_unigram*00.src|tgt`
- Generated from the `.norm` files by applying standard sentence piece training
- Used for SMT, TF and RNN models

### Full-sentence data without word segmentation

- Files `train.csv`, `dev.csv`, `test.csv`
- Generated from the `.norm` files with the script `convert_csv.py`
- Used for ByT5 models

