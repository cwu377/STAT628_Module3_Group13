library(shiny)
library(shinythemes)
library(tidyverse)
library(DT)
#library(tidyr) # for unnesting attributes
library(leaflet) # map


data <- read_csv('sushi.csv', col_types = cols()) %>% select(-1)
#data <- as.data.frame(data)
#data <- data %>% unnest(attributes) 