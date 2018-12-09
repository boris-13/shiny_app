library(shiny)
library(plotly)
library(DT)
shinyUI(fluidPage(
  titlePanel("MPG prediction based on Motor Trend data set - mtcars"),
  sidebarLayout(
    sidebarPanel(
      conditionalPanel(condition="input.tabselected==1",
      span(h3("MPG vs Displacement", align = "center"), style = "color:darkgreen"),
      hr(),
      sliderInput("sliderDisp", "Displacement in cu.in.:", 71.1, 472, value = 200, step=1),
      checkboxInput("showModel1", span("Show/Hide Model 1", style = "color:blue"), value=TRUE),
      checkboxInput("showModel2", span("Show/Hide Model 2", style = "color:red" ), value=TRUE),
      hr(),
      img(src = "https://predict.mpg.football/static/media/PREDICT_Logo_blanc.92c0a8c.png", height = 70, width = 250)
      ),
#===========================================================================    
      conditionalPanel(condition="input.tabselected==2",
      span(h3("MPG vs Weight", align = "center"), style = "color:darkgreen"),
      hr(),
      sliderInput("sliderWT", "Weight (wt) in 1000 lbs:", 1.51, 5.42, value = 3, step=0.01),
      numericInput("numericHP", "Gross horse power (hp):", value = 200, min = 52, max = 335, step = 1), 
      radioButtons("cylindr", "Number of cylinders:",
                   c(
                     "4" = "four",
                     "6" = "six",
                     "8" = "eight"
                     )),
      radioButtons("transm", "Transmission A/M:",
                   c(
                     "Automatic" = "zero",
                     "Manual" = "one"
                   )),
      hr(),
      checkboxInput("showDT", "Show/Hide mtcars table", value=TRUE),
      hr(),
      img(src = "https://predict.mpg.football/static/media/PREDICT_Logo_blanc.92c0a8c.png", height = 70, width = 250)
      ),
#===========================================================================    
      conditionalPanel(condition="input.tabselected==3",
      span(h3("Application Manual", align = "center"), style = "color:darkgreen"),
      hr(),
      tags$ul(
        tags$li("Intro"),
        br(),
        tags$li("MPG vs Displacement"), 
        br(),
        tags$li("MPG vs Weight"), 
        br(),
        tags$li("This manual")
      ),
       hr(),
      img(src = "https://predict.mpg.football/static/media/PREDICT_Logo_blanc.92c0a8c.png", height = 70, width = 250)
      )
      ),
#===========================================================================    
    mainPanel(
      tabsetPanel(
        tabPanel("MPG vs Displacement", value=1, br(),
      plotlyOutput("plot1"),
       hr(),
      h4("Predicted MPG from Model 1 - ", span("Linear Regression", style = "color:blue"),":"),
          span(textOutput("pred1"),style = "color:blue"), 
       hr(),
      h4("Predicted MPG from Model 2 - ", span("Loess Smoother", style = "color:red"),":"),
          span(textOutput("pred2"),style = "color:red") 
                        ),
#===========================================================================    
      tabPanel("MPG vs Weight", value=2, br(), textOutput("out2"),
        h4("Predicted MPG from ", span("lm(mpg~wt)", style = "color:darkviolet"),", A.R-sq.=74.46% :"),
          span(h4(textOutput("pred3")), style = "color:darkviolet"),  
         hr(),
        h4("Predicted MPG from ", span("lm(mgp~wt+hp+cyl+am)", style = "color:orange"),", A.R-sq.=82.67% :"),
          span(h4(textOutput("pred4")), style = "color:orange"),
         hr(),
        DT::dataTableOutput("mytable")
               ),
#===========================================================================    
      tabPanel("Application Manual", value=3, br(), 
                h4("Intro:"),
                p("The current reactive Shiny application and its reproducible pitch present multiple linear regression and also local polynomial regression to predict the miles per gallon (MPG) for a given car specification using the mtcars data set."),
                p("The data set has ten features: weight, number of cylinders, gross horse power, transmission type, displacement, rear axle ratio, 1/4 mile time, engine type - V or straight, number of forward gears and number of carburetors."),
                p("Mileage depends on a lot of car parameters such as car weight, number of cylinders, gross horse power, displacement, transmission automatic/manual) and others. As shown in this application such a minimal model is able to explain about 74.46% of the variability in the data - as shown by its adjusted R squared value."),
                p("A systematic analysis, presented in the pitch, shows that of all possible linear models from single feature (weight) to all the ten features, the optimal model (with highest adjusted R squared value) needs only four features: weight, number of cylinders, gross horse power, and transmission type."),
                p("Note that the optimal model is able to explain 82.67% of variability in the data. It takes three additional features to describe an extra 9% variability above the minimal model which has weight as its only feature!"),
                p("The applications has three tabs:"),
                h4("MPG vs Displacement:"),
                p("-	The first tab represents an minimal model of mpg ~ disp which has two fits models: linear regression (1) and local smooth regression (2) which is more precise in mpg prediction. It’s possible to show/hide between cylinder (4,6,8) data points in the graphic legend. Each point, hovering the mouse cursor at, provides several parameters of the car under that record. One can vary the displacement value by the slider to predict the mpg value."),
                h4("MPG vs Weight:"),
                p("-	The second tab represents the mpg prediction on  minimal model of mpg ~ wt and the optimal model mpg ~ wt+hp+cyl+am, also showing the 95% - lower and upper bounds of confidence interval values. Moreover, one can show/hide the table of the mtcar data set where it’s possible to select various records by the top filter. We can vary with the first reactive inputs (slider) the weight parameter to have the mpg prediction on the minimal model and varying more the rest 3 parameters we can have the optimal mpg prediction."),
                h4("This manual:"),
                p("-	Third tab is the current application manual :))"),
                p("Play with the app to discover insights like automatic transmission often leads to lower mileage, etc."),
                p("Source code for ui.R and server.R files are available on the GitHub repo: ", a("https://github.com/boris-13/shiny_app", href="https://github.com/boris-13/shiny_app"))
                ),
      id = "tabselected"
      )
      )
      )
    ))