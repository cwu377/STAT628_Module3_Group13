ui <- fluidPage(
    tags$head(
        tags$link(rel = "stylesheet", type="text/css", href="div.css")
    ),
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
            tabsetPanel(
                tabPanel('Information',
                    uiOutput("restaurant_name"),
                    uiOutput("address"),
                    tags$div(
                        style="display:flex",
                        class="block_container",
                        uiOutput("wifi", class="bloc1"),
                        uiOutput("wheelchair", class="bloc2"),
                        uiOutput("alcohol"),
                        uiOutput("noise", class="bloc1")
                    ),
                    leafletOutput("mymap"),
                    dataTableOutput('data_2show')
                ),
                tabPanel('Charts',
                    plotOutput('rating_vs_year'),
                    plotOutput('count_vs_year')
                )
            ),
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





         
         
