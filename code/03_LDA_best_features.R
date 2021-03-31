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

glass_acc_vec = numeric()
brown_acc_vec = numeric()

# LDA for glass scales
for (i in seq.int(2, nbands)) {

  bands_sel = ks_df$band[ks_df$scale == "Glass"]
  bands_sel = bands_sel[seq_len(i)]
  acc = classify_LDA(data, bands_sel)
  glass_acc_vec = c(glass_acc_vec, acc)

}

# LDA for brown scales
for (i in seq.int(2, nbands)) {

  bands_sel = ks_df$band[ks_df$scale == "Brown"]
  bands_sel = bands_sel[seq_len(i)]
  acc = classify_LDA(data, bands_sel)
  brown_acc_vec = c(brown_acc_vec, acc)

}

# LDA accuracy on the number of features
acc_df = data.frame(number = seq.int(2, nbands), acc_glass = glass_acc_vec,
                    acc_brown = brown_acc_vec)
acc_df
