library("MASS")
library("prospectr")
source("code/utils.R")

# read and process data
data_csv = read.csv2("data/Spectra.csv")
data = transform_data(data_csv)

# initialize empty vectors
D_vec = numeric()
p.value_vec = numeric()

# Kolmogorov–Smirnov test
for (i in seq.int(2, ncol(data))) {

  ks_test = ks.test(data[data$Species == "Diachrysia chrysitis", i],
                    data[data$Species == "Diachrysia stenochrysis", i])

  D_vec = c(D_vec, ks_test$statistic)
  p.value_vec = c(p.value_vec, ks_test$p.value)

}

ks_df = data.frame(band = colnames(data)[-1], D = D_vec, p.value = p.value_vec)
ks_df = ks_df[order(ks_df$D, decreasing = TRUE), ]
ks_df$scale = ifelse(substr(ks_df$band, 1, 1) == "G", "Glass", "Brown")
ks_df$scale = as.factor(ks_df$scale)
ks_df[1:20, ]

# number of bands
nbands = 8

# select best spectral features for both scales separately
glass_vec = ks_df[ks_df$scale == "Glass", "band"][seq_len(nbands)]
brown_vec = ks_df[ks_df$scale == "Brown", "band"][seq_len(nbands)]

# bands combinations
glass_comb = list()
brown_comb = list()

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

  # columns selection
  names_sel = glass_comb[[i]]
  names_sel = c("Species", names_sel)
  data_sel = data[, names(data) %in% names_sel]

  mdl = MASS::lda(data_sel[, -1], grouping = data_sel$Species, tol = 1.0e-5)
  pred = predict(mdl, data_sel[, -1])$class
  acc = accuracy(data_sel$Species, pred)
  glass_acc_vec = c(glass_acc_vec, acc)

}

for (i in seq_along(brown_comb)) {

  # columns selection
  names_sel = brown_comb[[i]]
  names_sel = c("Species", names_sel)
  data_sel = data[, names(data) %in% names_sel]

  mdl = MASS::lda(data_sel[, -1], grouping = data_sel$Species, tol = 1.0e-5)
  pred = predict(mdl, data_sel[, -1])$class
  acc = accuracy(data_sel$Species, pred)
  brown_acc_vec = c(brown_acc_vec, acc)

}

# select those band combinations that give 100% species separation
glass_idx = which(glass_acc_vec == 1)
glass_comb[glass_idx]

brown_idx = which(brown_acc_vec == 1)
brown_comb[brown_idx]
