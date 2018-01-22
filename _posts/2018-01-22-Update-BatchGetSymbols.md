---
layout: post
title: "Major update to BatchGetSymbols"
subtitle: "Making it even easier to download and organize stock prices from Yahoo Finance"
author: "Marcelo S. Perlin"
image: img/packages.jpg
tags: [R, BatchGetSymbols, Yahoo finance]
---

I just released a long due update to package `BatchGetSymbols`. The
files are under review in CRAN and you should get the update soon.
Meanwhile, you can install the new version from Github:

    if (!require(devtools)) install.packages('devtools')
    devtools::install_github('msperlin/BatchGetSymbols')

The main innovations are:

-   **Clever cache system**: By default, every new download of data will
    be saved in a local file located in a directory chosen by user.
    Every new request of data is compared to the available local
    information. If data is missing, the function only downloads the
    piece of data that is missing. This make the call to function
    `BatchGetSymbols` a lot faster! When updating an existing dataset of
    prices, the function only downloads the new available data that is
    missing from the local files.

-   **Returns calculation**: Function now returns a return vector in
    `df.tickers`. Returns are used a lot more than prices in research.
    No reason why they should be keep out of the output.

-   **Wide format**: Added function for converting data to the wide
    format. In some situations, such as portfolio analysis, the wide
    format makes a lot of sense and is required for some methodologies.

-   **Ibovespa composition**: Added function for downloading current
    Ibovespa composition directly from Bovespa website.

In the next chunks of code I show some of the innovations:

    library(BatchGetSymbols)

    ## Loading required package: rvest

    ## Loading required package: xml2

    # download Ibovespa stocks
    my.tickers <- GetSP500Stocks()$tickers[1:10] # lets keep it light

    # set dates
    first.date <- '2016-01-01'
    last.date <- '2018-01-01'

    # set folder for cache system
    my.temp.cache.folder <- 'BGS_CACHE'

    # get data and time it
    time.nocache <- system.time({
    my.l <- BatchGetSymbols(tickers = my.tickers, first.date, last.date, 
                            cache.folder = my.temp.cache.folder, do.cache = FALSE)
    })

    ## 
    ## Running BatchGetSymbols for:
    ##    tickers = MMM, ABT, ABBV, ACN, ATVI, AYI, ADBE, AMD, AAP, AES
    ##    Downloading data for benchmark ticker
    ## MMM | yahoo (1|10) - You got it!
    ## ABT | yahoo (2|10) - Nice!
    ## ABBV | yahoo (3|10) - Looking good!
    ## ACN | yahoo (4|10) - Got it!
    ## ATVI | yahoo (5|10) - Good job!
    ## AYI | yahoo (6|10) - Looking good!
    ## ADBE | yahoo (7|10) - Fells good!
    ## AMD | yahoo (8|10) - Good job!
    ## AAP | yahoo (9|10) - Youre doing good!
    ## AES | yahoo (10|10) - Well done!

    time.withcache <- system.time({
    my.l <- BatchGetSymbols(tickers = my.tickers, first.date, last.date, 
                            cache.folder = my.temp.cache.folder, do.cache = TRUE)
    })

    ## 
    ## Running BatchGetSymbols for:
    ##    tickers = MMM, ABT, ABBV, ACN, ATVI, AYI, ADBE, AMD, AAP, AES
    ##    Downloading data for benchmark ticker | Found cache file
    ## MMM | yahoo (1|10) | Found cache file - You got it!
    ## ABT | yahoo (2|10) | Found cache file - Mais faceiro que guri de bombacha nova!
    ## ABBV | yahoo (3|10) | Found cache file - OK!
    ## ACN | yahoo (4|10) | Found cache file - Looking good!
    ## ATVI | yahoo (5|10) | Found cache file - Youre doing good!
    ## AYI | yahoo (6|10) | Found cache file - Good job!
    ## ADBE | yahoo (7|10) | Found cache file - Boa!
    ## AMD | yahoo (8|10) | Found cache file - Youre doing good!
    ## AAP | yahoo (9|10) | Found cache file - Nice!
    ## AES | yahoo (10|10) | Found cache file - Well done!

    cat('\nTime with no cache:', time.nocache['elapsed'])

    ## 
    ## Time with no cache: 5.721

    cat('\nTime with cache:', time.withcache['elapsed'])

    ## 
    ## Time with cache: 0.419

