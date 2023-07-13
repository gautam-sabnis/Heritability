libs <- c("data.table", "argparse")
sapply(libs, require, character.only = TRUE)
basedir <- getwd()

parser <- ArgumentParser()
parser$add_argument("-n", "--ntrait", help="Number of traits")
parser$add_argument("-o", "--out", help="Output directory to store results")
parser$add_argument("-name", "--file", help="File names")

args <- parser$parse_args()

get_sigmas <- function(logfile){
  con <- file(logfile, "r")
  vg = NULL
  ve = NULL
  pve = NULL
  pvese = NULL
  while(is.null(ve) | is.null(vg)){
    line <- readLines(con, n=1)
    if (grepl("^## pve estimate", line)) pve <- as.numeric(strsplit(line, " = ")[[1]][2])
    if (grepl("^## se\\(pve\\) ", line)) pvese <- as.numeric(strsplit(line, " = ")[[1]][2])
    if (grepl("^## vg estimate", line)) vg <- as.numeric(strsplit(line, " = ")[[1]][2])
    if (grepl("^## ve estimate", line)) ve <- as.numeric(strsplit(line, " = ")[[1]][2])
  }
  return (list(PVE=pve, PVESE=pvese, Vg=vg, Ve=ve))
}

allVPE <- data.table(phenotype=character(), PVE=numeric(), PVESE=numeric(), Vg=numeric(), Ve=numeric())


for (n in 1:as.numeric(args$ntrait)){
    fname <- paste0(basedir, "/", args$out, "/", args$file, "_", n, ".log.txt")
    if (file.exists(fname)){
      sigs <- get_sigmas(fname)
      sigs$phenotype <- paste("V", n)
      allVPE <- rbind(allVPE, sigs)
    }
}

fwrite(allVPE, file=paste0(basedir, "/", args$out, "/PVE_GEMMA_estimates_", args$file, ".txt"))

print("HERE!")
