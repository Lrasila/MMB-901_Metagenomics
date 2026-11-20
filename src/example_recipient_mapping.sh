#!/bin/bash
#SBATCH --job-name=Mapping
#SBATCH --account=project_2022405
#SBATCH --time=3:00:00
#SBATCH --cpus-per-task=16
#SBATCH --mem=40G
#SBATCH --output=Mapping_%j.out
#SBATCH --error=Mapping_%j.err

set -euo pipefail

module load bio-apps/v202603
module load bowtie2/2.5.4
module load samtools/1.24

READS="/scratch/project_2022405/$USER/MMB-901_Metagenomics/08_RECIPIENTS"
INDEX="/scratch/project_2022405/$USER/MMB-901_Metagenomics/04_MAPPING/contigs"
OUT="/scratch/project_2022405/$USER/MMB-901_Metagenomics/08_RECIPIENTS/MAPPING"


for R1 in "$READS"/*_1.fastq.gz; do

    SAMPLE=$(basename "$R1" _1.fastq.gz)
    R2="$READS/${SAMPLE}_2.fastq.gz"

    bowtie2 -p "$SLURM_CPUS_PER_TASK" \
        -x "$INDEX" \
        -1 "$R1" \
        -2 "$R2" \
    | samtools sort -@ "$SLURM_CPUS_PER_TASK" -o "$OUT/${SAMPLE}.sorted.bam" -

    samtools index "$OUT/${SAMPLE}.sorted.bam"

done
