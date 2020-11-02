source("utility.R")

server <- function(input, output) {
    
    # Reactive Dataframe ----
    
    reacitve_df <- reactive({
        
        master_df %>% 
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
    
    output$SelectConf <- renderUI({
        
        shinyWidgets::pickerInput("SelectConf", label = "Select Conf",
                                  choices = master_df$conf,
                                  selected = master_df$conf,
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
                    selected = "Per.Game.2P")
    })
    
    output$SelectMetric_3P <- renderUI({
        
        selectInput("SelectMetric_3P", label = "Select 3P Metric",
                    choices = grep("3P",colnames(master_df),value = TRUE),
                    selected = "Per.Game.3P")
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
    
    # Top 10 Bar plot ----
    
    output$bar <- renderPlotly({
        
        # https://stackoverflow.com/questions/43999317/how-to-call-reorder-within-aes-string-of-ggplot
    
    b <- ggplot(data=head(arrange(reacitve_df(),desc(!!sym(input$SelectMetric_BP))),10), aes(x=reorder(PlayerName,-!!sym(input$SelectMetric_BP)), 
                                                                                         y=!!sym(input$SelectMetric_BP), 
                                                                                         fill=Class,
                                                                                         text1 = PlayerName,
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
            color = ~TS.,
            text = ~PlayerName,
            textposition = "top", mode = "markers+text",
            hovertemplate  = ~paste('</br> Player Name: ', PlayerName,
                                    '</br> Class: ', Class,
                                    '</br> School: ', School,
                                    '</br> Conf: ', Conf,
                                    '</br> 2P Metric: ', get(input$SelectMetric_2P),
                                    '</br> 3P Metric: ', get(input$SelectMetric_3P),
                                    '</br> FT Per Game: ', Per.Game.FT,
                                    '</br> TS%: ', TS.,
                                    '</br> Points Per Game: ', Per.Game.PTS))
        
        fig <- fig %>% layout(xaxis = x, yaxis = y)
        
        
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
            title = "X Axis",
            titlefont = f
        )
        
        y <- list(
            title = "Y Axis",
            titlefont = f
        )
        
        fig <- plot_ly(
            data = reactive, 
            x = ~get(input$SelectMetric_PAP1), y = ~get(input$SelectMetric_PAP2), 
            color = ~Class,
            colors = "Paired",
            hovertemplate  = ~paste('</br> Player Name: ', PlayerName,
                                    '</br> Class: ', Class,
                                    '</br> School: ', School,
                                    '</br> Conf: ', Conf,
                                    '</br>',input$SelectMetric_PAP1,': ', get(input$SelectMetric_PAP1),
                                    '</br>',input$SelectMetric_PAP2,': ', get(input$SelectMetric_PAP2)))
        
        fig <- fig %>% layout(xaxis = x, yaxis = y)
        
        
    })
    }