library(shiny)
library(shinythemes)
library(tidyverse)
library(DT)

data <- read_csv('sushi.csv', col_types = cols())