# Shiny Ui.R

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

# build UI

ui <- fluidPage(
        headerPanel("Getting drunk help guide"),
        sidebarPanel(
                helpText("Please select two beer styles to compare them"),
                selectInput('Beer_Style1', 'Beer style 1', choices = count, selected = "Belgian Tripel"),
                selectInput('Beer_Style2', 'Beer style 2', choices = count, selected = "English IPA")
        ),
        mainPanel(
                plotlyOutput('Histoplot'),
                h4("Average ABV of beer style 1:"),
                h3(textOutput('abv1')),
                h4("Average ABV of beer style 2:"),
                h3(textOutput('abv2'),
                   h1(""),
                   h6("The data is from website Brewer's Friend and contains recipes for homebrew beer. Downloaded from Kaggle."))
        )
)
