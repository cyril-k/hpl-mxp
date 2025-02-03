#!/bin/bash
#SBATCH --job-name "hpl.1N"
#SBATCH --time=40:00
#SBATCH --output=logs/enroot-%x.%J.%N.out
#SBATCH --ntasks-per-node=8
#SBATCH --cpus-per-task=16
#SBATCH --gpus-per-node=8
#SBATCH -N1

DATEFORMAT="+%Y-%m-%dT%H:%M:%S"

# CONT='nvcr.io#nvidia/hpc-benchmarks:24.03'
CONT='nvcr.io#nvidia/hpc-benchmarks:24.09'

echo "Running on hosts: $(echo $(scontrol show hostname))"
echo "Started at $(date $DATEFORMAT)"

srun -N1 --ntasks-per-node=8 --cpu-bind=none --mem-bind=none --container-image="${CONT}" --mpi=pmix \
      ./hpl.sh --dat /workspace/hpl-linux-x86_64/sample-dat/HPL-dgx-1N.dat

echo "Finished at $(date $DATEFORMAT)"