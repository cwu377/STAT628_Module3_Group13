library(jsonlite)
library(tidyverse)

file_review <- "data/yelp_dataset_2022/review.json"

# not working
review <- jsonlite::stream_in(textConnection(readLines(file_review)), verbose=F)

review1 <- jsonlite::stream_in(textConnection(read_lines(file_review, skip=0, n_max=1000)), verbose=F)
review2 <- jsonlite::stream_in(textConnection(read_lines(file_review, skip=1000, n_max=2000)), verbose=F)
#...

#### do it separately ####
num_total <- 6990280
num_each_division <- 100000
num_partition <- num_total%/%num_each_division + 1

for (x in 1:num_partition){
  review <- jsonlite::stream_in(textConnection(read_lines(file_review, skip=(i-1)*num_partition, n_max=i*num_partition)), 
                                verbose=F)
  # do something here...
}

