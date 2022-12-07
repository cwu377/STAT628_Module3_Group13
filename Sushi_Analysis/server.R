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

    output$selectid<-renderUI({
        input_restaurant <- input$restaurant
        business_id_list <- data %>% filter(name %in% input_restaurant) %>%
            select(business_id) %>% arrange(business_id) %>% 
            distinct(business_id) %>% unlist()
        names(business_id_list) <- NULL
        selectInput("business_id","Choose a ID:",
                    business_id_list)
    })
    
    output$data_2show <- renderDataTable(
        get_data()
    )
    
    
    get_data <- eventReactive(input$search, {
        input_business_id <- input$business_id
        d <- data %>% filter(business_id %in% input_business_id)
        return (d)
    })

    get_review <- eventReactive(input$search, {
        input_business_id <- input$business_id
        d <- review %>% filter(business_id %in% input_business_id)
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
    
    output$restaurant_name <- renderUI({
        t <- get_data() %>%
            select(name) %>% distinct(name) %>% unlist()
        h1(t)
    })
    
    output$address <- renderUI({
        t <- get_data() %>%
            select(address, city, state) %>% unlist()

        p(paste(t[1], t[2], t[3], sep=", "), class="text-warning")
    })
    
    
    output$rating_vs_year <- renderPlot({
        review2 <- get_review() %>%
            group_by(year = lubridate::year(date)) %>%
            summarise(avg = mean(stars), count=n())
        ggplot(data=review2)+
            geom_line(aes(x=year,y=avg)) +
            ylab("Average Star") +
            theme(axis.text.x = element_text(angle = 45, hjust = 0.5, vjust = 0.5))
    })
    
    output$count_vs_year <- renderPlot({
        review2 <- get_review() %>%
            group_by(year = lubridate::year(date)) %>%
            summarise(avg = mean(stars), count=n())
        ggplot(data=review2)+
            geom_col(aes(x=year, y=count))+
            ylab("Review Number")
    })
    
}



