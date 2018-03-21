# Shiny server.R

# packages
library(readr)
library(shiny)
library(dplyr)
library(ggplot2)
library(plotly)

# load data
beer_recipes <- read_csv("beer-recipes.zip")

# prepare data
beer <- filter(beer_recipes, ABV <= 20) # remove strong stuff

count <- as.data.frame(table(beer$Style) >100) # remove rare stuff
is.na(count) <- !count
count <- rownames(na.omit(count))
beer <- filter(beer, Style %in% count)


server <- function(input, output) {


        # add reactive data information
        data <- reactive({
                beer %>%
                        filter(Style == input$Beer_Style1 | Style == input$Beer_Style2)
        })
        
        data1 <- reactive({
                beer %>%
                        filter(Style == input$Beer_Style1)
        })
        
        data2 <- reactive({
                beer %>%
                        filter(Style == input$Beer_Style2)
        })
        
        # build plot with ggplot
        output$Histoplot <- renderPlotly({
                p <- ggplot(data(), aes(x = data()$ABV, fill = data()$Style)) + 
                        geom_histogram(alpha=.5, position="identity") +
                        labs(y = "# beers",
                             x = "ABV",
                             title = "Distribution of ABV for selected beer styles",
                             caption = "based on data from Brewer's Friend, downloaded from Kaggle") +
                        scale_fill_discrete(name = "Beer Styles")
                # run ggplotly
                ggplotly(p)
        })
        
        # compute average ABV for style 1
        output$abv1 <- renderText({
                abv1 <- mean(data1()$ABV)
                abv1 <- paste(round(abv1, digits = 2), "%")
                abv1
        })
        # compute average ABV for style 2
        output$abv2 <- renderText({
                abv2 <- mean(data2()$ABV)
                abv2 <- paste(round(abv2, digits = 2), "%")
                abv2
        })
}

