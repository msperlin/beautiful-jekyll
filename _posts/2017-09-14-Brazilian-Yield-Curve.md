The latest version of `GetTDData` offers function `get.yield.curve` to
download the current Brazilian yield curve directly from
[Anbima](http://www.anbima.com.br/est_termo/CZ.asp). The yield curve is
a financial tool that shows how, based on current prices of fixed income
instruments, the market perceives the future real, nominal and inflation
returns. You can find more details regarding the use and definition of a
yield curve in
\[Investopedia\]\[<http://www.investopedia.com/terms/y/yieldcurve.asp>\].

Unfortunately, function `get.yield.curve` only downloads the **current**
yield curve from the website. Data for historical curves over five
business days are not available in Anbima website.

The new version of `GetTDData` is available in github:

    devtools::install_github('msperlin/GetTDData')

I just send the update to CRAN. It should be up in a couple of hours.
You can install it with:

    install.packages('GetTDData')

The current Brazilian yield curve
=================================

Downloading the yield curve is easy, all you need is to call function
`get.yield.curve` without any argument:

    library(GetTDData)

    df.yield <- get.yield.curve()  
    str(df.yield)

    ## 'data.frame':    117 obs. of  5 variables:
    ##  $ n.biz.days  : num  252 378 504 630 756 ...
    ##  $ type        : chr  "real_return" "real_return" "real_return" "real_return" ...
    ##  $ value       : num  3.27 3.26 3.55 3.86 4.12 ...
    ##  $ ref.date    : Date, format: "2018-05-23" "2018-09-26" ...
    ##  $ current.date: Date, format: "2017-09-13" "2017-09-13" ...

The result is a dataframe in the long format containing data for the
yield curve of real, nominal and inflation returns. Let's plot it!

    library(ggplot2)

    p <- ggplot(df.yield, aes(x=ref.date, y = value) ) +
      geom_line(size=1) + geom_point() + facet_grid(~type, scales = 'free') + 
      labs(title = paste0('The current Brazilian Yield Curve '),
           subtitle = paste0('Date: ', df.yield$current.date[1]))     

    print(p)  

    ## Warning: Removed 1 rows containing missing values (geom_point).

![](img/2017-09-14-Brazilian-Yield-Curve_files/figure-markdown_strict/unnamed-chunk-4-1.png)

The expected inflation in Brazil seems to be stable. Market expectation
is for an inflation around 5% a year in 2024. This level is quite low
when compared to our
[history](https://tradingeconomics.com/brazil/inflation-cpi). As for
future nominal interest rate, market expects another drop in the
interest rate level in 2018. This is in line with the latest report from
[COPOM](http://www.bcb.gov.br/?ATACOPOM), the Brazilian comittee of
monetary policy. Real returns also seems to be stable and low, around
5%. Again, this is one of the lowest levels of real returns in our
economy.

I'm very optimistic (and very biased as I love my country!) regarding
the future of the Brazilian economy. I hope we can keep these low levels
of interest rate and inflation in order to foment comsumption, jobs and
overall economic well-being.
