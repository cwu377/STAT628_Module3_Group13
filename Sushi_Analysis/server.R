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
        get_data() %>% select(1:10)
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
    
    output$wifi <- renderUI({
        r <- 0
        t <- get_data() %>% select(WiFi) %>% unlist()
        if (grepl("free", t)){
            r <- 1    
        }
        
        if (r==1){
            tags$div(
                style="display:flex",
                class="block_container",
                h6("WiFi:", class="bloc1"),
                tags$img(src = "check.png", height="10%", width="10%", class="bloc2")
            )
        }else if(r==0){
            tags$div(
                style="display:flex",
                class="block_container",
                h6("WiFi:", class="bloc1"),
                tags$img(src = "cross.png", height="10%", width="10%", class="bloc2")
            )
        }
        
    })
    
    output$wheelchair <- renderUI({
        r <- 0
        t <- get_data() %>% select(WheelchairAccessible) %>% unlist()
        if (isTRUE(t)){
            r <- 1    
        }
        
        if (r==1){
            tags$div(
                style="display:flex",
                class="block_container",
                h6("Wheelchair:", class="bloc1"),
                tags$img(src = "check.png", height="10%", width="10%", class="bloc2")
            )
        }else if(r==0){
            tags$div(
                style="display:flex",
                class="block_container",
                h6("Wheelchair:", class="bloc1"),
                tags$img(src = "cross.png", height="10%", width="10%", class="bloc2")
            )
        }
        
    })
    
    output$noise <- renderUI({
        r <- 0
        t <- get_data() %>% select(NoiseLevel) %>% unlist()
        if (grepl("quite", t)){
            r <- 1    
        }else if(grepl("average", t)){
            r <- 2
        }else if(grepl("very_loud", t)){
            r <- 3
        }else if(grepl("very_loud", t)){
            r <- 4
        }
        
        if (r==0){
            tags$div(
                style="display:flex",
                class="block_container",
                h6("Noisy Level:", class="bloc1"),
                tags$img(src = "cross.png", height="10%", width="10%", class="bloc2")
            )
        }else{
            tags$div(
                style="display:flex",
                class="block_container",
                tags$div(
                    h6("Noisy_Level: "),
                    class="bloc1"
                    ),
                tags$div(
                    h3(r,style="color:red"),
                    class="bloc2"
                )
            )
        }
        
    })
    
    output$alcohol <- renderUI({
        r <- 0
        t <- get_data() %>% select(Alcohol) %>% unlist()
        if (grepl("bar|bear|wine", t)){
            r <- 1    
        }
        
        if (r==1){
            tags$div(
                style="display:flex",
                class="block_container",
                h6("Alcohol:", class="bloc1"),
                tags$img(src = "check.png", height="10%", width="10%", class="bloc2")
            )
        }else if(r==0){
            tags$div(
                style="display:flex",
                class="block_container",
                h6("Alcohol:", class="bloc1"),
                tags$img(src = "cross.png", height="10%", width="10%", class="bloc2")
            )
        }
        
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



