# Factorizing
USA_Housing$SalePrice <- as.factor(USA_Housing$SalePrice)
class(USA_Housing$SalePrice)

library(psych)

pairs.panels(USA_Housing, digits = 3, pch = 21, lm=TRUE, ellipses = FALSE)
pairs.panels(USA_Housing[1:6], digits = 3, pch = 21, lm=TRUE, ellipses = FALSE)
pairs.panels(USA_Housing[7:12], digits = 3, pch = 21, lm=TRUE, ellipses = FALSE)
pairs.panels(USA_Housing[13:18], digits = 3, pch = 21, lm=TRUE, ellipses = FALSE)
pairs.panels(USA_Housing[14:23], digits = 3, pch = 21, lm=TRUE, ellipses = FALSE)


vars_except_saleprice <- setdiff(names(USA_Housing), "SalePrice")
subset_data <- USA_Housing[, c("SalePrice", vars_except_saleprice)]

pairs.panels(subset_data[2:6], digits = 3, pch = 21, lm = TRUE, ellipses = FALSE)


# Graphs
# 1 with OverallQual
# 2 with LivArea

USA_Housingnorm <- as.data.frame(lapply(USA_Housing,normalize))

# 1st Viz
#Plot the scatterplot matrix for OverallQual with SalePrice
ggplot(USA_Housingnorm, aes(x = OverallQual, y = SalePrice)) +
  geom_point(aes(fill = SalePrice, color = SalePrice)) +
  xlab("OverallQual") +
  ylab("SalePrice") + 
  ggtitle("SalePrice vs OverallQual") +
  theme(plot.title = element_text(hjust = 0.5))

# 2nd Viz
#Plot the scatterplot matrix for LivArea with SalePrice
ggplot(USA_Housingnorm, aes(x = LivArea, y = SalePrice)) +
  geom_point(aes(fill = SalePrice, color = SalePrice)) +
  xlab("LivArea") +
  ylab("SalePrice") + 
  ggtitle("SalePrice vs LivArea") +
  theme(plot.title = element_text(hjust = 0.5))

# Run linear regression
linearmodel <- lm(SalePrice~.,data = USA_Housing)

# Model summary
summary(linearmodel)

# Installing package
install.packages("car",dependencies = TRUE)
library(car)

# Using vif function for Variance inflation factor analysis
viftable<- vif(linearmodel)
viftable

# Sort the table in desceasing oder
sorttable <- sort(viftable,decreasing=TRUE)
sorttable

# Take attribute with vif smaller than 10
attributes <- sorttable[sorttable < 10]
attributes

vifless10 <- c("GarageCars", "GarageArea", "TotRmsAbvGrd" ,"TotalBsmtSF", "YearBuilt", "OverallQual", 
              "FullBath", "BsmtFin", "Bedroom", "HalfBath", "BsmtFullBath", "Fireplaces", "LotFrontage", 
              "Kitchen", "OverallCond", "LotArea",
              "WoodDeckSF", "BsmtHalfBath", "PoolArea")

#Creating Linear Model with attributes less than 10
lmOut <- lm(SalePrice ~ GarageCars + GarageArea + TotRmsAbvGrd + TotalBsmtSF + YearBuilt + OverallQual +  FullBath + BsmtFin + 
              Bedroom + HalfBath + BsmtFullBath + Fireplaces + LotFrontage + Kitchen + OverallCond + LotArea + WoodDeckSF + 
              BsmtHalfBath + PoolArea, data = USA_Housing)

summary(lmOut)

#Creating new dataset with attributes less than 10
housing <- USA_Housing[,c("SalePrice",vifless10)]

#Defining the normalize function 
normalize <- function(x) {return((x-min(x))/(max(x)-min(x)))}

#Defining the denormalize function 
denormalize <- function(y,x){return(y*(max(x)-min(x))+min(x))}

#Normalize the data
housingnorm <- as.data.frame(lapply(housing,normalize))

head(housingnorm)

#Separate Dataset into training and testing 
Housing_index <- sample(nrow(housingnorm), 0.7 * nrow(housingnorm),replace = FALSE)
Housing_train <- housingnorm[Housing_index, ]
Housing_test <- housingnorm[-Housing_index, ]

