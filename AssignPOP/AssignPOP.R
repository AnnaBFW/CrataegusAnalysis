rm(list=ls())

setwd("C:/Users/anna.zoechner/OneDrive - Bundesforschungszentrum fuer Wald/Dokumente/GitHub/CrataegusAnalysis/AssignPOP")

crataegus_morph <- read.csv("RearrangedTable.csv", na="NA", header=TRUE)

# Create Dataframe from .csv File
# Exclude data about sepals
df <- crataegus_morph[-c(7:8)]
df <- df[complete.cases(df), ] # deletes NAs

# Create subset with wanted species:
# 3: Laevigata
# 4: Rhipidophylla
# 5: Monogyna

df_sub <- subset(df, samp_target == "3" | samp_target == "4" |samp_target == "5")

####################################################################
##### Assign Pop #####

install.packages("assignPOP")
library(assignPOP)

library(dplyr)

# Population label in last columns
df_sub <- df_sub %>%
  mutate(pop_label = case_when(samp_target == 3 ~ 'Laevigata',
                               samp_target == 4 ~ 'Rhipidophylla',
                               samp_target == 5 ~ 'Monogyna'))

install.packages("corrr")
library(corrr)
df_sub <- first_col(df_sub,rownames(df_sub), var="ID")
df_sub <- df_sub[-c(2)]

# Convert your sample ID to factor data type, because they are numeric 
df_sub[,1] <- as.factor(df_sub[,1])

# Monte-Carlo cross-validation
assign.MC(df_sub, train.inds=c(0.5, 0.7, 0.9), iterations=30, pca.method=TRUE, model="tree",
          dir="ResultFolder_MC/")










