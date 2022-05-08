
kdmd<-function(x){
  if (!is.matrix(x)) stop("X must be matrix")
  structure(as.matrix(x), class = c("kdmd", 'matrix', 'array'))
}
#' Create a Koopman Matrix
#'
#' @param data the matrix data for which you wish to predict future columns
#' @param p The Percentage of explanation of the SVD required (default=1)
#' Returns an object of class kdmd
#' @examples
#' ## Not run:
#' m<-matrix(ncol=10,nrow=3)
#' m[1,]<-1:10
#' m[2,]<-2:11
#' m[3,]<-3,12
#' A<-getAmatrix(m)
#' @importFrom pracma pinv
#' @export
getAMatrix<-function(data,p=1){
  x<-data[,-ncol(data)]
  y<-data[,-1]
  wsvd<-base::svd(x)
  sv<-(wsvd$d^2)/sum(wsvd$d^2)
  if (p==1){
    r<-length(sv)
  } else {
    r<-max(which(cumsum(sv)>=p)[1],2)
  }

  u<-wsvd$u
  v<-wsvd$v
  d<-wsvd$d
  Atil2<-crossprod(u[,1:r],y)
  Atil3<-crossprod(t(Atil2),v[,1:r])
  AtilR<-crossprod(t(Atil3),diag(1/d[1:r]))
  eig<-eigen(AtilR)
  Phi<-eig$values
  Q<-eig$vectors
  Psi<- y %*% v[,1:r] %*% diag(1/d[1:r]) %*% (Q)
  x<-Psi %*% diag(Phi) %*% pracma::pinv(Psi)
  A<- kdmd(x)
  return(A)
}


#' Predict from a Koopman Matrix
#'
#' @param A the Koopman Matrix for prediction
#' @param data the matrix data for which you wish to predict future columns
#' @param l the length of the predictions (number of columns to predict)
#' @param p The Percentage of explanation of the SVD required (default=1)
#' Returns a matrix with l additional columns
#' @examples
#' ## Not run:
#' m<-matrix(ncol=10,nrow=3)
#' m<-matrix(ncol=10,nrow=3)
#' m[1,]<-1:10
#' m[2,]<-2:11
#' m[3,]<-3:12
#' A<-getAmatrix(m)
#' predict(A,m,1)
#' @importFrom pracma pinv
#' @export
predict.kdmd<-function(A,data,l,p=1){
  len_predict<-l
  t<-dim(data)[2]
  N<-dim(data)[1]
  ynew<-data
  for (st in 0:(len_predict-1)){
    b<-Re(crossprod(t(A),matrix(ynew[,(t+st)], ncol=1)))
    ynew<-cbind(ynew,b)
  }
  return(ynew)
}
