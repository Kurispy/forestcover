import numpy as np
from sklearn.ensemble import RandomForestClassifier

df = np.loadtxt("/Users/rlau/repos/forestcover/covtype.data", delimiter=',')
train_x = df[1:522909,0:12]
train_y = df[1:522909,54]

clf = RandomForestClassifier(n_estimators=10, max_features = 12)
clf.fit(train_x, train_y)

