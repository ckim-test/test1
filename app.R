# Load packages ----
library(shiny)
library(ggmap)
library(ggplot2)
library(data.table)
library(readr)

# Load data ----
load("data/station_latlon.RData")


# Color list
color_list <- c("#0052A4", "#009D3E", "#EF7C1C", "#00A5DE", "#996CAC", "#CD7C2F", "#747F00", "#EA545D", "#BDB092")

# User interface ----
ui <- fluidPage(
  titlePanel("서울시 지하철 정보"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("서울시 지하철 노선도"),
      
      selectInput("station", 
                  label = "지하철호선 선택",
                  choices = c("01호선", "02호선",
                              "03호선", "04호선",
                              "05호선", "06호선",
                              "07호선", "08호선", "09호선"),
                  selected = "02호선"),
      
      checkboxInput("district", 
                  label = "행정구역 표시",  value = FALSE),
      img(src = "p06020100_03.gif", height = 200, width = 200)
    ),
    
    mainPanel(plotOutput("map"))
  ),
  
  hr(),
  
  fluidRow(
    column(3),
    column(4),
    column(4)
  )
)

# Server logic ----
server <- function(input, output) {
  
  stationInput <- reactive({
    station_latlon[호선==input$station]
  })
  
  colorInput <- reactive({
    color_list[parse_number(input$station)]
  })
  
  distInput <- reactive({
    if(input$district){
      return(p + geom_polygon(data = seoul_map, 
                          aes(x = long, 
                              y = lat,
                              group = group),
                          fill = "black", alpha=0.2,
                          color = "white"))
    }else{
      return(p)
    }
  })
  
  output$map <- renderPlot({

    distInput() + geom_point(data = stationInput(), aes(lon, lat), size = 2.5, colour=colorInput())
    
  })
}

# Run app ----
shinyApp(ui, server)