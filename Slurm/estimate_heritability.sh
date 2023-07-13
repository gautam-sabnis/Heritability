#!/bin/bash
#SBATCH -J estimate_heritability
#SBATCH -q batch -p compute
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -t 00:10:00
#SBATCH --mem=8GB
#SBATCH --array=1-60

#Number of arrays jobs is equal to the number of traits.

kinship_file=kinship_mat
name=vame_12k_heritability
anno=anno_vame_12k_2023-04-03.txt
geno=geno_vame_12k_2023-04-03.txt.gz
pheno=pheno_vame_12k_2023-04-03.txt
covars=covar_vame_12k_2023-04-03.txt

module load singularity
singularity exec -B/projects /projects/kumar-lab/sabnig/GWAS/Gemma.sif \
gemma -g /projects/kumar-lab/sabnig/GWAS/${geno} \
-p /projects/kumar-lab/sabnig/GWAS/${pheno} -n \
${SLURM_ARRAY_TASK_ID} \
-a /projects/kumar-lab/sabnig/GWAS/${anno} -lmm \
-k /projects/kumar-lab/sabnig/GWAS/output/${kinship_file}.cXX.txt \
-c /projects/kumar-lab/sabnig/GWAS/${covars} \
-o ${name}_${SLURM_ARRAY_TASK_ID} -w 1000 \
-s 10000 -seed 1


