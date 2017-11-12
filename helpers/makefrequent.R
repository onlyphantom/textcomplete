library(tm)
makeFreq <- function(x){
    freq.t <- termFreq(x$content, control=list(tokenize="scan", 
                                               tolower=T))    
    freq.t <- sort(freq.t, decreasing = T)
    freq.t <- as.data.frame(freq.t)
}