setwd("C:/Users/anna.zoechner/OneDrive - Bundesforschungszentrum fuer Wald/Dokumente/GitHub/CrataegusAnalysis/PCA")

crataegus_morph <- read.csv("RearrangedTable.csv", na="NA")

# Create Dataframe from .csv File
# Exclude data about sepals
df <- crataegus_morph[-c(3,6:8)]
df <- df[complete.cases(df), ] # deletes NAs

# Create subset with wanted species:
# 3: Laevigata
# 4: Rhipidophylla
# 5: Monogyna

df_sub <- subset(df, samp_target == "3" | samp_target == "4" |samp_target == "5")


# Create dataframes for each feature
disk_radius = df_sub[2]
tot_radius = df_sub[3]
fr_length = df_sub[4]
fr_width = df_sub[5]
fr_pos = df_sub[6]
styles = df_sub[7]

# PCA
crat_pca <- prcomp(df_sub[,c(2:4)], center = TRUE,scale. = TRUE)

summary(crat_pca)
str(crat_pca)

# Visualize PCA
install_github("vqv/ggbiplot")
install_github('sinhrks/ggfortify')

library(devtools)
library(ggbiplot)
library(ggfortify); library(ggplot2)



autoplot(crat_pca)
autoplot(crat_pca, data = df_sub, colour = 'samp_target', loadings=TRUE, loadings.label=TRUE)


# Plotting Cluster package
install.packages("cluster")
library(cluster)
autoplot(clara(df_sub[-1], 3))


autoplot(pam(df_sub[-1], 3), frame = TRUE, frame.type = 'norm')





