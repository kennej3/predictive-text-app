library(shiny)

shinyUI(fluidPage(

        # Application title
        titlePanel("Predictive Text App"),

	sidebarLayout(

	sidebarPanel(
  		textInput("input.text", label= h3("Text Input"), value="Enter text ..."),
		submitButton("Submit")
		),
        mainPanel(
		tabsetPanel(
			tabPanel("Results:",
				h3('Input Text:'),
				verbatimTextOutput("input.text"),
				h3('Predicted Word:'),
				verbatimTextOutput("word")
				),
			tabPanel("Help:",
				h2('About:'),
				p('This appliction predicts a word given an input phrase. A simple back-off algorithm combined with a large text corpus combining twitter, news, and blog data.'),
				# adding the new div tag to the sidebar            
				tags$div(class="header", checked=NA,
				         tags$p("For brief description of the data and pre-processing steps click to the following link to an RPubs document:"),
				         tags$a(href="https://rpubs.com/kennej3/137918", "rpubs.com/kennej3/137918")
				         ),
				p(' '),
				h2('How To:'),
				p('To run the application, enter a phrase in the `Text Input` box on the left and click the Submit button. The filtered input phrase (with profanity removed) will appear on the top right text box and the predicted text to follow will appear in the bottom right text box in the `Results` tab')
				)	
		)	
	)
	)
))

