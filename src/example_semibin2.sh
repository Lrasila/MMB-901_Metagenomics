#!/bin/bash -l
#SBATCH --job-name=semibin2
#SBATCH --account=project_XXXXXXX
#SBATCH --partition=small
#SBATCH --time=02:00:00
#SBATCH --cpus-per-task=8
#SBATCH --mem=50G
#SBATCH --bb="#BB_LUA SBF storagesize=100G path=/sbf/data"
#SBATCH --output=00_LOGS/semibin2_%j.out

module load bio-apps/v202603
module load py-semibin/2.6.0

mkdir -p 00_LOGS
mkdir -p 05_BINNING/SemiBin2

SemiBin2 single_easy_bin \
    --input-fasta 02_ASSEMBLY/contigs_filtered.fasta \
    --input-bam 04_MAPPING/*.sorted.bam \
    --tmpdir /sbf/data \
    --threads $SLURM_CPUS_PER_TASK \
    --output 05_BINNING/SemiBin2/
