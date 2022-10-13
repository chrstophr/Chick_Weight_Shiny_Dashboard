library(shiny)
library(shinydashboard)
library(dplyr)
library(ggplot2)
library(fresh)


my_theme <- create_theme(
  adminlte_color(
    light_blue = "#232D4B"
  ),
  
  adminlte_sidebar(
    dark_color = "#E57200"
  )
)

ui <- dashboardPage(
  dashboardHeader(title = "Chick Weights"),
  dashboardSidebar(sliderInput("time", "Days Since birth", 0, 20, 0, step = 2),
                   sidebarMenu(
                     menuItem( "Dashboard", tabName = "dashboard"),
                     menuItem("Raw Data", tabName = "rawdata")
                     )),
  dashboardBody(
    use_theme(my_theme),
    tabItems(
      tabItem(tabName = "dashboard",
              fluidRow(
                valueBoxOutput("chick"),
                valueBoxOutput("days"),
                valueBoxOutput("avg_weight")
              ),
              fluidRow(
                box(img(src = "chicks.jpg", width = "100%")),
                box(plotOutput("weight_plot"))
              )),
      
      tabItem(tabName = "rawdata",
              fluidRow(
                box(tableOutput("show_df"))
                ))
    )
    
    
  )
)



server <- function(input, output) {
  
  df <- reactive({
    datasets::ChickWeight
  })
  
  time_df <- reactive({
    filter(df(), Time == input$time)
  })
  
  output$chick <- renderValueBox({
    numChicks <- nrow(time_df())
    
    valueBox(
      value = numChicks,
      subtitle =  "Number of Chicks",
      icon = icon("kiwi-bird"),
      color = "aqua"
    )
  })
  
  output$days <- renderValueBox({
    daysSinceBirth <- input$time
    
    valueBox(
      value = daysSinceBirth,
      subtitle = "Days Since Birth",
      icon = icon("calendar"),
      color = "aqua"
    )
  })
  
  output$avg_weight <- renderValueBox({
    avg_weight <- mean(time_df()$weight)
      
      valueBox(
        value = formatC(avg_weight,digits = 1, format = "f"),
        subtitle = "Average Weight (grams)",
        icon =icon("weight-scale"),
        color = if (avg_weight < 75) "red" else if (avg_weight >= 75 && avg_weight < 150) "yellow" else "green")
    
  })
  
  output$weight_plot <- renderPlot({
    ggplot(time_df(), aes(x=Chick, y=weight, color = Diet)) + geom_point()
  })
  
  
  output$show_df <- renderTable({
    time_df()
    })
}


shinyApp(ui,server)