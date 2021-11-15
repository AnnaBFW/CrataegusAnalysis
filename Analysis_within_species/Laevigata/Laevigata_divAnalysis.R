rm(list=ls())

## Data preparation ##

setwd("C:/Users/anna.zoechner/OneDrive - Bundesforschungszentrum fuer Wald/Dokumente/GitHub/CrataegusAnalysis/Analysis_within_species/Laevigata")

# Read in table with morphometric data
crataegus_morph <- read.csv("Rearranged_completeTable.csv", na="NA")

# Read in table with ploidy data
crataegus_ploidy <- read.csv("Ploidy_Crataegus.csv", na="NA", sep=";", header = FALSE)

colnames(crataegus_ploidy) = c("samp_name","place","ploidy") # give dataframe header

crataegus_ploidy$ploidy = substr(crataegus_ploidy$ploidy,1,nchar(crataegus_ploidy$ploidy)-1) # deleting x after ploidy level

crataegus_ploidy[, c(3)] <- sapply(crataegus_ploidy[, c(3)], as.numeric) # convert ploidy to numeric

# Dataframe combining morphometric and ploidy data
df = merge(crataegus_morph, crataegus_ploidy)

# Creating subset with data of Laevigata
df_sub <- subset(df, samp_target == "3")

# Exclude data about sepals
df_sub = subset(df_sub, select = -c(9,10,12) )
df_sub <- df_sub[complete.cases(df_sub), ] # deletes NAs

# -----------------------------------------------------------------

# Sub groups: population numbers

# Create dataframes for each feature
disk_radius = df_sub[4]
tot_radius = df_sub[5]
fr_length = df_sub[6]
fr_width = df_sub[7]
fr_pos = df_sub[8]
styles = df_sub[9]
ploidy = df_sub[10]

# Summary for each column (feature)
summary(df)
#write.csv(summary(df), file="Summary.csv")
# Boxplot
par(mar=c(7,5,1,1)) # more space to labels
boxplot(df_sub[-c(1,2,3)],las=2)

# distribution of the values for each attribute and each population
df_sub_zero <- subset(df_sub, pop_numbers == "0")
df_sub_one <- subset(df_sub, pop_numbers == "1")
df_sub_two <- subset(df_sub, pop_numbers == "2")
df_sub_five <- subset(df_sub, pop_numbers == "5")
df_sub_eight <- subset(df_sub, pop_numbers == "8")

par(mfrow=c(1,5))
boxplot(df_sub_zero[,4:10], main="Population 0",ylim = c(0,14),las=2)
boxplot(df_sub_one[,4:10], main="Population 1",ylim = c(0,14),las=2)
boxplot(df_sub_two[,4:10], main="Population 2",ylim = c(0,14),las=2)
boxplot(df_sub_five[,4:10], main="Population 5",ylim = c(0,14),las=2)
boxplot(df_sub_eight[,4:10], main="Population 8",ylim = c(0,14),las=2)


# Compare features of each species

par(mfrow=c(1,5))
hist(df_sub_zero$disk_radius,breaks=seq(0,8,l=17),xlim=c(0,8),ylim=c(0,150))
hist(df_sub_one$disk_radius,breaks=seq(0,8,l=17),xlim=c(0,8),ylim=c(0,150))
hist(df_sub_two$disk_radius,breaks=seq(0,8,l=17),xlim=c(0,8),ylim=c(0,150))
hist(df_sub_five$disk_radius,breaks=seq(0,8,l=17),xlim=c(0,8),ylim=c(0,150))
hist(df_sub_eight$disk_radius,breaks=seq(0,8,l=17),xlim=c(0,8),ylim=c(0,150))

hist(df_sub_zero$tot_radius,breaks=seq(0,8,l=17),xlim=c(0,8),ylim=c(0,150))
hist(df_sub_one$tot_radius,breaks=seq(0,8,l=17),xlim=c(0,8),ylim=c(0,150))
hist(df_sub_two$tot_radius,breaks=seq(0,8,l=17),xlim=c(0,8),ylim=c(0,150))
hist(df_sub_five$tot_radius,breaks=seq(0,8,l=17),xlim=c(0,8),ylim=c(0,150))
hist(df_sub_eight$tot_radius,breaks=seq(0,8,l=17),xlim=c(0,8),ylim=c(0,150))

hist(df_sub_zero$fr_length,breaks=seq(0,14,l=17),xlim=c(0,14),ylim=c(0,150))
hist(df_sub_one$fr_length,breaks=seq(0,14,l=17),xlim=c(0,14),ylim=c(0,150))
hist(df_sub_two$fr_length,breaks=seq(0,14,l=17),xlim=c(0,14),ylim=c(0,150))
hist(df_sub_five$fr_length,breaks=seq(0,14,l=17),xlim=c(0,14),ylim=c(0,150))
hist(df_sub_eight$fr_length,breaks=seq(0,14,l=17),xlim=c(0,14),ylim=c(0,150))

hist(df_sub_zero$fr_width,breaks=seq(0,12,l=17),xlim=c(0,12),ylim=c(0,70))
hist(df_sub_one$fr_width,breaks=seq(0,12,l=17),xlim=c(0,12),ylim=c(0,70))
hist(df_sub_two$fr_width,breaks=seq(0,12,l=17),xlim=c(0,12),ylim=c(0,70))
hist(df_sub_five$fr_width,breaks=seq(0,12,l=17),xlim=c(0,12),ylim=c(0,70))
hist(df_sub_eight$fr_width,breaks=seq(0,12,l=17),xlim=c(0,12),ylim=c(0,70))

hist(df_sub_zero$fr_pos,breaks=seq(0,10,l=17),xlim=c(0,10),ylim=c(0,150))
hist(df_sub_one$fr_pos,breaks=seq(0,10,l=17),xlim=c(0,10),ylim=c(0,150))
hist(df_sub_two$fr_pos,breaks=seq(0,10,l=17),xlim=c(0,10),ylim=c(0,150))
hist(df_sub_five$fr_pos,breaks=seq(0,10,l=17),xlim=c(0,10),ylim=c(0,150))
hist(df_sub_eight$fr_pos,breaks=seq(0,10,l=17),xlim=c(0,10),ylim=c(0,150))

hist(df_sub_zero$styles,breaks=seq(0,4,l=17),xlim=c(0,4),ylim=c(0,150))
hist(df_sub_one$styles,breaks=seq(0,4,l=17),xlim=c(0,4),ylim=c(0,150))
hist(df_sub_two$styles,breaks=seq(0,4,l=17),xlim=c(0,4),ylim=c(0,150))
hist(df_sub_five$styles,breaks=seq(0,4,l=17),xlim=c(0,4),ylim=c(0,150))
hist(df_sub_eight$styles,breaks=seq(0,4,l=17),xlim=c(0,4),ylim=c(0,150))

hist(df_sub_zero$ploidy,breaks=seq(0,8,l=17),xlim=c(0,8),ylim=c(0,150))
hist(df_sub_one$ploidy,breaks=seq(0,8,l=17),xlim=c(0,8),ylim=c(0,150))
hist(df_sub_two$ploidy,breaks=seq(0,8,l=17),xlim=c(0,8),ylim=c(0,150))
hist(df_sub_five$ploidy,breaks=seq(0,8,l=17),xlim=c(0,8),ylim=c(0,150))
hist(df_sub_eight$ploidy,breaks=seq(0,8,l=17),xlim=c(0,8),ylim=c(0,150))

# Summaries of the populations

summary(df_sub_zero)
summary(df_sub_one)
summary(df_sub_two)
summary(df_sub_five)
summary(df_sub_eight)





