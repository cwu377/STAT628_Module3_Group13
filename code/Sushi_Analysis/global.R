library(shiny)
library(shinythemes)
library(tidyverse)
library(DT)
#library(tidyr) # for unnesting attributes
library(leaflet) # map
library(lubridate) # processing date
library(tidytext)
library(wordcloud2)
library(tm)


data <- read_csv('sushi_park.csv', col_types = cols()) %>% select(-1)
review <- read_csv('sushi_review.csv', col_types = cols())

int_breaks <- function(x, n = 5) {
  l <- pretty(x, n)
  l[abs(l %% 1) < .Machine$double.eps ^ 0.5] 
}

clean<-function(text){
  text<-tolower(text) 
  text<-removeNumbers(text) #remove numbers
  text<-removeWords(text,stop_words$word) #remove stopword
  text<-removePunctuation(text) 
  text<-stripWhitespace(text) #去掉多余的空格
}