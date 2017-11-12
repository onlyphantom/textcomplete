library(data.table)
library(tm)

# read in the swear words and profanity 
swear <- fread("helpers/swear.csv", header=F)
swear <- as.character(swear)

# Clean up and remove "/", "@" etc with empty spaces from our Corpus
transformer <- content_transformer(function(x, pattern)
    gsub(pattern, " ", x)
)

towill <- content_transformer(function(x, pattern)
    gsub(pattern, " will", x)    
)

cleaner <- function(corpus){
    docs <- tm_map(corpus, towill, "'ll")
    docs <- tm_map(docs, transformer, "/")
    docs <- tm_map(docs, transformer, "@")
    docs <- tm_map(docs, transformer, "\\|")
    docs <- tm_map(docs, transformer, "#")
    docs <- tm_map(docs, transformer, "%")
    docs <- tm_map(docs, transformer, "$")
    docs <- tm_map(docs, transformer, "&")
    docs <- tm_map(docs, transformer, ",")
    docs <- tm_map(docs, content_transformer(tolower))
    docs <- tm_map(docs, removeNumbers)
    docs <- tm_map(docs, removePunctuation)
    docs <- tm_map(docs, removeWords, swear)
    docs <- tm_map(docs, stripWhitespace)
    
    return(docs)
    
}