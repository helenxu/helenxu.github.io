
# install.packages("ggplot2")

library(ggplot2)

#=============== Illustrating the basic usage of ggplot2 ===============#

# learn about the data
?mpg
head(mpg)

# Data
ggplot(data = mpg)

# Data + Mapping
ggplot(mpg, mapping = aes(x = cty, y = hwy))

# Data + Mapping + Layers (scatter plot + fitted line)
ggplot(mpg, aes(cty, hwy)) + geom_point() +
  geom_smooth(formula = y ~ x, method = "lm")

# Data + Mapping + Layers + Scales
# To use scales, one can use one of the scale functions that are patterned as 
# scale_{aesthetic}_{type}() functions, where {aesthetic} is one of the pairings 
# made in the mapping part of a plot.
ggplot(mpg, aes(cty, hwy, colour = class)) + geom_point()

ggplot(mpg, aes(cty, hwy, colour = class)) + geom_point() +
  scale_colour_viridis_d()

ggplot(mpg, aes(cty, hwy, colour = class)) + geom_point() +
  scale_colour_grey()


# Data + Mapping + Layers + Facets
# Facets is a powerful tool to quickly split up the data into smaller panels, based 
# on one or more variables, to display patterns or trends within the subsets.
ggplot(mpg, aes(cty, hwy)) + geom_point() +
  facet_grid(year ~ drv)


# Data + Mapping + Layers + Theme
# The theme system controls almost any visuals of the plot that are not controlled by the data
ggplot(mpg, aes(cty, hwy, colour = class)) + geom_point() + theme_minimal() + 
  theme(legend.position = "top", axis.line.x.bottom = element_line(colour = "blue"))


#============================== Draw different types of figures: Bar plot =========================#
# Bar plot of the type of cars
# The brewer scales provide sequential, diverging and qualitative colour schemes 
# from ColorBrewer. See https://ggplot2.tidyverse.org/reference/scale_brewer.html
ggplot(mpg, aes(x = class, fill = class)) + geom_bar() + 
  scale_fill_brewer(palette="Blues")

# Bar plot of the type of cars by the type of drive train
# Stacked bar plot: multiple bars are being stacked on top of each other
ggplot(mpg, aes(x = class, fill = drv)) + geom_bar() + 
  scale_fill_brewer(palette="Greens")

# Dodged/clustered bar plot: multiple bars are positioned side by side
# Add title and change the label of the x-axis
ggplot(mpg, aes(x = class, fill = drv)) + geom_bar(position = position_dodge()) + 
  scale_fill_brewer(palette="Accent") + 
  labs(title = "Type of Cars by Drive Train", x = "Type of Cars") +
  theme(plot.title = element_text(hjust = 0.5))


#============================== Draw different types of figures: Histogram =========================#
# Histogram of the engine displacement
hist1 <- ggplot(mpg, aes(x = displ)) + geom_histogram(fill = "lightblue") +
  labs(title = "Distribution of Engine Displacement", x = "Engine Displacement (liters)") +
  theme(plot.title = element_text(hjust = 0.5))

mpg[mpg$displ > 6, ]

# Add density plot and mean line on the histogram
ggplot(mpg, aes(x = displ)) + geom_histogram(aes(y=..density..), fill = "lightblue") +
  geom_density(alpha=.2, fill = "darkblue") + 
  labs(title = "Distribution of Engine Displacement", x = "Engine Displacement (liters)") +
  theme(plot.title = element_text(hjust = 0.5))

hist1 + geom_vline(aes(xintercept = mean(displ)), color="darkblue", linetype="dashed") 


#============================== Draw different types of figures: Box plot =========================#
# Bar plot of the type of cars by the type of drive train
# Set outliers = FALSE to suppress the display of outliers
ggplot(mpg, aes(x = class, y = hwy, fill = class)) + geom_boxplot(outliers = FALSE) + 
  labs(title = "Highway MPG by Car Type", y = "Highway MPG") +
  theme(plot.title = element_text(hjust = 0.5))

# Add data points to the box plot
ggplot(mpg, aes(x = class, y = hwy, fill = class)) + geom_boxplot(alpha = 0.5, outliers = FALSE) + 
  labs(title = "Highway MPG by Car Type", y = "Highway MPG") +
  geom_jitter(shape = 21) + theme_minimal() + 
  theme(legend.position="none", plot.title = element_text(hjust = 0.5))


#========================= Draw different types of figures: Correlation Heat Map ====================#
# Prepare the data
# The package reshape2 is required to melt the correlation matrix
# The function geom_tile() is used to visualize the correlation matrix
library(reshape2)
subcars <- mtcars[, c("mpg", "disp", "hp", "drat", "wt", "qsec")]
head(subcars)
cormat <- round(cor(subcars), 2)
cormat[lower.tri(cormat)]<- NA
melted_cormat <- melt(cormat, na.rm = TRUE) 

# An initial correlation heatmap
ggplot(data = melted_cormat, aes(x = Var2, y = Var1, fill = value)) + geom_tile() + 
  scale_fill_gradient2(low = "blue", high = "red", mid = "white", midpoint = 0, 
                       limit = c(-1,1), name = "Pearson\nCorrelation") 

# Add the value of the Pearson correlation to the heatmap
ggplot(melted_cormat, aes(Var2, Var1, fill = value)) + geom_tile(color = "white") +
  scale_fill_gradient2(low = "blue", high = "red", mid = "white", midpoint = 0, 
                       limit = c(-1,1), name = "Pearson\nCorrelation") +
  geom_text(aes(Var2, Var1, label = value), color = "black", size = 4) +
  theme_minimal() + theme(legend.position = 'inside',legend.position.inside = c(0.25, 0.75),
                          legend.direction = "horizontal") +
  guides(fill = guide_colorbar(title.position = "top", title.hjust = 0.5))
