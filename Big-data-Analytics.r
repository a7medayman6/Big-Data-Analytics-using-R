install.packages("factoextra")
library(factoextra)

# Step 1: Retrieve and Clean Up Data using R 
# ___________________________________________#

# Read the zeta file
zeta <- read.csv("./Data/zeta.csv")
head(zeta)

# Print the columns  names
colnames(zeta)

# print number of rows
print(nrow(zeta)) 

# check if there any dups 
nrow(unique(zeta))== nrow(zeta)

# ___________________________________________#
# Step 2: Data Analysis in R
# ___________________________________________#

# Read zipincome.csv file
zipincome = read.csv("./Data/zipIncome.csv")
colnames(zipincome)
head(zipincome)

# Change zcta column name to zipCode and meanhouseholdincome to income, in zipincome dataframe
colnames(zipincome) <- c("zipCode", "income")
colnames(zipincome)

# Print the summary of the zeta table to analyze
summary(zipincome)
# Plot the zipcode against the income in a scatter plot
plot(x = zipincome$zipCode,
     y = zipincome$income,
     xlab = "Zip Code",
     ylab = "Income",	 
     main = "Zip Code VS Income")

# Ommit outliers, by limiting the income to 7000 > income > 200,000
zipincome_omitted <- zipincome[(zipincome$income > 7000 & zipincome$income < 200000),]

# Number of rows before ommitting outliers
nrow(zipincome)
# Number of rows after ommitting outliers
nrow(zipincome_omitted)

# Print the summary of the zeta table after ommitting outliers
summary(zipincome_omitted)

# ___________________________________________#
# Step 3: Visualize your data
# ___________________________________________#

# Box Plot for income 
boxplot(zipincome_omitted$income~as.factor(zipincome_omitted$zipCode), 
        data=zipincome_omitted, 
        xlab = "Zip Code",
        ylab = "Income Amount", 
        main = "Income Box-Plot")

logincome = log10(zipincome_omitted$income)

# Box Plot for income log10 
boxplot(logincome~as.factor(zipincome_omitted$zipCode), 
        data=zipincome_omitted, 
        range=0,
        xlab = "Zip Code",
        ylab = "Income Amount", 
        main = "Log Income Box-Plot")

# ___________________________________________#
# Step 4 : Advanced Analytics/Methods (K-means)
# ___________________________________________#

# Read income_elec_state data and rename cols
income_elec <- read.csv("./Data/income_elec_state.csv")
colnames(income_elec) <- c("State", "Mean_Household_Income", "Mean_Electricity_Usage")
head(income_elec)

# Take the Mean_Household_Income, and Mean_Electricity_Usage cols
x <- income_elec[, 2:3]
x_sc <- scale(x)

# Calculate K-means with k = 10 and visualize the clusters alongside their centroids
k_out <- kmeans(x_sc, 10, 25)
fviz_cluster(object = list(data=x_sc,cluster=k_out$cluster))

# Visualize the Elbow to find a more suitable K value
fviz_nbclust(x_sc, kmeans, method="wss") + labs(subtitle="Elbow method")

# Calculate K-means with k = 8 and visualize the clusters alongside their centroids
k_out_2 <- kmeans(x_sc, 8, 25)
fviz_cluster(object = list(data=x_sc,cluster=k_out_2$cluster))


# Convert the data to log10
x_lg <- log10(x)
x_lg

x_lg_sc <- scale(x_lg)
x_lg_sc
# Calculate K-means with k = 8 and visualize the clusters alongside their centroids
k_out_3 <- kmeans(x_lg_sc, 8, 25)
fviz_cluster(object = list(data=x_lg_sc,cluster=k_out_3$cluster))


# Plot the data  to find the outliers
plot(x = x_lg$Mean_Household_Income,
     y = x_lg$Mean_Electricity_Usage,
     xlab = "Mean Household Income",
     ylab = "Mean Electricity Usage",	 
     main = "Mean Household Income VS Mean Electricity Usage")
# found outliers at Mean_Household_Income > 4.85

x_lg_om <- x_lg[(x_lg$Mean_Household_Income < 4.85) ,]
x_lg_om_sc <- scale(x_lg_om)
head(x_lg_om_sc)

# Plot the data to make sure deleted outliers
plot(x = x_lg_om$Mean_Household_Income,
     y = x_lg_om$Mean_Electricity_Usage,
     xlab = "Mean Household Income",
     ylab = "Mean Electricity Usage",	 
     main = "Mean Household Income VS Mean Electricity Usage")

# Visualize the Elbow to find a more suitable K value
fviz_nbclust(x_lg_om_sc, kmeans, method="wss") + labs(subtitle="Elbow method")
# found k = 8 to be more suitable

# Calculate K-means with k = 8 and visualize the clusters alongside their centroids
k_out_4 <- kmeans(x_lg_om_sc, 8, 25)
fviz_cluster(object = list(data=x_lg_om_sc,cluster=k_out_4$cluster))