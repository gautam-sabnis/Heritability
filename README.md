### Estimate Heritability
Estimate heritability using individual-level genotype data via *embarrassingly parallel* array jobs. 

#### Requirements
The pipeline is developed and tested in Linux and Mac OS environments. The following software and packages are required:

1. [R](https://www.r-project.org/)
2. [GEMMA](https://github.com/genetics-statistics/GEMMA)
3. [mousegwas](https://github.com/TheJacksonLaboratory/mousegwas)
4. [Singularity](https://sylabs.io/docs/)

`mousegwas` comes preinstalled with several packages. This pipeline needs to be run using a Slurm cluster. 

### Tutorial

You can download the pipeline by 

    cd ~
    git clone https://github.com/gautam-sabnis/heritability
    cd heritability

To create the singularity images, run, for example

    singularity build --fakeroot gemma.sif gemma.def


You'll need the following **input** files to execute the pipeline:

- **CSV file**: A CSV file containing the traits, Strain and MouseID as columns. 

- **yaml**: Yaml file similar to the one in the example folder.

#### 1. Prepare input files for GEMMA.
    Submit prepare_input.sh on the cluster.   

This runs prepare_input.R using the input files (*csv* and *yaml*). 

    Specify the args$input, args$yaml, name, and basedir variables in prepare_input.R

This will create the following files (see the **example folder**),

- anno_name.txt 
- geno_name.txt  
- pheno_name.txt  
- genotypes_name.csv  
- phenotypes_name.csv  

Use `gzip` to create `geno_name.txt.gz` file from `geno_name.txt`

#### 2. Using GEMMA

    Submit estimate_heritability_kinship.sh. 

Specify the kinship_file variable. This will estimate the kinship matrix. The estimated matrix is used, along with others, as input to the next script. 

    Submit estimate_heritability.sh. 

Specify the shell variables appropriately. The kinship_file variable should match the one in the previous step. This will estimate the heritabilities for all traits. 

To combine the estimates of heritability for different traits into one file,

    Submit extract_heritability.sh

In `extract_heritability.sh`, `-n` is the number of traits and `-o` is the folder where the resulting `csv` file will be saved, and `-name` is the name of the `csv` file to be specified by the user. The file is saved as `PVE_GEMMA_estimates_{name}.txt`. 

#### 3. Post-processing

Use `plot_heritability.R` file to make the final plot. 

    Rscript Code/plot_heritability.R -i example/csv_file -y example/yaml_file -H example/heritability_file

where

- csv_file: Original input **CSV file**
- yaml_file: Original input **yaml** file
- heritability_file: `PVE_GEMMA_estimates_{name}.txt` file obtained at the end of step 2. 



#### References
- Xiang Zhou and Matthew Stephens (2014). [Efficient multivariate linear mixed model algorithms for genome-wide association studies](https://www.nature.com/articles/nmeth.2848). *Nature Methods* **11**, 407–409.