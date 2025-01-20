#!/bin/bash
#SBATCH --job-name=hpl-mxp-single
#SBATCH --nodelist=worker-7
#SBATCH --gpus-per-node=8
#SBATCH --ntasks-per-node=8

#SBATCH --time=72:00:00
#SBATCH --output=logs/%x-%j.out
#SBATCH --error=logs/%x-%j.err
#SBATCH --exclusive


# export CONT=nvcr.io#nvidia/hpc-benchmarks:24.09
export CONT=nvcr.io#nvidia/hpc-benchmarks:24.03
# export GDRCOPY_ENABLE_LOGGING=1
outputs_mount="./outputs:/workspace/outputs"
CONTAINER_MOUNTS="${outputs_mount}"
NSYSCMD="nsys profile --sample=none --cpuctxsw=none  --trace=cuda,nvtx --cuda-graph-trace=node --nic-metrics=true --gpu-metrics-device=all --force-overwrite true --output /workspace/outputs/profile-${SLURM_JOB_NAME}-${SLURM_JOBID}.nsys-rep "

sloppy_type=2


srun \
    --cpu-bind=none \
    --mem-bind=none \
    --container-image="${CONT}" \
    --container-mounts="${CONTAINER_MOUNTS}" \
    --mpi=pmix \
    bash -c "
        if [[ \$SLURM_PROCID -eq 0 ]]; then
            ${NSYSCMD} ./hpl-mxp.sh \
                --gpu-affinity 0:1:2:3:4:5:6:7 \
                --mem-affinity 0:0:0:0:1:1:1:1 \
                --ucx-affinity mlx5_4:mlx5_5:mlx5_6:mlx5_7:mlx5_0:mlx5_1:mlx5_2:mlx5_3 \
                --cpu-affinity 0-15:16-31:32-47:48-63:64-79:80-95:96-111:112-127 \
                --n 380000 \
                --nb 2048 \
                --nprow 2 \
                --npcol 4 \
                --nporder row \
                --preset-gemm-kernel 0 \
                --u-panel-chunk-nbs 16 \
                --use-mpi-panel-broadcast 50 \
                --sloppy-type ${sloppy_type} \
                --call-dgemv-with-multiple-threads 0 \
                --Anq-device 0 \
                --mpi-use-mpi 1 \
                --prioritize-trsm 0 \
                --prioritize-factorization 1
        else
            ./hpl-mxp.sh \
                --gpu-affinity 0:1:2:3:4:5:6:7 \
                --mem-affinity 0:0:0:0:1:1:1:1 \
                --ucx-affinity mlx5_4:mlx5_5:mlx5_6:mlx5_7:mlx5_0:mlx5_1:mlx5_2:mlx5_3 \
                --cpu-affinity 0-15:16-31:32-47:48-63:64-79:80-95:96-111:112-127 \
                --n 380000 \
                --nb 2048 \
                --nprow 2 \
                --npcol 4 \
                --nporder row \
                --preset-gemm-kernel 0 \
                --u-panel-chunk-nbs 16 \
                --use-mpi-panel-broadcast 50 \
                --sloppy-type ${sloppy_type} \
                --call-dgemv-with-multiple-threads 0 \
                --Anq-device 0 \
                --mpi-use-mpi 1 \
                --prioritize-trsm 0 \
                --prioritize-factorization 1
        fi
    "