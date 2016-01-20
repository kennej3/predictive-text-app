library(shiny)
library(tm)

load('TextMiningData.RData')
ProcessPhrase <- function(phrase,pre.process=FALSE){
        if(pre.process==TRUE){
                phrase <- tolower(phrase)
                phrase <- removePunctuation(phrase)
                phrase <- removeNumbers(phrase)
                profanity_list <- readLines('badwords.txt')
                phrase <- removeWords(phrase,profanity_list)
        	phrase <- stripWhitespace(phrase)
	}
        processed.phrase <- strsplit(phrase,' ')
        if(length(processed.phrase)>= 1){processed.phrase <- processed.phrase[[1]]}
}
CutPhrase <- function(phrase,WordNum,add.space=FALSE,pre.process=FALSE){
        processed.phrase <- ProcessPhrase(phrase,pre.process)
        phrase.length <- length(processed.phrase)
        if(WordNum < 0){
		cut.phrase <- paste(processed.phrase,sep=" ", collapse=" ")
        }else if(WordNum == 0){
                cut.phrase <- character(0)
        }else{
                if(phrase.length <= WordNum){
                        cut.phrase <- paste(processed.phrase,sep=" ", collapse=" ")
                }else{
                        cut.phrase <- paste(processed.phrase[(phrase.length-WordNum+1):phrase.length],sep=" ", collapse=" ")
                }
                if (add.space==TRUE){
                        cut.phrase <- paste(c(cut.phrase,''),sep=" ", collapse=" ")
                }
        }
        return(cut.phrase)
}
PredictFinalWord <- function(phrase,sorted.ngram){
        # This function searches the input N-gram for the given phrase
        # it then returns the last word of the top matched N-gram phrase.
        index <- grep(paste('^',phrase,sep=''),sorted.ngram)
        if (length(index) > 0){
                new.phrase <- sorted.ngram[index[1]]
                # Take the last word
                predict.word <- CutPhrase(new.phrase,1)
        }else{
                predict.word <- NULL
        }
        return(predict.word)
}
PredictFinalWord <- function(phrase,sorted.ngram){
        # This function searches the input N-gram for the given phrase
        # it then returns the last word of the top matched N-gram phrase.
        index <- grep(paste('^',phrase,sep=''),sorted.ngram)
        if (length(index) > 0){
                new.phrase <- sorted.ngram[index[1]]
                # Take the last word
                predict.word <- CutPhrase(new.phrase,1)
        }else{
                predict.word <- NULL
        }
        return(predict.word)
}
PredictWord <- function(phrase){
        next.word <- NULL
        # Apply pre processing
        phrase <- ProcessPhrase(phrase,pre.process=TRUE)
        phrase <- paste(phrase,sep=" ",collapse=" ")
        while(is.null(next.word)){
                phrase.length <- length(ProcessPhrase(phrase))
                if (phrase.length >= 3){
                        phrase <- CutPhrase(phrase,3,add.space = TRUE)
                        next.word <- PredictFinalWord(phrase,N4)
                        phrase <- CutPhrase(phrase,2,add.space = TRUE)
                }else if(phrase.length == 2){
                        next.word <- PredictFinalWord(phrase,N3)
                        phrase <- CutPhrase(phrase,1,add.space = TRUE)
                }else if(phrase.length == 1){
                        next.word <- PredictFinalWord(phrase,N2)
                        phrase <- CutPhrase(phrase,0)
                }else{
                        next.word <- N1 # Most popular word        
                }
        }
        return(next.word)
}

# Define server logic required to plot various variables against mpg
shinyServer(function(input, output) {

  next.word <- reactive({PredictWord(input$input.text)})
  output$input.text <- reactive({CutPhrase(input$input.text,-1,pre.process=TRUE)})
  output$word <- next.word
})

