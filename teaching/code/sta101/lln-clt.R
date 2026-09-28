
#===== Example 3.10: coin tossing result. 0 - Tail, 1 - Head. =====#

# Toss a fair coin n times and record the results, repeat the experiment 3 times.
n <- 10000
set.seed(20250319)

results1 <- rbinom(n, size = 1, prob = 0.5)
results2 <- rbinom(n, size = 1, prob = 0.5)
results3 <- rbinom(n, size = 1, prob = 0.5)

# Compute the frequency of Head at each number of toss.
freq1 <- cumsum(results1) / (1:n)
freq2 <- cumsum(results2) / (1:n)
freq3 <- cumsum(results3) / (1:n)

plot(1:n, freq1, type = "l", xlab = "number of coin toss", ylab = "frequency of Head", 
     col = 'yellowgreen', lwd = 2, ylim = c(0, 1))
lines(1:n, freq2, col = 'lightsalmon', lwd = 2)
lines(1:n, freq3, col = 'lightskyblue1', lwd = 2)
abline(h = 0.5, lty = 2)
grid()


#===== Example 3.11: Consecutive numbers drawn from random sampling =====#

# Write a function to determine if a random draw contains at least k consecutive numbers
# This may not be the most efficient realization
consecutiveCount <- function(arr, k) {
  temp1 <- sort(arr) # sort the sampling result from smallest to largest
  temp2 <- diff(temp1) # compute the difference between adjacent numbers
  temp3 <- rle(temp2)
  maxCount <- max(temp3$lengths[temp3$values == 1]) # the maximum number of consecutive numbers
  if (maxCount < (k-1)) return(0)
  else return(1)
}

# Repeat the random sampling n times and record the number of times with more than k consecutive numbers
n <- 100000
set.seed(20250319)

N1 <- 5141; m1 <- 124; k1 <- 6
cnt1 <- 0
# Warning message may appear due to no consecutive numbers
for (i in 1:n) {
  result <- sample.int(N1, size = m1)
  cnt1 <- cnt1 + consecutiveCount(result, k1)
}

N2 <- 1138; m2 <- 514; k2 <- 14
cnt2 <- 0
for (i in 1:n) {
  result <- sample.int(N2, size = m2)
  cnt2 <- cnt2 + consecutiveCount(result, k2)
}

# Compute the estimated probability
cnt1/n
cnt2/n


#===== Example 3.12: Sample from Exp(1) and look at the distribution of the sample mean =====#
nrep <- 1000
set.seed(20250319)

# First consider the special case when n=1
n <- 1
means1 <- rep(0, nrep) # initialization
for (i in 1:nrep) {
  means1[i] <- mean(rexp(n))
}
# means1 <- sapply(1:nrep, function(x){return(mean(rexp(n)))}) # more efficient
hist(means1, main = "Sample mean of Exp(1) - n=1", xlab = "sample mean")

# Then consider the case when n = 5
n <- 5
means2 <- rep(0, nrep) # initialization
for (i in 1:nrep) {
  means2[i] <- mean(rexp(n))
}
# means2 <- sapply(1:nrep, function(x){return(mean(rexp(n)))})
hist(means2, main = "Sample mean of Exp(1) - n=5", xlab = "sample mean", 
     xlim = c(0, 3), breaks = 10)

# Then consider the case when n = 15
n <- 15
means3 <- rep(0, nrep) # initialization
for (i in 1:nrep) {
  means3[i] <- mean(rexp(n))
}
# means3 <- sapply(1:nrep, function(x){return(mean(rexp(n)))})
hist(means3, main = "Sample mean of Exp(1) - n=15", xlab = "sample mean", 
     xlim = c(0, 3), breaks = 10)

# Finally consider the case when n = 30
n <- 30
means4 <- rep(0, nrep) # initialization
for (i in 1:nrep) {
  means4[i] <- mean(rexp(n))
}
# means4 <- sapply(1:nrep, function(x){return(mean(rexp(n)))})
hist(means4, main = "Sample mean of Exp(1) - n=30", xlab = "sample mean", 
     xlim = c(0, 3), breaks = 10)

