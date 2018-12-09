library(shiny)
library(plotly)
library(DT)
shinyServer(function(input, output) {
  #===========================================================
  
  model1 <- lm(mpg ~ disp, data = mtcars)

  model1pred <- reactive({
    dispInput <- input$sliderDisp
    predict(model1, newdata = data.frame(disp = dispInput))
  })
  #===========================================================
  
  model2 <- loess(mpg ~ disp, data = mtcars)
  
  model2pred <- reactive({
    dispInput <- input$sliderDisp
    predict(model2, newdata = data.frame(disp = dispInput))
  })
  #===========================================================
  model3 <- lm(mpg ~ wt, data = mtcars)
  
  model3pred <- reactive({
    wtInput <- input$sliderWT
    predict(model3, newdata = data.frame(wt = wtInput), interval="confidence")
  })
  
  #===========================================================
  
  model4 <- lm(mpg ~ wt+am+hp+cyl, data = mtcars)
  
  model4pred <- reactive({
    cylindr <- switch(input$cylindr,
                      four=4,
                      six=6,
                      eight=8,
                      4
    )
    transm <- switch(input$transm,
                     zero=0,
                     one=1,
                     0
    )
    hpInput <- input$numericHP
    wtInput <- input$sliderWT
    
    predict(model4, newdata = data.frame(wt = wtInput, hp=hpInput, cyl=cylindr, am=transm), interval="confidence")
  })
  
  #===========================================================
  
  output$plot1 <- renderPlotly({

        p<-plot_ly(mtcars, x = ~disp, y = ~mpg, 
                   type = "scatter", 
                   mode="markers", 
                   # Hover text:
                   text = ~paste("<b>",rownames(mtcars),"</b>", 
                                 "<br>Power: ", hp,
                                 "hp<br>Weight.: ", round(wt*453.59237,0),
                                 "kg.<br>Transm.: ", ifelse(am==0, "Automatic","Manual")), 
                   color = ~factor(cyl), 
                   size = ~hp) %>%
        layout( 
               xaxis = list(title = "Displacement, cu.in."), 
               yaxis = list(title = "Miles Per Gallon"))
        #===========================================================
        
        if(input$showModel1 & input$showModel2){p%>%add_lines(y = ~fitted(lm(mpg ~ disp)),
                                           line = list(color = 'blue'),
                                           name = "Linear Regression", showlegend = FALSE)%>%
                                              add_trace(
                                             x = ~input$sliderDisp,
                                             y = ~model1pred(),
                                             marker = list(
                                               color = 'rgb(0, 0, 255)',
                                               size = 120
                                             ), showlegend = FALSE
                                           )%>%add_lines(y = ~fitted(loess(mpg ~ disp)),
                                                         line = list(color = 'red'),
                                                         name = "Loess Smoother", showlegend = FALSE)%>%
            add_trace(
              x = ~input$sliderDisp,
              y = ~model2pred(),
              marker = list(
                color = 'rgb(255, 0, 0)',
                size = 120
              ), showlegend = FALSE
            )    
        }
        else 
          #===========================================================
        
          if(input$showModel1 & !input$showModel2){p%>%add_lines(y = ~fitted(lm(mpg ~ disp)),
                                             line = list(color = 'blue'),
                                             name = "Linear Regression", showlegend = FALSE)%>%
              add_trace(
                x = ~input$sliderDisp,
                y = ~model1pred(),
                marker = list(
                  color = 'rgb(0, 0, 255)',
                  size = 120
                ), showlegend = FALSE
              )  
          }
        else 
          #===========================================================
        
        if(!input$showModel1 & input$showModel2){p%>%add_lines(y = ~fitted(loess(mpg ~ disp)),
                                           line = list(color = 'red'),
                                           name = "Loess Smoother", showlegend = FALSE)%>%
            add_trace(
              x = ~input$sliderDisp,
              y = ~model2pred(),
              marker = list(
                color = 'rgb(255, 0, 0)',
                size = 120
              ), showlegend = FALSE
            )
        }
        
        else {p}

  }) 
  #===========================================================
        
         output$pred1 <- renderText({paste(round(model1pred(),2)," mpg")})

         output$pred2 <- renderText({paste(round(model2pred(),2)," mpg")})
         
         output$pred3 <- renderText({paste(
          round(model3pred()[[1]],2)," mpg ( 95% confidence interval: ", 
          round(model3pred()[[2]],2), " - ",
          round(model3pred()[[3]],2), " )")})
         
         output$pred4 <- renderText({paste(
           round(model4pred()[[1]],2)," mpg ( 95% confidence interval: ",
           round(model4pred()[[2]],2), " - ",
           round(model4pred()[[3]],2), " )")})
         
         output$pred5 <-renderText({h3("The mtcars data set")})
         
         output$mytable = DT::renderDataTable({
             if(input$showDT){(
               datatable(mtcars, filter='top'))}
         })
})