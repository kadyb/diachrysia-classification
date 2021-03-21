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

  bands_sel = ks_df$band[seq_len(i)]
  acc = classify_LDA(data, bands_sel)
  acc_vec = c(acc_vec, acc)

}

# LDA accuracy on the number of features
acc_df = data.frame(number = seq.int(2, nbands), accuracy = acc_vec)
acc_df
