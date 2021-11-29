setwd("C:/Users/anna.zoechner/OneDrive - Bundesforschungszentrum fuer Wald/Dokumente/GitHub/CrataegusAnalysis/PCA")

crataegus_morph <- read.csv("RearrangedTable.csv", na="NA")

# Create Dataframe from .csv File
# Exclude data about sepals
#df <- crataegus_morph[-c(3,5:8)]
df <- crataegus_morph[complete.cases(crataegus_morph), ] # deletes NAs

# Create subset with wanted species:
# 3: Laevigata
# 4: Rhipidophylla
# 5: Monogyna

df_sub <- subset(df, samp_target == "3" | samp_target == "4" |samp_target == "5")


# Correlations between Variables

corr <- cor(df_sub[,2:9])
round(corr, 3)

pairs(df_sub[,2:9])

# Are the (visual) correlations different for each class?
pairs(df_sub[,2:7],col=df_sub[,1],oma=c(4,4,6,12))
par(xpd=TRUE)
legend(0.85,0.6, as.vector(unique(df_sub$samp_target)),fill=c(1,2,3))


# PCA
crat_pca <- prcomp(df_sub[,c(2,4,7:9)], center = TRUE,scale. = TRUE)

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

#index = c("disk_radius", "fr_length", "styles")


# Plotting Cluster package
install.packages("cluster")
library(cluster)
autoplot(clara(df_sub[-1], 3))


autoplot(pam(df_sub[-1], 3), frame = TRUE, frame.type = 'norm')





