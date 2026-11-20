#!/bin/bash -l
#SBATCH --job-name mapping
#SBATCH --output 00_LOGS/mapping_%A_%a.out
#SBATCH --error 00_LOGS/mapping_%A_%a.err
#SBATCH --time 00:30:00
#SBATCH --nodes 1
#SBATCH --ntasks-per-node 1
#SBATCH --cpus-per-task 8
#SBATCH --mem 12G
#SBATCH --account project_XXXXXXX
#SBATCH --array=1-9

module purge
module load bio-apps/v202603
module load bowtie2/2.5.4
module load samtools/1.24

mkdir -p 04_MAPPING

SAMPLE_ACC=$(sed -n ${SLURM_ARRAY_TASK_ID}p 01_DATA/DF16_accessions.txt)

bowtie2 \
    -x 04_MAPPING/contigs \
    -1 01_DATA/${SAMPLE_ACC}_1.fastq.gz \
    -2 01_DATA/${SAMPLE_ACC}_2.fastq.gz \
    -p $SLURM_CPUS_PER_TASK \
    | samtools sort \
        -@ $SLURM_CPUS_PER_TASK \
        -o 04_MAPPING/${SAMPLE_ACC}.sorted.bam -

samtools index 04_MAPPING/${SAMPLE_ACC}.sorted.bam
