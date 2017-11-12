library(shiny)
source("models.R")

# Define server logic
shinyServer(function(input, output) {
    
    resp <- reactive({
        if(input$input1 == ""){
            return(" ")
        }else{
            pred.boff(input$input1, uni=uni, bi=bi, tri=tri, fou=fou, fiv=fiv, k=input$k) 
        }
    }) 
    
    
    output$output1 <- renderText({
        resp()
    })
    
})
