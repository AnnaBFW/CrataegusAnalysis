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

#sns_plot = sns.pairplot(df_LRM, hue='samp_target', height=2.5)
#sns_plot.savefig("Scatterplot_CombinationallFeatures_Laev_Mon_Rhip.png")

# We already know there are 3 groups so 3 cluster

km = KMeans(n_clusters = 3, random_state=21)
km.fit(X)

# identify center points
centers = km.cluster_centers_
print(centers)

#this will tell us to which cluster does the data observations belong.
new_labels = km.labels_

# Plot the identified clusters and compare with the answers
# Try: disk_radius & fruit length, fruit length and fruit width

fig, axes = plt.subplots(1, 2, figsize=(16,8))
axes[0].scatter(X[:, 0], X[:, 3], c=y, cmap='gist_rainbow',
edgecolor='k', s=150)
axes[1].scatter(X[:, 0], X[:, 3], c=new_labels, cmap='jet',
edgecolor='k', s=150)
axes[0].set_xlabel('Disk radius', fontsize=18)
axes[0].set_ylabel('Fruit Length', fontsize=18)
axes[1].set_xlabel('Disk radius', fontsize=18)
axes[1].set_ylabel('Fruit Length', fontsize=18)
axes[0].tick_params(direction='in', length=10, width=5, colors='k', labelsize=20)
axes[1].tick_params(direction='in', length=10, width=5, colors='k', labelsize=20)
axes[0].set_title('Actual', fontsize=18)
axes[1].set_title('Predicted', fontsize=18)
plt.show()

plt.figure(figsize=(8,6))
sp_names = ['Laevigata', 'Rhipidophylla', 'Monogyna']
scatter = plt.scatter(X[:, 0], X[:, 4], c=y)
plt.xlabel("Disk radius", size=24)
plt.ylabel("Fruit Length", size=24)
# add legend to the plot with names
plt.legend(handles=scatter.legend_elements()[0], 
           labels=sp_names,
           title="species")
plt.show()

# Looks more like 2 cluster, which makes sense according to the distribution graphs

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
sp_names = ['Laevigata', 'Rhipidophylla', 'Monogyna']
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



