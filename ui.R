source("utility.R")

ui <- dashboardPage(skin = "red",
    dashboardHeader(title = "Prospect Analysis"),
    dashboardSidebar(
        uiOutput("SelectClass")
    ),
    dashboardBody(
        # Hide Warnings 
        tags$style(type="text/css",".shiny-output-error { visibility: hidden; }",".shiny-output-error:before {visibility: hidden;}"),
        
        fluidRow(column(12,tabBox(title="",width = 12,
                                  tabPanel("Top 10 By Selected Metric",
                                           uiOutput("SelectMetric_BP"),
                                           loadingscreen(plotlyOutput("bar"))),
                                  tabPanel("Scoring Dynamics & Efficiency",
                                           uiOutput("SelectMetric_2P"),
                                           uiOutput("SelectMetric_3P"),
                                           loadingscreen(plotlyOutput("score"))),
                                  tabPanel("Box Plot Analysis",
                                           uiOutput("SelectMetric_Box"),
                                           loadingscreen(plotlyOutput("box"))),
                                  tabPanel("Pick-A-Plot", 
                                           uiOutput("SelectMetric_PAP1"),
                                           uiOutput("SelectMetric_PAP2"),
                                           loadingscreen(plotlyOutput("PickAPlot")))
                                  
                                  )))
        
    )
)