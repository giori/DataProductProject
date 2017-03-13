#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(googleVis)
library(Ecdat)
library(plotly)
library(ggplot2)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  data(Produc)
  Produc$year <- as.factor(Produc$year)
  myData <- split(Produc, Produc$year)
  
  output$year <- renderText({
    paste( "In the map you can observe the specified productive sector for the year you selected ", input$year ,".")
  })
  
  output$mapPlot <- renderGvis({
    
    gvisGeoChart(myData[[as.character(input$year)]], locationvar="state", colorvar=input$sector, options=list(region="US", 
                                                                                                              displayMode="regions", 
                                                                                                              resolution="provinces",
                                                                                                              width=600, height=400))
  })
  
  output$viewPlot1 <- renderPlotly({
    dx <- myData[[as.character(input$year)]][as.character(input$indicator)] 
    dy <- myData[[as.character(input$year)]][as.character(input$sector)] 
    ds <- myData[[as.character(input$year)]]["state"]
    df <- data.frame(cbind(dx,dy,ds))
    
    #summary(df)
    fit <- lm( df[,1] ~df[,2], data = df)
    
    #print(summary(fit))
    xlab <- list(
      title = input$indicator
    )
    
    ylab <- list(
      title = input$sector
    )
    
    plot_ly( df, x= df[,1] , y= df[,2], text= df[,3], type="scatter", mode = "markers"  ) %>% 
      layout(xaxis = xlab, yaxis = ylab, showlegend = FALSE) %>% 
      add_trace(df, 
                x = df[,1],
                y = fitted(lm(df[,2] ~ df[,1])),
                mode = "lines",
                showlegend=FALSE
      )
    
    
  })
  
  output$description <- renderUI({
    div(  
      div(
        HTML("<div>
             <h4>The Produc data set</h4>
             <p>A dataframe containing a panel of 48 observations from 1970 to 1986 about US production. The following variables are considered:</p>
             <ul>
             <li>  
             <strong>state: </strong>
             the US state
             <li> 
             <strong>year: </strong> 
             the year
             <li> 
             <strong>pcap: </strong>
             private capital stock
             <li> 
             <strong>hwy: </strong>
             highway and streets
             <li> 
             <strong>water: </strong>
             water and sewer facilities
             <li> 
             <strong>util: </strong>
             other public buildings and structures
             <li> 
             <strong>pc: </strong>
             public capital
             <li> 
             <strong>gsp: </strong>
             gross state products
             <li> 
             <strong>emp: </strong>
             labor input measured by the employment in non-agricultural payrolls
             <li>  
             <strong>unemp: </strong>
             state unemployment rate</p>
             </ul>
             
             For more information, please refer to:
             </div>"
        )
        
        ),
      a(href = "http://www.wiley.com/legacy/wileychi/baltagi/", "http://www.wiley.com/legacy/wileychi/baltagi/") 
      )
  })
  
})