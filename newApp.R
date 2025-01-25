library(shiny)
library(shinydashboard)

ui <- dashboardPage(
  skin = "black",
  dashboardHeader( title = "My First Dashboard"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Dashboard", tabName = "dashboard", icon = icon("gauge")),
      menuItem("Widgets", tabName = "widgets", icon = icon("table"))
      
      
    )
    
    
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "dashboard", 
              fluidRow(
                box(plotOutput("plot1", height = 250)),
                
                box(title = "Controls",
                    sliderInput("slider", "Number of Observations:", 1, 100, 50 ))
                
                
              )
              ),
      tabItem(tabName = "widgets",
              h2("This is my Widget page."))
    
    

  ))
)


server<- function(input, output) {
  set.seed(120)
  histdata<- rnorm(500)
  
  output$plot1 <- renderPlot({ 
    data <- histdata[seq_len(input$slider)]
    hist(data)
    })
  
}

shinyApp(ui, server)