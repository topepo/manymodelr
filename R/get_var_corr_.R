#' Get correlations for combinations
#' @importFrom utils combn
#' @param df A `data.frame` object for which correlations are required in combinations.
#' @param ... Other arguments to `get_var_corr`
#' @return A data.frame object with combinations.
#' @details This function extends get_var_corr by providing an opportunity to get correlations
#' for combinations of variables. It is currently slow and may take up to a minute depending on system specifications.
#' @examples 
#' get_var_corr_(mtcars,method="pearson")
#' @export
get_var_corr_<-function(df,...){
# Strictly  pair wise combinations. 
# This code is left in case there is ever need to move away
# from package dependencies, it was slow(ver very slow)
#get_combn<-expand.grid(names(df),names(df))
#no_dupe<-apply(get_combn,1,function(x) x[!anyDuplicated(x)])
#plyr::ldply(lapply(no_dupe[lengths(no_dupe)>0],
#           function(x) get_var_corr(df=df,
#                         comparison_var = x[1],
#                            other_vars = x[2],
#                         get_all = FALSE,...)),
#              data.frame)[,-1]

# Refactored in an attempt to improve speed.
if("factor" %in% sapply(df,class)){
  warning("Factor columns were found in the data set, these have 
          been discarded.")
  # Already depending on purrr, use it.
  # Otherwise can just use base. This is done for "simplicity."
  df <- purrr::discard(df,is.factor)
  
  # Transpose, support pairwise combinations
  to_use <- as.data.frame(t(combn(names(df),2)),
                          stringsAsFactors= FALSE)
  compare_with<-to_use[[1]]
  other <- to_use[[2]]
 plyr::ldply(purrr::map2(compare_with,other,function(x,y)
    manymodelr::get_var_corr(df,
                             comparison_var = x,
                             other_vars = y,
                             get_all = FALSE)),data.frame)
} else{
  # Transpose, support pairwise combinations
  to_use <- as.data.frame(t(combn(names(df),2)),
                          stringsAsFactors= FALSE)
  compare_with<-to_use[[1]]
  other <- to_use[[2]]
  plyr::ldply(purrr::map2(compare_with,other,function(x,y)
     get_var_corr(df,
                             comparison_var = x,
                           other_vars = y,
                            get_all = FALSE)),data.frame)
}
}

  


