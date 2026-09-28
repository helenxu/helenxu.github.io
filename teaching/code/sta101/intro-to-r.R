
#============================================ Basics =================================================#
# The Console is a tab in RStudio where we can run R code.
# We can use the console to test code immediately.
# Example: type expressions like 1 + 2, 2^2, sqrt(2), exp(1), log(2)
# We can store the output of these commands as variables with the "assignment operator" <- or =
result1 <- log(2)
result2 = log(2)
# We’ll see any objects we created, such as result1 and result2, under values in the Environment tab.
# When we type result1 into the console and hit enter, we see the stored value of 0.6931472.

# We can create vectors using the function c, which stands for concatenate. 
number <- c(3, 5, 1, 8)
country <- c("Italy", "China", "Egypt")

# We can also write a function to implement some functionality.
# Example: to solve the quadratic equations of the form ax^2 + bx + c = 0
solveQE <- function(a, b, c) {
  temp <- b^2 - 4 * a * c
  if (temp < 0) print('No real solution!')
  else if (temp > 0) {
    x1 <- (-b - sqrt(temp)) / (2 * a)
    x2 <- (-b + sqrt(temp)) / (2 * a)
    return (c(x1, x2))
  }
  else return (-b / (2 * a))
}

solveQE(1, 2, 1)
solveQE(1, 3, 1)

#============================================ Packages ==============================================#
# Much of the functionality in R comes from using packages. 
# Packages are shareable collections of code, data, and documentation.
# To install packages in R we use the built-in install.packages() function.
# Example: access to Galton’s family height data through the HistData package.
install.packages('HistData')
# After a package is installed on a computer’s hard drive, library() is used to load it into memory.
# To check which packages are loaded, refer to the Packages tab at the bottom right of the window.
library(HistData)
# Get the help file of the data
?GaltonFamilies
# Output the first 6 lines of the data
head(GaltonFamilies)
# Filter the children who are male
subdata <- GaltonFamilies[GaltonFamilies$gender == 'male', ]
# Plot the son's height against the father's height
plot(childHeight ~ father, data = subdata)
# Make the figure nicer
plot(childHeight ~ father, data = subdata, col = "grey", pch = 20)
grid()
# The package ggplot2 can be used to generate nice-looking figures
# Fit a linear model
fit1 <- lm(childHeight ~ father, data = subdata)
# Add the fitted line to the figure
abline(fit1, col = "darkorange", lwd = 3)
# Show the regression to the mean effect by looking at the slope
# If we reverse the regression, regression to the mean effect still exist
fit2 <- lm(father ~ childHeight, data = subdata)