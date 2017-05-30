---
layout: post
title: "Update to GetHFData (Version 1.3)"
subtitle: " "
author: "Marcelo Perlin"
output: html_document
image: /img/Rlogo.png
tags: [R, GetHFData]
---

I just posted a major update to GetHFData. Version 1.3 of `GetHFData` makes it possible to download and aggregate order data from Bovespa. The data comprises  buy and sell orders sent by market operators. Tabular data includes type of orders (buy or sell, new/update/cancel/..), date/time of submission, priority time, prices, order quantity, among many other information.

**Be aware that these are very large files.** One day of buy and sell orders in the equity market is around 100 MB zipped and close to 1 GB unzipped. If you computer is not suited to store this data in its memory, **it will crash**.  

Here's an example of usage that will download and aggregate order data for all option contracts related to Petrobras (PETR):

```
library(GetHFData)

first.time <- '10:00:00'
last.time <- '17:00:00'

first.date <- '2015-08-18' 
last.date <- '2015-08-18'

type.output <- 'agg' # aggregates data 
agg.diff <- '5 min' # interval for aggregation

my.assets <- 'PETR' # all options related to Petrobras (partial matching)
type.matching <- 'partial' # finds tickers from my.assets using partial matching
type.market = 'options' # option market
type.data <- 'orders' # order data

df.out <- ghfd_get_HF_data(my.assets =my.assets, 
                           type.data= type.data,
                           type.matching = type.matching,
                           type.market = type.market,
                           first.date = first.date,
                           last.date = last.date,
                           first.time = first.time,
                           last.time = last.time,
                           type.output = type.output,
                           agg.diff = agg.diff)

```

Minor updates:

* Fixed link to paper and citation
* Now it is possible to use partial matching (e.g. use PETR for all stocks or options related to Petrobras)
* implement option for only downloading files (this is helpful if you are dealing with order data and will process the files in other R session or software)
* muted message "Using ',' as decimal ..." from readr

I'm also now using Github for development. This will make it easier to handle bug reports and version control. Here's is the [link](https://github.com/msperlin/GetHFData). The new version is already available in Github. Give it a try:

```
devtools::install_github('msperlin/GetHFData')
``` 

The update should be in CRAN shortly.

