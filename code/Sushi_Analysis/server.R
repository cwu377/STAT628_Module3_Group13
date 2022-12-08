server <- function(input, output) {
    output$selectstate <- renderUI({
        state_list <- data %>% select(state) %>% arrange(state) %>% distinct(state) 
        selectInput("state","Choose a State:",
                    state_list)
    })
    output$selectcity <- renderUI({
        input_state <- input$state
        city_list <- data %>% filter(state %in% input_state) %>% 
            select(city) %>% arrange(city) %>% distinct(city) 
        selectInput("city","Choose a City:",
                    city_list)
    })
    output$selectname <- renderUI({
        input_state <- input$state
        input_city <- input$city
        restaurant_list <- data %>% filter(state %in% input_state) %>%
            filter(city %in% input_city) %>% 
            select(name) %>% arrange(name) %>% distinct(name) %>% unlist()
        names(restaurant_list) <- NULL
        selectInput("restaurant","Choose a Restaurant:",
                    restaurant_list)
    })

    output$selectid <- renderUI({
        input_restaurant <- input$restaurant
        business_id_list <- data %>% filter(name %in% input_restaurant) %>%
            select(business_id) %>% arrange(business_id) %>% 
            distinct(business_id) %>% unlist()
        names(business_id_list) <- NULL
        selectInput("business_id","Choose a ID:",
                    business_id_list)
    })
    
    output$competitor_header <- renderUI({
        if(!is.na(get_data_city())){
            h3("Competitors in the same city", style="color:red")
        }
    })
    
    output$data_2show <- renderDataTable(
        get_data_city()
    )
    
    
    get_data <- eventReactive(input$search, {
        input_business_id <- input$business_id
        d <- data %>% filter(business_id %in% input_business_id)
        return (d)
    })
    
    get_data_city <- eventReactive(input$search, {
        input_city <- input$city
        d <- data %>% filter(city %in% input_city) %>%
            select(name, address, state, city, stars, review_count, business_id)
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
            scale_x_continuous(breaks = int_breaks) +
            theme(axis.text.x = element_text(angle = 45, hjust = 0.5, vjust = 0.5))
    })
    
    output$count_vs_year <- renderPlot({
        review2 <- get_review() %>%
            group_by(year = lubridate::year(date)) %>%
            summarise(avg = mean(stars), count=n())
        ggplot(data=review2)+
            geom_col(aes(x=year, y=count))+
            scale_x_continuous(breaks = int_breaks) +
            ylab("Review Number")
    })
    
    output$WC_pos <- renderWordcloud2({
        review_one <- get_review() %>%
            mutate(star_sd=scale(stars))
        text<-clean(review_one$text)
        posi<-which(review_one$star_sd>=0)
        text_posi<-text[posi]
        text_df_p <- tibble(line = 1:length(text_posi), text = text_posi)
        tidy_text_p <- text_df_p%>%
            unnest_tokens(word, text)
        tidy_text_p$word[which(tidy_text_p$word=="rolls")]<-"roll"
        word_freq_p<-tidy_text_p %>%
            count(word, sort = TRUE)
        word_freq_p<-word_freq_p[-c(1:31),]
        return(
        wordcloud2(word_freq_p,size=0.5,
                   fontFamily="Times New Roman",
                   color="random-light")
        )
        
    })
    
    output$WC_neg <- renderWordcloud2({
        review_one <- get_review() %>%
            mutate(star_sd=scale(stars))
        text<-clean(review_one$text)
        nega<-which(review_one$star_sd<0)
        text_nega<-text[nega]
        text_df_n <- tibble(line = 1:length(text_nega), text = text_nega)
        tidy_text_n <- text_df_n%>%
            unnest_tokens(word, text)
        tidy_text_n$word[which(tidy_text_n$word=="rolls")]<-"roll"
        tidy_text_n$word[which(tidy_text_n$word=="dishes")]<-"dish"
        word_freq_n<-tidy_text_n %>%
            count(word, sort = TRUE)
        word_freq_n<-word_freq_n[-c(1:31),]
        return(
        wordcloud2(word_freq_n,size=0.5,
                   fontFamily="Times New Roman",
                   color="random-light")
        )

    })
    
}



