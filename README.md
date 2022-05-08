## Koopman Dynamic Mode Decomposition Prediction

This is an experimental R package implementing Koopman Matrix Dymanic Mode Decomposition Machine Learning and Prediction. Example:

```
Library(Rdmd)
# Create a trivial test matrix
m<-matrix(ncol=10,nrow=3)
m[1,]<-1:10
m[2,]<-2:11
m[3,]<-3:12
# Obtain the Koopman Matrix
A<-getAMatrix(m)
# predict the next column of data
predict(A,m,1)

