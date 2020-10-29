server <- function(input, output) {
    
    # Reactive Filters ----
    
    output$SelectMetric_BP <- renderUI({
        
        selectInput("SelectMetric_BP", label = "Select Metric",
                    choices = colnames(select_if(master_df, is.numeric)),
                    selected = "BPM")
    })
    
    # Top 10 Bar plot ----
    
    output$bar <- renderPlotly({
        
        # https://stackoverflow.com/questions/43999317/how-to-call-reorder-within-aes-string-of-ggplot
    
    b <- ggplot(data=head(arrange(master_df,desc(!!sym(input$SelectMetric_BP))),10), aes(x=reorder(PlayerName,-!!sym(input$SelectMetric_BP)), 
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
        theme(panel.grid.major = element_blank(),
              panel.grid.minor = element_blank(),
              panel.border = element_blank(),
              panel.background = element_blank(),
              plot.title = element_text(color = "black",size = 14, face = "bold.italic"),
              axis.title.x = element_text(color = "black", size =9),
              axis.title.y = element_text(color = "black", size =9),
              axis.text.x = element_text(angle = 35)) +
        scale_y_continuous(expand = c(.1, .1))
    
    b <- ggplotly(b, tooltip = c("text1","text2","text3","text4"))%>%
        style(textposition = "top")
    
    })
        
    
    
    
    # Scoring Dynamics Scatter Plot
    
    output$score <- renderPlotly({
        
        # https://stackoverflow.com/questions/43999317/how-to-call-reorder-within-aes-string-of-ggplot
        
        p <- ggplot(data=master_df,aes(x=Per.Game.3P,y=Per.Game.2P,
                                                                   text1 = PlayerName,
                                                                   text2 = Class,
                                                                   text3 = School,
                                                                   text4 = Conf,
                                                                   text5 = Per.Game.2P,
                                                                   text6 = Per.Game.3P,
                                                                   text7 = Per.Game.FT,
                                                                   text8 = TS.,
                                                                   text9 = Per.Game.PTS)) +
            geom_point(aes(color = TS.),alpha=0.9)+
            labs(x = "3PM Per Game", y = "2PM Per Game") +
            theme(panel.grid.major = element_blank(),
                  panel.grid.minor = element_blank(),
                  panel.border = element_blank(),
                  panel.background = element_blank(),
                  plot.title = element_text(color = "black",size = 14, face = "bold.italic"),
                  axis.title.x = element_text(color = "black", size =9),
                  axis.title.y = element_text(color = "black", size =9))+
            scale_color_gradient()
        
        p <- ggplotly(p, tooltip = c("text1","text2","text3","text4","text5","text6","text7","text8","text9"))
        
    })
    
    }