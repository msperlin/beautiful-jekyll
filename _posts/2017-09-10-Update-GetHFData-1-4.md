---
layout: post
title: "Recreating the LOB"
subtitle: "Update to GetHFData (Version 1.4)"
author: "Marcelo Perlin"
output: html_document
image: /img/Rlogo.png
tags: [R, GetHFData, LOB]
---

`GetHFData` newest version (1.4) allows the recreation of the LOB (limit order book) based on order data. A limit order book is the standard format that trading occurs in most exchanges. Order are sent and executed whenever there is a match of order prices from sellers and buyers. Recreating the LOB is a recursive problem where all trading orders must be sorted, added and organized into a LOB object. Based on the LOB, we have information about the mid quote, best bid/ask, spread and LOB depth. These variables are usually used in studies regarding market liquidity.

I want to thank Prof. Satchit Sagade and [House of Finance - Goethe Uni](http://www.hof.uni-frankfurt.de/home.html) for inviting me as a visiting researcher in June 2017. Not only I had a wonderful time there, most of the code for the LOB reconstruction was developed during my stay. 

Be aware that recreating the LOB is a computer intensive problem. The current code is not optimized for speed and may take a long time to finish, even for a few periods of trading days. Here's an example of usage for the new code:

```
library(GetHFData)

first.time <- '10:00:00'
last.time <- '17:00:00'

first.date <- '2015-08-18' 
last.date <- '2015-08-18'

type.output <- 'raw' 

my.assets <- 'PETR4F' 
type.matching <- 'exact' 
type.market = 'equity-odds' 
type.data <- 'orders' 

df.out <- ghfd_get_HF_data(my.assets =my.assets, 
                           type.data= type.data,
                           type.matching = type.matching,
                           type.market = type.market,
                           first.date = first.date,
                           last.date = last.date,
                           first.time = first.time,
                           last.time = last.time,
                           type.output = type.output)
                           
df.lob <- ghfd_build_lob(df.out)
```
