#!/bin/bash

srun --container-image=nvidia/cuda:11.0-cudnn8-runtime-ubuntu18.04 --container-save=roberta-container.sqsh --container-mount-home bash /root/container_preparation_script.sh