housingnet <- neuralnet(SalePrice ~ GarageCars + GarageArea + TotRmsAbvGrd + TotalBsmtSF + YearBuilt + OverallQual +  
                          FullBath + BsmtFin + Bedroom + HalfBath + BsmtFullBath + Fireplaces + LotFrontage + Kitchen + 
                          OverallCond + LotArea + WoodDeckSF + BsmtHalfBath + PoolArea, housingnorm, 
                          hidden = 1, lifesign = "minimal", linear.output = TRUE, threshold = 0.01)
plot(housingnet)

# Creating First Neural Network (One hidden Layer with loop from 1 to 3 nodes)
cur_max_list <- list()
for (layer_one in 1:3){
  housingnet <- neuralnet(SalePrice ~ GarageCars + GarageArea + TotRmsAbvGrd + TotalBsmtSF + YearBuilt + 
                          OverallQual +  FullBath + BsmtFin + Bedroom + HalfBath + BsmtFullBath + Fireplaces + 
                          LotFrontage + Kitchen + OverallCond + LotArea + WoodDeckSF + BsmtHalfBath + PoolArea,
                          Housing_train, hidden=layer_one, lifesign="minimal", linear.output=TRUE,
                          threshold=0.1,stepmax=1e7)
  Housing_results <- compute(housingnet, Housing_test[2:20])
  housingnorm <- denormalize(Housing_results$net.result, housing$SalePrice)
  actualstrength <- housing$SalePrice[-Housing_index]
  housingnet_correlation <- cor(housingnorm,actualstrength)
  print(housingnet_correlation)
  cur_max_list[paste(layer_one)] <- housingnet_correlation
}
cur_max_list[which.max(sapply(cur_max_list,max))]

plot(housingnet)

# Find the combination with the highest correlation
best_combination <- names(cur_max_list)[which.max(unlist(cur_max_list))]
print(paste("Best Combination:", best_combination, "Layer & Node:", cur_max_list[[best_combination]]))


# Creating Second Neural Network (two hidden Layer from 1 to 3 nodes)
housingnet2 <- neuralnet(SalePrice ~ GarageCars + GarageArea + TotRmsAbvGrd + TotalBsmtSF + YearBuilt + OverallQual +  
                          FullBath + BsmtFin + Bedroom + HalfBath + BsmtFullBath + Fireplaces + LotFrontage + Kitchen + 
                          OverallCond + LotArea + WoodDeckSF + BsmtHalfBath + PoolArea, Housing_train, 
                        hidden = 2, lifesign = "minimal", linear.output = TRUE, threshold = 0.01)
plot(housingnet2)

# Creating Second Neural Network (two hidden Layer with loop from 1 to 3 nodes)
cur_max_list <- list() # Initialize an empty list
# Loop through the first hidden layer node count (1 to 3)
for (first_layer_node in 1:3) {
  set.seed(7)
  for (second_layer_node in 1:3) {
    housingnet2 <- neuralnet(SalePrice ~ GarageCars + GarageArea + TotRmsAbvGrd + TotalBsmtSF + YearBuilt + 
                            OverallQual +  FullBath + BsmtFin + Bedroom + HalfBath + BsmtFullBath + Fireplaces + 
                            LotFrontage + Kitchen + OverallCond + LotArea + WoodDeckSF + BsmtHalfBath + PoolArea,
                            Housing_train, hidden = c(first_layer_node, second_layer_node), lifesign = "minimal",
                            linear.output = FALSE, threshold = 0.1, stepmax = 1e7)
    # Calculate predictions on the test data
    Housing_results <- compute(housingnet2, Housing_test[, 2:20])
    housingdenorm <- denormalize(Housing_results$net.result, housing$SalePrice[Housing_index])
    # Extract actual sale prices
    actualstrength <- housing$SalePrice[-Housing_index]
    # Calculate the correlation between predictions and actual values
    housingnet_correlation <- cor(housingdenorm, actualstrength)
    print(housingnet_correlation)
    # Save the highest correlation in each combination in the list
    key <- paste(first_layer_node, second_layer_node, sep = '-')
    cur_max_list[[key]] <- housingnet_correlation
  }
}
# Print the list of correlations for all combinations
print(cur_max_list)
cur_max_list[which.max(sapply(cur_max_list,max))]

# Find the combination with the highest correlation
best_combination <- names(cur_max_list)[which.max(unlist(cur_max_list))]
print(paste("Best Combination:", best_combination, "Layer & Node:", cur_max_list[[best_combination]]))

plot(housingnet2)