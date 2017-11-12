library(shiny)

# Define UI for application 
shinyUI(fixedPage(
  includeCSS("www/custom.css"),
    fixedRow(
        column(12, 
            tags$div(class="spotlight",
                tags$h1("Text Complete"),
                tags$p("A next-word prediction app built with R"),
                textInput("input1", "Write something here:"),
                htmlOutput("output1", inline=T)
            ),
        
             
            fixedRow(
                column(3,
                offset = 1,
                h4("Lightweight. Fast."),
                helpText("A next-word suggestion app built with the \n
                            Stupid Backoff Model described and proposed \n 
                            by Brants et. al. \n
                          This language model is inexpensive to calculate while \n
                            approaching the quality of Kneser-Ney smoothing \n 
                            for large amounts of data (Brants et. al)."
                         )
                ),
                #end column5
                     
                column(4,
                    sliderInput("k",
                    "Number of suggestions:",
                    min=1,
                    max=5,
                    value=4)
                ),
                
                column(3,
                       h4("Credits"),
                       tags$ul(
                           tags$li("Author / Developer: Samuel Chan"),
                           tags$li(tags$a(href="http://www.aclweb.org/anthology/D07-1090.pdf", "References: Large Language Models 
                                          in Machine Translation"),
                                    "(Google, Inc., Mountain View), Thorsten Brants, Ashok C. Popat, Peng Xu, Franz J. Och,
                                    Jeffrey Dean"),
                           tags$li("R packages:", tags$code("Shiny"), ",", tags$code("RSQlite"), ",", 
                                   tags$code("tm"), ",", tags$code("stringi"),
                                   ",", tags$code("dplyr")),
                           offset=1
                       )
                
                #end column5
            )#end fluidRow
        )#end column12
    )
  
  
  
)))
