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


## Package "tidytext" uses methods from packages NLP, tm, topicmodels
## -> Wraps needed function and is also 'tidy'!
if(require("tidytext")==FALSE) install.packages("tidytext")
library("tidytext")

## Package stringr contains functions for cleaning text
if(require("stringr")==FALSE) install.packages("stringr")
library("stringr")

## Package tm contains functions for topic modelling utils
if(require("tm")==FALSE) install.packages("tm")
library("tm")

# Clean text to remove odd characters/emojs
rt$text <- base::sapply(rt$text,function(row) iconv(row, "latin1", "ASCII", sub=""))

#replace hashtags
rt$text <- stringr::str_replace_all(rt$text, "#[a-z,A-Z,0-9]*", "")

#replace user tags
rt$text <- stringr::str_replace_all(rt$text, "@[a-z,A-Z,0-9]*", "")

## Replace URLs
rt$text <- stringr::str_replace_all(rt$text, "http\\S+", "")

## Replace retweets
rt$text <- stringr::str_replace_all(rt$text, "RT @[a-z,A-Z,0-9]*", "")

## Keep non-empty rows/remove every row with an empty string
rt <- dplyr::filter(rt, rt$text != " ")

#create Vector of the corpus
tweetCorpus <- VCorpus(VectorSource(rt$text))

#remove whitespaces
tweetCorpus <- tm::tm_map(tweetCorpus, stripWhitespace)

#do the remaining preprocesses and create DocumentTermMatrix
dtm <- tm::DocumentTermMatrix(tweetCorpus, control = list (tolower = TRUE, stopwords = TRUE, 
                                                     removeNumbers = TRUE, removePunctuation = TRUE, wordLengths = c (3, 15)))
#write DocumentTermMatrix into csv
write.csv((as.matrix(dtm)), "dtm.csv")

## Data structures and algorithms for sparse arrays and matrices, based on index arrays and simple triplet representations, respectively.
if(require("slam")==FALSE) install.packages("slam")
library("slam")

#Tf-idf is a approach to filter out ‘unimportant’ words from our text. This omit terms which have low frequency as well as those occurring in many documents.
term_tfidf <- tapply(dtm$v/slam::row_sums(dtm)[dtm$i],
                     dtm$j, mean) * log2(nDocs(dtm)/slam::col_sums(dtm > 0))

#ensuring that the very frequent terms are omitted
median_tfidf <- summary(term_tfidf)[3]
dtm <- dtm[, term_tfidf >= median_tfidf]

if(require("Rmpfr")==FALSE) install.packages("Rmpfr")
library("Rmpfr")

#define a function for harmonic mean
harmonicMeanCalc <- function(logLikelihoods, precision=2000L) {
  llMed <- Rmpfr::median(logLikelihoods)
  as.double(llMed - log(Rmpfr::mean(exp(-Rmpfr::mpfr(logLikelihoods,
                                       prec = precision) + llMed))))
}

#Find the sum of words in each Document
rowTotals <- base::apply(dtm , 1, sum) 

#remove all docs without words
dtm.new   <- dtm[rowTotals> 0, ]

#define the values for LDA function
burnin = 100
iter = 100
keep = 50

#generates different values for k
k_values <- base::seq(2, 100, 10)

#run LDA for each of values of k
fitted_many_models <- base::lapply(k_values, function(k) topicmodels::LDA(dtm.new, k = k,
                                            method = "Gibbs", control = list(burnin = burnin, iter = iter, keep = keep) ))
# extract loglikelihood from each topic
logLiks_many <- base::lapply(fitted_many_models, function(L) L@logLiks[-c(1:(burnin/keep))])

# compute harmonic means
hm_many <- base::sapply(logLiks_many, function(h) harmonicMeanCalc(h))

graphics.off()
par("mar")
plot(k_values, hm_many, type = "l")
k <- k_values[which.max(hm_many)]

#run LDA using optimal value of k to have the our final model
seedNum <- 42
final_model <- topicmodels::LDA(dtm.new, k = k, method = "Gibbs", control = list(
  burnin = burnin, iter = iter, keep = keep, seed=seedNum))

#writing out results...

#output: docs to topics 
ldamodel.topics <- as.matrix(topicmodels::topics(final_model))
write.csv(ldamodel.topics, file=paste("LDAGibbs",k,"DocsToTopics.csv"))


#outpu: top 8 terms in each topic
ldamodel.terms <- as.matrix(topicmodels::terms(final_model,8))
write.csv(ldamodel.terms, file=paste("LDAGibbs",k,"TopicsToTerms.csv"))


#output: probabilities associated with each topic assignment
docTopicProbabilities <- as.data.frame(final_model@gamma)
write.csv(docTopicProbabilities,file=paste("LDAGibbs",k,"DocTopicProbabilities.csv"))
