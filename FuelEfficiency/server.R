#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(caret)
library(ggplot2)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  set.seed(41527)
  
  data(mtcars)
  dp <- createDataPartition(y = mtcars$mpg, p = 0.7, list = F)
  
  c.train <- mtcars[dp,]
  c.test <- mtcars[-dp,]
  
  formula <- reactive({
    feat <- character()
    if (input$cyl) feat <- c(feat, "cyl")
    if (input$disp) feat <- c(feat, "disp")
    if (input$hp) feat <- c(feat, "hp")
    if (input$drat) feat <- c(feat, "drat")
    if (input$wt) feat <- c(feat, "wt")
    if (input$qsec) feat <- c(feat, "qsec")
    if (input$vs) feat <- c(feat, "vs")
    if (input$am) feat <- c(feat, "am")
    if (input$gear) feat <- c(feat, "gear")
    if (input$carb) feat <- c(feat, "carb")
    
    if (length(feat) == 0) return(-1)
    
    formula <- as.formula(paste("mpg", paste(feat, collapse = " + "), sep = " ~ "))
  })
  
  buildModel <- reactive({
    form <- formula()
    if (class(form) %in% c("double", "numeric")) return(-1)
    
    set.seed(41527)
    model <- train(form, data = c.train, method = "lm")
    
    model
  })
  
  output$lmPlot <- renderPlot({
    ggp <- ggplot(c.train, aes(x = row.names(c.train), y = mpg)) + 
      geom_point(aes(col = "Actual")) + theme(axis.text.x = element_text(angle = 60, hjust = 1)) +
      theme(axis.text=element_text(size=12),
            axis.title=element_text(size=14,face="bold")) +
      xlab("Vehicle") + ylab("Fuel Efficiency (MPG)") +
      theme(legend.title=element_blank())
    
    print(ggp)
    
    model <- buildModel()
    if (class(model) %in% c("double", "numeric")) return()
    tr.pred <- predict(model, c.train)
    
    ggp <- ggp + 
      geom_point(aes(x = row.names(c.train), y = tr.pred, col = "Model"))
    print(ggp)
  })
  
  output$fm <- renderPrint({
    model <- buildModel()
    if (class(model) %in% c("double", "numeric")) return()
    
    model$finalModel
  })
  
  output$rs <- renderPrint({
    model <- buildModel()
    if (class(model) %in% c("double", "numeric")) return()
    
    model$results$Rsquared
  })
  
  output$aov <- renderPrint({
    form <- formula()
    if (class(form) %in% c("double", "numeric")) return()
    summary(aov(form, data = mtcars))
  })
  
  output$tci <- renderPrint({
    model <- buildModel()
    if (class(model) %in% c("double", "numeric")) return()
    
    t(confint(model$finalModel))
  })
  
  output$lmTest <- renderPlot({
    model <- buildModel()
    if (class(model) %in% c("double", "numeric")) return()
    tr.pred <- predict(model, c.test)
    
    ggp <- ggplot(c.test, aes(x = row.names(c.test), y = mpg)) + 
      geom_point(aes(col = "Actual")) + theme(axis.text.x = element_text(angle = 60, hjust = 1)) +
      geom_point(aes(x = row.names(c.test), y = tr.pred, col = "Model")) +
      theme(axis.text=element_text(size=12),
            axis.title=element_text(size=14,face="bold")) +
      xlab("Vehicle") + ylab("Fuel Efficiency (MPG)") +
      theme(legend.title=element_blank())
    
    print(ggp)
  })
  
  output$t.rs <- renderPrint({
    model <- buildModel()
    if (class(model) %in% c("double", "numeric")) return()
    tr.pred <- predict(model, c.test)
    
    print(cor(c.test$mpg, tr.pred) ^ 2)
  })
  
})
