from sklearn import datasets
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
from sklearn.cluster import KMeans

df = pd.read_csv('RearrangedTable.csv')
df_new = df.drop(df.columns[[6, 7]], axis=1) # deleting data about sepals

print(df.head())

# deleting all rows with nan
df_clean = df_new.dropna()

# keeping only data from Laevigata, Monogyna and Rihpidophylla
# 3: Laevigata, 4: Rhipidophylla, 5: Monogyna
df_LRM = df_clean[(df_clean.samp_target == 3) | (df_clean.samp_target == 4) | (df_clean.samp_target == 5)]

df_LRM = pd.DataFrame(df_LRM,columns=['samp_target','disk_radius', 'tot_radius', 'fr_length', 'fr_width','fr_pos','styles'])

# Putting Monogyna and Rhipidophylla into one group: 5
df_LRM['samp_target']= df_LRM['samp_target'].replace([4],5)

X = df_LRM.iloc[:,1:7].values
y = df_LRM.iloc[:,0:1].values

disk_radius = X[:, 0]
tot_radius = X[:, 1]
fr_length = X[:, 2]
fr_width = X[:, 3]
fr_pos = X[:, 4]
styles = X[:, 5]

# Seaborn visualization, comparing all combinations of features
#import seaborn as sns

# KMeans

km = KMeans(n_clusters = 2, random_state=21)
km.fit(X)

# identify center points
centers = km.cluster_centers_
print(centers)

#this will tell us to which cluster does the data observations belong.
new_labels = km.labels_

#sns_plot = sns.pairplot(df_LRM, hue='samp_target', height=2.5)
#sns_plot.savefig("Scatterplot_CombinationallFeatures_Laev_against_MonRhip.png")

fig, axes = plt.subplots(1, 2, figsize=(16,8))
axes[0].scatter(X[:, 3], X[:, 4], c=y, cmap='gist_rainbow',
edgecolor='k', s=150)
axes[1].scatter(X[:, 3], X[:, 4], c=new_labels, cmap='jet',
edgecolor='k', s=150)
axes[0].set_xlabel('Fruit Length', fontsize=18)
axes[0].set_ylabel('Fruit Width', fontsize=18)
axes[1].set_xlabel('Fruit Length', fontsize=18)
axes[1].set_ylabel('Fruit Width', fontsize=18)
axes[0].tick_params(direction='in', length=10, width=5, colors='k', labelsize=20)
axes[1].tick_params(direction='in', length=10, width=5, colors='k', labelsize=20)
axes[0].set_title('Actual', fontsize=18)
axes[1].set_title('Predicted', fontsize=18)
plt.legend(y)
plt.show()


plt.figure(figsize=(8,6))
sp_names = ['Laevigata', 'Mixture']
scatter = plt.scatter(X[:, 3], 
            X[:, 4],
            c=y)
plt.xlabel("Fruit Length", size=24)
plt.ylabel("Fruit Width", size=24)
# add legend to the plot with names
plt.legend(handles=scatter.legend_elements()[0], 
           labels=sp_names,
           title="species")
plt.show()