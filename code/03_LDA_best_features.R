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

glass_metrics = data.frame(accuracy = double(), sensitivity = double(),
                           specificity = double())
brown_metrics = glass_metrics

# LDA for glass scales
for (i in seq.int(2, nbands)) {

  bands_sel = ks_df$band[ks_df$scale == "Glass"]
  bands_sel = bands_sel[seq_len(i)]
  metrics = classify_LDA(data, bands_sel)
  glass_metrics = rbind(glass_metrics, metrics)

}

# LDA for brown scales
for (i in seq.int(2, nbands)) {

  bands_sel = ks_df$band[ks_df$scale == "Brown"]
  bands_sel = bands_sel[seq_len(i)]
  metrics = classify_LDA(data, bands_sel)
  brown_metrics = rbind(brown_metrics, metrics)

}

# LDA accuracy on the number of features
acc_df = data.frame(number = seq.int(2, nbands),
                    acc_glass = glass_metrics$accuracy,
                    acc_brown = brown_metrics$accuracy)
acc_df
