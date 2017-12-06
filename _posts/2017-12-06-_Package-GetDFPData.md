---
layout: post
title: "Package GetDFPData"
subtitle: "Downloading Annual Financial Reports and Corporate Events from B3 (formerly Bovespa)"
author: "Marcelo Perlin"
output: md_document
image: img/b3.png
tags: [R, GetDFPData, corporate events, financial reports]
---

Financial statements of companies traded at B3 (formerly Bovespa), the
Brazilian stock exchange, are available in its
[website](http://www.bmfbovespa.com.br/). Accessing the data for a
single company is straightforward. In the website one can find a simple
interface for accessing this dataset. An example is given
[here](https://www.rad.cvm.gov.br/ENETCONSULTA/frmGerenciaPaginaFRE.aspx?NumeroSequencialDocumento=67775&CodigoTipoInstituicao=2).
However, gathering and organizing the data for a large scale research,
with many companies and many dates, is painful. Financial reports must
be downloaded or copied individually and later aggregated. Changes in
the accounting format thoughout time can make this process slow,
unreliable and irreproducible.

Package `GetDFPData` provides a R interface to all annual financial
statements available in the website and more. It not only downloads the
data but also organizes it in a tabular format and allows the use of
inflation indexes. Users can select companies and a time period to
download all available data. Several information about current
companies, such as sector and available quarters are also at reach. The
main purpose of the package is to make it easy to access financial
statements in large scale research, facilitating the reproducibility of
corporate finance studies with B3 data.

The positive aspects of `GetDFDData` are:

-   Easy and simple R and web interface
-   Changes in accounting format are internally handled by the software
-   Access to corporate events in the FRE system such as dividend
    payments, changes in stock holder composition, changes in governance
    listings, board composition and compensation, debt composition, and
    a lot more!
-   The output data is automatically organized using tidy data
    principles (long format)
-   A cache system is employed for fast data acquisition
-   Completely free and open source!

Installation
============

The package is (not yet) available in CRAN (release version) and in
Github (development version). You can install any of those with the
following code:

    # Release version in CRAN
    install.packages('GetDFPData') # not in CRAN yet

    # Development version in Github
    devtools::install_github('msperlin/GetDFPData')

Shinny interface
================

The web interface of `GetDFPData` is available at
<http://www.msperlin.com/shiny/GetDFPData/>.

How to use `GetDFPData`
=======================

The starting point of `GetDFPData` is to find the official names of
companies in B3. Function `gdfpd.search.company` serves this purpose.
Given a string (text), it will search for a partial matches in companies
names. As an example, let's find the *official* name of Petrobras, one
of the largest companies in Brazil:

    library(GetDFPData)
    library(tibble)

    gdfpd.search.company('petrobras',cache.folder = tempdir())

    ## 
    ## Reading info file from github
    ## Found 43873 lines for 687 companies  [Actives =  521  Inactives =  167 ]
    ## Last file update:  2017-10-19
    ## Caching RDATA into tempdir()
    ## 
    ## Found 1 companies:
    ## PETRÓLEO BRASILEIRO  S.A.  - PETROBRAS | situation = ATIVO | first date = 1998-12-31 | last date - 2016-12-31

    ## [1] "PETRÓLEO BRASILEIRO  S.A.  - PETROBRAS"

Its official name in Bovespa records is
`PETRÓLEO BRASILEIRO  S.A.  - PETROBRAS`. Data for quarterly and annual
statements are available from 1998 to 2017. The situation of the
company, active or canceled, is also given. This helps verifying the
availability of data.

The content of all available financial statements can be accessed with
function `gdfpd.get.info.companies`. It will read and parse a .csv file
from my [github
repository](https://github.com/msperlin/GetDFPData_auxiliary). This will
be periodically updated for new information. Let's try it out:

    df.info <- gdfpd.get.info.companies(type.data = 'companies', cache.folder = tempdir())

    ## 
    ## Reading info file from github
    ## Found 43873 lines for 687 companies  [Actives =  521  Inactives =  167 ]
    ## Last file update:  2017-10-19
    ## Caching RDATA into tempdir()

    glimpse(df.info)

    ## Observations: 689
    ## Variables: 8
    ## $ name.company    <chr> "521 PARTICIPAÇOES S.A. - EM LIQUIDAÇÃO EXTRAJ...
    ## $ id.company      <int> 16330, 16284, 108, 20940, 21725, 19313, 18970,...
    ## $ situation       <chr> "ATIVO", "ATIVO", "CANCELADA", "CANCELADA", "A...
    ## $ listing.segment <chr> NA, "None", "None", "None", "None", "None", "C...
    ## $ main.sector     <chr> NA, "Financeiro e Outros", "Materiais Básicos"...
    ## $ tickers         <chr> NA, "QVQP3B", NA, NA, NA, "AELP3", "TIET11;TIE...
    ## $ first.date      <date> 1998-12-31, 2001-12-31, 2009-12-31, 2009-12-3...
    ## $ last.date       <date> 2016-12-31, 2016-12-31, 2009-12-31, 2009-12-3...

This file includes several information that are gathered from Bovespa:
names of companies, official numeric ids, listing segment, sectors,
traded tickers and, most importantly, the available dates. The resulting
dataframe can be used to filter and gather information for large scale
research such as downloading financial data for a specific sector.

Downloading financial information for ONE company
-------------------------------------------------

All you need to download financial data with `GetDFPData` are the
official names of companies, which can be found with
`gdfpd.search.company`, the desired starting and ending dates and the
type of financial information (individual or consolidated). Let's try it
for PETROBRAS:

    name.companies <- 'PETRÓLEO BRASILEIRO  S.A.  - PETROBRAS'
    first.date <- '2004-01-01'
    last.date  <- '2006-01-01'

    df.reports <- gdfpd.GetDFPData(name.companies = name.companies, 
                                   first.date = first.date,
                                   last.date = last.date,
                                   cache.folder = tempdir())

    ## Found cache file. Loading data..
    ## 
    ## Downloading data for 1 companies
    ## First Date: 2004-01-01
    ## Laste Date: 2006-01-01
    ## Inflation index: dollar
    ## 
    ## Downloading inflation data
    ##  Caching inflation RDATA into tempdir()  Done
    ## 
    ## 
    ## WARNING: Cash flow statements are not available before 2009 
    ## 
    ## Inputs looking good! Starting download of files:
    ## 
    ## PETRÓLEO BRASILEIRO  S.A.  - PETROBRAS
    ##  Available periods: 2005-12-31   2004-12-31
    ## 
    ## 
    ## Processing 9512 - PETRÓLEO BRASILEIRO  S.A.  - PETROBRAS
    ##  Finding info from Bovespa | downloading and reading data | saving cache
    ##  Processing 9512 - PETRÓLEO BRASILEIRO  S.A.  - PETROBRAS | date 2005-12-31
    ##      Acessing DFP data | downloading file | reading file | saving cache
    ##      Acessing FRE data | No FRE file available..
    ##      Acessing FCA data | No FCA file available..
    ##  Processing 9512 - PETRÓLEO BRASILEIRO  S.A.  - PETROBRAS | date 2004-12-31
    ##      Acessing DFP data | downloading file | reading file | saving cache
    ##      Acessing FRE data | No FRE file available..
    ##      Acessing FCA data | No FCA file available..

The resulting object is a `tibble`, a data.frame type of object that
allows for list columns. Let's have a look in its content:

    glimpse(df.reports)

    ## Observations: 1
    ## Variables: 33
    ## $ company.name                  <chr> "PETRÓLEO BRASILEIRO  S.A.  - PE...
    ## $ company.code                  <int> 9512
    ## $ company.tickers               <chr> "PETR3;PETR4"
    ## $ min.date                      <date> 2004-12-31
    ## $ max.date                      <date> 2005-12-31
    ## $ n.periods                     <int> 2
    ## $ company.segment               <chr> "Tradicional"
    ## $ current.stockholders          <list> [<c("PETRÓLEO BRASILEIRO  S.A. ...
    ## $ current.stock.composition     <list> [<c("PETRÓLEO BRASILEIRO  S.A. ...
    ## $ fr.assets                     <list> [<c("PETRÓLEO BRASILEIRO  S.A. ...
    ## $ fr.liabilities                <list> [<c("PETRÓLEO BRASILEIRO  S.A. ...
    ## $ fr.income                     <list> [<c("PETRÓLEO BRASILEIRO  S.A. ...
    ## $ fr.cashflow                   <list> [<character(0), character(0), c...
    ## $ fr.assets.consolidated        <list> [<c("PETRÓLEO BRASILEIRO  S.A. ...
    ## $ fr.liabilities.consolidated   <list> [<c("PETRÓLEO BRASILEIRO  S.A. ...
    ## $ fr.income.consolidated        <list> [<c("PETRÓLEO BRASILEIRO  S.A. ...
    ## $ fr.cashflow.consolidated      <list> [<character(0), character(0), c...
    ## $ history.dividends             <list> [<c("PETRÓLEO BRASILEIRO  S.A. ...
    ## $ history.stockholders          <list> [NULL]
    ## $ history.capital.issues        <list> [NULL]
    ## $ history.mkt.value             <list> [NULL]
    ## $ history.capital.increases     <list> [NULL]
    ## $ history.capital.reductions    <list> [NULL]
    ## $ history.stock.repurchases     <list> [NULL]
    ## $ history.other.stock.events    <list> [NULL]
    ## $ history.compensation          <list> [NULL]
    ## $ history.compensation.summary  <list> [NULL]
    ## $ history.transactions.related  <list> [NULL]
    ## $ history.debt.composition      <list> [NULL]
    ## $ history.governance.listings   <list> [NULL]
    ## $ history.board.composition     <list> [NULL]
    ## $ history.committee.composition <list> [NULL]
    ## $ history.family.relations      <list> [NULL]

Object `df.reports` only has one row since we only asked for data of one
company. The number of rows increases with the number of companies, as
we will soon learn with the next example. All financial statements for
the different years are available within `df.reports`. For example, the
assets statements for all desired years of PETROBRAS are:

    df.income.long <- df.reports$fr.income[[1]]

    glimpse(df.income.long)

    ## Observations: 48
    ## Variables: 6
    ## $ name.company       <chr> "PETRÓLEO BRASILEIRO  S.A.  - PETROBRAS", "...
    ## $ ref.date           <date> 2005-12-31, 2005-12-31, 2005-12-31, 2005-1...
    ## $ acc.number         <chr> "3.01", "3.02", "3.03", "3.04", "3.05", "3....
    ## $ acc.desc           <chr> "Receita Bruta de Vendas e/ou Serviços", "D...
    ## $ acc.value          <int> 143665730, -37843204, 105822526, -57512113,...
    ## $ acc.value.infl.adj <dbl> 61398234.97, -16173000.56, 45225234.41, -24...

The resulting dataframe is in the long format, ready for processing. In
the long format, financial statements of different years are stacked. In
the wide format, we have the year as columns of the table.

If you want the wide format, which is the most common way that financial
reports are presented, you can use function `gdfpd.convert.to.wide`. See
an example next:

    df.income.wide <- gdfpd.convert.to.wide(df.income.long)

    knitr::kable(df.income.wide )

<table>
<thead>
<tr class="header">
<th align="left">acc.number</th>
<th align="left">acc.desc</th>
<th align="left">name.company</th>
<th align="right">2004-12-31</th>
<th align="right">2005-12-31</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left">3.01</td>
<td align="left">Receita Bruta de Vendas e/ou Serviços</td>
<td align="left">PETRÓLEO BRASILEIRO S.A. - PETROBRAS</td>
<td align="right">120024727</td>
<td align="right">143665730</td>
</tr>
<tr class="even">
<td align="left">3.02</td>
<td align="left">Deduções da Receita Bruta</td>
<td align="left">PETRÓLEO BRASILEIRO S.A. - PETROBRAS</td>
<td align="right">-34450292</td>
<td align="right">-37843204</td>
</tr>
<tr class="odd">
<td align="left">3.03</td>
<td align="left">Receita Líquida de Vendas e/ou Serviços</td>
<td align="left">PETRÓLEO BRASILEIRO S.A. - PETROBRAS</td>
<td align="right">85574435</td>
<td align="right">105822526</td>
</tr>
<tr class="even">
<td align="left">3.04</td>
<td align="left">Custo de Bens e/ou Serviços Vendidos</td>
<td align="left">PETRÓLEO BRASILEIRO S.A. - PETROBRAS</td>
<td align="right">-48607576</td>
<td align="right">-57512113</td>
</tr>
<tr class="odd">
<td align="left">3.05</td>
<td align="left">Resultado Bruto</td>
<td align="left">PETRÓLEO BRASILEIRO S.A. - PETROBRAS</td>
<td align="right">36966859</td>
<td align="right">48310413</td>
</tr>
<tr class="even">
<td align="left">3.06</td>
<td align="left">Despesas/Receitas Operacionais</td>
<td align="left">PETRÓLEO BRASILEIRO S.A. - PETROBRAS</td>
<td align="right">-11110540</td>
<td align="right">-14810467</td>
</tr>
<tr class="odd">
<td align="left">3.06.01</td>
<td align="left">Com Vendas</td>
<td align="left">PETRÓLEO BRASILEIRO S.A. - PETROBRAS</td>
<td align="right">-2858630</td>
<td align="right">-4195157</td>
</tr>
<tr class="even">
<td align="left">3.06.02</td>
<td align="left">Gerais e Administrativas</td>
<td align="left">PETRÓLEO BRASILEIRO S.A. - PETROBRAS</td>
<td align="right">-2599552</td>
<td align="right">-3453753</td>
</tr>
<tr class="odd">
<td align="left">3.06.03</td>
<td align="left">Financeiras</td>
<td align="left">PETRÓLEO BRASILEIRO S.A. - PETROBRAS</td>
<td align="right">-1019901</td>
<td align="right">126439</td>
</tr>
<tr class="even">
<td align="left">3.06.04</td>
<td align="left">Outras Receitas Operacionais</td>
<td align="left">PETRÓLEO BRASILEIRO S.A. - PETROBRAS</td>
<td align="right">0</td>
<td align="right">0</td>
</tr>
<tr class="odd">
<td align="left">3.06.05</td>
<td align="left">Outras Despesas Operacionais</td>
<td align="left">PETRÓLEO BRASILEIRO S.A. - PETROBRAS</td>
<td align="right">-5982336</td>
<td align="right">-9070019</td>
</tr>
<tr class="even">
<td align="left">3.06.06</td>
<td align="left">Resultado da Equivalência Patrimonial</td>
<td align="left">PETRÓLEO BRASILEIRO S.A. - PETROBRAS</td>
<td align="right">1349879</td>
<td align="right">1782023</td>
</tr>
<tr class="odd">
<td align="left">3.07</td>
<td align="left">Resultado Operacional</td>
<td align="left">PETRÓLEO BRASILEIRO S.A. - PETROBRAS</td>
<td align="right">25856319</td>
<td align="right">33499946</td>
</tr>
<tr class="even">
<td align="left">3.08</td>
<td align="left">Resultado Não Operacional</td>
<td align="left">PETRÓLEO BRASILEIRO S.A. - PETROBRAS</td>
<td align="right">-550694</td>
<td align="right">-199982</td>
</tr>
<tr class="odd">
<td align="left">3.08.01</td>
<td align="left">Receitas</td>
<td align="left">PETRÓLEO BRASILEIRO S.A. - PETROBRAS</td>
<td align="right">46611</td>
<td align="right">1256194</td>
</tr>
<tr class="even">
<td align="left">3.08.02</td>
<td align="left">Despesas</td>
<td align="left">PETRÓLEO BRASILEIRO S.A. - PETROBRAS</td>
<td align="right">-597305</td>
<td align="right">-1456176</td>
</tr>
<tr class="odd">
<td align="left">3.09</td>
<td align="left">Resultado Antes Tributação/Participações</td>
<td align="left">PETRÓLEO BRASILEIRO S.A. - PETROBRAS</td>
<td align="right">25305625</td>
<td align="right">33299964</td>
</tr>
<tr class="even">
<td align="left">3.10</td>
<td align="left">Provisão para IR e Contribuição Social</td>
<td align="left">PETRÓLEO BRASILEIRO S.A. - PETROBRAS</td>
<td align="right">-5199166</td>
<td align="right">-8581490</td>
</tr>
<tr class="odd">
<td align="left">3.11</td>
<td align="left">IR Diferido</td>
<td align="left">PETRÓLEO BRASILEIRO S.A. - PETROBRAS</td>
<td align="right">-1692288</td>
<td align="right">-422392</td>
</tr>
<tr class="even">
<td align="left">3.12</td>
<td align="left">Participações/Contribuições Estatutárias</td>
<td align="left">PETRÓLEO BRASILEIRO S.A. - PETROBRAS</td>
<td align="right">-660000</td>
<td align="right">-846000</td>
</tr>
<tr class="odd">
<td align="left">3.12.01</td>
<td align="left">Participações</td>
<td align="left">PETRÓLEO BRASILEIRO S.A. - PETROBRAS</td>
<td align="right">-660000</td>
<td align="right">-846000</td>
</tr>
<tr class="even">
<td align="left">3.12.02</td>
<td align="left">Contribuições</td>
<td align="left">PETRÓLEO BRASILEIRO S.A. - PETROBRAS</td>
<td align="right">0</td>
<td align="right">0</td>
</tr>
<tr class="odd">
<td align="left">3.13</td>
<td align="left">Reversão dos Juros sobre Capital Próprio</td>
<td align="left">PETRÓLEO BRASILEIRO S.A. - PETROBRAS</td>
<td align="right">0</td>
<td align="right">0</td>
</tr>
<tr class="even">
<td align="left">3.15</td>
<td align="left">Lucro/Prejuízo do Exercício</td>
<td align="left">PETRÓLEO BRASILEIRO S.A. - PETROBRAS</td>
<td align="right">17754171</td>
<td align="right">23450082</td>
</tr>
</tbody>
</table>

Downloading financial information for SEVERAL companies
-------------------------------------------------------

If you are doing serious research, it is likely that you need financial
statements for more than one company. Package `GetDFPData` is specially
designed for handling large scale download of data. Let's build a case
with two selected companies:

    my.companies <- c('PETRÓLEO BRASILEIRO  S.A.  - PETROBRAS',
                      'BANCO DO ESTADO DO RIO GRANDE DO SUL SA')

    first.date <- '2005-01-01'
    last.date  <- '2007-01-01'
    type.statements <- 'individual'

    df.reports <- gdfpd.GetDFPData(name.companies = my.companies, 
                                   first.date = first.date,
                                   last.date = last.date,
                                   cache.folder = tempdir())

    ## Found cache file. Loading data..
    ## 
    ## Downloading data for 2 companies
    ## First Date: 2005-01-01
    ## Laste Date: 2007-01-01
    ## Inflation index: dollar
    ## 
    ## Downloading inflation data
    ##  Found cache file. Loading data..    Done
    ## 
    ## 
    ## WARNING: Cash flow statements are not available before 2009 
    ## 
    ## Inputs looking good! Starting download of files:
    ## 
    ## BANCO DO ESTADO DO RIO GRANDE DO SUL SA
    ##  Available periods: 2006-12-31   2005-12-31
    ## PETRÓLEO BRASILEIRO  S.A.  - PETROBRAS
    ##  Available periods: 2006-12-31   2005-12-31
    ## 
    ## 
    ## Processing 1210 - BANCO DO ESTADO DO RIO GRANDE DO SUL SA
    ##  Finding info from Bovespa | downloading and reading data | saving cache
    ##  Processing 1210 - BANCO DO ESTADO DO RIO GRANDE DO SUL SA | date 2006-12-31
    ##      Acessing DFP data | downloading file | reading file | saving cache
    ##      Acessing FRE data | No FRE file available..
    ##      Acessing FCA data | No FCA file available..
    ##  Processing 1210 - BANCO DO ESTADO DO RIO GRANDE DO SUL SA | date 2005-12-31
    ##      Acessing DFP data | downloading file | reading file | saving cache
    ##      Acessing FRE data | No FRE file available..
    ##      Acessing FCA data | No FCA file available..
    ## Processing 9512 - PETRÓLEO BRASILEIRO  S.A.  - PETROBRAS
    ##  Finding info from Bovespa
    ##      Found cache file /tmp/RtmpSpLsOP/9512_PETRÓLEO/GetDFPData_BOV_cache_9512_PETR.rds
    ##  Processing 9512 - PETRÓLEO BRASILEIRO  S.A.  - PETROBRAS | date 2006-12-31
    ##      Acessing DFP data | downloading file | reading file | saving cache
    ##      Acessing FRE data | No FRE file available..
    ##      Acessing FCA data | No FCA file available..
    ##  Processing 9512 - PETRÓLEO BRASILEIRO  S.A.  - PETROBRAS | date 2005-12-31
    ##      Acessing DFP data | Found DFP cache file
    ##      Acessing FRE data | No FRE file available..
    ##      Acessing FCA data | No FCA file available..

And now we can check the resulting `tibble`:

    glimpse(df.reports)

    ## Observations: 2
    ## Variables: 33
    ## $ company.name                  <chr> "BANCO DO ESTADO DO RIO GRANDE D...
    ## $ company.code                  <int> 1210, 9512
    ## $ company.tickers               <chr> "BRSR3;BRSR5;BRSR6", "PETR3;PETR4"
    ## $ min.date                      <date> 2005-12-31, 2005-12-31
    ## $ max.date                      <date> 2006-12-31, 2006-12-31
    ## $ n.periods                     <int> 2, 2
    ## $ company.segment               <chr> "Corporate Governance - Level 1"...
    ## $ current.stockholders          <list> [<c("BANCO DO ESTADO DO RIO GRA...
    ## $ current.stock.composition     <list> [<c("BANCO DO ESTADO DO RIO GRA...
    ## $ fr.assets                     <list> [<c("BANCO DO ESTADO DO RIO GRA...
    ## $ fr.liabilities                <list> [<c("BANCO DO ESTADO DO RIO GRA...
    ## $ fr.income                     <list> [<c("BANCO DO ESTADO DO RIO GRA...
    ## $ fr.cashflow                   <list> [<character(0), character(0), c...
    ## $ fr.assets.consolidated        <list> [<c("BANCO DO ESTADO DO RIO GRA...
    ## $ fr.liabilities.consolidated   <list> [<c("BANCO DO ESTADO DO RIO GRA...
    ## $ fr.income.consolidated        <list> [<c("BANCO DO ESTADO DO RIO GRA...
    ## $ fr.cashflow.consolidated      <list> [<character(0), character(0), c...
    ## $ history.dividends             <list> [<c("BANCO DO ESTADO DO RIO GRA...
    ## $ history.stockholders          <list> [NULL, NULL]
    ## $ history.capital.issues        <list> [NULL, NULL]
    ## $ history.mkt.value             <list> [NULL, NULL]
    ## $ history.capital.increases     <list> [NULL, NULL]
    ## $ history.capital.reductions    <list> [NULL, NULL]
    ## $ history.stock.repurchases     <list> [NULL, NULL]
    ## $ history.other.stock.events    <list> [NULL, NULL]
    ## $ history.compensation          <list> [NULL, NULL]
    ## $ history.compensation.summary  <list> [NULL, NULL]
    ## $ history.transactions.related  <list> [NULL, NULL]
    ## $ history.debt.composition      <list> [NULL, NULL]
    ## $ history.governance.listings   <list> [NULL, NULL]
    ## $ history.board.composition     <list> [NULL, NULL]
    ## $ history.committee.composition <list> [NULL, NULL]
    ## $ history.family.relations      <list> [NULL, NULL]

Every row of `df.reports` will provide information for one company.
Metadata about the corresponding dataframes such as min/max dates is
available in the first columns. Keeping a tabular structure facilitates
the organization and future processing of all financial data. We can use
tibble `df.reports` for creating other dataframes in the long format
containing data for all companies. See next, where we create dataframes
with the assets and liabilities of all companies:

    df.assets <- do.call(what = rbind, args = df.reports$fr.assets)
    df.liabilities <- do.call(what = rbind, args = df.reports$fr.liabilities)

    df.assets.liabilities <- rbind(df.assets, df.liabilities)

As an example, let's use the resulting dataframe for calculating and
analyzing a simple liquidity index of a company, the total of current
(liquid) assets (*Ativo circulante*) divided by the total of current
short term liabilities (*Passivo Circulante*), over time.

    library(dplyr)

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

    my.tab <- df.assets.liabilities %>%
      group_by(name.company, ref.date) %>%
      summarise(Liq.Index = acc.value[acc.number == '1.01']/ acc.value[acc.number == '2.01'])

    my.tab

    ## # A tibble: 3 x 3
    ## # Groups:   name.company [?]
    ##                              name.company   ref.date Liq.Index
    ##                                     <chr>     <date>     <dbl>
    ## 1 BANCO DO ESTADO DO RIO GRANDE DO SUL SA 2006-12-31 0.7251432
    ## 2  PETRÓLEO BRASILEIRO  S.A.  - PETROBRAS 2005-12-31 0.9370813
    ## 3  PETRÓLEO BRASILEIRO  S.A.  - PETROBRAS 2006-12-31 0.9733600

Now we can visualize the information using `ggplot2`:

    library(ggplot2)

    p <- ggplot(my.tab, aes(x = ref.date, y = Liq.Index, fill = name.company)) +
      geom_col(position = 'dodge' )
    print(p)

![](/img/2017-12-06-_Package-GetDFPData_files/figure-markdown_strict/unnamed-chunk-12-1.png)

Exporting financial data
------------------------

The package includes function `gdfpd.export.DFP.data` for exporting the
financial data to an Excel or zipped csv files. See next:

    my.basename <- 'MyExcelData'
    my.format <- 'csv' # only supported so far
    gdfpd.export.DFP.data(df.reports = df.reports, 
                          base.file.name = my.basename,
                          type.export = my.format)

The resulting Excel file contains all data available in `df.reports`.
