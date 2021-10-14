setwd("C:/Users/anna.zoechner/OneDrive - Bundesforschungszentrum fuer Wald/Dokumente/GitHub/CrataegusAnalysis/PCA")

crataegus_morph <- read.csv("RearrangedTable.csv", na="NA")

# Create Dataframe from .csv File
# Exclude data about sepals
df <- crataegus_morph[-c(6:8)]
df <- df[complete.cases(df), ] # deletes NAs

# Create subset with wanted species:
# 3: Laevigata
# 4: Rhipidophylla
# 5: Monogyna

df_sub <- subset(df, samp_target == "3" | samp_target == "4" |samp_target == "5")

# Standardization
df_sub <- scale(df_sub) # standardize variables


# Create dataframes for each feature
disk_radius = df_sub[2]
tot_radius = df_sub[3]
fr_length = df_sub[4]
fr_width = df_sub[5]
fr_pos = df_sub[6]
styles = df_sub[7]

# Determine number of clusters
wss <- (nrow(df_sub)-1)*sum(apply(df_sub,2,var))
for (i in 2:15) wss[i] <- sum(kmeans(df_sub,
                                     centers=i)$withinss)
plot(1:15, wss, type="b", xlab="Number of Clusters",
     ylab="Within groups sum of squares")


# K-Means Cluster Analysis
fit <- kmeans(df_sub, 3) # 5 cluster solution
# get cluster means
aggregate(df_sub,by=list(fit$cluster),FUN=mean)
# append cluster assignment
df_sub <- data.frame(df_sub, fit$cluster)

library(cluster)
clusplot(df_sub, fit$cluster, color=TRUE, shade=TRUE,lines=0)

# Centroid Plot against 1st 2 discriminant functions
install.packages("fpc")
library(fpc)
plotcluster(df_sub, fit$cluster)













