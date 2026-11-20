#!/bin/bash -l
#SBATCH --job-name mapping
#SBATCH --output 00_LOGS/dastool_prep%A_%a.out
#SBATCH --error 00_LOGS/dastool_prep%A_%a.err
#SBATCH --time 00:30:00
#SBATCH --nodes 1
#SBATCH --ntasks-per-node 1
#SBATCH --cpus-per-task 8
#SBATCH --mem 5G
#SBATCH --account project_XXXXXX

# Load DAS Tool
module load bio-apps/v202603
export PATH="/projappl/project_2022405/das_tool-1.1.7/bin:$PATH"

# Input files
CONTIGS="/scratch/project_2022405/$USER/MMB-901_Metagenomics/02_ASSEMBLY/filtered_contigs.fasta"

SEMIBIN="/scratch/project_2022405/$USER/MMB-901_Metagenomics/05_BINNING/SemiBin2/output_bins"

METABAT="/scratch/project_2022405/$USER/MMB-901_Metagenomics/05_BINNING/METABAT"

# Output directory
OUTDIR="/scratch/project_2022405/parnanen/MMB-901_Metagenomics/06_DASTOOL/DF16"

mkdir -p "$OUTDIR"

# Convert SemiBin2 bins (.fa.gz)
mkdir -p "$TMPDIR/SemiBin2"

for f in "$SEMIBIN"/*.fa.gz; do
    [[ -e "$f" ]] || continue
    gunzip -c "$f" > "$TMPDIR/SemiBin2/$(basename "${f%.gz}")"
done

# Create contig-to-bin tables
Fasta_to_Contig2Bin.sh \
    -i "$TMPDIR/SemiBin2" \
    -e fa \
    > "$OUTDIR/SemiBin2_contigs2bin.tsv"

Fasta_to_Contig2Bin.sh \
    -i "$METABAT" \
    -e fa \
    > "$OUTDIR/MetaBAT2_contigs2bin.tsv"
