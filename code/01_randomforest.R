library("ranger")
library("prospectr")
source("code/utils.R")

# read and prepare data
data_csv = read.csv2("data/Spectra.csv")
data = transform_data(data_csv)

# number of iterations
iters = 300

# initialize empty vectors
ID_vec = integer()
imp_vec = double()
pred_vec = integer()
metrics_df = data.frame(accuracy = double(iters), sensitivity = double(iters),
                        specificity = double(iters))

for (i in seq_len(iters)) {

  # random split data into training (70%) and test (30%) sets
  trainIndex = sample(nrow(data), size = round(0.7 * nrow(data)))
  train = data[trainIndex, ]
  test = data[-trainIndex, ]
  ID_vec = c(ID_vec, setdiff(seq_len(nrow(data)), trainIndex))

  # train model
  rf_mdl = ranger::ranger(Species ~ ., train, importance = "impurity")

  # calculate significance of spectral features
  imp = ranger::importance(rf_mdl)
  imp = sort(imp, decreasing = TRUE)[1:50] # select top 50 most important
  imp_vec = c(imp_vec, imp)

  # calculate classification performance on test set
  pred = predict(rf_mdl, test)$predictions
  pred_vec = c(pred_vec, pred)
  metrics = get_metrics(test$Species, pred, "Diachrysia chrysitis",
                        "Diachrysia stenochrysis")
  metrics_df[i, ] = metrics

}

# average classification performance and standard deviation from all iterations
apply(metrics_df, MARGIN = 2, FUN = "mean")
apply(metrics_df, MARGIN = 2, FUN = "sd")

# average features importance from all iterations
imp_df = aggregate(imp_vec, by = list(names(imp_vec)), FUN = mean)
colnames(imp_df) = c("band", "importance")
imp_df = imp_df[order(imp_df$importance, decreasing = TRUE), ]
imp_df$glass = ifelse(substr(imp_df$band, 1, 1) == "G", "Glass", "Brown")
imp_df$glass = as.factor(imp_df$glass)
imp_df[1:20, ] # print top 20 most important

# save bands importance from RF
if (!dir.exists("results")) dir.create("results")
write.csv2(imp_df, "results/rf-importance.csv", row.names = FALSE)


##############################################################
### evaluating models performance at the individual level
legislative = read.csv2("data/Legislative.csv")

pred_df = data.frame(ID = legislative$ID[ID_vec], pred_class = pred_vec)
pred_df$pred_class = ifelse(pred_df$pred_class == 1, "dc", "ds")
pred_df$truth_class = substr(pred_df$ID, 1, 2)
# 1 if the predicted class is correct, otherwise 0
pred_df$score = ifelse(pred_df$truth_class == pred_df$pred_class, 1, 0)

# correct classifications percentages
ncount = as.vector(table(pred_df$ID))
scores = aggregate(pred_df$score, list(pred_df$ID), sum)
scores$x = round(scores$x / ncount * 100, 1)
colnames(scores) = c("ID", "percentage")
scores

# rank correlation
scores = merge(scores, legislative[, c(1, 10)], by = "ID")
cor.test(scores$percentage, scores$Feature_level, method = "kendall")
