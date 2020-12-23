#!/bin/bash
# Dependencies needed to be installed for training the model
apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    gcc-multilib \
    libatlas-base-dev \
    libboost-all-dev \
    libhdf5-serial-dev \
    libprotobuf-dev \
    protobuf-compiler \
    libopenblas-dev \
    gfortran \
    libcurl4-openssl-dev \
    python3-pip \
    python3-setuptools \
    pkg-config \
    cmake \
    wget \
    cython \
    git
    
apt-get clean

pip3 install numpy
pip3 install --pre torch torchvision torchaudio -f https://download.pytorch.org/whl/nightly/cu110/torch_nightly.html
pip3 install sentencepiece
git clone https://github.com/NVIDIA/apex && cd apex && \
    pip3 install -v --no-cache-dir --global-option="--cpp_ext" --global-option="--cuda_ext" \
        --global-option="--deprecated_fused_adam" --global-option="--xentropy" \
        --global-option="--fast_multihead_attn" ./ && cd

git clone https://github.com/pytorch/fairseq && cd fairseq && pip3 install --editable ./ && cd 
pip3 install pyarrow
