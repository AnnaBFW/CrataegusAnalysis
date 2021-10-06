# https://towardsdatascience.com/feature-selection-with-pandas-e3690ad8504b
# Feature Selection for Laevigata, Monogyna, Rhypidophylla

import pandas as pd
import numpy as np
import matplotlib
import matplotlib.pyplot as plt
import seaborn as sns
import statsmodels.api as sm
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LinearRegression
from sklearn.feature_selection import RFE
from sklearn.linear_model import RidgeCV, LassoCV, Ridge, Lasso

#### Preparation ####

df = pd.read_csv('RearrangedTable.csv')
df_new = df.drop(df.columns[[6, 7]], axis=1) # deleting data about sepals

# deleting all rows with nan
df_clean = df_new.dropna()

# keeping only data from Laevigata & Monogyna
df_LRM = df_clean[(df_clean.samp_target == 3) | (df_clean.samp_target == 4) | (df_clean.samp_target == 5)]

X = df_LRM.iloc[:,1:] # Feature Matrix
y = df_LRM["samp_target"] # Target Variable

df_LRM.head()

# The correlation coefficient has values between -1 to 1
# — A value closer to 0 implies weaker correlation (exact 0 implying no correlation)
# — A value closer to 1 implies stronger positive correlation
# — A value closer to -1 implies stronger negative correlation

# Using Pearson Correlation
plt.figure(figsize=(12,10))
cor = df_LRM.corr()
sns.heatmap(cor, annot=True, cmap=plt.cm.Reds)
plt.show()

# high correlation: tot - f_length/width

# Correlation with output variable
cor_target = abs(cor["samp_target"])
# Selecting highly correlated features
relevant_features = cor_target[cor_target>0.5]
print(relevant_features)

print(df[["disk_radius","styles"]].corr())

# Correlation: 0.47, not above 0.5

#Adding constant column of ones, mandatory for sm.OLS model
X_1 = sm.add_constant(X)
#Fitting sm.OLS model
model = sm.OLS(y,X_1).fit()
print("Model 1: ",model.pvalues)

# if pvalue above 0.05, remove the feature

X_2 = X_1.drop(X_1.columns[[4]], axis = 1)

#Backward Elimination
# returns features to keep (pvalue under 0.05)
cols = list(X.columns)
pmax = 1
while (len(cols)>0):
    p= []
    X_1 = X[cols]
    X_1 = sm.add_constant(X_1)
    model = sm.OLS(y,X_1).fit()
    p = pd.Series(model.pvalues.values[1:],index = cols)      
    pmax = max(p)
    feature_with_p_max = p.idxmax()
    if(pmax>0.05):
        cols.remove(feature_with_p_max)
    else:
        break
selected_features_BE = cols
print(selected_features_BE)

# disk_radius, tot_radius, fr_pos, styles


# Embedded Method: Lasso regularization

# If the feature is irrelevant,
# lasso penalizes it’s coefficient and make it 0.
#Hence the features with coefficient = 0 are removed and the rest are taken.

reg = LassoCV()
reg.fit(X, y)
print("Best alpha using built-in LassoCV: %f" % reg.alpha_)
print("Best score using built-in LassoCV: %f" %reg.score(X,y))
coef = pd.Series(reg.coef_, index = X.columns)


print("Lasso picked " + str(sum(coef != 0)) + " variables and eliminated the other " +  str(sum(coef == 0)) + " variables")

imp_coef = coef.sort_values()
import matplotlib
matplotlib.rcParams['figure.figsize'] = (8.0, 10.0)
imp_coef.plot(kind = "barh")
plt.title("Feature importance using Lasso Model")
plt.show()

# fruit width is almost 0

# according to the tutorial of this website it seems that we should leave out fruit width

##############################################################################################################################

#https://www.datacamp.com/community/tutorials/feature-selection-python

print("Different Tutorial: ")
import pandas as pd
import numpy as np

# A = X, B = Y
array = df_LRM.values
A = array[:,1:7]
B = array[:,0]

# Import the necessary libraries first
from sklearn.feature_selection import SelectKBest
from sklearn.feature_selection import chi2

# Feature extraction
test = SelectKBest(score_func=chi2, k=4) # choose the best 4 features
fit = test.fit(A, B)

# Summarize scores
np.set_printoptions(precision=3)
print(fit.scores_)

features = fit.transform(A)
# Summarize selected features
print(features[0:5,:])

# You can see the scores for each attribute and the 4 attributes chosen
# (those with the highest scores): disk_radius, tot_radius, fr_width, styles.

# Import your necessary dependencies
from sklearn.feature_selection import RFE
from sklearn.linear_model import LogisticRegression

# Feature extraction - select best 3 
model = LogisticRegression()
rfe = RFE(model, 3)
fit = rfe.fit(A, B)
print("Num Features: %s" % (fit.n_features_))
print("Selected Features: %s" % (fit.support_))
print("Feature Ranking: %s" % (fit.ranking_))

# disk_radius, fr_pos, styles

# ridge regression
from sklearn.linear_model import Ridge

ridge = Ridge(alpha=1.0)
ridge.fit(A,B)

# A helper method for pretty-printing the coefficients
def pretty_print_coefs(coefs, names = None, sort = False):
    if names == None:
        names = ["X%s" % x for x in range(len(coefs))]
    lst = zip(coefs, names)
    if sort:
        lst = sorted(lst,  key = lambda x:-np.abs(x[0]))
    return " + ".join("%s * %s" % (round(coef, 3), name)
                                   for coef, name in lst)


print ("Ridge model:", pretty_print_coefs(ridge.coef_))

# not the optimal optimizer, it stopped the iterations, therefore not sure how useful the results are
# Selected features: disk radius, fruit length and styles









