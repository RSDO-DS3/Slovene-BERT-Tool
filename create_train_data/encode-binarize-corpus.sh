#!/bin/bash

train="path/to/corpus.txt.train" # corpora as split by preprocess_corpora/split_corpus.py
eval="path/to/corpus.txt.eval"
test="path/to/corpus.txt.test"

# encode raw text corpora into sentencepiece pieces
for textcorpus in train eval test
do
    spm_encode --model=sl_spm.model --output_format=piece < ${textcorpus} > ${textcorpus}.encoded
done

# preprocess/binarize using the dictionary from create_train_data/train_sentencepiece_model.sh
# very important that it is the same dict.txt file
fairseq-preprocess \
    --only-source \
    --srcdict dict.txt \
    --trainpref ${train}.encoded \
    --validpref ${eval}.encoded \
    --testpref ${test}.encoded \
    --destdir binary_data \
    --workers 8 # match the number of workers with the number of CPU threads of the computer which runs preprocess
