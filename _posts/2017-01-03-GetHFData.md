---
layout: post
title: "Using R to download high frequency trade data directly from Bovespa"
subtitle: "Using package GetHFData"
author: "Marcelo Perlin"
output: md_document
image: "/img/2017-01-03-GetHFData_files/figure-markdown_strict/unnamed-chunk-8-1.png"
bibliography: /bib files/MyBib.bib
tags: [R, GetHFData,vbovespa, market microstructure, high frequency]
---

Recently, Bovespa, the Brazilian financial exchange company, allowed
external access to its [ftp site](ftp://ftp.bmf.com.br/). In this
address one can find several information regarding the Brazilian
financial system, including datasets with high frequency (tick by tick)
trading data for three different markets: equity, options and BMF.

Downloading and processing these files, however, can be exausting. The
dataset is composed of zip files with the whole trading data, separated
by day and market. These files are huge in size and processing or
aggregating them in a usefull manner requires specific knowledge for the
structure of the dataset.

The package GetHFData make is easy to access this dataset directly by
allowing the easy importation and aggregations of it. Based on this
package the user can:

-   Access the contents of the Bovespa ftp using function function
    `ghfd_get_ftp_contents`
-   Get the list of available ticker in the trading data using
    `ghfd_get_available_tickers_from_ftp`
-   Download individual files using `ghfd_download_file`
-   Download and process a batch of dates and assets codes with
    `ghfd_get_HF_data`

More details about the usage of the package can be found in my [SSRN
paper](https://ssrn.com/abstract=2824058). Next, we present an example
of how to use the package in an empirical application. This particular
example is based in Perlin and Henrique (2016).

Liquidity and the time of the day
---------------------------------

In order to illustrate the usage of the software with aggregated data,
the chosen problem is the analysis of the intraday *U* shaped pattern of
liquidity in the equity market. This particular issue has been found and
discussed in several papers from the literature such as Admati and
Pfleiderer (1988), Back and Pedersen (1998), Engle and Russell (1998),
Groß-Klußmann and Hautsch (2011), among many others.

The data used in this empirical study is related to the six most traded
assets in the period of fifteen trading days from 2016-09-12 until
2016-09-30. The use of a small time period is not accidental. We chose
to keep fifteen days as it facilitates the replication of the example by
decreasing the time needed to download the dataset.

The first step is to select the liquid assets to run the empirical
research. To do that, we select the six most traded assets in the last
date of the study (2016-09-30) by checking the available tickers from
the ftp site in this date. The following code executes this procedure.

    library(GetHFData)

    ## Thank you for using GetHFData! More details about the package can be found in:
    ## 
    ##  https://ssrn.com/abstract=2824058 
    ## 
    ##  If applicable, please use the following citations in your research report. Thanks! 
    ## 
    ## APA:
    ##  Perlin, M., Ramos, H. (2016). GetHFData: A R Package for Downloading and Aggregating High Frequency Trading Data from Bovespa. Available at SSRN. 
    ## 
    ## bibtex:
    ##  @article{perlin2016gethfdata,
    ##   title={GetHFData: A R Package for Downloading and Aggregating High Frequency Trading Data from Bovespa},
    ##   author={Perlin, Marcelo and Henrique, Ramos},
    ##   journal={Available at SSRN},
    ##   year={2016}
    ## }

    n.assets <- 6
    my.date <- as.Date('2016-09-30')
    type.market <- 'equity'

    df.tickers <- ghfd_get_available_tickers_from_ftp(my.date = my.date, 
                                                      type.market = type.market)

    ## 
    ## Reading ftp contents for equity (attempt = 1|10) Attempt 1 - File exists, skipping dl

As explained before, function `ghfd_get_available_tickers_from_ftp` will
output a vector with the number of trades for each ticker found in the
dataset. As a robustness check, we can use package `ggplot2` (Wickham
2009) to create a figure to illustrate the number of trades for each of
the 25 most traded stocks in the date of 2016-09-30, as shown next.

    library(ggplot2)

    temp.df <- df.tickers[1:25, ]

    p <- ggplot(temp.df, aes(x = reorder(tickers, -n.trades), y = n.trades))
    p <- p + geom_bar(stat = "identity")
    p <- p + theme(axis.text.x=element_text(angle=90,hjust=1,vjust=0.5))
    p <- p + labs(x = 'Tickers', y = 'Number of trades')
    print(p)

![](/img/2017-01-03-GetHFData_files/figure-markdown_strict/unnamed-chunk-2-1.png)

From the previous figure we can see that the six most traded assets in
2016-09-30 are ITSA4, PETR4, ITUB4, BBDC4, ABEV3, BBSE3. A particular
feature of the high frequency data from Brazil is that the liquidity is
disperse and decreases rapidly across the assets, as we can see from the
previosu graphic. Even though we are only looking at trading data for
one day, we can expect that the number of trades will also drop quickly
in other time periods.

From the programming side, the dataframe `df.tickers` is already sorted
by the number of trades so, in order to select the six most traded
assets, we select the first six elements of `df.tickers$tickers`.

    my.assets <- df.tickers$tickers[1:n.assets]

And now we can print it to check its content:

    print(my.assets)

    ## [1] ITSA4 PETR4 ITUB4 BBDC4 ABEV3 BBSE3
    ## 462 Levels: AALC34 AAPL34 ABCB10 ABCB4 ABEV3 AEFI11 AELP3 AFLT3 ... XTED11

We continue the empirical example by using the package `GetHFData` to
download and aggregate the desired information for later analysis. The
first step in this stage is to set the options for downloading the
dataset. Notice that it is good policy to set the object `my.folder` as
the name of a folder in the computer's hard disk where the user has
writing permission in order to download the files. We set an example
path as `PATH TO YOUR FOLDER HERE`. We make it clear that the user has
to modify this object in order for the code to run without error. Users
in the Windows platform should be aware that the folder path has to be
set using forward slashes (/) and not backslashes, which is the default.

As for the intraday time periods, we use a first time of *10:30:00* and
last as *16:30:00* in order to avoid the trading noise from the opening
and closing of the market, which could bias our results. The options
used with `GeHFData` are set as follows.

    my.folder<-'PATH TO YOUR FOLDER HERE'
    #setwd(my.folder)

    first.time <- '10:30:00'
    last.time <- '16:30:00'

    first.date <- as.Date('2016-09-12')
    last.date <- as.Date('2016-09-30')
    type.output <- 'agg'
    agg.diff <- '15 min'

    my.assets <- c("ITSA4", "PETR4", "ITUB4", "BBDC4", "ABEV3", "BBSE3")
    type.market <- 'equity'

After setting the inputs, we now use function `ghfd_get_HF_data` to
download and aggregate the financial data.

     df.out <- ghfd_get_HF_data(my.assets = my.assets,
                               type.market = type.market,
                               first.date = first.date,
                               last.date = last.date,
                               first.time = first.time,
                               last.time = last.time,
                               type.output = type.output,
                               agg.diff = agg.diff)

    ## 
    ## Running ghfd_get_HF_Data() for:
    ##    type.market = equity
    ##    my.assets = ITSA4, PETR4, ITUB4, BBDC4, ABEV3, BBSE3
    ##    type.output = agg
    ##       agg.diff = 15 min
    ## Reading ftp contents for equity (attempt = 1|10)
    ##    Found  517  files in ftp
    ##    First available date in ftp:  2014-12-22
    ##    Last available date in ftp:   2017-01-02
    ##    First date to download:  2016-09-12
    ##    Last date to download:   2016-09-30
    ## Downloading ftp files/NEG_20160912.zip (1|15) Attempt 1 - File exists, skipping dl
    ##    -> Reading files - Imported  861097 lines, 463 unique tickers
    ##    -> Processing file - Found 136851 lines for 6 selected tickers
    ##    -> Aggregation resulted in dataframe with 144 rows
    ## Downloading ftp files/NEG_20160913.zip (2|15) Attempt 1 - File exists, skipping dl
    ##    -> Reading files - Imported  1173408 lines, 427 unique tickers
    ##    -> Processing file - Found 236805 lines for 6 selected tickers
    ##    -> Aggregation resulted in dataframe with 144 rows
    ## Downloading ftp files/NEG_20160914.zip (3|15) Attempt 1 - File exists, skipping dl
    ##    -> Reading files - Imported  836391 lines, 426 unique tickers
    ##    -> Processing file - Found 178667 lines for 6 selected tickers
    ##    -> Aggregation resulted in dataframe with 144 rows
    ## Downloading ftp files/NEG_20160915.zip (4|15) Attempt 1 - File exists, skipping dl
    ##    -> Reading files - Imported  721937 lines, 436 unique tickers
    ##    -> Processing file - Found 189977 lines for 6 selected tickers
    ##    -> Aggregation resulted in dataframe with 144 rows
    ## Downloading ftp files/NEG_20160916.zip (5|15) Attempt 1 - File exists, skipping dl
    ##    -> Reading files - Imported  726891 lines, 409 unique tickers
    ##    -> Processing file - Found 127384 lines for 6 selected tickers
    ##    -> Aggregation resulted in dataframe with 144 rows
    ## Downloading ftp files/NEG_20160919.zip (6|15) Attempt 1 - File exists, skipping dl
    ##    -> Reading files - Imported  666277 lines, 457 unique tickers
    ##    -> Processing file - Found 114975 lines for 6 selected tickers
    ##    -> Aggregation resulted in dataframe with 144 rows
    ## Downloading ftp files/NEG_20160920.zip (7|15) Attempt 1 - File exists, skipping dl
    ##    -> Reading files - Imported  733741 lines, 427 unique tickers
    ##    -> Processing file - Found 134744 lines for 6 selected tickers
    ##    -> Aggregation resulted in dataframe with 144 rows
    ## Downloading ftp files/NEG_20160921.zip (8|15) Attempt 1 - File exists, skipping dl
    ##    -> Reading files - Imported  924202 lines, 443 unique tickers
    ##    -> Processing file - Found 177271 lines for 6 selected tickers
    ##    -> Aggregation resulted in dataframe with 144 rows
    ## Downloading ftp files/NEG_20160922.zip (9|15) Attempt 1 - File exists, skipping dl
    ##    -> Reading files - Imported  858705 lines, 451 unique tickers
    ##    -> Processing file - Found 146025 lines for 6 selected tickers
    ##    -> Aggregation resulted in dataframe with 144 rows
    ## Downloading ftp files/NEG_20160923.zip (10|15) Attempt 1 - File exists, skipping dl
    ##    -> Reading files - Imported  799861 lines, 440 unique tickers
    ##    -> Processing file - Found 131548 lines for 6 selected tickers
    ##    -> Aggregation resulted in dataframe with 144 rows
    ## Downloading ftp files/NEG_20160926.zip (11|15) Attempt 1 - File exists, skipping dl
    ##    -> Reading files - Imported  564303 lines, 478 unique tickers
    ##    -> Processing file - Found 90066 lines for 6 selected tickers
    ##    -> Aggregation resulted in dataframe with 144 rows
    ## Downloading ftp files/NEG_20160927.zip (12|15) Attempt 1 - File exists, skipping dl
    ##    -> Reading files - Imported  778917 lines, 434 unique tickers
    ##    -> Processing file - Found 177992 lines for 6 selected tickers
    ##    -> Aggregation resulted in dataframe with 144 rows
    ## Downloading ftp files/NEG_20160928.zip (13|15) Attempt 1 - File exists, skipping dl
    ##    -> Reading files - Imported  764733 lines, 481 unique tickers
    ##    -> Processing file - Found 136236 lines for 6 selected tickers
    ##    -> Aggregation resulted in dataframe with 144 rows
    ## Downloading ftp files/NEG_20160929.zip (14|15) Attempt 1 - File exists, skipping dl
    ##    -> Reading files - Imported  790120 lines, 432 unique tickers
    ##    -> Processing file - Found 155809 lines for 6 selected tickers
    ##    -> Aggregation resulted in dataframe with 144 rows
    ## Downloading ftp files/NEG_20160930.zip (15|15) Attempt 1 - File exists, skipping dl
    ##    -> Reading files - Imported  790261 lines, 462 unique tickers
    ##    -> Processing file - Found 172620 lines for 6 selected tickers
    ##    -> Aggregation resulted in dataframe with 144 rows

We point out that the previous code will take some time to finish as it
has to download and read several large files from Bovespa ftp site. Once
it is finished, we can check the output of `ghfd_get_HF_data` by calling
function `str` for the object `df.out`, which will show the textual
representation of the object in the R environment.

    str(df.out)

    ## 'data.frame':    2160 obs. of  13 variables:
    ##  $ InstrumentSymbol: chr  "ABEV3" "ABEV3" "ABEV3" "ABEV3" ...
    ##  $ SessionDate     : Date, format: "2016-09-12" "2016-09-12" ...
    ##  $ TradeDateTime   : POSIXct, format: "2016-09-12 10:30:00" "2016-09-12 10:45:00" ...
    ##  $ n.trades        : int  531 1143 441 1168 603 618 617 512 492 379 ...
    ##  $ last.price      : num  19.8 19.7 19.8 19.7 19.8 ...
    ##  $ weighted.price  : num  19.7 19.7 19.7 19.7 19.8 ...
    ##  $ period.ret      : num  -0.000506 -0.001013 0.001014 -0.002532 0.003553 ...
    ##  $ period.ret.volat: num  0.000388 0.000175 0.000261 0.000319 0.000282 ...
    ##  $ sum.qtd         : num  314000 584500 1210500 281800 189100 ...
    ##  $ sum.vol         : num  6200565 11522865 23873576 5553286 3736272 ...
    ##  $ n.buys          : int  304 170 199 405 230 283 181 273 348 170 ...
    ##  $ n.sells         : int  227 973 242 763 373 335 436 239 144 209 ...
    ##  $ Tradetime       : chr  "10:30:00" "10:45:00" "11:00:00" "11:15:00" ...

As described earlier, the object returned from `ghfd_get_HF_data` is a
dataframe with several columns calculated from the raw data. Notice that
the columns already have the correct class, which facilitates the future
manipulation of the data.

Once the data is available, we proceed to the analysis of the intraday
pattern of liquidity. To do so, we use the number of trades as a proxy
for liquidity. The analysis will be based on the visual examination of a
figure that relates the distribution of number of trades to the time of
the day. Since the number of trades are not comparable across assets, we
plot the same figure for different stocks. Next, we show the R code that
creates the figure based on the `ggplot2` package.

    p <- ggplot(df.out, aes(x =  Tradetime, y = n.trades))
    p <- p + geom_boxplot() + coord_cartesian(ylim = c(0, 3000))
    p <- p  + theme(axis.text.x=element_text(angle=90,hjust=1,vjust=0.5))
    p <- p + facet_wrap(~InstrumentSymbol)
    p <- p + labs(y='Number of Trades', x = 'Time of Day')
    print(p)

![](/img/2017-01-03-GetHFData_files/figure-markdown_strict/unnamed-chunk-8-1.png)

In the previous figure we show the number of trades as a function of the
time of the day. As expected, we find that the intraday shape of
liquidity follows a *U* pattern, that is, the number of trades rises in
the beginning and ending of the day, with the smallest value around
13:15:00. Such a pattern is found for the great majority of the assets.

This result is supported by previous findings in the literature (Engle
and Russell 1998,Groß-Klußmann and Hautsch (2011)). In the beginning of
the trading day, a significant volume of overnight information is priced
at the market, which justifies the increase of the number of trades. As
for the end of the day, the higher volume of trades can be explained as
a inventory strategy by the investors or market makers, which aims to
finish the day with null portfolio positions in order to avoid the
overnight risk. Since the decrease of portfolio size is achieved with
more trades, we see a significant increase of negotiations at the end of
the day. Interestingly, this pattern for liquidity is correlated to a
pattern of intraday volatility (Andersen and Bollerslev 1997).

References
==========

Admati, Anat R, and Paul Pfleiderer. 1988. “A Theory of Intraday
Patterns: Volume and Price Variability.” *Review of Financial Studies* 1
(1). Soc Financial Studies: 3–40.

Andersen, Torben G, and Tim Bollerslev. 1997. “Intraday Periodicity and
Volatility Persistence in Financial Markets.” *Journal of Empirical
Finance* 4 (2). Elsevier: 115–58.

Back, Kerry, and Hal Pedersen. 1998. “Long-Lived Information and
Intraday Patterns.” *Journal of Financial Markets* 1 (3). Elsevier:
385–402.

Engle, Robert F, and Jeffrey R Russell. 1998. “Autoregressive
Conditional Duration: A New Model for Irregularly Spaced Transaction
Data.” *Econometrica*. JSTOR, 1127–62.

Groß-Klußmann, Axel, and Nikolaus Hautsch. 2011. “When Machines Read the
News: Using Automated Text Analytics to Quantify High Frequency
News-Implied Market Reactions.” *Journal of Empirical Finance* 18 (2).
Elsevier: 321–40.

Perlin, Marcelo, and Ramos Henrique. 2016. “GetHFData: A R Package for
Downloading and Aggregating High Frequency Trading Data from Bovespa.”
*Available at SSRN*.

Wickham, Hadley. 2009. *Ggplot2: Elegant Graphics for Data Analysis*.
Springer-Verlag New York. <http://ggplot2.org>.
