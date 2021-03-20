library("MASS")
library("prospectr")
source("code/utils.R")

# read and process data
data_csv = read.csv2("data/Spectra.csv")
data = transform_data(data_csv)
ks_df = read.csv2("results/ks-test.csv")
ks_df$scale = as.factor(ks_df$scale)

##############################################################
### LDA for 20 most important features

# number of bands
nbands = 20

acc_vec = numeric()

for (i in seq.int(2, nbands)) {

  # columns selection
  names_sel = ks_df$band[seq_len(i)]
  names_sel = c("Species", names_sel)
  data_sel = data[, names(data) %in% names_sel]

  mdl = MASS::lda(data_sel[, -1], grouping = data_sel$Species, tol = 1.0e-5)
  pred = predict(mdl, data_sel[, -1])$class
  acc = accuracy(data_sel$Species, pred)
  acc_vec = c(acc_vec, acc)

}

# LDA accuracy on the number of features
acc_df = data.frame(number = seq.int(2, nbands), accuracy = acc_vec)
acc_df
