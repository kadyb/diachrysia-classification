accuracy = function(truth, predicted) {
  sum(truth == predicted) / length(truth)
}

transform_data = function(data) {

  data$Species = as.factor(data$Species)
  data$Scale = as.factor(data$Scale)

  # Savitzky-Golay filtering
  data_SG = prospectr::savitzkyGolay(data[, 4:1704], m = 2, p = 2, w = 5)
  data_SG = data.frame(Species = data[, 2], data_SG)

  # create wide data.frame
  brown = data_SG[data$Scale == "Brown", ]
  colnames(brown)[2:1698] = paste0("B", 402:2098)
  glass = data_SG[data$Scale == "Glass", ]
  colnames(glass)[2:1698] = paste0("G", 402:2098)
  data = cbind(brown[, 1:1698], glass[, 2:1698])

  return(data)

}

classify_LDA = function(data, bands) {

  bands = c("Species", bands)
  data_sel = data[, names(data) %in% bands]

  # Linear Discriminant Analysis
  mdl = MASS::lda(data_sel[, -1], grouping = data_sel$Species, tol = 1.0e-5)
  pred = predict(mdl, data_sel[, -1])$class
  acc = accuracy(data_sel$Species, pred)

  return(acc)

}
