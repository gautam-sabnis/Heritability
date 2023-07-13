#!/bin/bash
#SBATCH -J estimate_heritability
#SBATCH -q batch -p compute
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -t 00:02:00
#SBATCH --mem=1GB

#ntraits is equal to the number of traits.
ntraits=60

module load singularity
singularity exec -B/projects /projects/kumar-lab/sabnig/GWAS/mousegwas.sif \
Rscript extract_heritability.R -n ${ntraits} -o output -name vame_12k_heritability


