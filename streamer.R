## Install rtweet
install.packages("rtweet")
## Load rtweet
library(rtweet)

## Stream keywords used to filter tweets
q <- "hillaryclinton,imwithher,realdonaldtrump,maga,electionday"

## Stream time in seconds so for one minute set timeout = 60
## For larger chunks of time, I recommend multiplying 60 by the number
## of desired minutes. This method scales up to hours as well
## (x * 60 = x mins, x * 60 * 60 = x hours)
## Stream for 30 minutes
streamtime <- 1 * 60

## Filename to save json data (backup)
filename <- "rtelect.json"

## install the {httpuv} package to authorize via web browser
install.packages("httpuv")
## load httpuv package
library(httpuv)

rt <- stream_tweets(q = q, timeout = streamtime, file_name = filename)

