#' @title Replacing all NAs with mean values of a given row
#' @param data is the data you for which the mean is needed
#' @param func describes the function to use. Currently only supports the mean(others may work with some inaccuracies)
#' @param observations takes on column names  for which manipulations are required
#' @param na.rm Logical. Should NAs be removed from analysis?
#' @param exc the column to exclude from analysis. Useful for removing factor columns
#' @return Returns a data.frame object showing columns with NAs and their replacement if na.rm=T
#' @export
row_mean_na<-function(data,func,observations,na.rm=F,exc){
  .Deprecated("na_replace")
  m<-as.data.frame(mget(observations,envir = as.environment(data)))
  if(na.rm==T){
  #m[is.na(m)]<-as.numeric(0)
  res1<-apply(m[complete.cases(m),],1,func)
  m<-m[!complete.cases(m),]
  m[is.na(m)]<-0
  res2<-rowSums(m)/ncol(m)
  with_NA<-data[,observations]
  with_NA<-with_NA[!complete.cases(with_NA),]
 res<-reshape2::melt(c(res1,res2))
 res_with_NA<-setNames(cbind(res2,with_NA),nm=c("Replacement"))
 #return(list(res1,res2,with_NA,res_with_NA["Replacement"]))
 replaced<-list(res1,res2,res_with_NA["Replacement"])[3]
 merge(data,replaced,by=0)[-1]
 #res2  contains mean for rows with NAs
 #exc is the column to exclude ie has non numeric data
  #res1 has mean for all rows with no NAs
  }else{
 res3<-reshape2::melt(apply(m,1,func))
 data.frame(data,res3)
}
}
#' @title Replace missing values
#' @param df The data set for which replacements are required
#' @param how How should missing values be replaced?  One of ffill, samples or any other known
#' method e.g mean, median, max ,min. The default is NULL meaning no  imputation is done.
#' @return A data.frame object with missing values replaced.
#' @examples
#' set.seed(520)
#' na_replace(airquality,how="samples")
#' @export
na_replace<-function(df,how=NULL){
if(is.null(how)){
  return(df)
}
else if(!how%in%c("ffill","samples")){
  as.data.frame(apply(df,2,function(x){
    x[is.na(x)]<-do.call(how,list(x[!is.na(x)]))
    x
  }))
}
else if(how=="ffill"){
  as.data.frame(apply(df,2,function(x){
    to_replace<-x[!is.na(x)]
    x[is.na(x)]<-to_replace[1:length(x[is.na(x)])]
    x
  }))
}
else if(how=="samples"){
  as.data.frame(apply(df,2,function(x){
    to_replace<-x[!is.na(x)]
    x[is.na(x)]<-sample(to_replace,length(x[is.na(x)]),replace = TRUE)
    x
  }))
}

}