Now let's check the default output with data in the long format:

    dplyr::glimpse(my.l)

    ## List of 2
    ##  $ df.control:'data.frame':  10 obs. of  6 variables:
    ##   ..$ ticker              : Factor w/ 10 levels "MMM","ABT","ABBV",..: 1 2 3 4 5 6 7 8 9 10
    ##   ..$ src                 : Factor w/ 1 level "yahoo": 1 1 1 1 1 1 1 1 1 1
    ##   ..$ download.status     : Factor w/ 1 level "OK": 1 1 1 1 1 1 1 1 1 1
    ##   ..$ total.obs           : int [1:10] 503 503 503 503 503 503 503 503 503 503
    ##   ..$ perc.benchmark.dates: num [1:10] 1 1 1 1 1 1 1 1 1 1
    ##   ..$ threshold.decision  : Factor w/ 1 level "KEEP": 1 1 1 1 1 1 1 1 1 1
    ##  $ df.tickers:'data.frame':  5030 obs. of  10 variables:
    ##   ..$ price.open         : num [1:5030] 148 147 146 143 141 ...
    ##   ..$ price.high         : num [1:5030] 148 148 146 143 142 ...
    ##   ..$ price.low          : num [1:5030] 145 146 143 141 140 ...
    ##   ..$ price.close        : num [1:5030] 147 147 144 141 140 ...
    ##   ..$ volume             : num [1:5030] 3277200 2688100 2997100 3553500 2664000 ...
    ##   ..$ price.adjusted     : num [1:5030] 140 140 137 134 134 ...
    ##   ..$ ref.date           : Date[1:5030], format: "2016-01-04" ...
    ##   ..$ ticker             : chr [1:5030] "MMM" "MMM" "MMM" "MMM" ...
    ##   ..$ ret.adjusted.prices: num [1:5030] NA 0.00436 -0.02014 -0.02436 -0.0034 ...
    ##   ..$ ret.closing.prices : num [1:5030] NA 0.00436 -0.02014 -0.02436 -0.0034 ...

And change the format of the long dataframe to wide:

    l.wide <- reshape.wide(my.l$df.tickers) 

Now we check the matrix of prices:

    print(head(l.wide$price.adjusted))

    ##     ref.date      AAP     ABBV      ABT      ACN  ADBE      AES  AMD
    ## 1 2016-01-04 151.7778 53.13200 40.73167 97.84000 91.97 8.676987 2.77
    ## 2 2016-01-05 150.7410 52.91066 40.72218 98.34921 92.34 8.796606 2.75
    ## 3 2016-01-06 146.7531 52.91988 40.38061 98.15706 91.02 8.492956 2.51
    ## 4 2016-01-07 148.3781 52.76309 39.41285 95.27461 89.11 8.281322 2.28
    ## 5 2016-01-08 145.1181 51.32436 38.58740 94.35222 87.85 8.400942 2.14
    ## 6 2016-01-11 146.6036 49.69193 38.64433 95.34187 89.38 8.308928 2.34
    ##       ATVI      AYI      MMM
    ## 1 37.08925 231.8706 139.7082
    ## 2 36.61602 234.8136 140.3171
    ## 3 36.27096 228.6194 137.4910
    ## 4 35.75830 222.5544 134.1415
    ## 5 35.20620 214.2424 133.6848
    ## 6 35.69915 205.1450 133.6562

and matrix of returns:

    print(head(l.wide$ret.adjusted.prices))

    ##     ref.date          AAP         ABBV           ABT          ACN
    ## 1 2016-01-04           NA           NA            NA           NA
    ## 2 2016-01-05 -0.006831368 -0.004165926 -0.0002329146  0.005204589
    ## 3 2016-01-06 -0.026455014  0.000174256 -0.0083877625 -0.001953793
    ## 4 2016-01-07  0.011073327 -0.002962743 -0.0239660045 -0.029365662
    ## 5 2016-01-08 -0.021971161 -0.027267849 -0.0209438784 -0.009681414
    ## 6 2016-01-11  0.010236201 -0.031806010  0.0014754559  0.010488932
    ##           ADBE         AES          AMD         ATVI         AYI
    ## 1           NA          NA           NA           NA          NA
    ## 2  0.004022997  0.01378578 -0.007220217 -0.012759168  0.01269226
    ## 3 -0.014294987 -0.03451900 -0.087272727 -0.009423798 -0.02637922
    ## 4 -0.020984356 -0.02491877 -0.091633466 -0.014134199 -0.02652876
    ## 5 -0.014139861  0.01444455 -0.061403509 -0.015439800 -0.03734795
    ## 6  0.017416039 -0.01095282  0.093457944  0.014001682 -0.04246338
    ##             MMM
    ## 1            NA
    ## 2  0.0043588215
    ## 3 -0.0201408824
    ## 4 -0.0243618296
    ## 5 -0.0034048077
    ## 6 -0.0002134424
