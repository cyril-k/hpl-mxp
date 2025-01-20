#!/bin/bash
#SBATCH --job-name "hpl.4N"
#SBATCH --time=40:00
#SBATCH --output=logs/enroot-%x.%J.%N.out
#SBATCH --ntasks-per-node=8
#SBATCH --cpus-per-task=16
#SBATCH --gpus-per-node=8
#SBATCH -N8

DATESTRING=`date "+%Y-%m-%dT%H:%M:%S"`

# CONT='nvcr.io#nvidia/hpc-benchmarks:24.03'
CONT='nvcr.io#nvidia/hpc-benchmarks:24.09'

echo "Running on hosts: $(echo $(scontrol show hostname))"
echo "$DATESTRING"

srun -N8 --ntasks-per-node=8 --cpu-bind=none --mem-bind=none --container-image="${CONT}" --mpi=pmix \
      ./hpl.sh --dat /workspace/hpl-linux-x86_64/sample-dat/HPL-dgx-4N.dat


echo "Done"
echo "$DATESTRING"