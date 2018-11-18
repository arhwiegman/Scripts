#Shiny App Example
#April 29 2018
#DMH

#This example derived from https://shiny.rstudio.com/articles/build.html

#Save as app.R in its own folder (exampleapp)

#Shiny apps are contained in a single script called app.R. The script app.R lives in a directory (for example, newdir/) and the app can be run with runApp("newdir").
#app.R has three components:
#a user interface object
#a server function
#a call to the shinyApp function

#Preliminaries
library(shiny)
library(RColorBrewer)
library(shinythemes)
library(ggplot2)
#Load mpg dataset
d<-mpg
#str(d)

#First build our user interface
#controls the layout and appearance of your app
#FluidPage creates a display that automatically adjusts to the dimensions of your user's browser window
#You can also choose fixedPage, navbarPage, or fluidRow or Column
ui <- fluidPage(
  
  #choose a shiny theme (united, darkly, cosmo)
  theme = shinytheme("united"),
  
  #give your app a title
  titlePanel("Miles Per Gallon"),
  
  #create a sidebar for inputs
  sidebarLayout(position = "right",
    sidebarPanel(
      #Give sidebarPanel a name
      h3("Choose Your Inputs"),
      
      #Choose inputs
      selectInput("mpgtype","MPG Standard",c("Highway"="hwy","City"="city")),
      selectInput("variable","Variable:",c("Manufacturer"="manufacturer","Year"="year","Fuel Type"="fl","Class"="class"))),
    
    #Main panel for displaying outputs
    mainPanel(
      h3(textOutput("caption"),align="center"),
      plotOutput("mpgPlot")
    )
  )
)
#server  contains the instructions that your computer needs to build your app
server <- function(input,output){
  formulaText <- reactive({
    if (input$mpgtype=="hwy")
      paste("hwy~",input$variable)
    else
      paste("cty~",input$variable)
  })
  output$caption <- renderText({formulaText()})
  output$mpgPlot <- renderPlot({
    par(mar=c(6,6,0,0))
    boxplot(as.formula(formulaText()), data=d,las=2,col=brewer.pal(n=8,name="Set2"),pch=19,xlab="",ylab="")
    mtext(input$variable,side=1,line=5,font=2)
    mtext(c("(mpg)",input$mpgtype),side=2,line=3:4,font=2)
})
}


shinyApp(ui,server)

#Your R session will be busy while the Hello Shiny app is active, so you will not be able to run any R commands. R is monitoring the app and executing the app's reactions

#Can also run using:
#library(shiny)
#runApp("exampleapp")
