ui <- dashboardPage(skin = "red",
    dashboardHeader(title = "Prospect Analysis"),
    dashboardSidebar(),
    dashboardBody(
        
        fluidRow(column(12,tabBox(title="",width = 12,
                                  tabPanel("Top 10 By Selected Metric",
                                           uiOutput("SelectMetric_BP"),
                                           plotlyOutput("bar")),
                                  tabPanel("Scoring Dynamics & Efficiency",
                                           plotlyOutput("score")),
                                  tabPanel("Tab 3", "Coming Soon"),
                                  tabPanel("Tab 4", "Coming Soon"),
                                  tabPanel("Tab 5", "Coming Soon")
                                  
                                  )))
        
    )
)