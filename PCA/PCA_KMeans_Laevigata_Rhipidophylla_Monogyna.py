import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

# get dataframe
df = pd.read_csv('RearrangedTable.csv')
df_new = df.drop(df.columns[[2, 4, 6, 7]], axis=1) # deleting data about tot_radius, fr_width and sepals

# deleting all rows with nan
df_clean = df_new.dropna()

# keeping only data from Laevigata, Monogyna and Rhipidophylla
df_LRM = df_clean[(df_clean.samp_target == 3) | (df_clean.samp_target == 4) | (df_clean.samp_target == 5)]

X = df_LRM.iloc[:,1:7].values
y = df_LRM.iloc[:,0:1].values

# importing StandardScaler
from sklearn.preprocessing import StandardScaler
scaler = StandardScaler()
scaler.fit(df_LRM)

scaled_data = scaler.transform(df_LRM)

# PCA
from sklearn.decomposition import PCA
pca = PCA(n_components=2)
pca.fit(scaled_data)

x_pca = pca.transform(scaled_data)

# Scatterplot PC1 vs. PC2

plt.figure(figsize=(8,6))
sp_names = ['Laevigata', 'Rhipidophylla', 'Monogyna']
scatter = plt.scatter(x_pca[:,0],x_pca[:,1],c=y,cmap='rainbow')
plt.xlabel('First principal component')
plt.ylabel('Second Principal Component')
# add legend to the plot with names
plt.legend(handles=scatter.legend_elements()[0], 
           labels=sp_names,
           title="species")
plt.show()

from sklearn.cluster import KMeans

# KMeans with dimension reduced data

km = KMeans(n_clusters = 3, random_state=21)
km.fit(X)

# identify center points
centers = km.cluster_centers_
print(centers)

#this will tell us to which cluster does the data observations belong.
new_labels = km.labels_

