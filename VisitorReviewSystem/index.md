---
title       : "Visitor Review"
subtitle    : "Implemented using RStudio Shiny"
author      : "Chaoping Guo"
job         : "Project Manager"
framework   : io2012        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : []            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2slides
---

## Idea

This project is inspired by how App Review and Rating system of Google Play, where users get to give ratings to an app, as well as to write a review.

The app allows users to rate the app in a scale of 1 to 5, and to leave a comment to express in more details. All the ratings will be collected and used to calculate the average, and the last 3 comments are shown to all visitors.



--- .class #id 

## UI

In **[ui.R]()**, there are 3 input widgets: radioButton() of Rating, textInput() of Nickname and tags$textarea() of Comment.

![Inputs](assets/img/new_input.png)

Both of the outputs are uiOuput so that **[server.R]()** can generate HTML using Shiny UI library.
![Comments](assets/img/comments.png) ![Ratings](assets/img/ratings.png)

---

## Server
A file named "feedback.csv" is used to record all the rating data. For real case implementation, a database will be needed.

read.csv() is called before shinyServer() so that the data is loaded along with the initialization of the app. In this way, we get rid of unnecessary file readings.

When there is new input sent, it saves the changed dataset to "feedback.csv". Again, if we were using a database, we could insert only the new entry.

Click to see the code of **[server.R]()**.

---

## Reactivity

In this case, the data is used in both outputs, so reactive expression is used:


```r
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
```



