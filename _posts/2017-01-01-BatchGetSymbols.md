---
layout: post
title: "How to download and organize financial data from yahoo finance for several tickers"
subtitle: "How to use BatchGetSymbols"
author: "Marcelo Perlin"
output: md_document
image: /img/hello_world.jpeg
tags: [yahoo finance, batchgetsymbols, quantmod]
---

One of the great things of working in finance is that financial datasets
are freely available from sources such as Google and Yahoo Finance. This
is an excelent feature for building up to date content for classes and
conducting academic research.

In the past I have used function GetSymbols from the CRAN package
[quantmod](https://cran.r-project.org/package=quantmod) in order to
download end of day trade data for several stocks in the financial
market. The problem in using GetSymbols is that it was not designed to
take into consideration the aggregation of financial data for several
tickers. In the usage of GetSymbols, each stock will have its own `xts`
object with different column names and this makes it troublesome to
store data from several tickers in a single dataframe in the long
format. Nonetheless, if you are using dplyr and ggplot2 to process and
plot data, the long format is expected.

The package BatchGetSymbols is my solution to this problem. Based on a
list of tickers and a time period, the function will download the data
by automatically choosing the correct source, yahoo or google, and
output two dataframes: a single dataframe with all the information for
the stocks in the list and a dataframe with a report of the download
process. The user can also set a benchmark ticker in order to compare
dates and eliminate assets with a low number of observations from the
resulting dataframe.

A simple example
----------------

As a simple exercise, let's download data for three stocks, facebook
(FB), 3M (MMM), PETR4.SA (PETROBRAS) and abcdef, a ticker I just made
up. We will use the last 150 days as the time period. This example will
show the simple interface of the package and how it handles invalid
tickers.

    library(BatchGetSymbols)

    ## Loading required package: rvest

    ## Loading required package: xml2

    ## 
    ## Thank you for using BatchGetSymbols! If applicable, please use the following citation in your research report. Thanks! 
    ## 
    ## APA:
    ##  Perlin, M. (2016) BatchGetSymbols: Downloads and Organizes Financial Data for Multiple Tickers. CRAN Package, Available in https://CRAN.R-project.org/package=BatchGetSymbols. 
    ## 
    ## BIBTEX:
    ##  @misc{perlin2016batchgetsymbols,
    ##   title = {BatchGetSymbols: Downloads and Organizes Financial Data for Multiple Tickers},
    ##   author = {Marcelo Perlin},
    ##   year = {2016},
    ##   journal = {CRAN Package},
    ##   url = {https://CRAN.R-project.org/package=BatchGetSymbols}
    ## }
    ## }

    first.date <- Sys.Date()-150
    last.date <- Sys.Date()

    tickers <- c('FB','NYSE:MMM','PETR4.SA','abcdef')

    l.out <- BatchGetSymbols(tickers = tickers,
                             first.date = first.date,
                             last.date = last.date)

    ## 
    ## Running BatchGetSymbols for:
    ##    tickers = FB, NYSE:MMM, PETR4.SA, abcdef
    ##    Downloading data for benchmark ticker
    ## Downloading Data for FB from yahoo (1|4) - Boa!
    ## Downloading Data for NYSE:MMM from google (2|4) - Boa!
    ## Downloading Data for PETR4.SA from yahoo (3|4) - Good job!
    ## Downloading Data for abcdef from yahoo (4|4) - Error in download..

After downloading the data, we can check the success of the process for
each ticker. Notice that the last ticker does not exist in yahoo finance
or google and therefore results in an error. All information regarding
the download process is provided in the dataframe df.control:

    print(l.out$df.control)

    ##     ticker    src download.status total.obs perc.benchmark.dates
    ## 1       FB  yahoo              OK       102                    1
    ## 2 NYSE:MMM google              OK       102                    1
    ## 3 PETR4.SA  yahoo              OK       106                    1
    ## 4   abcdef  yahoo          NOT OK         0                    0
    ##   threshold.decision
    ## 1               KEEP
    ## 2               KEEP
    ## 3               KEEP
    ## 4                OUT

Moreover, we can plot the daily closing prices using ggplot2:

    library(ggplot2)
     
    p <- ggplot(l.out$df.tickers, aes(x = ref.date, y = price.close))
    p <- p + geom_line()
    p <- p + facet_wrap(~ticker, scales = 'free_y') 
    print(p)

![](/img/2017-01-01-BatchGetSymbols_files/figure-markdown_strict/plot.prices-1.png)

Downloading data for all tickers in the SP500 index
---------------------------------------------------

A more advanced example would be to download data for all stocks in the
current composition of the SP500 stock index. The package also includes
a function that downloads the current composition of the SP500 index
from the internet. By using this function along with BatchGetSymbols, we
can easily import end-of-day data for all assets in the SP500 index.

Notice the following code, where we download data for the SP500 stocks
for the last year. The code is not executed in this example given its
time duration, but you can just copy and paste on its own R script in
order to check the results. In my computer it takes around 5 minutes to
download the whole dataset.

    library(BatchGetSymbols)

    first.date <- Sys.Date()-365
    last.date <- Sys.Date()

    df.SP500 <- GetSP500Stocks()
    tickers <- df.SP500$tickers

    l.out <- BatchGetSymbols(tickers = tickers,
                             first.date = first.date,
                             last.date = last.date)

    print(l.out$df.control)
    print(l.out$df.tickers)
