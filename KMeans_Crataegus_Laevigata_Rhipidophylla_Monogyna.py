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
df_LM = df_clean[(df_clean.samp_target == 3) | (df_clean.samp_target == 4) | (df_clean.samp_target == 5)]
target_values = []

X = df_LM.iloc[:,1:7].values
y = df_LM.iloc[:,0:1].values

# Scatterplot to identify the number of clusters
plt.scatter(X[:,0], X[:,1],c=y, cmap='gist_rainbow')
plt.xlabel('Disk Radius', fontsize=18)
plt.ylabel('Total Radius', fontsize=18)
plt.show()

km = KMeans(n_clusters = 3, random_state=21)
km.fit(X)

# identify center points
centers = km.cluster_centers_
print(centers)

#this will tell us to which cluster does the data observations belong.
new_labels = km.labels_
# Plot the identified clusters and compare with the answers
fig, axes = plt.subplots(1, 2, figsize=(16,8))
axes[0].scatter(X[:, 0], X[:, 1], c=y, cmap='gist_rainbow',
edgecolor='k', s=150)
axes[1].scatter(X[:, 0], X[:, 1], c=new_labels, cmap='jet',
edgecolor='k', s=150)
axes[0].set_xlabel('Disk radius', fontsize=18)
axes[0].set_ylabel('Total radius', fontsize=18)
axes[1].set_xlabel('Disk radius', fontsize=18)
axes[1].set_ylabel('Total radius', fontsize=18)
axes[0].tick_params(direction='in', length=10, width=5, colors='k', labelsize=20)
axes[1].tick_params(direction='in', length=10, width=5, colors='k', labelsize=20)
axes[0].set_title('Actual', fontsize=18)
axes[1].set_title('Predicted', fontsize=18)
plt.show()

###################################################################################
# same code only with the features disk radius and styles

# Scatterplot to identify the number of clusters
plt.scatter(X[:,0], X[:,5],c=y, cmap='gist_rainbow')
plt.xlabel('Disk Radius', fontsize=18)
plt.ylabel('Styles', fontsize=18)
plt.show()

km = KMeans(n_clusters = 2, random_state=21)
km.fit(X)

# identify center points
centers = km.cluster_centers_
print(centers)

#this will tell us to which cluster does the data observations belong.
new_labels = km.labels_
# Plot the identified clusters and compare with the answers
fig, axes = plt.subplots(1, 2, figsize=(16,8))
axes[0].scatter(X[:, 0], X[:, 5], c=y, cmap='gist_rainbow',
edgecolor='k', s=150)
axes[1].scatter(X[:, 0], X[:, 5], c=new_labels, cmap='jet',
edgecolor='k', s=150)
axes[0].set_xlabel('Disk radius', fontsize=18)
axes[0].set_ylabel('Styles', fontsize=18)
axes[1].set_xlabel('Disk radius', fontsize=18)
axes[1].set_ylabel('Styles', fontsize=18)
axes[0].tick_params(direction='in', length=10, width=5, colors='k', labelsize=20)
axes[1].tick_params(direction='in', length=10, width=5, colors='k', labelsize=20)
axes[0].set_title('Actual', fontsize=18)
axes[1].set_title('Predicted', fontsize=18)
plt.show()

###################################################################################
# same code only with the features disk radius and fruit width

# Scatterplot to identify the number of clusters
plt.scatter(X[:,0], X[:,3],c=y, cmap='gist_rainbow')
plt.xlabel('Disk Radius', fontsize=18)
plt.ylabel('Fruit Width', fontsize=18)
plt.show()

km = KMeans(n_clusters = 2, random_state=21)
km.fit(X)

# identify center points
centers = km.cluster_centers_
print(centers)

#this will tell us to which cluster does the data observations belong.
new_labels = km.labels_
# Plot the identified clusters and compare with the answers
fig, axes = plt.subplots(1, 2, figsize=(16,8))
axes[0].scatter(X[:, 0], X[:, 3], c=y, cmap='gist_rainbow',
edgecolor='k', s=150)
axes[1].scatter(X[:, 0], X[:, 3], c=new_labels, cmap='jet',
edgecolor='k', s=150)
axes[0].set_xlabel('Disk radius', fontsize=18)
axes[0].set_ylabel('Fruit Width', fontsize=18)
axes[1].set_xlabel('Disk radius', fontsize=18)
axes[1].set_ylabel('Fruit Width', fontsize=18)
axes[0].tick_params(direction='in', length=10, width=5, colors='k', labelsize=20)
axes[1].tick_params(direction='in', length=10, width=5, colors='k', labelsize=20)
axes[0].set_title('Actual', fontsize=18)
axes[1].set_title('Predicted', fontsize=18)
plt.show()
