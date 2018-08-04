#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinythemes)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  theme = shinytheme("cosmo"),
  
  tags$head(
    tags$style(HTML("
      @import url('https://fonts.googleapis.com/css?family=Dosis');
      
      *:not(pre) {
        font-family: 'Dosis', sans-serif !important;
        line-height: 1.1;
      }

      p {
        font-size: 18px !important;
      }

      .tab-pane {
        margin-top: 2vh !important;
      }

    "))
  ),
  
  # Application title
  titlePanel("Predicting Fuel Efficiency"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    position = "right",
    sidebarPanel(
      checkboxInput("cyl", "# of cylinders", value = F),
      checkboxInput("disp", "Displacement", value = F),
      checkboxInput("hp", "Gross horsepower", value = F),
      checkboxInput("drat", "Rear axle ratio", value = F),
      checkboxInput("wt", "Weight", value = F),
      checkboxInput("qsec", "1/4 mile time", value = F),
      checkboxInput("vs", "Engine", value = F),
      checkboxInput("am", "Transmission", value = F),
      checkboxInput("gear", "# of gears", value = F),
      checkboxInput("carb", "# of carburetors", value = F),
      submitButton("Build Model")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel(type = "tabs",
                  tabPanel("Home",
                           h3("Welcome!"),
                           p(HTML("<br>This is a tool to help you explore the <code>mtcars</code> dataset. 
                                   Using the plot in the <code>Plot</code> tab, you'll be able to explore
                                   the actual values of an auto-generated training dataset. You can pick
                                   from the different variables at right which ones you'd like to use to
                                   create a model for the fuel efficiency.<br><br>Once you've chosen the
                                   ones you like, go ahead and hit <code>Build model</code>! You'll then
                                   see the predicted values superimposed on the actual ones, and the 
                                   <code>Information</code> tab will give you some important highlights
                                   from your generated model.<br><br>Use these highlights to fine-tune your
                                   model using the training dataset, and when you think you're done, go
                                   ahead and hit the <code>Test</code> button to apply your model to the
                                   auto-generated test dataset. Just don't overfit!"))),
                  tabPanel("Plot", 
                           plotOutput("lmPlot")),
                  tabPanel("Information", 
                           strong("Final Model"), verbatimTextOutput("fm"),
                           strong("R-Squared"), verbatimTextOutput("rs"),
                           strong("Analysis of Variance"), verbatimTextOutput("aov"),
                           strong("Student's T Confidence Interval"), verbatimTextOutput("tci")),
                  tabPanel("Test",
                           plotOutput("lmTest"),
                           strong("R-Squared"), verbatimTextOutput("t.rs"))
                  )
    )
  )
))
