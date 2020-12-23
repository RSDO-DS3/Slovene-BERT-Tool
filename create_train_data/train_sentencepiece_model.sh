#!/bin/bash
# Usage: bash train_sentencepiece_model.sh corpora_for_vocab.txt

inputcorpora=$1 # path to corpora file(s) used to train a sentencepiece model
modelname="sl_spm" # name/prefix of sentencepiece model
spm_train --input=${inputcorpora} --model_prefix=${modelname} --vocab_size=32000 --character_coverage=0.99999 --model_type=bpe

# Translate sl_spm.vocab to dict.txt
cat ${modelname}.vocab | awk '{print $1" 999"}' > dict.txt
# Depending on fairseq version and/or other libraries versions,
# dict.txt might need #fairseq:overwrite appended to first 3 lines, comment the following line if not needed
sed -i '1s/$/ #fairseq:overwrite/;2s/$/ #fairseq:overwrite/;3s/$/ #fairseq:overwrite/' dict.txt
