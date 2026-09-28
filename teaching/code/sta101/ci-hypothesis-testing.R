
#========== Draw N samples of size n from N(mu,1) and construct the 95% CI of mu ==========#
mu <- 4
n <- 10
N <- 10000
# initialize a matrix to record the 95% CIs
CIs <- matrix(0, nrow = N, ncol = 2) 
margin <- 1.96 / sqrt(n)

set.seed(20250427)

for (i in 1:N) {
  x_bar <- mean(rnorm(n, mean = mu, sd = 1))
  CIs[i, 1] <- x_bar - margin
  CIs[i, 2] <- x_bar + margin
}

# compute the proportion of CIs that contain the true mu=4
sum(CIs[, 1] < 4 & CIs[, 2] > 4) / N


#==================== Draw N samples of size n from N(mu0,sigma^2) ====================#
#==================== Test H0: mu = mu0 <-> H1: mu > mu0 ====================#
mu0 <- 175
sigma <- 5
n <- 25
alpha <- 0.05
N <- 10000

# initialize two vectors to record the results and one matrix to record the samples
p_vals <- rep(0, N)
rejOrNot <- rep(0, N)
samples <- matrix(0, nrow = N, ncol = n)

# From the Lecture PPT, the rejection region is {X_bar - mu0 > z_alpha * sigma / sqrt(n)}
c <- qnorm(alpha, lower.tail = FALSE) * sigma / sqrt(n)

set.seed(20250427)
for (i in 1:N) {
  samples[i, ] <- rnorm(n, mean = mu0, sd = sigma)
  x_bar <- mean(samples[i, ])
  rejOrNot[i] <- ifelse(x_bar - mu0 > c, TRUE, FALSE)
  # From the Lecture PPT, the p-value is P(X_bar > x_bar|mu=mh0)
  # X_bar follows N(mu0, sigma^2/n) under H0
  p_vals[i] <- pnorm(x_bar, mean = mu0, sd = sigma / sqrt(n), lower.tail = FALSE)
}

# compute the number of rejection (i.e., Type I error)
sum(rejOrNot)

# look at one of the samples based on which H0 is rejected
rejOrNot
samples[12, ]
hist(samples[12, ])
hist(samples[1, ]) # for comparison

# Plot the p-values (uniform distribution on [0,1])
hist(p_vals)

