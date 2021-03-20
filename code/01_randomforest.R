library("ranger")
library("prospectr")
source("code/utils.R")

# read and prepare data
data_csv = read.csv2("data/Spectra.csv")
data = transform_data(data_csv)

# initialize empty vectors
ID_vec = vector()
acc_vec = vector()
imp_vec = vector()
pred_vec = vector()

# number of iterations
iters = 300

for (i in seq_len(iters)) {

  # random split data into training (70%) and test (30%) sets
  trainIndex = sample(nrow(data), size = round(0.7 * nrow(data)))
  train = data[trainIndex, ]
  test = data[-trainIndex, ]
  ID_vec = c(ID_vec, setdiff(seq(nrow(data)), trainIndex))

  # train model
  rf_mdl = ranger::ranger(Species ~ ., train, importance = "impurity")

  # calculate significance of spectral features
  imp = ranger::importance(rf_mdl)
  imp = sort(imp, decreasing = TRUE)[1:50] # select top 50 most important
  imp_vec = c(imp_vec, imp)

  # calculate classification performance on test set
  pred = predict(rf_mdl, test)$predictions
  pred_vec = c(pred_vec, pred)
  acc = accuracy(test$Species, pred)
  acc_vec = c(acc_vec, acc)

}

# average classification accuracy and standard deviation from all iterations
mean(acc_vec)
sd(acc_vec)

# average features importance from all iterations
imp_df = aggregate(imp_vec, by = list(names(imp_vec)), FUN = mean)
colnames(imp_df) = c("band", "importance")
imp_df = imp_df[order(imp_df$importance, decreasing = TRUE), ]
imp_df[1:20, ] # print top 20 most important


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
cor.test(scores$percentage, legislative$Feature_level, method = "kendall")
