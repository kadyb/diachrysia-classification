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

glass_metrics = data.frame(accuracy = double(), sensitivity = double(),
                           specificity = double())
brown_metrics = glass_metrics

for (i in seq_along(glass_comb)) {

  bands_sel = glass_comb[[i]]
  acc = classify_LDA(data, bands_sel)
  metrics = classify_LDA(data, bands_sel)
  glass_metrics = rbind(glass_metrics, metrics)

}

for (i in seq_along(brown_comb)) {

  bands_sel = brown_comb[[i]]
  acc = classify_LDA(data, bands_sel)
  metrics = classify_LDA(data, bands_sel)
  brown_metrics = rbind(brown_metrics, metrics)

}

# select those band combinations that give 100% species separation
glass_idx = which(glass_metrics$accuracy == 1)
glass_comb[glass_idx]

brown_idx = which(brown_metrics$accuracy == 1)
brown_comb[brown_idx]
