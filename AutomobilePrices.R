# read in the data
df <- read.table("imports-85.data", sep = ",", na.strings = "?")
# add column names
colnames(df) <- c("symboling", "normalized_losses", "make", "fuel_type", "aspiration",
                  "num_of_doors", "body_style", "drive_wheels", "engine_location", "wheel_base",
                  "length", "width", "height", "curb_weight", "engine_type",
                  "num_of_cylinders", "engine_size", "fuel_system", "bore", "stroke",
                  "compression_ratio", "horsepower", "peak_rpm", "city_mpg", "highway_mpg",
                  "price")
# remove symboling and normalized_losses columns as we are only interested in car characteristics
df <- df[, -c(1, 2)]
# remove rows that have missing values for one or more variables
df <- na.omit(df)
# final data set
summary(df)

### Part 1
## (2)
plot(price ~ horsepower, data = df,
     xlab = "Horsepower", ylab = "Price",
     main = "Scatterplot of Automobile's Price vs Horsepower")

## (3)
# log-transform price and horsepower
df$lprice <- log(df$price)
df$lhorsepower <- log(df$horsepower)
# histograms of variables before and after transformation
par(mfrow = c(2, 2))
hist(df$price, breaks = 20,
     xlab = "Price", main = "Histogram of Price")
hist(df$lprice, breaks = 20,
     xlab = "Log of Price", main = "Histogram of Log of Price")
hist(df$horsepower, breaks = 20,
     xlab = "Horsepower", main = "Histogram of Horsepower")
hist(df$lhorsepower, breaks = 20,
     xlab = "Log of Horsepower", main = "Histogram of Log of Horsepower")
par(mfrow = c(1, 1))
# scatterplot of log-transformed data
plot(lprice ~ lhorsepower, data = df,
     xlab = "Log of Horsepower", ylab = "Log of Price",
     main = "Scatterplot of Log of Automobile's Price vs Log of Horsepower")

## (4)
mod1 <- lm(lprice ~ lhorsepower, data = df)
summary(mod1)

# superimpose regression line on the scatterplot
plot(lprice ~ lhorsepower, data = df,
     xlab = "Log of Horsepower", ylab = "Log of Price",
     main = "Scatterplot of Log of Automobile's Price vs Log of Horsepower")
abline(mod1, col = "red")

## (6)
confint(mod1)

## (8)
x <- seq(3.5, 6, by = 0.1)
y.pred <- predict(mod1, newdata = data.frame(lhorsepower = x),
                  interval = "confidence", level = 0.9)
# scatterplot
plot(lprice ~ lhorsepower, data = df,
     xlab = "Log of Horsepower", ylab = "Log of Price",
     main = "Scatterplot of Log of Automobile's Price vs Log of Horsepower")
# superimpose regression line
abline(mod1, col = "red")
# lower confidence band
lines(x, y.pred[, "lwr"], col = "blue")
# upper confidence band
lines(x, y.pred[, "upr"], col = "blue")

## (9)
# residuals vs fitted
plot(mod1, which = 1)
# normal probability plot
plot(mod1, which = 2)


### Part 2
## (i)
mod2 <- lm(lprice ~ lhorsepower + length + city_mpg, data = df)
summary(mod2)

## (iii)
anova_tbl <- anova(mod2)
anova_tbl
# SST
sum(anova_tbl$`Sum Sq`)
# SST df
sum(anova_tbl$Df)
# SSR
sum(anova_tbl$`Sum Sq`[1:3])
# SSR df
sum(anova_tbl$Df[1:3])

## (vi)
mod3 <- lm(lprice ~ lhorsepower * fuel_type, data = df)
summary(mod3)

## (x)
# remove price and horsepower as we use log-transformed price and horsepower
df <- subset(df, select = -c(price, horsepower))
# fit the full model 
full.model <- lm(lprice ~ ., data = df)
# backward model selection using AIC
library(MASS)
mod4 <- stepAIC(full.model, direction = "backward", trace = FALSE)
summary(mod4)
extractAIC(mod4)
