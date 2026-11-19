# Predict age with an elastic net and leave-one-out cross-validation (R)
# input = wide matrix: one row per sample, columns age, sex, then one per site

library(glmnet)

## read the matrix; z-score every site
d <- read.csv("<wide_matrix.csv>", row.names = 1)
y <- d$age
x <- scale(as.matrix(d[, !(names(d) %in% c("age", "sex"))]))

## nested leave-one-out: each sample is predicted by a model that never saw it
## (cv.glmnet tunes lambda on the remaining samples)
pred <- sapply(seq_along(y), function(i) {
  fit <- cv.glmnet(x[-i, ], y[-i], alpha = 0.5, nfolds = length(y) - 1,
                   grouped = FALSE, standardize = FALSE)
  predict(fit, x[i, , drop = FALSE], s = "lambda.min")
})

## performance
mean(abs(pred - y))     # MAE
cor(pred, y)^2          # R squared

## sites selected by a model fitted on all samples
fit <- cv.glmnet(x, y, alpha = 0.5, nfolds = length(y), grouped = FALSE, standardize = FALSE)
b <- coef(fit, s = "lambda.min")
b[b[, 1] != 0, , drop = FALSE]
