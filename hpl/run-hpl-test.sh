#!/bin/bash
#SBATCH --job-name=hpl
#SBATCH --nodes=8
#SBATCH --gpus-per-node=8
#SBATCH --ntasks-per-node=8
#SBATCH --cpus-per-task=16

#SBATCH --time=72:00:00
#SBATCH --output=logs/%x-%j.out
#SBATCH --error=logs/%x-%j.err
#SBATCH --exclusive


# export CONT=nvcr.io#nvidia/hpc-benchmarks:24.09
export CONT=nvcr.io#nvidia/hpc-benchmarks:24.03

sloppy_type=2

srun \
    --cpu-bind=none \
    --mem-bind=none \
    --container-image="${CONT}" \
    --mpi=pmix \
    ./hpl.sh \
    --dat /workspace/hpl-linux-x86_64/sample-dat/HPL-64GPUs.dat
    