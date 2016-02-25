library(shiny)

## Initialize the variables
feedback = data.frame(username = character(0),comments = character(0), time = character(0), rate = numeric(0))
five = four = three = two = one = 0
view = 0
starttime = Sys.time()

## A function to render data to ui elements:
dataToUI = function(x){
  stars = function(n){ # A function to generate the star icons :D
    stars = div(align = "left")
    for(i in 1:n){
      stars = tagAppendChild(stars, icon("star"))
    }
    return(stars)
  }
  div(
    stars(as.numeric(as.character(x$rate))),
    div(HTML(gsub("\n","<br />",x$comments)), align = "left"),
    div(x$username, align = "right")
  )
}

shinyServer(function(input,output){
  view <<- view + 1 # Every time the page is loaded, it counts as a page view.
  observeEvent(input$send,{
    feedback <<- rbind(feedback, data.frame(username = input$username, comments = input$newcomment, time = as.character(Sys.time()), rate = input$newrating))
  })
  feedback.update = reactive({
    if(input$send) feedback
  })
  output$comment1 = renderUI({
    div(
      dataToUI(feedback.update()[nrow(feedback.update()),])
    )
  })
  output$comment2 = renderUI({
    div(
      dataToUI(feedback.update()[nrow(feedback.update())-1,])
    )
  })
  output$comment3 = renderUI({
    div(
      dataToUI(feedback.update()[nrow(feedback.update())-2,])
    )
  })
  output$debug = renderTable({
    feedback
  })

})