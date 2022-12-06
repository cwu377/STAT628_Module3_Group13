

data <- read_csv('sushi.csv', col_types = cols())


# Define UI for application that draws a histogram
ui <- fluidPage(
    theme = shinytheme("cerulean"),
    shinyFeedback::useShinyFeedback(),
    # Application title
    titlePanel("Sushi Restaurant"),
    
    sidebarLayout(
        sidebarPanel(
            uiOutput("selectstate"),
            uiOutput("selectcity"),
            uiOutput("selectname"),
            uiOutput("selectid"),
            actionButton("search", "Search", class="btn-primary"),
        ),
        
        mainPanel(
            uiOutput("restaurant_name"),
            leafletOutput("mymap"),
            dataTableOutput('data_2show')
        ),
    ),
    hr(),
    tags$div(
        class = "footer",
        HTML('Developed by: 
             <br>  
             <br> Chao-Sheng Wu: cwu377@wisc.edu
             <br> ')
    )
)




         
         
