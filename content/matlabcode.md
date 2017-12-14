---
layout: page
title: Matlab Code
---

Here you can find Matlab code I have used for research or fun. Be aware that I no longer  use Matlab and all code available here are not being actively mantained.

### ACD Models

This package includes functions and scripts for the estimation and simulation of ACD (autoregressive conditional duration) models. 
  
The zip file includes: 
  
- Scripts and functions for Estimation of an ACD(q,p) model with exponential or weibull distribution 
- Scripts and functions for Simulation of an ACD(q,p) model with exponential or weibull distribution 
- Scripts for cool plots/movies of weibull, burr and generalized gamma distributions. 
- Scripts and functions for visualizing the log likelihood space of the model (the figure showed above) 

Required Products: Statistics, Optimization

[Link to download](/content/matlab/ACD_Models_FEX.zip)

## Google Trends and Matlab

This Matlab code provides a simple function that access google trends for a given string and location, parses the data and return dates, frequency of data and google's search volume to the user.

Fell free to use it or provide suggestions on how to improve it.

INSTRUCTIONS
 1) Verify your chrome.exe file path (google can help you) and copy it over at to chromePath (see script)
 2) Manually open one chrome brownser and leave it open during the whole process 
 3) In chrome, change the download settings so that all downloads go to your default download folder without user dialog
 4) Set your default download path in dlFolder (see script)
 5) Run the example script

[Link to download](/content/matlab/Gtrends_Matlab_v1.zip)

### Random Portfolios

Considering some input arguments, this function performs n simulations with random trades in a price matrix, saving 3 performance indicators (annualized return, annualized standard deviation and annualized sharpe) at each simulation

For example, suppose that you're a trader and have earned 15% of annualized logarithm return over 248 trading days (1 year) where you traded, in average, for long positions only, 5 stocks for each day and for 50 days. This function will check if a monkey with no skill whatsoever can, in average, replicate your return after transaction costs (defined by the user). If such mamel can do it, maybe you should review your approach at trading.

From the academic point of view, this is called as the bootstrap method for assessing performance. The present code is a variant of such. 

The use of random seeds for portfolio performance is not new. The first paper to use it, as I recall is Cumby and Modest (1987). More recently, a more formal approach at the method was given in Burns (2006).

For a practical application of the codes published here, please check the papers of Perlin (2007a) and Perlin (2007b).

[Link to download](/content/matlab/Monkey_Trading_FEX.zip)

### MS_Regress - Markov Regime Switching Models

The package and its description are available in [Github](https://github.com/msperlin/MS_Regress-Matlab).

### Nearest Neighbor Algorithm

This is the algorithm involved on the use of the non-linear forecast of a time series based on the nearest neighbour method.

The basic idea of the NN algorithm is that the time series copies it's own past behavior, and such fact can be used for forecasting purposes. On the zip file there are two functions: one is the univariate version of NN (nn.m) and the other is the multivariate approach, also called simultaneous NN (snn.m).

The routines of the file were build according to the work of Rodriguez, Rivero and Artilles (2001).

[Link to download](/content/matlab/NN_FEX.zip)

### Pairs Trading

This function performs the classical pairs trading framework in a given set of prices 
   
From Wikipedia, the free encyclopedia: 
“The pairs trade was developed in the late 1980s by quantitative analysts and pioneered by Gerald Bamberger while at Morgan Stanley. With the help of others at Morgan Stanley at the time, including Nunzio Tartaglia, Bamberger found that certain securities, often competitors in the same sector, were correlated in their day-to-day price movements. When the correlation broke down, i.e. one stock traded up while the other traded down, they would sell the outperforming stock and buy the underperforming one, betting that the "spread" between the two would eventually converge.”

Source: http://en.wikipedia.org/wiki/Pairs_trade#Algorithmic_pairs_trading 
See also the great book “Demon of Our Own Design” by Richard Bookstaber, which provides an interesting background for the pairs trading strategy.

There are many ways you can implement the pairs trading framework. For this package, I used a very simple set of rules. Details can be found within code’s comments.

Please note that this package has been developed over the years and it will no longer exactly replicate the results from my 2007 paper.

Qualities of the package: 
- Handles any number of assets 
- Outputs separately the plot for the total cumulative profit from the long, short and combined positions. 
- Outputs all trades, including traded prices and time of trades. 
- Provides the user a large amount of input choices for the pairs trading algorithm, including: 
    * amount of money to put in each position (long and short) 
    * value of transaction cost (in money unit) 
    * size of moving window for finding the pairs over the price data 
    * periodicity of pairs updates 
    * maximum number of days to keep any trade (without convergence). 
    * value of threshold variable 

[Link to download](/content/matlab/PairsTrading_FEX.zip)


