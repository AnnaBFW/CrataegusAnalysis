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


library(tidyverse)

#crataegus_ploidy <- crataegus_morph %>%
#  select(samp_name, place)

joined_data <- left_join(crataegus_morph, crataegus_ploidy, by = "samp_name")
