---
layout: post
title: "Investing for the Long Run"
subtitle: ""
author: "Marcelo S. Perlin"
output: md_document
image: img/investing-by-horizon.png
tags: [R, finance, investing, BatchGetSymbols]
---

I often get asked about how to invest in the stock market. Not
surprisingly, this has been a common topic in my classes. Brazil is
experiencing a big change in its financial scenario. Historically, fixed
income instruments paid a large premium over the stock market and that
is no longer the case. Interest rates are low, without the pressure from
inflation. This means a more sustainable scenario for low-interest rates
in the future. Without the premium in the fixed income market, people
turn to the stock market.

We can separate investors according to their horizon. Traders try to
profit in the short term, usually within a day, and long-term investors
buy a stock without the intent to sell it in the near future. This type
of investment strategy is called BH (*buy and hold*). At the extreme,
you buy a stock and hold it forever. The most famous spokesperson of BH
is Warren Buffet, among many others.

Investing in the long run works for me because it doesn't require much
of my time. You just need to keep up with the quarterly and yearly
financial reports of companies. You can easily do it as a side activity,
parallel to your main job. You don't need a lot of brain power to do it
either, but it does require knowledge of accounting practices to
understand all the material that is released by the company.

I read many books before starting to invest and one of the most
interesting tables I've found portrays the relationship between
investment horizon and profitability. The idea is that the more time you
hold a stock (or index), higher the chance of a profit. The table,
originally from Taleb's *Fooled by Randomness*, is as follows.

<img src="/img/investing-by-horizon.png" width="300" />

My problem with the table is that it seems pretty off. My experience
tells me that a 67% chance of positive return every month seems
exaggerated. If that was the case, making money in the stock market
would be easy. Digging deeper, I found out that the data behind the
table is simulated and, therefore, doesn't really give good an estimate
about the improvement in the probability of profits as a function of the
investment horizon.

As you probably suspect, I decided to tackle the problem using real data
and R. I wrote a simple [function](/content/others/fct_invest_horizon.R)
that will grab data, simulate investments of different horizons many
times and plot the results. Let's try it for the SP500 index:

    source('fct_invest_horizon.R')

    my.ticker <- '^GSPC' # ticker from yahoo finance
    max.horizon = 255*50 # 50 years
    first.date <- '1950-01-01' 
    last.date <- Sys.Date()
    n.points <- 50 # number of points in figure 
    rf.year <- 0 # risk free return (or inflation)

    l.out <- get.figs.invest.horizon(ticker.in = my.ticker, 
                                     first.date = first.date, 
                                     last.date = last.date,
                                     max.horizon = max.horizon, 
                                     n.points = n.points, 
                                     rf.year = rf.year)

    ## 
    ## Running BatchGetSymbols for:
    ##    tickers = ^GSPC
    ##    Downloading data for benchmark ticker | Found cache file
    ## ^GSPC | yahoo (1|1) | Found cache file - Looking good!

    print(l.out$p1)

![](/img/2018-05-12-Investing-Long-Run_files/figure-markdown_strict/unnamed-chunk-2-1.png)

    print(l.out$p2)

![](/img/2018-05-12-Investing-Long-Run_files/figure-markdown_strict/unnamed-chunk-2-2.png)

As we can see, the data doesn't lie. As the investment horizon
increases, the chances of a positive return increases. This result
suggests that, if you invest for more than 13 years, it is very unlikely
that you'll see a negative return. When looking at the distribution of
total returns by the horizon, we find that it increases significantly
with time. Someone that invested for 50 years is likely to receive a
2500% return on the investment.

With input input `rf.year` we can also set a desired rate of return.
Let's try it with 5% return per year, with is pretty standard for
financial markets.

    my.ticker <- '^GSPC' # ticker from yahoo finance
    max.horizon = 255*50 # 50 years
    first.date <- '1950-01-01' 
    last.date <- Sys.Date()
    n.points <- 50 # number of points in figure 
    rf.year <- 0.05 # risk free return (or inflation) - yearly

    l.out <- get.figs.invest.horizon(ticker.in = my.ticker, 
                                     first.date = first.date, 
                                     last.date = last.date,
                                     max.horizon = max.horizon, 
                                     n.points = n.points, 
                                     rf.year = rf.year)

    ## 
    ## Running BatchGetSymbols for:
    ##    tickers = ^GSPC
    ##    Downloading data for benchmark ticker | Found cache file
    ## ^GSPC | yahoo (1|1) | Found cache file - Got it!

    print(l.out$p1)

![](/img/2018-05-12-Investing-Long-Run_files/figure-markdown_strict/unnamed-chunk-3-1.png)

As expected, the curve of probabilities has a lower slope, meaning that
you need more time investing in the SP500 index to guarantee a return of
more than 5% a year.

Now, let's try the same setup for Berkshire stock (BRK-A). This is
Buffet's company and looking at its share price we can have a good
understanding of how successful Buffet has been as a BH (*buy and hold*)
investor.

    my.ticker <- 'BRK-A' # ticker from yahoo finance
    max.horizon = 255*25 # 50 years
    first.date <- '1980-01-01' 
    last.date <- Sys.Date()
    n.points <- 50 # number of points in figure 
    rf.year <- 0.05 # risk free return (or inflation) - yearly

    l.out <- get.figs.invest.horizon(ticker.in = my.ticker, 
                                     first.date = first.date, 
                                     last.date = last.date,
                                     max.horizon = max.horizon, 
                                     n.points = n.points, 
                                     rf.year = rf.year)

    ## 
    ## Running BatchGetSymbols for:
    ##    tickers = BRK-A
    ##    Downloading data for benchmark ticker | Found cache file
    ## BRK-A | yahoo (1|1) | Found cache file - OK!

    print(l.out$p1)

![](/img/2018-05-12-Investing-Long-Run_files/figure-markdown_strict/unnamed-chunk-4-1.png)

    print(l.out$p2)

![](/img/2018-05-12-Investing-Long-Run_files/figure-markdown_strict/unnamed-chunk-4-2.png)

Well, needless to say that, historically, Buffet has done very well in
his investments! If you bought the stock and kept it for more 1 year,
there is a 70% chance that you got a profit on your investment.

I hope this post convinced you to start investing. The results don't
lie. The earlier you start, the best.
