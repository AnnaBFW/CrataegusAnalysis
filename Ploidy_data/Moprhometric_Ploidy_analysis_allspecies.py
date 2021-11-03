from sklearn import datasets
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
from sklearn.cluster import KMeans

# Read in tables
df_morph = pd.read_csv('RearrangedTable_samp_names.csv') # morphometric data
df_new = df_morph.drop(df_morph.columns[[7, 8]], axis=1) # deleting data about sepals

df_ploidy = pd.read_csv('Ploidy_Crataegus.csv', sep = ';', header = None, names=["samp_name", "place", "ploidy"], dtype = 'str') # ploidy data


# deleting all rows with nan
df_morph_clean = df_new.dropna()
df_ploidy_clean = df_ploidy.dropna()

# Deleting the x for each ploidy level
ploidy_array = df_ploidy_clean.iloc[:,2:].values
ploidy_array_brackets = np.array(ploidy_array).ravel()
ploidy = [x[:-1] for x in ploidy_array_brackets]
float_ploidy = [float(item) for item in ploidy]

df_ploidy_clean.loc[:,'ploidy'] = float_ploidy

# Adding column with sample target to the df_ploidy

# extracting array with sample names
samp_df = df_ploidy_clean.iloc[:,0:1].values

# deleting brackets of the names
samp_list = [] # new list for sample names without brackets

for i in samp_df:
    samp_list.append(str(i)[2:-2])
    
samp_array = np.array(samp_list) # converting samp_list to array
    
# assigning numbers to species

import re # Regular expression library

# first: legend -> each species is assigned to one number
legend = np.array([['HMAC','HMED','HS','L','R','M'], [0,1,2,3,4,5]])

samp_target = [] # list for species numbers
samp_name = [] # list for sample names

for name in samp_array:
    if re.search('HMAC.+', name): 
            samp_target.append(0)
    elif re.search('HMED.+', name): 
            samp_target.append(1)
    elif re.search('HS.+', name): 
            samp_target.append(2)
    elif re.search('L.+', name): 
            samp_target.append(3)
    elif re.search('R.+', name): 
            samp_target.append(4)
    elif re.search('M.+', name): 
            samp_target.append(5)
    else:
        samp_target.append('NA')

df_ploidy_clean.insert(0, "samp_target", samp_target)

# keeping only data from Laevigata, Monogyna and Rihpidophylla
# 3: Laevigata, 4: Rhipidophylla, 5: Monogyna
df_morph_LRM = df_morph_clean[(df_morph_clean.samp_target == 3) | (df_morph_clean.samp_target == 4) | (df_morph_clean.samp_target == 5)]
df_ploidy_LRM = df_ploidy_clean[(df_ploidy_clean.samp_target == 3) | (df_ploidy_clean.samp_target == 4) | (df_ploidy_clean.samp_target == 5)]

result1 = pd.merge(df_morph_LRM, df_ploidy_LRM, on=["samp_name","samp_target"])
result2 = result1.drop(['place', 'samp_name'], axis = 1)


#result2.to_csv("MergedTable.csv", index=False)

# X = df_LRM.iloc[:,1:7].values
# y = df_LRM.iloc[:,0:1].values
# 
# disk_radius = X[:, 0]
# tot_radius = X[:, 1]
# fr_length = X[:, 2]
# fr_width = X[:, 3]
# fr_pos = X[:, 4]
# styles = X[:, 5]

# Seaborn visualization, comparing all combinations of features
#import seaborn as sns

import seaborn as sns

sns_plot = sns.pairplot(result2, hue='samp_target', height=2.5)
plt.show()
sns_plot.savefig("Scatterplot_CombinationallFeatures_ploidy_Laev_Mon_Rhip.png")

