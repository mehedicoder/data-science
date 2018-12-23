## Install rtweet

if(require("rtweet")==FALSE) install.packages("rtweet") 
## Load rtweet
library("rtweet")

## install the {httpuv} package to authorize via web browser
if(require("httpuv")==FALSE) install.packages("httpuv") 
## load httpuv package
library("httpuv")

if(require("dplyr")==FALSE) install.packages("dplyr") 
library("dplyr")

if(require("devtools")==FALSE) install.packages("devtools") 
library("devtools")

if(require("readr")==FALSE) install.packages("readr") 
library("readr")


if(require("jsonlite")==FALSE) install.packages("jsonlite") 
library("jsonlite")

# install remotes if not already
if (!requireNamespace("remotes", quietly = TRUE)) {
  install.packages("remotes")
}
## install textfeatures and the depending tweetbotornot from github
if(require("textfeatures")==FALSE) devtools::install_github("mkearney/textfeatures")
library(textfeatures)

if(require("tweetbotornot")==FALSE) devtools::install_github("mkearney/tweetbotornot")
library(tweetbotornot)

## Stream keywords used to filter tweets
q <- "hillaryclinton,imwithher,realdonaldtrump,maga,electionday"

## Stream time in seconds so for one minute set timeout = 60
## For larger chunks of time, I recommend multiplying 60 by the number
## of desired minutes. This method scales up to hours as well
## (x * 60 = x mins, x * 60 * 60 = x hours)
## Stream for 30 minutes
streamtime <- 1 * 5

## Filename to base::save json data (backup)
## ToDo: Maybe change variable to an input parameter
## ToDo: Instead of a generic name, a combination of search terms and date
##       might work as well.
filename <- "tweets.json"

## ToDo: Maybe change variable to an input parameter
batch_processing <- TRUE
## Bind bot detection to batch_processing; No Bot detection in batchmode
## ToDo: Either change variable to an input parameter or omit de-activation of function
bot_detection = !batch_processing

## Batch-Processing
## ToDo: Mayhaps changing function call to 
## "rtweet::parse_stream(path = filenames, verbose = FALSE)"
if(batch_processing) {
  rt <- rtweet::parse_stream(path = filename)
  users <- rt
  } else {
## ToDo: Mayhaps changing function call to 
## "rtweet::stream_tweets(q = q, timeout = streamtime, file_name = filename, verbose = FALSE)"
  rt <- rtweet::stream_tweets(q = q, timeout = streamtime, file_name = filename)
  users <- rtweet::users_data(rt)
}

if(bot_detection) {
## Feed User_IDs to Tweetbotornot, get back User_IDs and prob of being bot
data <- tweetbotornot(users$user_id, fast = TRUE)

## Threshold of a row being considered a bot
## ToDo: Maybe change variable to an input parameter
threshold <- 0.50

bots <- dplyr::filter(data, prob_bot > threshold)

## Delete bots from Dataset
rt <- dplyr::anti_join(rt,bots,by="user_id")
}

#write data to bot-tweet filtered json if we stream from twitter.com only; 
#If we do batch processing we reduce disk access keeping the filtered tweets in memory
if(!batch_processing) {
  base::writeLines(jsonlite::toJSON(rt, pretty = TRUE), "filtered_tweets.json")
}

## Just leave the columns for text
rt <- select(rt, text)


## arrange descending by prob estimates, for control purposes
## ToDo: Remove this line
#data[order(-data$prob_bot), ]



## Package "tidytext" uses methods from packages NLP, tm, topicmodels
## -> Wraps needed function and is also 'tidy'!
if(require("tidytext")==FALSE) install.packages("tidytext")
library("tidytext")

## Package stringr contains functions for cleaning text
if(require("stringr")==FALSE) install.packages("stringr")
library("stringr")

# Clean text to remove odd characters/emojs
rt$text <- sapply(rt$text,function(row) iconv(row, "latin1", "ASCII", sub=""))


tweetCorpus <- VCorpus(VectorSource(rt$text))

tweetCorpus <- tm_map(tweetCorpus, stripWhitespace)


dtm <- DocumentTermMatrix(tweetCorpus, control = list (tolower = TRUE, stopwords = TRUE, 
                                                     removeNumbers = TRUE, removePunctuation = TRUE, wordLengths = c (4, 15)))

write.csv((as.matrix(dtm)), "dtm.csv")


