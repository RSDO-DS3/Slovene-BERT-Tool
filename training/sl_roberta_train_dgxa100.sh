#!/bin/bash
#SBATCH --time=4-0:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --job-name=roberta_sl
#SBATCH --gpus-per-task=4
#SBATCH --cpus-per-gpu=2

TOTAL_UPDATES=200000            # Total number of training steps
WARMUP_UPDATES=10000            # Warmup the learning rate over this many updates
PEAK_LR=0.0005                  # Peak learning rate, adjust as needed
TOKENS_PER_SAMPLE=512           # Max sequence length
MAX_POSITIONS=512               # Num. positional embeddings (usually same as above)
MAX_SENTENCES=16                # Number of sequences per batch (batch size)
NUM_GPUS=4
MAX_TOKENS=$((5120*$NUM_GPUS))  # For 4 gpus use 20480, for 1 use 5120, for 2 use 10240
UPDATE_FREQ=$((128/$NUM_GPUS))  # Increase the batch size 32x (for 4 gpus), 64x for 2 gpus, 128x for 1 gpu


CURR_EPOCH=0 # How many epochs already trained for

DATA_DIR=/root/sl/sl_roberta_preprocessed
CHECKPOINT_DIR=/root/sl/checkpoints

# the following 2 should be done by hand in user's home folder
#mkdir -p sl/checkpoints
#tar xzf sl_roberta_preprocessed.tar.gz -C sl/

if [ $CURR_EPOCH -gt 0 ]
then
    srun --container-image ~/roberta-container.sqsh --container-mount-home \
    fairseq-train --fp16 $DATA_DIR \
        --task masked_lm --criterion masked_lm \
        --arch roberta_base --sample-break-mode complete --tokens-per-sample $TOKENS_PER_SAMPLE \
        --optimizer adam --adam-betas '(0.9,0.98)' --adam-eps 1e-6 --clip-norm 0.0 \
        --lr-scheduler polynomial_decay --lr $PEAK_LR --warmup-updates $WARMUP_UPDATES --total-num-update $TOTAL_UPDATES \
        --dropout 0.1 --attention-dropout 0.1 --weight-decay 0.01 \
        --max-tokens $MAX_TOKENS \
        --update-freq $UPDATE_FREQ \
        --max-update $TOTAL_UPDATES --log-format simple --log-interval 1 \
        --skip-invalid-size-inputs-valid-test \
        --mask-whole-words \
        --bpe sentencepiece \
        --sentencepiece-model /root/sl_spm.model \
        --keep-last-epochs 2 \
        --num-workers 2 \
        --restore-file ${CHECKPOINT_DIR}/checkpoint${CURR_EPOCH}.pt \
        --save-dir $CHECKPOINT_DIR >> trainout.txt 2>> trainerr.txt
else
    srun --container-image ~/roberta-container.sqsh --container-mount-home \
    fairseq-train --fp16 $DATA_DIR \
        --task masked_lm --criterion masked_lm \
        --arch roberta_base --sample-break-mode complete --tokens-per-sample $TOKENS_PER_SAMPLE \
        --optimizer adam --adam-betas '(0.9,0.98)' --adam-eps 1e-6 --clip-norm 0.0 \
        --lr-scheduler polynomial_decay --lr $PEAK_LR --warmup-updates $WARMUP_UPDATES --total-num-update $TOTAL_UPDATES \
        --dropout 0.1 --attention-dropout 0.1 --weight-decay 0.01 \
        --max-tokens $MAX_TOKENS \
        --update-freq $UPDATE_FREQ \
        --max-update $TOTAL_UPDATES --log-format simple --log-interval 1 \
        --skip-invalid-size-inputs-valid-test \
        --mask-whole-words \
        --bpe sentencepiece \
        --sentencepiece-model /root/sl_spm.model \
        --keep-last-epochs 2 \
        --num-workers 2 \
        --save-dir $CHECKPOINT_DIR >> trainout.txt 2>> trainerr.txt
