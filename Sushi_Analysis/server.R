

server <- function(input, output) {
    output$selectstate<-renderUI({
        state_list <- data %>% select(state) %>% arrange(state) %>% distinct(state) 
        selectInput("state","Choose a State:",
                    state_list)
    })
    output$selectcity<-renderUI({
        input_state <- input$state
        city_list <- data %>% filter(state %in% input_state) %>% 
            select(city) %>% arrange(city) %>% distinct(city) 
        selectInput("city","Choose a City:",
                    city_list)
    })
    output$selectname<-renderUI({
        input_state <- input$state
        input_city <- input$city
        restaurant_list <- data %>% filter(state %in% input_state) %>%
            filter(city %in% input_city) %>% 
            select(name) %>% arrange(name) %>% distinct(name) %>% unlist()
        names(restaurant_list) <- NULL
        selectInput("restaurant","Choose a Restaurant:",
                    restaurant_list)
    })

    output$data_2show <- renderDataTable(
        get_data()
    )
    
    
    get_data <- eventReactive(input$search, {
        input_restaurant <- input$restaurant
        d <- data %>% filter(name %in% input_restaurant)
        return (d)
    })
    
    
    output$mymap <- renderLeaflet({
        point <- get_data() %>%
            select(longitude, latitude)
        leaflet() %>%
            addTiles() %>%
            #addMarkers(data = df, lat = ~stop_lat, lng = ~stop_lon, layerId = ~stop_id)
            addMarkers(data = point, lng = ~longitude, lat = ~latitude)
    })
    # output$txt <- renderText({ 
    #     r <- get_bodyfatper()
    #     paste("Body Fat: ", r, "%", sep="")
    #})

}



