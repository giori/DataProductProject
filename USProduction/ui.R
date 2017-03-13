#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)
library(ggplot2)
library(googleVis)
library(Ecdat)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application titlet
  titlePanel("Us States Production"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      selectInput("sector", "Choose a production sector:", 
                  choices = c("Highway and streets"="hwy", "Water and sewer facilities"="water", "Other public buildings and structures"="util")),
      selectInput("indicator", "Choose an economic indicator:", 
                  choices = c("Private capital stock"="pcap", "Public capital"="pc", "State unemployment rate"="unemp")),
      sliderInput("year", "Year:", min=1970, max=1986, value=1970, step=1, sep = ""),
      div(
        "In this simple application it is possible to explore the data about the US production during years 1970-1986. Two kind of charts are show: a map of US, where the specified value of the production is shown for all states and a scatter-plot to evaluate a relation between the prediction and some ecomonomic indicator."
      )
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel(type = "tabs",
                  tabPanel("Data set info", br(), htmlOutput("description") ),
                  tabPanel("US States map", br(), textOutput("year"), htmlOutput("mapPlot") ),
                  tabPanel("Exploratory analysis", br(), plotlyOutput("viewPlot1") )
      )
    )
  )
))
