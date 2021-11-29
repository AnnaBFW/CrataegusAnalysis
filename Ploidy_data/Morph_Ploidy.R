rm(list=ls())

install.packages("readxl")
install.packages("dplyr")
library(readxl)
library(dplyr)


## Data preparation ##

setwd("C:/Users/anna.zoechner/OneDrive - Bundesforschungszentrum fuer Wald/Dokumente/GitHub/CrataegusAnalysis/Ploidy_data")


# Read in table with morphometric data
crataegus_morph <- read.csv("RearrangedTable_samp_names.csv", na="NA")


# Read in table with ploidy data
crataegus_ploidy <- read.csv("Ploidy_Crataegus.csv", na="NA", sep=";", header = FALSE)

colnames(crataegus_ploidy) = c("samp_name","place","ploidy") # give dataframe header

crataegus_ploidy$ploidy = substr(crataegus_ploidy$ploidy,1,nchar(crataegus_ploidy$ploidy)-1) # deleting x after ploidy level

crataegus_ploidy[, c(3)] <- sapply(crataegus_ploidy[, c(3)], as.numeric) # convert ploidy to numeric


# Dataframe combining morphometric and ploidy data
df = merge(crataegus_morph, crataegus_ploidy)


# Creating subset with data of Laevigata, Monogyna, Rhipidophylla
df_sub <- subset(df, samp_target == "3" | samp_target == "4" | samp_target == "5")


# Exclude data about sepals
df_sub <- df_sub[-c(7,8,10,11)]
df_sub <- df_sub[complete.cases(df_sub), ] # deletes NAs


# Make a sublist for each species
df_sub_L <- subset(df_sub, samp_target == "3")
df_sub_R <- subset(df_sub, samp_target == "4")
df_sub_M <- subset(df_sub, samp_target == "5")

summary(df_sub_L)
summary(df_sub_R)
summary(df_sub_M)

## Exploratory Data Analysis ## 

# Boxplots for each sepcies
par(mfrow=c(1,3),mar=c(6,3,2,1))
boxplot(df_sub_L[,2:8], main="Laevigata",ylim = c(0,14),las=2)
boxplot(df_sub_R[,2:8], main="Rhipidophylla",ylim = c(0,14),las=2)
boxplot(df_sub_M[,2:8], main="Monogyna",ylim = c(0,14),las=2)

# Histogram for ploidy for each species
hist(df_sub_L$ploidy,breaks=seq(0,4,l=17),xlim=c(0,4),ylim=c(0,250))
hist(df_sub_R$ploidy,breaks=seq(0,4,l=17),xlim=c(0,4),ylim=c(0,250))
hist(df_sub_M$ploidy,breaks=seq(0,4,l=17),xlim=c(0,4),ylim=c(0,250))

# Correlations between Variables
par(mfrow=c(1,1))
corr <- cor(df_sub[,2:8])
corr_matrix <- round(corr, 3)

write.table(corr_matrix,"Correlation_matrix.csv", row.names = FALSE)

pairs(df_sub[,2:8])

# Are the (visual) correlations different for each class?
pairs(df_sub[,3:9],col=df_sub[,2],oma=c(4,4,6,12))
par(xpd=TRUE)
legend(0.85,0.6, as.vector(unique(df_sub$samp_target)),fill=c(1,2,3))

install.packages("reshape2")
library(reshape2)
melted_cormat <- melt(corr)

library(ggplot2)
ggplot(data = melted_cormat, aes(x=Var1, y=Var2, fill=value)) + 
  geom_tile()



## KMeans ##

install.packages("factoextra")
install.packages("cluster")
library(factoextra)
library(cluster)

# Scale the data
df_scaled <- scale(df_sub[-c(1)])

# KMeans with 3 cluster
set.seed(1) # make it reproducable 

km <- kmeans(df_scaled, centers = 3, nstart = 25)

# Plot the model
fviz_cluster(km, data = df_scaled)

# Find mean values for each feature and each species
aggregate(df_sub[-c(1,2)], by=list(cluster=km$cluster), mean)



## PCA ##

# PCA with all features
crat_pca <- prcomp(df_sub[,c(3:9)], center = TRUE,scale. = TRUE)

summary(crat_pca)
str(crat_pca)

# PCA withouth ploidy
crat_pca_morph <- prcomp(df_sub[,c(3:8)], center = TRUE,scale. = TRUE)

# PCA with: disk_radius, fr_length, fr_pos, styles 
df_pca <- df_sub[-c(1,4,5)]

crat_pca_clean <-  prcomp(df_pca[,c(2:6)], center = TRUE,scale. = TRUE)

# PCA with selected features but without ploidy
df_pca_withoutploidy <- df_sub[-c(1,4,5,9)]

crat_pca_clean_withoutploidy <-  prcomp(df_pca_withoutploidy[,c(2:5)], center = TRUE,scale. = TRUE)


# Visualize PCA
# install_github("vqv/ggbiplot")
# install_github('sinhrks/ggfortify')

library(devtools)
library(ggbiplot)
library(ggfortify); library(ggplot2)


# PCA with all features
autoplot(crat_pca, data = df_sub, colour = 'samp_target' )

# PCA withouth ploidy
autoplot(crat_pca_morph, data = df_sub, colour = 'samp_target' )

# PCA with disk_radius, fr_length, fr_pos, styles 
autoplot(crat_pca_clean, data = df_pca, colour = 'samp_target' )

# PCA with selected features but without ploidy
autoplot(crat_pca_clean_withoutploidy, data = df_pca_withoutploidy, colour = 'samp_target' )


mean_vals_L <- apply(df_sub_L, MARGIN = 2, mean)
mean_vals_M <- apply(df_sub_M, MARGIN = 2, mean)
mean_vals_R <- apply(df_sub_R, MARGIN = 2, mean)
