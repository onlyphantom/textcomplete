library(stringi)
library(tm)
source("helpers/cleaner.R")

corpusify <- function(x){
    docs <- Corpus(VectorSource(x))
    docs <- cleaner(docs)
}


right <- function(x, n){
    terms <- tail(strsplit(x, split=" ")[[1]],n)
    return(paste(terms, sep=" ", collapse=" "))
}


bigramTkn <- function(x){
    NGramTokenizer(x, Weka_control(min=2, max=2))
}
trigramTkn <- function(x){
    NGramTokenizer(x, Weka_control(min=3, max=3))
}
quadgramTkn <- function(x){
    NGramTokenizer(x, Weka_control(min=4, max=4))
}
fivegramTkn <- function(x){
    NGramTokenizer(x, Weka_control(min=5, max=5))
}

