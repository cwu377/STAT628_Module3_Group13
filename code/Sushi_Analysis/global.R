library(shiny)
library(shinythemes)
library(tidyverse)
library(DT)
#library(tidyr) # for unnesting attributes
library(leaflet) # map
library(lubridate) # processing date


data <- read_csv('sushi_park.csv', col_types = cols()) %>% select(-1)
review <- read_csv('sushi_review.csv', col_types = cols())
#data <- as.data.frame(data)
#data <- data %>% unnest(attributes) 