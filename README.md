# Dialect-to-Standard
Dialect-to-Standard dataset comprising Finnish, Norwegian, Slovene, and Swiss German dialects.

## Original corpora
When using the data, the original corpora must be referenced.

### SKN
The original data is downloadable here: https://korp.csc.fi/download/SKN/skn-vrt/

Citation instructions: https://www.kielipankki.fi/viittaus/?key=skn-vrt&lang=en

Following preprocessing steps are executed on the original data:
- Selecting the basic transcriptions instead of detailed ones.
- Removing punctuation.
- Excluding utterances that consist only of filler words (['mm', 'joo', 'ja', 'juu', 'niin', 'jo', 'kyllä', 'on', 'ei']).

### NDC
We utilize the word-aligned version of the data, detailed here: https://github.com/Helsinki-NLP/ndc-aligned

Citation instructions: https://tekstlab.uio.no/nota/NorDiaSyn/english/index.html

Following preprocessing steps are executed:
- Removing punctuation and pause markers.
- Substituting name tags with capital X.
- Excluding utterances that consist only of filler words (["ja", "mm", "nei", "å", "m", "e", "ok", "da", "jaha", "hæ", "hm", "oi", "og", "så", "jo", "ehe", "men", "jaha", "mhm", "det", "akkurat", "em", "mm"])

### Archimob
The original data is downloadable here: https://spur.uzh.ch/en/departments/research/textgroup/ArchiMob.html

Following preprocessing steps are executed:
- Only using the six manually normalized files.
- Substituting name tags with capital X.
- Excluding utterances that consist only of filler words (['ja', 'nein', 'und', 'so', 'mh', 'aha', 'jaja', 'ha-a', 'he-e', 'heh', 'äääh', 'oh', 'ah', 'X']).

### GOS
The original data is downloadable here: https://www.clarin.si/repository/xmlui/handle/11356/1438

Citation instructions: http://eng.slovenscina.eu/korpusi/gos

Following preprocessing steps are executed:
- Only using the data from a filtered set of speakers (in 'filtered-speakers.csv').
- Removing punctuation.
- Excluding sequences using foreign words (mainly German and Italian).
- Substituting name tags with capital X.
- Excluding utterances that consist only of filler words (['eee', 'eem', 'mhm', 'aha', 'ja', 'ne', 'X']).

## Splits
All datasets have split 1. Each file is split 80 % to training, 10 % to development and 10 % to test set. The difference between 1a, 1b and 1c is a different seed for random selection and shuffling.

SKN and NDC also have splits 2 and 3. 
In split 2, 80 % of speakers are in training, 10 % in development and 10 % in test set. Each location is presented in the training. The speakers in each set are assigned at random, but ensuring minimal overlap between 2a, 2b and 2c.
In split 3, 80 % of locations are in training, 10 % in development and 10 % in test set. The locations in each set are assigned at random so that they do not overlap between 3a, 3b and 3c.
