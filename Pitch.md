Pitch Developing Data Products, Shiny app.
========================================================
author: Bstraaten
date: 21-3-2018
autosize: true

Introduction
========================================================

This is the documentation for my app as part of Coursera's Developing Data Products course.

The app is published here: https://bstraaten.shinyapps.io/Developing_Data_Products_week_4/

This documenation will talk you through the following steps:

- Data
- Calculations
- Results

Note: The app can take a minute to load. Please be patient :). 

This presentation uses the following packages.


```r
library(readr)
library(dplyr)
library(ggplot2)
```

Data
========================================================

The data is from the website Brewers Friend and downloaded from Kaggle. It contains
data from homebrew beers. In the app we do some data cleaning like removing beers with ABV over 20% and only including beers that occur over 100 times.


```r
beer_recipes <- read_csv("beer-recipes.zip") # load data
beer <- filter(beer_recipes, ABV <= 20) # remove strong stuff
count <- as.data.frame(table(beer$Style) >100) # remove rare stuff
is.na(count) <- !count
count <- rownames(na.omit(count))
beer <- filter(beer, Style %in% count)

summary(beer)
```

```
    Style              StyleID          Size(L)              OG        
 Length:70812       Min.   :  1.00   Min.   :   1.00   Min.   : 1.000  
 Class :character   1st Qu.:  9.00   1st Qu.:  18.93   1st Qu.: 1.051  
 Mode  :character   Median : 30.00   Median :  20.82   Median : 1.058  
                    Mean   : 58.77   Mean   :  43.90   Mean   : 1.405  
                    3rd Qu.:109.00   3rd Qu.:  24.00   3rd Qu.: 1.068  
                    Max.   :175.00   Max.   :9200.00   Max.   :32.501  
       FG              ABV              IBU              Color       
 Min.   :-0.003   Min.   : 0.000   Min.   :   0.00   Min.   :  0.00  
 1st Qu.: 1.011   1st Qu.: 5.070   1st Qu.:  23.93   1st Qu.:  5.19  
 Median : 1.013   Median : 5.790   Median :  36.42   Median :  8.42  
 Mean   : 1.076   Mean   : 6.096   Mean   :  45.04   Mean   : 13.44  
 3rd Qu.: 1.017   3rd Qu.: 6.820   3rd Qu.:  57.35   3rd Qu.: 16.77  
 Max.   :23.425   Max.   :19.850   Max.   :2673.83   Max.   :186.00  
  BoilSize(L)         BoilTime      BoilGravity          Efficiency    
 Min.   :   1.00   Min.   :  0.00   Length:70812       Min.   :  0.00  
 1st Qu.:  20.82   1st Qu.: 60.00   Class :character   1st Qu.: 65.00  
 Median :  27.50   Median : 60.00   Mode  :character   Median : 70.00  
 Mean   :  49.72   Mean   : 65.27                      Mean   : 66.37  
 3rd Qu.:  30.00   3rd Qu.: 60.00                      3rd Qu.: 75.00  
 Max.   :9700.00   Max.   :240.00                      Max.   :100.00  
 MashThickness       SugarScale         BrewMethod       
 Length:70812       Length:70812       Length:70812      
 Class :character   Class :character   Class :character  
 Mode  :character   Mode  :character   Mode  :character  
                                                         
                                                         
                                                         
  PitchRate         PrimaryTemp(C)     PrimingMethod     
 Length:70812       Length:70812       Length:70812      
 Class :character   Class :character   Class :character  
 Mode  :character   Mode  :character   Mode  :character  
                                                         
                                                         
                                                         
 PrimingAmount     
 Length:70812      
 Class :character  
 Mode  :character  
                   
                   
                   
```

Calculation
========================================================

The app does several calculations on the data. 

(Here folows a simplified static example of what the app does using 2 beers: Belgian Tripel and English IPA. The actual reactive code is more complex. See the server.R file on Github.)

- Firstly, the app extracts beer types to create searchable dropbown boxes using the count object created at the data cleaning stage.

```r
head(count)
```

```
[1] "Altbier"             "American Amber Ale"  "American Barleywine"
[4] "American Brown Ale"  "American IPA"        "American Lager"     
```
- Then, the selected beer types are used to compute subsets of the data. The reactive output is displayed in a plot using GGplot and Plotly. The app draws 2 histograms in a single plot comparing the ABV distribution of the selected beer types. (In the app this part is written in reactive statements.)

```r
presentation_scope <- c("Belgian Tripel", "English IPA")
data <- filter(beer, Style %in% presentation_scope)
data1 <- filter(beer, Style == "Belgian Tripel")
data2 <- filter(beer, Style == "English IPA")
```
- Finally, it calculates the mean ABV of the selected beer types and displays them as reactive text elements.(Again, in the app this part is written in reactive statements.)

```r
abv1 <- mean(data1$ABV)
abv1 <- paste(round(abv1, digits = 2), "%")
abv2 <- mean(data2$ABV)
abv2 <- paste(round(abv2, digits = 2), "%")
abv2; abv2
```

```
[1] "5.92 %"
```

```
[1] "5.92 %"
```

Results
========================================================
Final results look like this. (In the app the plot is reactive)

```r
 p <- ggplot(data, aes(x = data$ABV, fill = data$Style)) + 
                        geom_histogram(alpha=.5, position="identity") +
                        labs(y = "# beers",
                             x = "ABV",
                             title = "Distribution of ABV for selected beer styles",
                             caption = "based on data from Brewer's Friend, downloaded from Kaggle") +
                        scale_fill_discrete(name = "Beer Styles")
p
```

<img src="Pitch-figure/results-1.png" title="plot of chunk results" alt="plot of chunk results" style="display: block; margin: auto;" />



