rm(list=ls())
# http://www.lac.inpe.br/~rafael.santos/Docs/CAP394/WholeStory-Iris.html

setwd("C:/Users/anna.zoechner/OneDrive - Bundesforschungszentrum fuer Wald/Dokumente/GitHub/CrataegusAnalysis/ExploratoryDataAnalysis")

crataegus_morph <- read.csv("RearrangedTable.csv", na="NA")

# Create Dataframe from .csv File, delete rows with NAs
df <- crataegus_morph[complete.cases(crataegus_morph), ]
#####
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
sep_width = df_sub[7]
sep_length = df_sub[8]
styles = df_sub[9]

# Summary for each column (feature)
summary(df)

# Boxplot
par(mar=c(7,5,1,1)) # more space to labels
boxplot(df_sub[-c(1)],las=2)


# distribution of the values for each attribute
df_sub_L <- subset(df_sub, samp_target == "3")
df_sub_R <- subset(df_sub, samp_target == "4")
df_sub_M <- subset(df_sub, samp_target == "5")
par(mfrow=c(1,3),mar=c(6,3,2,1))
boxplot(df_sub_L[,2:9], main="Laevigata",ylim = c(0,14),las=2)
boxplot(df_sub_R[,2:9], main="Rhipidophylla",ylim = c(0,14),las=2)
boxplot(df_sub_M[,2:9], main="Monogyna",ylim = c(0,14),las=2)

# Histogram for each feature
par(mfrow=c(1,1))
hist(df_sub$disk_radius)
hist(df_sub$tot_radius)
hist(df_sub$fr_length)
hist(df_sub$fr_width)
hist(df_sub$fr_pos)
hist(df_sub$styles)


# Compare features of each species

par(mfrow=c(1,3))
hist(df_sub_L$disk_radius,breaks=seq(0,8,l=17),xlim=c(0,8),ylim=c(0,150))
hist(df_sub_R$disk_radius,breaks=seq(0,8,l=17),xlim=c(0,8),ylim=c(0,150))
hist(df_sub_M$disk_radius,breaks=seq(0,8,l=17),xlim=c(0,8),ylim=c(0,150))

hist(df_sub_L$tot_radius,breaks=seq(0,8,l=17),xlim=c(0,8),ylim=c(0,150))
hist(df_sub_R$tot_radius,breaks=seq(0,8,l=17),xlim=c(0,8),ylim=c(0,150))
hist(df_sub_M$tot_radius,breaks=seq(0,8,l=17),xlim=c(0,8),ylim=c(0,150))

hist(df_sub_L$fr_length,breaks=seq(0,14,l=17),xlim=c(0,14),ylim=c(0,100))
hist(df_sub_R$fr_length,breaks=seq(0,14,l=17),xlim=c(0,14),ylim=c(0,100))
hist(df_sub_M$fr_length,breaks=seq(0,14,l=17),xlim=c(0,14),ylim=c(0,100))

hist(df_sub_L$fr_width,breaks=seq(0,12,l=17),xlim=c(0,12),ylim=c(0,100))
hist(df_sub_R$fr_width,breaks=seq(0,12,l=17),xlim=c(0,12),ylim=c(0,100))
hist(df_sub_M$fr_width,breaks=seq(0,12,l=17),xlim=c(0,12),ylim=c(0,100))

hist(df_sub_L$fr_pos,breaks=seq(0,10,l=17),xlim=c(0,10),ylim=c(0,80))
hist(df_sub_R$fr_pos,breaks=seq(0,10,l=17),xlim=c(0,10),ylim=c(0,80))
hist(df_sub_M$fr_pos,breaks=seq(0,10,l=17),xlim=c(0,10),ylim=c(0,80))

hist(df_sub_L$sep_width,breaks=seq(0,6,l=17),xlim=c(0,6),ylim=c(0,100))
hist(df_sub_R$sep_width,breaks=seq(0,6,l=17),xlim=c(0,6),ylim=c(0,100))
hist(df_sub_M$sep_width,breaks=seq(0,6,l=17),xlim=c(0,6),ylim=c(0,100))

hist(df_sub_L$sep_length,breaks=seq(0,6,l=17),xlim=c(0,6),ylim=c(0,100))
hist(df_sub_R$sep_length,breaks=seq(0,6,l=17),xlim=c(0,6),ylim=c(0,100))
hist(df_sub_M$sep_length,breaks=seq(0,6,l=17),xlim=c(0,6),ylim=c(0,100))

hist(df_sub_L$styles,breaks=seq(0,4,l=17),xlim=c(0,4),ylim=c(0,250))
hist(df_sub_R$styles,breaks=seq(0,4,l=17),xlim=c(0,4),ylim=c(0,250))
hist(df_sub_M$styles,breaks=seq(0,4,l=17),xlim=c(0,4),ylim=c(0,250))


# Beanplot
# Boxplots were really designed for normal data, or at least unimodal data. 
# The Beanplot shows you the actual density curve, which is more informative.
# The shape is the density, and the short horizontal lines represent each data point. 
# longer thick lines are the mean
# https://stats.stackexchange.com/questions/28612/wondering-what-this-bean-plot-analysis-chart-means
install.packages("beanplot")
library(beanplot)

par(mfrow=c(1,1))

xcrat <- df_sub
xcrat$samp_target <- NULL
beanplot(xcrat, main = "Crataegus fruits",
         col=c('#ff8080','#0000FF','#0000FF','#FF00FF'), 
         border = "#000000")


# Correlations between Variables

corr <- cor(df_sub[,2:9])
round(corr, 3)

library(corrplot)

col <- colorRampPalette(c("#BB4444", "#EE9988", "#FFFFFF", "#77AADD", "#4477AA"))
corrplot(corr,
         method="shade", # visualisation method
         shade.col=NA, # colour of shade line
         tl.col="black", # colour of text label
         tl.srt=45, # text label rotation
         col=col(200), # colour of glyphs
         addCoef.col="black", # colour of coefficients
         order="AOE" # ordering method
)

summary(df_sub_L)
summary(df_sub_M)
summary(df_sub_R)




