library(dplyr)
library(tm)
library(RSQLite)
source("helpers/tokenizer.R")

db <- dbConnect(SQLite(), "grams.sqlite")
uni <- dbReadTable(db, "Unigram")
bi <- dbReadTable(db, "Bigram")
tri <- dbReadTable(db, "Trigram")
fou <- dbReadTable(db, "Fourgram")
fiv <- dbReadTable(db, "Fivegram")
dbDisconnect(db) 

spanify <- function(x){
    results <- c()
    for(i in x){
        results[i] <- paste("<span>",i,"</span>")
    }
    names(results) <- NULL
    return(results)
}

pred.boff <- function(input, fiv, fou, tri, bi, uni, k=5){
    input <- corpusify(input)$content
    # take the last 4 characters
    input <- right(input, 4)
    #r <- fiv[fiv$Freq==0,]
    r <- data.frame(x=character())
    
    # only search if three words input
    if(length(strsplit(input, split=" ")[[1]]) >=4){
        fiv.match <- grepl(paste0("^",input, " "), fiv$fivg)
        r <- fiv[fiv.match, ]
        r$score <- r$Freq / sum(r$Freq)
    }
    
    
    # if no match, backoff and search from fourgram
    if(nrow(r) == 0) {
        input <- right(input, 3)
        # only search if three words input
        if(length(strsplit(input, split=" ")[[1]]) >=3){
            fou.match <- grepl(paste0("^",input, " "), fou$quad)
            r <- fou[fou.match, ]
            r$score <- r$Freq / sum(r$Freq) * 0.4    
        }
        
        # if no match, backoff and search from trigram
        if(nrow(r) == 0) {
            input <- right(input, 2)
            # only search if two words input
            if(length(strsplit(input, split=" ")[[1]]) >=2){
                tri.match <- grepl(paste0("^",input, " "), tri$tri)
                r <- tri[tri.match, ]
                r$score <- r$Freq / sum(r$Freq) * 0.16    
            }
            # if no match, backoff and search from bigram
            if(nrow(r) == 0) {
                input <- right(input, 1)
                bi.match <- grepl(paste0("^",input, " "), bi$bi)
                r <- bi[bi.match, ]
                r$score <- r$Freq / sum(r$Freq) * 0.064
                # if no match, backoff and search from unigram
                if(nrow(r) == 0) {
                    r <- uni
                    r$score <- r$Freq / sum(r$Freq) * 0.0256
                }
            } 
            
        }
    } 
    
    
    
    words <- r[,1]
    score <- r$score
    prediction <- data.frame(next.word = words, score=score, stringsAsFactors = F)
    prediction <- unique(prediction)
    # choose k results
    prediction <- prediction[1:k,]   
    prediction <- stri_extract_last_words(prediction$next.word)
    prediction <- prediction[!is.na(prediction)]
    spanify(prediction)
}