
#==================== Whether to condition on variables =======================#
n <- 10000
set.seed(20240527)
X1 <- runif(n, min = 0, max = 1)
X2 <- runif(n, min = 1, max = 2)
X3 <- rnorm(n, mean = X1 + 0.5 * X2, sd = 0.1)
Y <- rnorm(n, mean = 2 * X1 + X2 + 0.5 * X3, sd = 0.1)

fit1 <- lm(Y ~ X3) # coefficient of X3 is not the causal effect of X3 on Y
fit2 <- lm(Y ~ X3 + X1 + X2) # coefficient of X3 is the causal effect of X3 on Y
fit3 <- lm(Y ~ X1) # coefficient of X1 is the total causal effect of X1 on Y
fit4 <- lm(Y ~ X1 + X3) # coefficient of X1 is not the causal effect of X1 on Y
