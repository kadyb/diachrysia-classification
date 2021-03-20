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
for (i in 2:ncol(data)) {

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

##############################################################
### LDA for 20 most important features

# number of bands
nbands = 20

acc_vec = numeric()

for (i in 2:nbands) {

  # columns selection
  names_sel = ks_df$band[1:i]
  names_sel = c("Species", names_sel)
  data_sel = data[, names(data) %in% names_sel]

  mdl = MASS::lda(data_sel[, -1], grouping = data_sel$Species, tol = 1.0e-5)
  pred = predict(mdl, data_sel[, -1])$class
  acc = accuracy(data_sel$Species, pred)
  acc_vec = c(acc_vec, acc)

}

# LDA accuracy on the number of features
acc_df = data.frame(number = 2:nbands, accuracy = acc_vec)
acc_df
