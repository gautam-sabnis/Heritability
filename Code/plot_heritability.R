#setwd("~/Heritability")
libs <- c("data.table","argparse","yaml","ggplot2","RColorBrewer")
sapply(libs, require, character.only = TRUE)
basedir <- getwd()

parser <- ArgumentParser()
parser$add_argument("-i", "--input", help="Input csv file, assume column names.")
parser$add_argument("-y", "--yaml", help="Yaml file which will include: strain- Name of strain column, phenotypes-phenotypes column names to test, covar-columns to be used as covariates, F1- a dictionary mapping F1 names to strain names (female parent first), translate- translate strain names to names in the genotypes file.")
parser$add_argument("-H", "--pve", help="PVE result file.")
parser$add_argument("-n", "--name", help="data name")
parser$add_argument("-c", "--color", action="store_true", default=FALSE, help="Use Set3 color palette for groups, default is Accent")
parser$add_argument("-thr", "--threshold", type="double", default=0,
	help= "Heritability threshold (PVE) to include a phenotype in the aggregated reports")
parser$add_argument("-size", "--base_size", default=16,
	help= "Set the plot size")

args <- parser$parse_args()
#args$input <- "example/vame_12k.csv"
#args$yaml <- "example/vame_12k.yaml"
#args$pve <- "example/PVE_GEMMA_estimates_vame_12k_heritability.txt"

if (args$color) {
  grpcol <- RColorBrewer::brewer.pal(12, "Set3")[2:12]
} else{
  grpcol <- RColorBrewer::brewer.pal(8, "Accent")
}

pheno <- read.csv(args$input, header = TRUE)
names(pheno) <- gsub("\\.", "-", names(pheno))
names(pheno) <- gsub("X", "", names(pheno))
yamin <- yaml.load_file(args$yaml)

traits <- names(pheno)[names(pheno) %in% names(yamin$phenotypes)]
dfr <- data.frame(read.csv(paste0(args$pve), sep = ",", header = TRUE))
dfr$phenotype <- traits
dfr$phenoname <- sapply(seq(nrow(dfr)), function(x) yamin$phenotypes[[x]]$papername)
dfr$Group <- sapply(1:nrow(dfr), function(x) yamin$phenotypes[[which(names(yamin$phenotypes) %in% dfr$phenotype[x])]]$group)

X11()
ggplot(dfr, aes(reorder(phenoname, -PVE), PVE, fill = Group, alpha = PVE > args$threshold)) + geom_bar(color = "black", stat = "identity") + geom_errorbar(aes(ymin = PVE - PVESE, ymax = PVE + PVESE), width = .2) + ylim(0,1) + scale_alpha_manual(breaks=c(FALSE, TRUE), values=c(0.4, 1), guide = "none") + scale_fill_manual(values = grpcol) + xlab("Phenotype") + coord_flip() + ggtitle("Mean") + theme_classic(base_size = args$base_size)

dev.print(pdf, paste0(basedir, "/heritability_plot", ".pdf"), width = 7.04, height = 12.55)
