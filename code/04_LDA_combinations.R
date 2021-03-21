library("MASS")
library("prospectr")
source("code/utils.R")

# read and process data
data_csv = read.csv2("data/Spectra.csv")
data = transform_data(data_csv)
ks_df = read.csv2("results/ks-test.csv")
ks_df$scale = as.factor(ks_df$scale)

# number of bands for combinations
nbands = 8

# select best spectral features for both scales separately
glass_vec = ks_df[ks_df$scale == "Glass", "band"][seq_len(nbands)]
brown_vec = ks_df[ks_df$scale == "Brown", "band"][seq_len(nbands)]

# initialize empty lists
glass_comb = list()
brown_comb = list()

# bands combinations
for (i in seq.int(2, nbands)) {

  comb = combn(glass_vec, i, simplify = FALSE)
  glass_comb = c(glass_comb, comb)

  comb = combn(brown_vec, i, simplify = FALSE)
  brown_comb = c(brown_comb, comb)

}

##############################################################
### LDA for bands combinations

glass_acc_vec = numeric()
brown_acc_vec = numeric()

for (i in seq_along(glass_comb)) {

  bands_sel = glass_comb[[i]]
  acc = classify_LDA(data, bands_sel)
  glass_acc_vec = c(glass_acc_vec, acc)

}

for (i in seq_along(brown_comb)) {

  bands_sel = brown_comb[[i]]
  acc = classify_LDA(data, bands_sel)
  brown_acc_vec = c(brown_acc_vec, acc)

}

# select those band combinations that give 100% species separation
glass_idx = which(glass_acc_vec == 1)
glass_comb[glass_idx]

brown_idx = which(brown_acc_vec == 1)
brown_comb[brown_idx]
