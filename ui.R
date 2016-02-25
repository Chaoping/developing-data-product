library(shiny)

shinyUI(fluidPage(
  titlePanel("Visitor Rating System"),
  hr(),
  p("Hello Wanderer,"),
  p("This little Shiny App can be used as a vistor satisfactory poll of a website. You can see comments from other users and how they rated this site. More importantly, you can rate it yourself and leave your comments. Anything you leave will be logged and displayed. Try it yourself! :)"),
  p("Chaoping Guo"),
  hr(),
  fluidRow(
    column(7,
           h4("Last 3 Comments:"),
           uiOutput("comment1"),
           uiOutput("comment2"),
           uiOutput("comment3")
           #style="border-right:1px solid #000;height:500px"
    ),
    column(5,
           h4("Ratings:"),
           #br(),
           plotOutput("ratings")
    )
  ),
  hr(),
  fluidRow(
    column(3,
           radioButtons("newrating", "Choose your rating:", list("5 Stars" = 5,"4 Stars" = 4,"3 Stars" = 3,"2 Stars" = 2,"1 Star" = 1), selected = 5)
    ),
    column(9,
           textInput("username", "Your Nickname: (Optional)"),
           strong("Leave your comment: (Optional)"),br(),
           tags$textarea(id="newcomment", rows=3, cols=90)
    )
  ),
  submitButton("Send"),
  tableOutput("debug")
))