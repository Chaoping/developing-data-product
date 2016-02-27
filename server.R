library(shiny)

## Initialize the variables
feedback = read.csv("feedback.csv")
feedback[is.na(feedback)] = ""

# A function to generate the star icons :D
stars = function(n){ 
  stars = div(align = "left")
  for(i in 1:n){
    stars = tagAppendChild(stars, icon("star"))
  }
  return(stars)
}

## A function to render data to ui elements:
dataToUI = function(x){
  if(x$username == "") {username = "Anonymous"} else {username = x$username}  # Anonymous users will be displayed as "Anonymous"
  if(x$comments == "") {comment = "- No comment - "} else {comment = x$comments}  # No comment
  div(
    stars(x$rate),
    div(HTML(gsub("\n","<br />",comment)), align = "left"),
    strong(div(username, align = "right")),
    div(x$time, align = "right")
  )
}

shinyServer(function(input,output){
  feedback.update = reactive({
    if(input$send) {  # if the button is clicked, update the value
      feedback <<- isolate( # isolate other input so they don't have to trigger the invalidation.
        rbind(feedback, data.frame(
          username = input$username, 
          comments = input$newcomment, 
          time = as.character(Sys.time()), 
          rate = as.numeric(as.character(input$newrating))
        ))
      )
      write.csv(feedback, "feedback.csv", row.names = F)
    }
    feedback
    
  })
  output$comment1 = renderUI({
    if(nrow(feedback.update())>=1){
      div(
        dataToUI(feedback.update()[nrow(feedback.update()),])
      )
    }
  })
  output$comment2 = renderUI({
    if(nrow(feedback.update())>=2){
      div(
        dataToUI(feedback.update()[nrow(feedback.update())-1,])
      )
    }
  })
  output$comment3 = renderUI({
    if(nrow(feedback.update())>=3){
      div(
        dataToUI(feedback.update()[nrow(feedback.update())-2,])
      )
    }
  })
  output$ratings = renderUI({
    ratings = feedback.update()$rate
    five = sum(ratings == "5")
    four = sum(ratings == "4")
    three = sum(ratings == "3")
    two = sum(ratings == "2")
    one = sum(ratings == "1")
    div(
      div(
        tags$table(
          tags$tr(tags$th(
            div(five),
            div(four),
            div(three),
            div(two),
            div(one)
          ),
          tags$th(
            stars(5),
            stars(4),
            stars(3),
            stars(2),
            stars(1)
          ))
        ),
        br(),
        "Average Rating:",
        round(mean(ratings),2)
      ),
      align = "left"
    )
  })

})