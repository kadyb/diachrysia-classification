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


if (!dir.exists("results")) dir.create("results")
write.csv2(ks_df, "results/ks-test.csv", row.names = FALSE)
