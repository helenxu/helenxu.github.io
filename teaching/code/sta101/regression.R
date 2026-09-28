
#======================================== Chapter 6 ========================================#
# Example 6.1
height <- c(63, 64, 66, 69, 69, 71, 71, 72, 73, 75)
weight <- c(127, 121, 142, 157, 162, 156, 169, 165, 181, 208)

# fit a linear regression model
fit1 <- lm(weight ~ height)
summary(fit1)


#================ Example 6.2 ================#
titanic <- read.csv('train_Titanic_complete.csv', header = TRUE)

library(ggplot2)
# survival by sex
ggplot(titanic, aes(x = Sex, fill = as.factor(Survived))) +
  geom_bar(position = position_dodge()) +
  scale_fill_brewer(palette="Accent") + 
  guides(fill = guide_legend(title="Survived")) +
  ggtitle("Survival by Sex") 

# survival by Pclass
ggplot(titanic, aes(x = Pclass, fill = as.factor(Survived))) +
  geom_bar(position = position_dodge()) +
  scale_fill_brewer(palette="Accent") + 
  guides(fill = guide_legend(title="Survived")) +
  ggtitle("Survival by Passenger Class") 

# survival by age
ggplot(titanic, aes(x = Age, y = Survived)) +
  geom_smooth(method = "loess") +
  ggtitle("Estimated Survival Probability by Age")

# fit a logistic regression model
fit2 <-  glm(Survived ~ Sex + as.factor(Pclass) + Age, data = titanic, family = "binomial")
summary(fit2)

# get the estimated probabilities and use 0.5 as the threshold
surv_logisticReg <- ifelse(fit2$fitted.values > 0.5, 1, 0)
TP <- sum(titanic$Survived == 1 & surv_logisticReg == 1)
FP <- sum(titanic$Survived == 0 & surv_logisticReg == 1)
FN <- sum(titanic$Survived == 1 & surv_logisticReg == 0)
TN <- sum(titanic$Survived == 0 & surv_logisticReg == 0)
acc <- (TP + TN) / nrow(titanic)
prec <- TP / (TP + FP)
reca_sens <- TP / (TP + FN)
spec <- TN / (TN + FP)

# use different thresholds and plot the ROC curve
threshs <- seq(0, 1, 0.05)
len <- length(threshs)
senss <- rep(0, len)
specs <- rep(0, len)
for (i in 1:len) {
  surv_logisticReg <- ifelse(fit2$fitted.values > threshs[i], 1, 0)
  TP <- sum(titanic$Survived == 1 & surv_logisticReg == 1)
  FP <- sum(titanic$Survived == 0 & surv_logisticReg == 1)
  FN <- sum(titanic$Survived == 1 & surv_logisticReg == 0)
  TN <- sum(titanic$Survived == 0 & surv_logisticReg == 0)
  senss[i] <- TP / (TP + FN)
  specs[i] <- TN / (TN + FP)
}

plot(1 - specs, senss, type = 'l', xlab = "1 - specificity", ylab = 'sensitivity', 
     main = 'The ROC curve', col = 'lightskyblue', lwd = 2)
grid()

# get the ROC curve for a random classifier
set.seed(20240408)
prob_random <- runif(nrow(titanic))

senss_r <- rep(0, len)
specs_r <- rep(0, len)
for (i in 1:len) {
  surv_random <- ifelse(prob_random > threshs[i], 1, 0)
  TP <- sum(titanic$Survived == 1 & surv_random == 1)
  FP <- sum(titanic$Survived == 0 & surv_random == 1)
  FN <- sum(titanic$Survived == 1 & surv_random == 0)
  TN <- sum(titanic$Survived == 0 & surv_random == 0)
  senss_r[i] <- TP / (TP + FN)
  specs_r[i] <- TN / (TN + FP)
}

lines(1 - specs_r, senss_r, lwd = 2, lty = 2)


#================ Example 6.3 ================#
library(caret)
head(iris)

# check the distribution of Sepal width vs Sepal Length and Petal width vs Petal length
ggplot(data = iris, aes(x = Sepal.Length, y = Sepal.Width, col = Species)) +
  geom_point()

ggplot(data = iris, aes(x = Petal.Length, y = Petal.Width, col = Species)) +
  geom_point()

# split data to training and test set
# random sampling is done within the levels of y when y is a factor in an attempt to 
# balance the class distributions within the splits.
set.seed(20240408)
inTrain <- createDataPartition(y = iris$Species, p = 0.8)
trainData <- iris[inTrain$Resample1, ]
testData <- iris[-inTrain$Resample1, ]
# check the class distribution in the test data
table(testData$Species)

# run the method with 10-fold cross validation
# the knn method here use the Euclidean distance
control <- trainControl(method = 'cv', number = 10)
fit.knn <- train(Species ~ ., data = trainData, method = "knn", metric = 'Accuracy', 
                 trControl = control, preProcess = c("center","scale"), tuneLength = 10)
fit.knn
# plot yields number of neighbors vs Accuracy (based on cross validation)
plot(fit.knn)

# prediction on the testData
testPred.knn <- predict(fit.knn, newdata = testData)
confusionMatrix(testPred.knn, testData$Species)

# for visualize purpose, fit the knn method with only Petal.Length and Petal.Width
trainData2 <- trainData[, 3:5]
testData2 <- testData[, 3:5]
fit.knn2 <- train(Species ~ ., data = trainData2, method = "knn", metric = 'Accuracy', 
                  trControl = control, preProcess = c("center","scale"), tuneLength = 10)
