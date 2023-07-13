#!/bin/bash
#SBATCH -J estimate_heritability
#SBATCH -q batch -p compute
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -t 00:10:00
#SBATCH --mem=8GB

#Number of arrays jobs is equal to the number of traits. 

kinship_file=kinship_mat
anno=anno_vame_12k_2023-04-03.txt
geno=geno_vame_12k_2023-04-03.txt.gz
pheno=pheno_vame_12k_2023-04-03.txt


module load singularity
singularity exec -B/projects /projects/kumar-lab/sabnig/GWAS/Gemma.sif \
gemma -g /projects/kumar-lab/sabnig/GWAS/${geno} \
-p /projects/kumar-lab/sabnig/GWAS/${pheno} \
-a /projects/kumar-lab/sabnig/GWAS/${anno} \
-gk 1 -o ${kinship_file}


