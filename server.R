source("utility.R")

server <- function(input, output) {
    
    # Reactive Data frame ----
    
    reacitve_df <- reactive({
        
        master_df %>% 
            filter(Class %in% c(input$SelectClass))
        
        
    })
    
    reacitve_df2 <- reactive({
        
        gamelogs_df %>% 
            filter(Class %in% c(input$SelectClass))
        
    })
    
    # Reactive Filters ----
    
    output$SelectClass <- renderUI({
        
        shinyWidgets::pickerInput("SelectClass", label = "Select Class",
                    choices = c("Freshman", "Sophmore","Junior","Senior"),
                    selected = c("Freshman", "Sophmore","Junior","Senior"),
                    multiple = TRUE,
        options = list(
                        `actions-box` = TRUE))
    })
    
    output$SelectMetric_BP <- renderUI({
        
        selectInput("SelectMetric_BP", label = "Select Metric",
                    choices = colnames(select_if(master_df, is.numeric)),
                    selected = "BPM")
    })
    
    output$SelectMetric_2P <- renderUI({
        
        selectInput("SelectMetric_2P", label = "Select 2P Metric",
                    choices = grep("2P",colnames(master_df),value = TRUE),
                    selected = "2P Per Game")
    })
    
    output$SelectMetric_3P <- renderUI({
        
        selectInput("SelectMetric_3P", label = "Select 3P Metric",
                    choices = grep("3P",colnames(master_df),value = TRUE),
                    selected = "3P Per Game")
    })
    
    output$SelectMetric_PAP1 <- renderUI({
        
        selectInput("SelectMetric_PAP1", label = "Select X Metric",
                    choices = colnames(select_if(master_df, is.numeric)),
                    selected = "OBPM")
    })
    
    output$SelectMetric_PAP2 <- renderUI({
        
        selectInput("SelectMetric_PAP2", label = "Select Y Metric",
                    choices = colnames(select_if(master_df, is.numeric)),
                    selected = "DBPM")
    })
    
    output$SelectMetric_Box <- renderUI({
        
        selectInput("SelectMetric_Box", label = "Select Metric",
                    choices = colnames(select_if(gamelogs_df, is.numeric)),
                    selected = "PTS")
    })
    
    # Top 10 Bar plot ----
    
    output$bar <- renderPlotly({
        
        # https://stackoverflow.com/questions/43999317/how-to-call-reorder-within-aes-string-of-ggplot
    
    b <- ggplot(data=head(arrange(reacitve_df(),desc(!!sym(input$SelectMetric_BP))),10), aes(x=reorder(Player_Name,-!!sym(input$SelectMetric_BP)), 
                                                                                         y=!!sym(input$SelectMetric_BP), 
                                                                                         fill=Class,
                                                                                         text1 = Player_Name,
                                                                                         text2 = Class,
                                                                                         text3 = School,
                                                                                         text4 = Conf)) +
        geom_bar(stat="identity")+
        geom_text(aes(y = !!sym(input$SelectMetric_BP), label = !!sym(input$SelectMetric_BP)), color = "black", size = 4) +
        scale_fill_brewer(palette="Paired")+
        labs(x = "Top 10 Players", y = input$SelectMetric_BP) +
        theme_minimal()+
        theme(axis.text.x = element_text(angle = 35)) +
        scale_y_continuous(expand = c(.1, .1))
    
    b <- ggplotly(b, tooltip = c("text1","text2","text3","text4"))%>%
        style(textposition = "top")
    
    })
    
    
    # Scoring Dynamics Scatter Plot ----
    
    output$score <- renderPlotly({
        
        reactive <- reacitve_df()
        
        f <- list(
            family = "Courier New, monospace",
            size = 18,
            color = "#7f7f7f"
        )
        
        x <- list(
            title = "3P Metric",
            titlefont = f
        )
        
        y <- list(
            title = "2P Metric",
            titlefont = f
        )
        
        fig <- plot_ly(
            data = reactive, 
            x = ~get(input$SelectMetric_3P), y = ~get(input$SelectMetric_2P),
            color = ~`TS%`,
            size = ~`FT Per Game`,
            textposition = "top", 
            mode = "markers+text",
            hovertemplate  = ~paste('</br> Player Name: ', Player_Name,
                                    '</br> Class: ', Class,
                                    '</br> School: ', School,
                                    '</br> Conf: ', Conf,
                                    '</br> 2P Metric: ', get(input$SelectMetric_2P),
                                    '</br> 3P Metric: ', get(input$SelectMetric_3P),
                                    '</br> FT Per Game: ', `FT Per Game`,
                                    '</br> TS%: ', `TS%`,
                                    '</br> Points Per Game: ', `PTS Per Game`))
        
        fig <- fig %>% layout(xaxis = x, yaxis = y)
        
        
    })
    
    # Box Plot Analysis ----
    
    output$box <- renderPlotly({
        
        reactive <- reacitve_df2()
        
        f <- list(
            family = "Courier New, monospace",
            size = 18,
            color = "#7f7f7f"
        )
        
        x <- list(
            title = "Player Name",
            titlefont = f
        )
        
        y <- list(
            title = input$SelectMetric_Box,
            titlefont = f
        )
        
        fig <- plot_ly(
            data = reactive,
            type = "box",
            x = ~Player_Name,
            y = ~get(input$SelectMetric_Box),
            color = ~Class,
            colors = "Paired",
            boxpoints = "all",
            jitter = 0.3,
            quartilemethod="exclusive",
            hovertemplate  = ~paste('</br> Player Name: ', Player_Name,
                                    '</br> Class: ', Class,
                                    '</br> School: ', School,
                                    '</br> Opponent: ', Opponent,
                                    '</br> Selected Metric: ', get(input$SelectMetric_Box)))
        
        fig <- fig %>% layout(xaxis = x, yaxis = y)
    
        fig
    
    })
    
    # Pick-A-Plot ----
    
    output$PickAPlot <- renderPlotly({
        
        reactive <- reacitve_df()
        
        f <- list(
            family = "Courier New, monospace",
            size = 18,
            color = "#7f7f7f"
        )
        
        x <- list(
            title = input$SelectMetric_PAP1,
            titlefont = f
        )
        
        y <- list(
            title = input$SelectMetric_PAP2,
            titlefont = f
        )
        
        fig <- plot_ly(
            data = reactive, 
            x = ~get(input$SelectMetric_PAP1), y = ~get(input$SelectMetric_PAP2), 
            color = ~Class,
            colors = "Paired",
            hovertemplate  = ~paste('</br> Player Name: ', Player_Name,
                                    '</br> Class: ', Class,
                                    '</br> School: ', School,
                                    '</br> Conf: ', Conf,
                                    '</br>',input$SelectMetric_PAP1,': ', get(input$SelectMetric_PAP1),
                                    '</br>',input$SelectMetric_PAP2,': ', get(input$SelectMetric_PAP2)))
        
        fig <- fig %>% layout(xaxis = x, yaxis = y)
        
        
    })
    
    }