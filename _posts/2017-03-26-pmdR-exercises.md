---
layout: post
title: "New book and package pafdR"
subtitle: "Processing and modelling financial data with R "
author: "Marcelo Perlin"
output: md_document
image: /img/CAPADigital_FinancialDataR.jpg
tags: [R, pafdR, exercises, book]
---

My Portuguese book about finance and R was
[published](https://www.amazon.com/s/ref=nb_sb_ss_c_1_18?url=search-alias%3Daps&field-keywords=processamento+e+modelagem+de+dados+financeiros+com+o+r&sprefix=processamento+e+mo%2Caps%2C287&crid=3SDV8WWLKP3H4)
a couple of months ago and, given its positive feedback, I decided to
work on the english version immediately. You can find details about my
experience in self publishing the book in this
[post](https://msperlin.github.io/2017-02-16-Writing-a-book/).

The English book is not a simple translation of text and examples. This
is a long term project that I always dreamed of doing. With time, I plan
to keep the Portuguese and English version synchronized. The feedback I
got from the Portuguese version was taken into account and I wrote
additional sections covering advanced use of `dplyr` with list-columns,
storing data in SQLITE, reporting tables with `xtable` and `stargazer`,
and many more.

The book is not yet finished. I'm taking my time in reviewing everything
and making sure that it comes out perfectly. I believe it will be ready
in a few months or less. If you are interested in the book, please go to
its [website](https://sites.google.com/view/pafdr/home) where you can
find its current TOC (table of contents), code and data.

If you want to be notified about the publication of the book, please
sign this [form](https://goo.gl/forms/ViTXWClGCduO8f8J3) and I'll let
you know as soon as it is available.

Package `pafdR`
===============

Yesterday I released package `pafdR`, which provides access to all
material from my book **Processing and Modelling Financial Data with
R**, including code, data and exercises.

The exercises are still not complete. I expect to have at least 100
exercises covering all chapters of the book. As soon as the book is
finished, I'll starting working on it.

With package `pafdR` you can:

1.  Download data and code with function `pafdR_download.code.and.data`
2.  Build exercises with function `pafdR_build.exercise`

Downloading code and data
-------------------------

All the R code from the book is publicly available in
[github](https://github.com/msperlin/pafdR-en-code_data/). Function
`pafdR_download.code.and.data` will download a zip file from the
repository and unzip it at specified folder. Have a look in its usage:

    if (!require(pafdR)){
      install.packages('pafdR')
      library(pafdR)
    } 

    my.lan <- 'en' # language of code and data ('en' or 'pt-br')

    # dl may take some time (around 60 mb)
    pafdR_download.code.and.data(lan = my.lan)

    dir.out <- 'pafdR-en-code_data-master'

    # list R code
    list.files(dir.out, pattern = '*.R')
    list.files(paste0(dir.out,'/data'))

Building exercises
------------------

All exercises from the book are based on package `exams`. This means
that every reader will have a different version of the exercise, with
different values and correct answer. I've written extensively about the
positive aspects of using `exams`. You can find the full post
[here](https://msperlin.github.io/2017-01-30-Exams-with-dynamic-content/)

You can create your custom exercise file using function
`pafdR_build.exercise`. Give it a try, just copy and paste the following
chunk of code in your R prompt.

    if (!require(pafdR)){
      install.packages('pafdR')
      library(pafdR)
    } 

    my.lan <- 'en' # language of exercises
    my.exercise.folder <- 'pafdR-exercises' # name of folder with exercises files (will download from github)
    my.pdf.folder <- 'PdfOut' # name of folder to place pdf file and answer sheet

    pafdR_build.exercise(lan = my.lan,
                         exercise.folder = my.exercise.folder, 
                         pdf.folder = my.pdf.folder)

    list.files(my.pdf.folder)