testPred.knn2 <- predict(fit.knn2, newdata = testData2)
confusionMatrix(testPred.knn2, testData2$Species)

# generate grid points for prediction
pl <- seq(min(iris$Petal.Length), max(iris$Petal.Length), by = 0.01)
pw <- seq(min(iris$Petal.Width), max(iris$Petal.Width), by = 0.01)
pgrid <- expand.grid(Petal.Length = pl, Petal.Width = pw)

gridPred.knn <- predict(fit.knn2, newdata = pgrid)
pgrid$Species <- gridPred.knn

# plot the decision boundary
ggplot(testData, aes(Petal.Width, Petal.Length, fill = Species)) +
  geom_raster(data = pgrid, alpha = 0.5) +
  geom_point(shape = 21, size = 3) + ggtitle("Decision Boundary of the k-NN method") 



#===== Illustrating example in Section 6.4 =====#
titanic <- read.csv('train_Titanic_complete.csv', header = TRUE)

# discretize Age to define a categorical variable about age
titanic$AgeCat <- ifelse(titanic$Age <= 12, 'child', 'senior')
titanic$AgeCat[titanic$Age > 12 & titanic$Age <= 18] <- 'teenager'
titanic$AgeCat[titanic$Age > 18 & titanic$Age <= 25] <- 'youth'
titanic$AgeCat[titanic$Age > 25 & titanic$Age <= 50] <- 'middle-aged'

titanic2 <- titanic[, c('Survived', 'Sex', 'Pclass', 'AgeCat')]

# compute the prior probabilities of survived or not
p1 <- sum(titanic2$Survived) / nrow(titanic2)
p0 <- 1 - p1

# compute the conditional probabilities of male
pm1 <- sum(titanic2$Sex == 'male' & titanic2$Survived == 1) / sum(titanic2$Survived == 1)
pm0 <- sum(titanic2$Sex == 'male' & titanic2$Survived == 0) / sum(titanic2$Survived == 0)

# compute the conditional probabilities of class 2
pc21 <- sum(titanic2$Pclass == 2 & titanic2$Survived == 1) / sum(titanic2$Survived == 1)
pc20 <- sum(titanic2$Pclass == 2 & titanic2$Survived == 0) / sum(titanic2$Survived == 0)

# compute the conditional probabilities of youth
py1 <- sum(titanic2$AgeCat == 'youth' & titanic2$Survived == 1) / sum(titanic2$Survived == 1)
py0 <- sum(titanic2$AgeCat == 'youth' & titanic2$Survived == 0) / sum(titanic2$Survived == 0)



#================ Example 6.4 ================#
library(e1071) # for the naiveBayes() function
library(tm)
library(wordcloud)
allData <- read.csv('yelp_labelled.csv', header = FALSE)
names(allData) <- c('text', 'label')
allData$label <- as.factor(allData$label)
table(allData$label)

# creating training and test datasets
set.seed(20240415)
inTrain <- createDataPartition(y = allData$label, p = 0.8)
trainData <- allData[inTrain$Resample1, ]
testData <- allData[-inTrain$Resample1, ]

# create corpus from the training and test data 
# corpus (文集/语料库) is a collection of text documents
train_corpus <- VCorpus(VectorSource(trainData$text))
test_corpus <- VCorpus(VectorSource(testData$text))

# create document-term matrices directly from the corpus
# the matrices are typically sparse
train_dtm <- DocumentTermMatrix(train_corpus, control = list(
  tolower = TRUE,
  removeNumbers = TRUE,
  stopwords = TRUE,
  removePunctuation = TRUE,
  stemming = TRUE
))
inspect(train_dtm) # display detailed information on the term-document matrix
findFreqTerms(train_dtm, 30) # find the terms that occur at least 30 times

# draw word cloud for positive reviews and negative reviews
positive <- train_dtm[trainData$label == 1, ]
negative <- train_dtm[trainData$label == 0, ]
words_pos <- sort(colSums(as.matrix(positive)), decreasing = TRUE)
words_neg <- sort(colSums(as.matrix(negative)), decreasing = TRUE)
wordcloud(names(words_pos), freq = words_pos, max.words = 50,
          scale = c(3.5, 0.25), colors = brewer.pal(6,"Dark2"),
          random.order = FALSE)
wordcloud(names(words_neg), freq = words_neg, max.words = 50,
          scale = c(3.5, 0.25), colors = brewer.pal(9,"Dark2"),
          random.order = FALSE)

test_dtm <- DocumentTermMatrix(test_corpus, control = list(
  tolower = TRUE,
  removeNumbers = TRUE,
  stopwords = TRUE,
  removePunctuation = TRUE,
  stemming = TRUE
))

# create function to convert counts to a factor
convert_counts <- function(x) {
  x <- ifelse(x > 0, "Yes", "No")
}

# apply() convert_counts() to columns of train/test data
train_dtm_binary <- apply(train_dtm, MARGIN = 2, convert_counts)
test_dtm_binary  <- apply(test_dtm, MARGIN = 2, convert_counts)

# model fitting and testing
fit.nb <- naiveBayes(x = as.matrix(train_dtm_binary), y = trainData$label)
testData$PredClass <- predict(fit.nb, as.matrix(test_dtm_binary))
sum(testData$PredClass == testData$label) / nrow(testData)
testData$PredProb <- predict(fit.nb, as.matrix(test_dtm_binary), type = 'raw')



