# Yelp Sushi Data Analysis

## Description
Our report is ***Executive Summary.pdf***    
You could play around with our model: [Yelp Sushi Analysis](https://cwu377.shinyapps.io/sushi_analysis/)

## Repo Structure

- data
  - sushi.csv: Original business.json file filterd by the categories of "sushi" and "japanese", which was processed by filter_sushi_data.ipynb  
  - sushi_review.csv: Original review.json file filterd by the categories of "sushi" and "japanese", which was processed by filter_sushi_data.ipynb 
  - sushi_park.csv: Unnested sushi.csv, which was processed by Preliminary Attribute Analysis.ipynb 
  
- code 
  - analysis
    - Logistic Regression Model Analysis.R: For attributes analysis in our executive summary
    - text_mining.Rmd: For text analysis in our executive summary
  - Sushi_Analysis: the code for our shiny app
    - www/div.css: css file for putting 2 divs in 1 line  
    - global.R: global packages and data for ui and server
    - ui.R: ui-side code for the app
    - server.R: server-side code for the app
    - sushi.csv: same as the one in the data folder
    - sushi_park.csv: same as the one in the data folder
  - dataprocessing: 
    - Preliminary Attribute Analysis.ipynb: 
    - filter_sushi_data.ipynb: Read original business.json/review.json, filtered by categories and ouputed to sushi.csv/sushi_review.csv 
- images  
  - logistic analysis
  - preliminary
  - Word Freq.png
  - word assoc.png

- Two-page Summary
- README: You are reading me now



