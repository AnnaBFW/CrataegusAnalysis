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

# creating array with samp_target column
target = df_LRM.samp_target


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
scatter = plt.scatter(x_pca[:,0],x_pca[:,1],c=target,cmap='rainbow')
plt.xlabel('First principal component')
plt.ylabel('Second Principal Component')
# add legend to the plot with names
plt.legend(handles=scatter.legend_elements()[0], 
           labels=sp_names,
           title="species")
plt.show()

# 3 groups clearly visible!!

###############################################################################################################

# Plotting with plotly express
# https://plotly.com/python/pca-visualization/

import plotly.express as px

features = ["disk_radius", "fr_length", "fr_pos", "styles"]

fig = px.scatter_matrix(
    df_LRM,
    dimensions=features,
    color="samp_target"
)
fig.update_traces(diagonal_visible=False)
fig.show()


#Visualize all the principal components
from sklearn.decomposition import PCA

pca = PCA()
components = pca.fit_transform(df_LRM[features])
labels = {
    str(i): f"PC {i+1} ({var:.1f}%)"
    for i, var in enumerate(pca.explained_variance_ratio_ * 100)
}

fig = px.scatter_matrix(
    components,
    labels=labels,
    dimensions=range(4),
    color=df_LRM["samp_target"]
)
fig.update_traces(diagonal_visible=False)
fig.show()

# PC1 vs. PC2 have together ~87% explained variance


# Visualize Loadings

X = df_LRM[features]

pca = PCA(n_components=2)
components = pca.fit_transform(X)

loadings = pca.components_.T * np.sqrt(pca.explained_variance_)

fig = px.scatter(components, x=0, y=1, color=df_LRM['samp_target'])

for i, feature in enumerate(features):
    fig.add_shape(
        type='line',
        x0=0, y0=0,
        x1=loadings[i, 0],
        y1=loadings[i, 1]
    )
    fig.add_annotation(
        x=loadings[i, 0],
        y=loadings[i, 1],
        ax=0, ay=0,
        xanchor="center",
        yanchor="bottom",
        text=feature,
    )
fig.show()

#############################################################################################################

# Model

from pca import pca

D = df_LRM.iloc[:,1:]

# Initialize to reduce the data up to the number of componentes that explains 95% of the variance.
model = pca(n_components=0.95)

# Or reduce the data towards 2 PCs
model = pca(n_components=2)

# Fit transform
results = model.fit_transform(D)

# Plot explained variance
fig, ax = model.plot()

# Scatter first 2 PCs
fig, ax = model.scatter()

# Make biplot with the number of features
fig, ax = model.biplot(n_feat=4)

