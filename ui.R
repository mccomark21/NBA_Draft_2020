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
                                  tabPanel("Tab 3", "Coming Soon"),
                                  tabPanel("Tab 4", "Coming Soon"),
                                  tabPanel("Tab 5", "Coming Soon")
                                  
                                  )))
        
    )
)