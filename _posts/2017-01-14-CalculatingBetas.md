---
layout: post
title: "How to calculate betas (systematic risk) for a large number of stocks"
subtitle: ""
author: "Marcelo Perlin"
output: md_document
image: 2017-01-07-predatory_files/predatory-publisher.png
bibliography: MyBib.bib
tags: [R, beta, linear regression]
---

One of the first examples about the usage of linear regression in
finance is the calculation of betas. The coefficient beta is a measure
of systematic risk and is calculated by estimating a linear model where
the dependent variable is the returns of a stock and the independent is
the returns of market index, such as SP500, FTSE or any other. We can
formulate it as:

*R*<sub>*i*, *t*</sub> = *α*<sub>*i*</sub> + *β*<sub>*i*</sub>*R**M*, *t* + *ϵ*

So, if you have a vector of prices for a stock and an index, you can
easilly transforme it to returns and estimate the beta of the stock.

The problem here is that, usually, you don't want the beta of a single
stocks. You want to calculate the systematic risk for a large number of
stocks. This is where students usually have problems, as they learned
only to estimate the model for a single stock. In order to do the same
procedure for more than one stock, some programming is needed.

In this post I will show three ways to calculate the beta of several
stocks:

1.  Using `loops` (simplest case)
2.  Using `tapply` and `sapply`
3.  Using package `dplyr`

But first, lets load the data.

Loading the data
----------------

I'm a bit biased, but I really like using package `BatchGetSymbols` to
download financial data from yahoo finance. In this example I will
download data for 10 stocks from the SP500 index. I will also add the
ticker `^GSPC`, which belongs to the SP500 index. We will need it to
calculate the betas later. I will also set `random.seed(100)` as a
replicability parameter.

    library(BatchGetSymbols)

    ## Loading required package: rvest

    ## Loading required package: xml2

    ## 
    ## Thank you for using BatchGetSymbols! If applicable, please use the following citation in your research report. Thanks! 
    ## 
    ## APA:
    ##  Perlin, M. (2016). BatchGetSymbols: Downloads and Organizes Financial Data for Multiple Tickers. CRAN Package, Available in https://CRAN.R-project.org/package=BatchGetSymbols. 
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

    set.seed(100)

    first.date <- as.Date('2015-01-01')
    last.date <- as.Date('2017-01-01')


    # get random stocks
    my.tickers <- c(sample(GetSP500Stocks()$tickers,10),
                    '^GSPC')

    l.out <- BatchGetSymbols(tickers = my.tickers, 
                                 first.date = first.date,
                                 last.date = last.date)

    ## 
    ## Running BatchGetSymbols for:
    ##    tickers = DUK, CCI, LLY, AAL, HST, IR, SRE, FB, LH, CAH, ^GSPC
    ##    Downloading data for benchmark ticker
    ## Downloading Data for DUK from yahoo (1|11) - Good stuff!
    ## Downloading Data for CCI from yahoo (2|11) - Well done!
    ## Downloading Data for LLY from yahoo (3|11) - Got it!
    ## Downloading Data for AAL from yahoo (4|11) - Nice!
    ## Downloading Data for HST from yahoo (5|11) - Good job!
    ## Downloading Data for IR from yahoo (6|11) - Good job!
    ## Downloading Data for SRE from yahoo (7|11) - Got it!
    ## Downloading Data for FB from yahoo (8|11) - Nice!
    ## Downloading Data for LH from yahoo (9|11) - Nice!
    ## Downloading Data for CAH from yahoo (10|11) - Good job!
    ## Downloading Data for ^GSPC from yahoo (11|11) - Good stuff!

    df.stocks <- l.out$df.tickers

Now, lets check if the import process went well for all stocks:

    print(l.out$df.control)

    ##    ticker   src download.status total.obs perc.benchmark.dates
    ## 1     DUK yahoo              OK       504                    1
    ## 2     CCI yahoo              OK       504                    1
    ## 3     LLY yahoo              OK       504                    1
    ## 4     AAL yahoo              OK       504                    1
    ## 5     HST yahoo              OK       504                    1
    ## 6      IR yahoo              OK       504                    1
    ## 7     SRE yahoo              OK       504                    1
    ## 8      FB yahoo              OK       504                    1
    ## 9      LH yahoo              OK       504                    1
    ## 10    CAH yahoo              OK       504                    1
    ## 11  ^GSPC yahoo              OK       504                    1
    ##    threshold.decision
    ## 1                KEEP
    ## 2                KEEP
    ## 3                KEEP
    ## 4                KEEP
    ## 5                KEEP
    ## 6                KEEP
    ## 7                KEEP
    ## 8                KEEP
    ## 9                KEEP
    ## 10               KEEP
    ## 11               KEEP

It seens that everything went well, as all stocks had column
`perc.benchmark.dates` equal to one (100%).

Now, lets plot the time series of prices and look for any problem:

    library(ggplot2)

    p <- ggplot(df.stocks, aes(x=ref.date, y=price.adjusted, color=ticker))
    p <- p + geom_line()
    p <- p + facet_wrap(~ticker, scales = 'free')
    print(p)

![](2017-01-14-CalculatingBetas_files/figure-markdown_strict/unnamed-chunk-3-1.png)

We can see that all prices seems to be Ok. This is one of the advantages
of working with adjusted (and not closing) prices from yahoo finance.
Artificial effects in the dataset such as ex-dividend prices, splits and
inplits are already taken into account and result is a smooth series
without any breaks.

Calculating returns
-------------------

In the previous step we downloaded prices from yahoo finance. In the
regression, however, returns are used. We have two choices here,
arithmetic or logarithmic returns. In general, logarithimic returns are
more used in research since they have some special properties. In
practice, though, it makes very little difference. The logarithmic
returns are given by:

$$
R\_t = \\log \\frac{P\_t}{P\_{t-1}}
$$

In order to calculate dailly returns for each stock, the first step is
to write a simple function that, given a vector of prices, outputs a
vector of returns.

    calc.ret <- function(p){
      
      my.n <- length(p)
      arit.ret <- c(NA, log(p[2:my.n]/p[1:(my.n-1)]))
      return(arit.ret)
    }

Notice that I used a NA for the first element. In the next steps we will
bind the vector of returns in the price dataframe. Therefore, it will be
needed that they have the same lenght. Remember that you always lose one
observation when calculating returns.

In order to organize the dataset, we will first calculate the returns of
all assets and store them in the same dataframe.

    list.ret <- tapply(X = df.stocks$price.adjusted, INDEX = df.stocks$ticker,FUN = calc.ret)

    list.ret <- list.ret[unique(df.stocks$ticker)]

    df.stocks$ret <- unlist(list.ret)

create a new column in `df.stocks` which will hold the

Another function that will be usefull later is the calculation of the
beta, given two vectors of return. Let's write it:

    get.beta <- function(r.stock, r.mkt){
      
      my.ols <- lm(x = r.mkt, y=r.stock)
      my.beta <- coef(my.ols)[2]
      return(my.beta)
    }

The previous function accepts two vectors, `r.stock` and `r.mkt`, uses
them to calculate a linear model with function `lm` and then return the
beta, which is the second coefficient in `coef(my.ols)`.

Now, with both functions ready, lets use the different approaches to
calculate and store the beta.

Using loops
-----------

Loops are great. Let use them in our problem.

    unique.tickers <- unique(df.stocks$ticker)

    for (i.ticker in unique.tickers){
      
      #df.temp <- df.stocks
    }
