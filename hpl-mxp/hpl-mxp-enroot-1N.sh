#!/bin/bash
#SBATCH --job-name "test-hpl-mxp.1N"
#SBATCH --time=40:00
#SBATCH --output=enroot-%x.%J.%N.out
#SBATCH --gpus-per-node=8

DATEFORMAT="+%Y-%m-%dT%H:%M:%S"

CONT='nvcr.io#nvidia/hpc-benchmarks:24.03'

echo "Running on hosts: $(echo $(scontrol show hostname))"
echo "Started at $(date $DATEFORMAT)"

#FP16
sloppy_type=2
srun -N1 --ntasks-per-node=8 --cpu-bind=none --mem-bind=none --container-image="${CONT}" --mpi=pmix \
      ./hpl-mxp.sh \
      --gpu-affinity 0:1:2:3:4:5:6:7 --mem-affinity 0:0:0:0:1:1:1:1 \
      --cpu-affinity 0-15:16-31:32-47:48-63:64-79:80-95:96-111:112-127 --ucx-affinity mlx5_4:mlx5_5:mlx5_6:mlx5_7:mlx5_0:mlx5_1:mlx5_2:mlx5_3 \
      --n 380000 --nb 2048 --nprow 4 --npcol 2 --nporder row \
      --preset-gemm-kernel 0 --u-panel-chunk-nbs 16  --use-mpi-panel-broadcast 50 --sloppy-type ${sloppy_type} \
      --call-dgemv-with-multiple-threads 0 --Anq-device 0 --mpi-use-mpi 0 --prioritize-trsm 0 --prioritize-factorization 1

#FP8
sloppy_type=1
srun -N1 --ntasks-per-node=8 --cpu-bind=none --mem-bind=none --container-image="${CONT}" --mpi=pmix \
      ./hpl-mxp.sh \
      --gpu-affinity 0:1:2:3:4:5:6:7 --mem-affinity 0:0:0:0:1:1:1:1 \
      --cpu-affinity 0-15:16-31:32-47:48-63:64-79:80-95:96-111:112-127 --ucx-affinity mlx5_4:mlx5_5:mlx5_6:mlx5_7:mlx5_0:mlx5_1:mlx5_2:mlx5_3 \
      --n 380000 --nb 4096 --nprow 4 --npcol 2 --nporder row \
      --preset-gemm-kernel 0 --u-panel-chunk-nbs 8 --use-mpi-panel-broadcast 50 --sloppy-type ${sloppy_type} \
      --call-dgemv-with-multiple-threads 0 --Anq-device 0 --mpi-use-mpi 0 --prioritize-trsm 0 --prioritize-factorization 1

echo "Finished at $(date $DATEFORMAT)"