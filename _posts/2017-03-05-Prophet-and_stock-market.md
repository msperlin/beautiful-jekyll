---
layout: post
title: "Can we predict stock prices with Prophet?"
subtitle: " "
author: "Marcelo Perlin"
output: md_document
image: /img/2017-03-05-Prophet-and_stock-market_files/figure-markdown_strict/unnamed-chunk-13-1.png
tags: [R, prophet, stock prices, market efficiency]
---

Facebook recently released a API package allowing access to its
forecasting model called
[prophet](http://blog.revolutionanalytics.com/2017/02/facebook-prophet.html).
According to the underling post:

    It's not your traditional ARIMA-style time series model. It's closer in spirit to a  Bayesian-influenced generalized additive model, a regression of smooth terms. The model is resistant   to the effects of outliers, and supports data collected over an irregular time scale (ingliding presence of missing data) without the need for interpolation. The underlying calculation engine is Stan; the R and Python packages simply provide a convenient interface.  

After reading it, I got really curious about the predictive performance
of this method for stock prices. That is, **can we predict stock price
movements based on prophet?** In this post I will investigate this
research question using a database of prices for the SP500 components.

Before describing the code and results, it is noteworthy to point out
that forecasting stock returns is really hard! There is a significant
body of literature trying to forecast prices and to prove (or not) that
financial markets are efficient in pricing publicly available
information, including historical prices. This is the so called
efficient market hypothesis. I have studied it, tried to trade for
myself for a while when I was a Msc student, advised several graduate
students on it, and the results are mostly the same: it is very
difficult to find a trade signal that works well and is sustainable in
real life.

This means that most of the variation in prices is due to random factors
that cannot be anticipated. The explanation is simple, prices move
according to investor's expectation from available information. Every
time that new (random) information, true or not, reaches the market,
investor's update their beliefs and trade accordingly. So, unless, new
information or market expectation have a particular pattern, price
changes will be mostly random.

Even with a body of evidence against our research, it is still
interesting to see how we could apply `prophet` in a trading setup.

The data
--------

First, let's download stock prices for all components of the SP500 index
in the previous two years. This is a lengthy download. If you don't have
the patience or time, I saved the the result in RData file available
[here](/data/SP500.RData).

    library(BatchGetSymbols)

    my.stocks <- GetSP500Stocks()$ticker

    first.date <- as.Date('2015-01-01')
    last.date <- Sys.Date()
    df.stocks <- BatchGetSymbols(my.stocks, 
                                 first.date = first.date, 
                                 last.date = last.date)[[2]]

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

In order to make the code run faster, I will select only 25 random
stocks from the sample:

    set.seed(10)
    n.stocks <- 25
    my.stocks <- sample(unique(df.stocks$ticker), n.stocks)

    df.stocks <- df.stocks[df.stocks$ticker %in% my.stocks, ]

Now, let's understand how prophet works. I was happy to see that the
interface is quite simple, you offer a time series with input `y` and a
date vector with `ds`. If no further custom option is set, you are good
to go. My only complain with `prophet` is that that the function outputs
lots of messages. They really should add a `quiet` option, so that the
user doesn't have to use `capture.output` to silent it. Have a look in
the next example with a dummy series:

    library(prophet)

    ## Loading required package: Rcpp

    df.est <- data.frame(y = rnorm(100), ds = Sys.Date() + 1:100)

    m <- prophet(df = df.est)

    ## STAN OPTIMIZATION COMMAND (LBFGS)
    ## init = user
    ## save_iterations = 1
    ## init_alpha = 0.001
    ## tol_obj = 1e-012
    ## tol_grad = 1e-008
    ## tol_param = 1e-008
    ## tol_rel_obj = 10000
    ## tol_rel_grad = 1e+007
    ## history_size = 5
    ## seed = 492642109
    ## initial log joint probability = -8.50656
    ## Optimization terminated normally: 
    ##   Convergence detected: absolute parameter change was below tolerance

The next step is to think about how to structure a function for our
research problem. Our study has two steps, first we will set a
*training* (in-sample) period, estimate the model and make forecasts.
After that, we use the *out-of-sample* data to test the accuracy of the
model.

The whole procedure of estimating and forecasting will be encapsulated
in a single R function. This is not the best way of doing it but, for
our simple example, it will suffice. My function will take as input a
dataframe and the number of out-of-sample forecasts. Based on the
adjusted closing prices, we calculate returns and feed
`1:(nrow(df)-nfor)` rows for the estimation. The last `nfor` rows are
used for testing the accuracy of the model. For example, if I have a
vector with 1000 returns and `nfor=5`, I use observations from `1:995`
for estimating the model and `996:1000` for testing the forecasts. The
function returns a dataframe with the predictions for each horizon, its
error, among other things. Here's the function definition:

    est.model.and.forecast <- function(df.in, nfor=5){
      # Estimated model using prophet and forecast it
      #
      # Args:
      #   df.in - A dataframe with columns price.adjusted and ref.date
      #   nfor - Number of out-of-sample forecasts
      #
      # Returns:
      #   A dataframe with forecasts and errors for each horizon.
      
      require(prophet)
      require(dplyr)
      
      my.ticker <- df.in$ticker[1]
      
      #cat('\nProcessing ', my.ticker)
      
      n.row <- nrow(df.in)
      df.in$ret <- with(df.in, c(NA,price.adjusted[2:n.row]/price.adjusted[1:(n.row - 1)] - 1))
      
      df.in <- select(df.in, ref.date, ret)
      names(df.in) <- c('ds', 'y')
      
      idx <- nrow(df.in) - nfor
      
      df.est <- df.in[1:idx, ]
      df.for <- df.in[(idx + 1):nrow(df.in), ]
      
      capture.output(
        m <- prophet(df = df.est)
      )
      
      # forecast 50 days ahead (it also includes non trading days)
      df.pred <- predict(m,
                         make_future_dataframe(m,
                                               periods = nfor + 50))
      
      
      df.for <- merge(df.for, df.pred, by = 'ds')
      df.for <- select(df.for, ds, y, yhat)
      
      # forecast statistics
      df.for$eps <- with(df.for,y - yhat)
      df.for$abs.eps <- with(df.for,abs(y - yhat))
      df.for$perc.eps <- with(df.for,(y - yhat)/y)
      df.for$nfor <- 1:nrow(df.for)
      df.for$ticker <- my.ticker
      
      return(df.for)
      
    }

Let's try it out using the `by` function to apply it for each stock in
our sample. All results are later combined in a single dataframe with
function `do.call`.

    out.l <- by(data = df.stocks,
                INDICES = df.stocks$ticker, 
                FUN = est.model.and.forecast, nfor = 5)

    my.result <- do.call(rbind, out.l)

Lets have a look in the resulting dataframe:

    head(my.result)

    ##                ds            y          yhat           eps      abs.eps
    ## AN.1   2017-02-27  0.004697779  1.073144e-03  0.0036246355 0.0036246355
    ## AN.2   2017-02-28 -0.024442020 -7.927652e-04 -0.0236492544 0.0236492544
    ## AN.3   2017-03-01  0.015468387  2.439663e-03  0.0130287240 0.0130287240
    ## AN.4   2017-03-02 -0.003647329  6.270727e-05 -0.0037100361 0.0037100361
    ## AN.5   2017-03-03 -0.013350539 -6.233167e-04 -0.0127272219 0.0127272219
    ## ANTM.1 2017-02-27  0.006592211  6.073838e-03  0.0005183736 0.0005183736
    ##          perc.eps nfor ticker
    ## AN.1   0.77156364    1     AN
    ## AN.2   0.96756548    2     AN
    ## AN.3   0.84228070    3     AN
    ## AN.4   1.01719266    4     AN
    ## AN.5   0.95331149    5     AN
    ## ANTM.1 0.07863425    1   ANTM

In this object you'll find the forecasts (yhat), the actual values (y),
the absolute and normalized error (abs.eps, perc.eps).

For ou first analysis, let's have a look on the effect of the
forecasting horizon over the absolute error distribution.

    library(ggplot2)

    p <- ggplot(my.result, aes(x=factor(nfor), 
                               y=abs.eps))
    p <- p + geom_boxplot()

    print(p)

![](/img/2017-03-05-Prophet-and_stock-market_files/figure-markdown_strict/unnamed-chunk-8-1.png)

We do find some positive dependency. As the horizon increases, the
forecasting algorithm makes more mistakes. Surprisingly, this pattern is
not found for `nfor=5`. It might be interesting to add more data and
check if this effect is robust.

Encopassing test
----------------

A simple and powerful test for verifying the accuracy of a prediction
algorithm is the encompassing test. The idea is to estimate the
following linear model with the real returns (*R*<sub>*t*</sub>) and its
predictions ($\\hat{R} \_t$).

![](/img/EncompassingTest.png)

If the model provides good forecasts, we can expect that *α* is equal to
zero (no bias) and *β* is equal to 1. If both conditions are true, we
have that $R\_t = \\hat{R} \_t + \\epsilon \_t$$, meaning that our
forecasting model provides an unbiased estimator of the predicted
variable. In a formal research, we could use a Wald test to verify this
hypothesis jointly.

First, lets find the result of the encompassing test for all forecasts.

    lm.model <- lm(formula = y ~yhat, data = my.result)
    summary(lm.model)

    ## 
    ## Call:
    ## lm(formula = y ~ yhat, data = my.result)
    ## 
    ## Residuals:
    ##       Min        1Q    Median        3Q       Max 
    ## -0.041310 -0.005200 -0.000846  0.006056  0.035647 
    ## 
    ## Coefficients:
    ##              Estimate Std. Error t value Pr(>|t|)   
    ## (Intercept) -0.002240   0.001289  -1.738  0.08479 . 
    ## yhat         0.822045   0.254414   3.231  0.00158 **
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 0.01133 on 123 degrees of freedom
    ## Multiple R-squared:  0.07824,    Adjusted R-squared:  0.07074 
    ## F-statistic: 10.44 on 1 and 123 DF,  p-value: 0.001582

As you can see, it didn't work very well. While the constant seems Ok,
the value of 0.8220446 is not even close to 1. But, it could be the case
that the different horizon have different results. A longer horizon,
with bad forecasts, will be affecting short horizons with good
forecasts. Lets use `dplyr` to separate our model according to `nfor`.

    models <- my.result %>%
      group_by(nfor) %>%
      do(ols.model = lm(data = ., formula = y ~ yhat ))

We report the results with `broom::tidy`.

    library(broom)
    knitr::kable(models %>% tidy(ols.model))

<table>
<thead>
<tr class="header">
<th align="right">nfor</th>
<th align="left">term</th>
<th align="right">estimate</th>
<th align="right">std.error</th>
<th align="right">statistic</th>
<th align="right">p.value</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="right">1</td>
<td align="left">(Intercept)</td>
<td align="right">0.0024381</td>
<td align="right">0.0017693</td>
<td align="right">1.3779940</td>
<td align="right">0.1814651</td>
</tr>
<tr class="even">
<td align="right">1</td>
<td align="left">yhat</td>
<td align="right">-0.3374193</td>
<td align="right">0.4488191</td>
<td align="right">-0.7517936</td>
<td align="right">0.4597999</td>
</tr>
<tr class="odd">
<td align="right">2</td>
<td align="left">(Intercept)</td>
<td align="right">-0.0071114</td>
<td align="right">0.0022989</td>
<td align="right">-3.0933634</td>
<td align="right">0.0051276</td>
</tr>
<tr class="even">
<td align="right">2</td>
<td align="left">yhat</td>
<td align="right">1.2326600</td>
<td align="right">0.4826284</td>
<td align="right">2.5540562</td>
<td align="right">0.0177381</td>
</tr>
<tr class="odd">
<td align="right">3</td>
<td align="left">(Intercept)</td>
<td align="right">0.0074791</td>
<td align="right">0.0026961</td>
<td align="right">2.7740540</td>
<td align="right">0.0107937</td>
</tr>
<tr class="even">
<td align="right">3</td>
<td align="left">yhat</td>
<td align="right">1.1998427</td>
<td align="right">0.4618100</td>
<td align="right">2.5981305</td>
<td align="right">0.0160770</td>
</tr>
<tr class="odd">
<td align="right">4</td>
<td align="left">(Intercept)</td>
<td align="right">-0.0079042</td>
<td align="right">0.0017917</td>
<td align="right">-4.4114616</td>
<td align="right">0.0002019</td>
</tr>
<tr class="even">
<td align="right">4</td>
<td align="left">yhat</td>
<td align="right">0.3345002</td>
<td align="right">0.3219130</td>
<td align="right">1.0391012</td>
<td align="right">0.3095587</td>
</tr>
<tr class="odd">
<td align="right">5</td>
<td align="left">(Intercept)</td>
<td align="right">-0.0041302</td>
<td align="right">0.0030427</td>
<td align="right">-1.3574059</td>
<td align="right">0.1878234</td>
</tr>
<tr class="even">
<td align="right">5</td>
<td align="left">yhat</td>
<td align="right">0.7356029</td>
<td align="right">0.6071194</td>
<td align="right">1.2116281</td>
<td align="right">0.2379564</td>
</tr>
</tbody>
</table>

Well, it again didn't work as expected. We do not find that shorter
horizons have better results in the encompassing test. In fact, we even
get some negative betas! This means that, for some horizons, it might be
better to take the opposite suggestion of the forecast!

Trading based on forecasts
--------------------------

In a practical trading applications, it might not be of interest to
forecast actual returns. If you are trading according to these
forecasts, you are probably more worried about the direction of the
forecasts and not its nominal error. A model can have bad nominal
forecasts, but be good in predicting the sign of the next price
movement. If this is the case, you can still make money even though your
model fails in the encompassing test.

Let's try it out with a simple trading strategy for all different
horizons:

-   buy in end of day *t* if forecast in *t+1* is positive and sell at
    the end of *t+1*
-   short-sell in the end of day *t* when forecast for *t+1* is negative
    and buy it back in the end of *t+1*

The total profit will be given by:

    my.profit <- sum(with(my.result, (yhat>0)*y + (yhat<0)*-y))
    print(my.profit)

    ## [1] 0.07947572

Not bad! Doesn't look like much, but remember that we have a few trading
days and this return might be due to a sistematic effect in the market.
Let's see how this result compares to random trading signals.

    n.sim <- 10000

    monkey.ret <- numeric(length = n.sim)
    for (i in seq(n.sim)) {
      rnd.vec <- rnorm(length(my.result$y))
      
      monkey.ret[i] <- sum( (rnd.vec>0)*my.result$y + (rnd.vec<0)*-my.result$y )
      
    } 

    temp.df <- data.frame(monkey.ret, my.profit)
    p <- ggplot(temp.df, aes(monkey.ret)) 
    p <- p + geom_histogram()
    p <- p + geom_vline(aes(xintercept =  my.profit),size=2)
    p <- p + labs(x='Returns from random trading signals')
    print(p)

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](/img/2017-03-05-Prophet-and_stock-market_files/figure-markdown_strict/unnamed-chunk-13-1.png)

The previous histogram shows the total return from randomnly generated
signals in 10^{4} simulations. The vertical line is the result from
using `prophet`. As you can see, it is a bit higher than the average of
the distribution. The total return from `prophet` is lower than the
return of the naive strategy in 27.5 percent of the simulations. This is
not a bad result. But, notice that we didnt add trading or liquidity
costs to the analysis, which will make the total returns worse.

The main results of this simple study are clear: **`prophet` is bad at
point forecasts for returns but does quite better in directional
predictions**. It might be interesting to test it further, with more
data, adding trading costs, other forecasting setups, and see if the
results hold.
