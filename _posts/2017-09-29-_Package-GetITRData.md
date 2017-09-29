---
layout: post
title: "New Package GetITRData"
subtitle: "Downloading Quarterly Financial Reports from Bovespa"
author: "Marcelo Perlin"
output: md_document
image: img/bovespa2.jpg
tags: [R, GetITRData, financial reports]
---

Financial statements of companies traded at B3 (formerly Bovespa), the
Brazilian stock exchange, are available in its
[website](http://www.bmfbovespa.com.br/). Accessing the data for a
single company is straightforwardd. In the website one can find a simple
interface for accessing this dataset. An example is given
[here](https://www.rad.cvm.gov.br/ENETCONSULTA/frmGerenciaPaginaFRE.aspx?NumeroSequencialDocumento=67775&CodigoTipoInstituicao=2).
However, gathering and organizing the data for a large scale research,
with many companies and many quarters, is painful. Quarterly reports
must be downloaded or copied individually and later aggregated. Changes
in the accounting format thoughout time can make this process slow,
unreliable and irreproducible.

Package `GetITRData` provides a R interface to all financial statements
available in the website. It not only downloads the data but also
organizes it in a tabular format and allows the use of inflation
indexes. Users can simply select companies and a time period to download
all available data. Several information about current companies, such as
sector and available quarters are also at reach. The main purpose of the
package is to make it easy to access quarterly financial statements in
large scale research, facilitating the reproducibility of corporate
finance studies with Bovespa data.

Installation
============

The package is available in CRAN (release version) and in Github
(development version). You can install any of those with the following
code:

\`\`\`r \# Release version in CRAN install.packages('GetITRData') \# not
in CRAN yet

\# Development version in Github
devtools::install\_github('msperlin/GetITRData') \`\`\`

How to use `GetITRData`
=======================

The starting point of `GetITRData` is to find the official names of
companies in Bovespa. Function `gitrd.search.company` serves this
purpose. Given a string (text), it will search for a partial matches in
companies names. As an example, let's find the *official* name of
Petrobras, one of the largest companies in Brazil:

    library(GetITRData)

    gitrd.search.company('petrobras')

    ## 
    ## Reading info file from github
    ## Found 24012 lines for 603 companies  [Actives =  457  Inactives =  146 ]
    ## Last file update:  2017-09-19
    ## 
    ## Found 1 companies:
    ## PETROBRAS | situation = ATIVO | first date = 1998-09-30 | last date - 2017-06-30

Its official name in Bovespa records is PETROBRAS. Data for quarterly
statements is available from 1998 to 2017. The situation of the company,
active or canceled, is also given. This helps verifying the availability
of data.

The content of all available quarterly statements can be accessed with
function `gitrd.get.info.companies`. It will read and parse a .csv file
from my [github
repository](https://github.com/msperlin/GetITRData_auxiliary). This will
be periodically updated for new quarterly statements. Let's try it out:

    df.info <- gitrd.get.info.companies()

    ## 
    ## Reading info file from github
    ## Found 24012 lines for 603 companies  [Actives =  457  Inactives =  146 ]
    ## Last file update:  2017-09-19

    str(df.info)

    ## Classes 'tbl_df', 'tbl' and 'data.frame':    24012 obs. of  10 variables:
    ##  $ id.company  : int  16330 16330 16330 16330 16330 16330 16330 16330 16330 16330 ...
    ##  $ name.company: chr  "521 PARTICIPAÇÕES S/A" "521 PARTICIPAÇÕES S/A" "521 PARTICIPAÇÕES S/A" "521 PARTICIPAÇÕES S/A" ...
    ##  $ main.sector : chr  NA NA NA NA ...
    ##  $ sub.sector  : chr  NA NA NA NA ...
    ##  $ segment     : chr  NA NA NA NA ...
    ##  $ id.file     : int  47368 42591 40601 37569 32706 30654 27521 22269 20368 17649 ...
    ##  $ dl.link     : chr  "http://www.rad.cvm.gov.br/enetconsulta/frmDownloadDocumento.aspx?CodigoInstituicao=2&NumeroSequencialDocumento=47368" "http://www.rad.cvm.gov.br/enetconsulta/frmDownloadDocumento.aspx?CodigoInstituicao=2&NumeroSequencialDocumento=42591" "http://www.rad.cvm.gov.br/enetconsulta/frmDownloadDocumento.aspx?CodigoInstituicao=2&NumeroSequencialDocumento=40601" "http://www.rad.cvm.gov.br/enetconsulta/frmDownloadDocumento.aspx?CodigoInstituicao=2&NumeroSequencialDocumento=37569" ...
    ##  $ id.date     : Date, format: "2015-03-31" "2014-09-30" ...
    ##  $ id.type     : chr  "after 2011" "after 2011" "after 2011" "after 2011" ...
    ##  $ situation   : chr  "ATIVO" "ATIVO" "ATIVO" "ATIVO" ...

This file includes several information that are gathered from Bovespa:
names of companies, sectors, dates quarterly statements and, most
importantly, the links to download the files. The resulting dataframe
can be used to filter and gather information for large scale research
such as downloading financial data for a specific sector.

Downloading financial information for ONE company
-------------------------------------------------

All you need to download financial data with `GetITRData` are the
official names of companies, which can be found with
`gitrd.search.company`, the desired starting and ending dates and the
type of financial information (individual or consolidated). Let's try it
for PETROBRAS:

    name.companies <- 'PETROBRAS'
    first.date <- '2005-01-01'
    last.date  <- '2006-01-01'
    type.statements <- 'individual'

    df.reports <- gitrd.GetITRData(name.companies = name.companies, 
                                   first.date = first.date,
                                   last.date = last.date,
                                   type.info = type.statements)

    ## 
    ## Reading info file from github
    ## Found 24012 lines for 603 companies  [Actives =  457  Inactives =  146 ]
    ## Last file update:  2017-09-19
    ## 
    ## Downloading data for 1 companies
    ## Type of financial statements: individual
    ## First Date: 2005-01-01
    ## Laste Date: 2006-01-01
    ## Inflation index: none
    ## 
    ## Downloading none data using BETS Done
    ## 
    ## 
    ## WARNING: For quarters before 2009, the cash flow statements are not available
    ## 
    ## Starting processing stage:
    ## PETROBRAS
    ##  Available quarters: 2005-09-30  2005-06-30  2005-03-31
    ## 
    ## 
    ## Processing PETROBRAS, Quarter = 2005-09-30   Downloading | Reading file
    ## Processing PETROBRAS, Quarter = 2005-06-30   Downloading | Reading file
    ## Processing PETROBRAS, Quarter = 2005-03-31   Downloading | Reading file

    ## Warning in max.default(structure(numeric(0), class = "Date"), na.rm =
    ## FALSE): no non-missing arguments to max; returning -Inf

The resulting object is a `tibble`, a data.frame type of object that
allows for list columns. Let's have a look in its content:

    str(df.reports)

    ## Classes 'tbl_df', 'tbl' and 'data.frame':    1 obs. of  10 variables:
    ##  $ company.name: chr "PETROBRAS"
    ##  $ company.code: int 9512
    ##  $ type.info   : chr "individual"
    ##  $ min.date    : Date, format: "2005-03-31"
    ##  $ max.date    : Date, format: "2005-09-30"
    ##  $ n.quarters  : int 3
    ##  $ assets      :List of 1
    ##   ..$ :Classes 'tbl_df', 'tbl' and 'data.frame': 191 obs. of  5 variables:
    ##   .. ..$ acc.number  : chr  "1" "1.01" "1.01.01" "1.01.01.01" ...
    ##   .. ..$ acc.desc    : chr  "Ativo Total" "Ativo Circulante" "Disponibilidades" "Caixa e Bancos" ...
    ##   .. ..$ acc.value   : int  147026464 41052623 15146496 1498194 13648302 9450575 3488650 4955111 1090180 -83366 ...
    ##   .. ..$ ref.date    : Date, format: "2005-09-30" ...
    ##   .. ..$ company.name: chr  "PETROBRAS" "PETROBRAS" "PETROBRAS" "PETROBRAS" ...
    ##  $ liabilities :List of 1
    ##   ..$ :Classes 'tbl_df', 'tbl' and 'data.frame': 160 obs. of  5 variables:
    ##   .. ..$ acc.number  : chr  "2" "2.01" "2.01.01" "2.01.01.01" ...
    ##   .. ..$ acc.desc    : chr  "Passivo Total" "Passivo Circulante" "Empréstimos e Financiamentos" "Financiamentos" ...
    ##   .. ..$ acc.value   : int  147026464 44603494 1154258 1039841 114417 0 5205735 7429086 1156875 935603 ...
    ##   .. ..$ ref.date    : Date, format: "2005-09-30" ...
    ##   .. ..$ company.name: chr  "PETROBRAS" "PETROBRAS" "PETROBRAS" "PETROBRAS" ...
    ##  $ income      :List of 1
    ##   ..$ :Classes 'tbl_df', 'tbl' and 'data.frame': 100 obs. of  5 variables:
    ##   .. ..$ acc.number  : chr  "3.01" "3.02" "3.03" "3.04" ...
    ##   .. ..$ acc.desc    : chr  "Receita Bruta de Vendas e/ou Serviços" "Deduções da Receita Bruta" "Receita Líquida de Vendas e/ou Serviços" "Custo de Bens e/ou Serviços Vendidos" ...
    ##   .. ..$ acc.value   : int  37870949 -9778549 28092400 -15030559 13061841 -4270217 -1221668 -895230 -899 -894331 ...
    ##   .. ..$ ref.date    : Date, format: "2005-09-30" ...
    ##   .. ..$ company.name: chr  "PETROBRAS" "PETROBRAS" "PETROBRAS" "PETROBRAS" ...
    ##  $ df.cashflow :List of 1
    ##   ..$ :'data.frame': 0 obs. of  5 variables:
    ##   .. ..$ acc.desc    : Named list()
    ##   .. ..$ acc.value   : logi 
    ##   .. ..$ acc.number  : chr 
    ##   .. ..$ company.name: chr 
    ##   .. ..$ ref.date    :Class 'Date'  num(0) 
    ##   .. ..- attr(*, "na.action")=Class 'omit'  Named int [1:3] 1 2 3
    ##   .. .. .. ..- attr(*, "names")= chr [1:3] "1" "2" "3"

Object `df.reports` only has one row since we only asked for data of one
company. The number of rows increases with the number of companies, as
we will soon learn with the next example. All financial statements for
the different quarters are available within `df.reports`. For example,
the income statements for all desired quarters of PETROBRAS are:

    df.income.long <- df.reports$income[[1]]

    str(df.income.long)

    ## Classes 'tbl_df', 'tbl' and 'data.frame':    100 obs. of  5 variables:
    ##  $ acc.number  : chr  "3.01" "3.02" "3.03" "3.04" ...
    ##  $ acc.desc    : chr  "Receita Bruta de Vendas e/ou Serviços" "Deduções da Receita Bruta" "Receita Líquida de Vendas e/ou Serviços" "Custo de Bens e/ou Serviços Vendidos" ...
    ##  $ acc.value   : int  37870949 -9778549 28092400 -15030559 13061841 -4270217 -1221668 -895230 -899 -894331 ...
    ##  $ ref.date    : Date, format: "2005-09-30" "2005-09-30" ...
    ##  $ company.name: chr  "PETROBRAS" "PETROBRAS" "PETROBRAS" "PETROBRAS" ...

The resulting dataframe is in the long format, ready for processing. In
the long format, financial statements of different quarters are stacked.
In the wide format, we have the quarters as dates. If you want the wide
format, which I believe is most common in financial analysis, you can
use function `gitrd.convert.to.wide`. See an example next:

    df.income.wide <- gitrd.convert.to.wide(df.income.long)

    knitr::kable(df.income.wide )

<table>
<thead>
<tr class="header">
<th align="left">acc.number</th>
<th align="left">acc.desc</th>
<th align="left">company.name</th>
<th align="right">2005-03-31</th>
<th align="right">2005-06-30</th>
<th align="right">2005-09-30</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left">3.01</td>
<td align="left">Receita Bruta de Vendas e/ou Serviços</td>
<td align="left">PETROBRAS</td>
<td align="right">31355183</td>
<td align="right">35425584</td>
<td align="right">37870949</td>
</tr>
<tr class="even">
<td align="left">3.02</td>
<td align="left">Deduções da Receita Bruta</td>
<td align="left">PETROBRAS</td>
<td align="right">-8788723</td>
<td align="right">-9321322</td>
<td align="right">-9778549</td>
</tr>
<tr class="odd">
<td align="left">3.03</td>
<td align="left">Receita Líquida de Vendas e/ou Serviços</td>
<td align="left">PETROBRAS</td>
<td align="right">22566460</td>
<td align="right">26104262</td>
<td align="right">28092400</td>
</tr>
<tr class="even">
<td align="left">3.04</td>
<td align="left">Custo de Bens e/ou Serviços Vendidos</td>
<td align="left">PETROBRAS</td>
<td align="right">-12052044</td>
<td align="right">-14530594</td>
<td align="right">-15030559</td>
</tr>
<tr class="odd">
<td align="left">3.05</td>
<td align="left">Resultado Bruto</td>
<td align="left">PETROBRAS</td>
<td align="right">10514416</td>
<td align="right">11573668</td>
<td align="right">13061841</td>
</tr>
<tr class="even">
<td align="left">3.06</td>
<td align="left">Despesas/Receitas Operacionais</td>
<td align="left">PETROBRAS</td>
<td align="right">-2869703</td>
<td align="right">-5249799</td>
<td align="right">-4270217</td>
</tr>
<tr class="odd">
<td align="left">3.06.01</td>
<td align="left">Com Vendas</td>
<td align="left">PETROBRAS</td>
<td align="right">-858170</td>
<td align="right">-820899</td>
<td align="right">-1221668</td>
</tr>
<tr class="even">
<td align="left">3.06.02</td>
<td align="left">Gerais e Administrativas</td>
<td align="left">PETROBRAS</td>
<td align="right">-768830</td>
<td align="right">-880185</td>
<td align="right">-895230</td>
</tr>
<tr class="odd">
<td align="left">3.06.02.01</td>
<td align="left">Honor.Diretoria e Cons. Administração</td>
<td align="left">PETROBRAS</td>
<td align="right">-984</td>
<td align="right">-886</td>
<td align="right">-899</td>
</tr>
<tr class="even">
<td align="left">3.06.02.02</td>
<td align="left">De Administração</td>
<td align="left">PETROBRAS</td>
<td align="right">-767846</td>
<td align="right">-879299</td>
<td align="right">-894331</td>
</tr>
<tr class="odd">
<td align="left">3.06.03</td>
<td align="left">Financeiras</td>
<td align="left">PETROBRAS</td>
<td align="right">-53787</td>
<td align="right">-480281</td>
<td align="right">-282706</td>
</tr>
<tr class="even">
<td align="left">3.06.03.01</td>
<td align="left">Receitas Financeiras</td>
<td align="left">PETROBRAS</td>
<td align="right">525452</td>
<td align="right">106753</td>
<td align="right">272290</td>
</tr>
<tr class="odd">
<td align="left">3.06.03.02</td>
<td align="left">Despesas Financeiras</td>
<td align="left">PETROBRAS</td>
<td align="right">-579239</td>
<td align="right">-587034</td>
<td align="right">-554996</td>
</tr>
<tr class="even">
<td align="left">3.06.04</td>
<td align="left">Outras Receitas Operacionais</td>
<td align="left">PETROBRAS</td>
<td align="right">0</td>
<td align="right">0</td>
<td align="right">0</td>
</tr>
<tr class="odd">
<td align="left">3.06.05</td>
<td align="left">Outras Despesas Operacionais</td>
<td align="left">PETROBRAS</td>
<td align="right">-2104923</td>
<td align="right">-3155693</td>
<td align="right">-1956858</td>
</tr>
<tr class="even">
<td align="left">3.06.05.01</td>
<td align="left">Custos Explot.p/Extração Petróleo/Gás</td>
<td align="left">PETROBRAS</td>
<td align="right">-107010</td>
<td align="right">-101527</td>
<td align="right">-334116</td>
</tr>
<tr class="odd">
<td align="left">3.06.05.02</td>
<td align="left">Custo c/ Pesq. Desenv. Tecnológico</td>
<td align="left">PETROBRAS</td>
<td align="right">-192741</td>
<td align="right">-221813</td>
<td align="right">-247456</td>
</tr>
<tr class="even">
<td align="left">3.06.05.03</td>
<td align="left">Tributárias</td>
<td align="left">PETROBRAS</td>
<td align="right">-185581</td>
<td align="right">-290086</td>
<td align="right">-114519</td>
</tr>
<tr class="odd">
<td align="left">3.06.05.04</td>
<td align="left">Variações Monetárias e Cambiais Líquidas</td>
<td align="left">PETROBRAS</td>
<td align="right">-117821</td>
<td align="right">-921626</td>
<td align="right">-401757</td>
</tr>
<tr class="even">
<td align="left">3.06.05.05</td>
<td align="left">Outras Despesas/Receitas Oper. Liquidas</td>
<td align="left">PETROBRAS</td>
<td align="right">-1501770</td>
<td align="right">-1620641</td>
<td align="right">-859010</td>
</tr>
<tr class="odd">
<td align="left">3.06.06</td>
<td align="left">Resultado da Equivalência Patrimonial</td>
<td align="left">PETROBRAS</td>
<td align="right">916007</td>
<td align="right">87259</td>
<td align="right">86245</td>
</tr>
<tr class="even">
<td align="left">3.07</td>
<td align="left">Resultado Operacional</td>
<td align="left">PETROBRAS</td>
<td align="right">7644713</td>
<td align="right">6323869</td>
<td align="right">8791624</td>
</tr>
<tr class="odd">
<td align="left">3.08</td>
<td align="left">Resultado Não Operacional</td>
<td align="left">PETROBRAS</td>
<td align="right">-151498</td>
<td align="right">-64670</td>
<td align="right">1064</td>
</tr>
<tr class="even">
<td align="left">3.08.01</td>
<td align="left">Receitas</td>
<td align="left">PETROBRAS</td>
<td align="right">1256</td>
<td align="right">8805</td>
<td align="right">450552</td>
</tr>
<tr class="odd">
<td align="left">3.08.02</td>
<td align="left">Despesas</td>
<td align="left">PETROBRAS</td>
<td align="right">-152754</td>
<td align="right">-73475</td>
<td align="right">-449488</td>
</tr>
<tr class="even">
<td align="left">3.09</td>
<td align="left">Resultado Antes Tributação/Participações</td>
<td align="left">PETROBRAS</td>
<td align="right">7493215</td>
<td align="right">6259199</td>
<td align="right">8792688</td>
</tr>
<tr class="odd">
<td align="left">3.10</td>
<td align="left">Provisão para IR e Contribuição Social</td>
<td align="left">PETROBRAS</td>
<td align="right">-1847762</td>
<td align="right">-1151342</td>
<td align="right">-3002751</td>
</tr>
<tr class="even">
<td align="left">3.11</td>
<td align="left">IR Diferido</td>
<td align="left">PETROBRAS</td>
<td align="right">-538132</td>
<td align="right">-408725</td>
<td align="right">-111709</td>
</tr>
<tr class="odd">
<td align="left">3.12</td>
<td align="left">Participações/Contribuições Estatutárias</td>
<td align="left">PETROBRAS</td>
<td align="right">0</td>
<td align="right">0</td>
<td align="right">0</td>
</tr>
<tr class="even">
<td align="left">3.12.01</td>
<td align="left">Participações</td>
<td align="left">PETROBRAS</td>
<td align="right">0</td>
<td align="right">0</td>
<td align="right">0</td>
</tr>
<tr class="odd">
<td align="left">3.12.01.01</td>
<td align="left">Partic. de Empregados e administradores</td>
<td align="left">PETROBRAS</td>
<td align="right">0</td>
<td align="right">NA</td>
<td align="right">NA</td>
</tr>
<tr class="even">
<td align="left">3.12.02</td>
<td align="left">Contribuições</td>
<td align="left">PETROBRAS</td>
<td align="right">0</td>
<td align="right">0</td>
<td align="right">0</td>
</tr>
<tr class="odd">
<td align="left">3.13</td>
<td align="left">Reversão dos Juros sobre Capital Próprio</td>
<td align="left">PETROBRAS</td>
<td align="right">0</td>
<td align="right">0</td>
<td align="right">0</td>
</tr>
<tr class="even">
<td align="left">3.15</td>
<td align="left">Lucro/Prejuízo do Período</td>
<td align="left">PETROBRAS</td>
<td align="right">5107321</td>
<td align="right">4699132</td>
<td align="right">5678228</td>
</tr>
</tbody>
</table>

Downloading financial information for SEVERAL companies
-------------------------------------------------------

If you are doing serious research, it is likely that you need financial
statements for more than one company. Package `GetITRData` is specially
designed for handling large scale download of data. Let's build a case
with 5 randomly selected companies:

    set.seed(5)
    my.companies <- sample(unique(df.info$name.company), 5)

    first.date <- '2005-01-01'
    last.date  <- '2006-01-01'
    type.statements <- 'individual'

    df.reports <- gitrd.GetITRData(name.companies = my.companies, 
                                      first.date = first.date,
                                      last.date = last.date,
                                      type.info = type.statements)

    ## 
    ## Reading info file from github
    ## Found 24012 lines for 603 companies  [Actives =  457  Inactives =  146 ]
    ## Last file update:  2017-09-19
    ## 
    ## Downloading data for 5 companies
    ## Type of financial statements: individual individual  individual  individual  individual
    ## First Date: 2005-01-01
    ## Laste Date: 2006-01-01
    ## Inflation index: none
    ## 
    ## Downloading none data using BETS Done
    ## 
    ## 
    ## WARNING: Cant find available dates for BV LEASING
    ## WARNING: For quarters before 2009, the cash flow statements are not available
    ## 
    ## Starting processing stage:
    ## BANESTES S/A
    ##  Available quarters: 2005-09-30  2005-06-30  2005-03-31
    ## CIA. IGUAÇU DE CAFÉ SOLÚVEL
    ##  Available quarters: 2005-09-30  2005-06-30  2005-03-31
    ## MUNDIAL
    ##  Available quarters: 2005-09-30  2005-06-30  2005-03-31
    ## TELEMAR PARTICIPAÇÔES S.A
    ##  Available quarters: 2005-09-30  2005-06-30  2005-03-31
    ## 
    ## 
    ## Processing BANESTES S/A, Quarter = 2005-09-30    Downloading | Reading file
    ## Processing BANESTES S/A, Quarter = 2005-06-30    Downloading | Reading file
    ## Processing BANESTES S/A, Quarter = 2005-03-31    Downloading | Reading file

    ## Warning in max.default(structure(numeric(0), class = "Date"), na.rm =
    ## FALSE): no non-missing arguments to max; returning -Inf

    ## 
    ## Processing CIA. IGUAÇU DE CAFÉ SOLÚVEL, Quarter = 2005-09-30 Downloading | Reading file
    ## Processing CIA. IGUAÇU DE CAFÉ SOLÚVEL, Quarter = 2005-06-30 Downloading | Reading file
    ## Processing CIA. IGUAÇU DE CAFÉ SOLÚVEL, Quarter = 2005-03-31 Downloading | Reading file

    ## Warning in max.default(structure(numeric(0), class = "Date"), na.rm =
    ## FALSE): no non-missing arguments to max; returning -Inf

    ## 
    ## Processing MUNDIAL, Quarter = 2005-09-30 Downloading | Reading file
    ## Processing MUNDIAL, Quarter = 2005-06-30 Downloading | Reading file
    ## Processing MUNDIAL, Quarter = 2005-03-31 Downloading | Reading file

    ## Warning in max.default(structure(numeric(0), class = "Date"), na.rm =
    ## FALSE): no non-missing arguments to max; returning -Inf

    ## 
    ## Processing TELEMAR PARTICIPAÇÔES S.A, Quarter = 2005-09-30   Downloading | Reading file
    ## Processing TELEMAR PARTICIPAÇÔES S.A, Quarter = 2005-06-30   Downloading | Reading file
    ## Processing TELEMAR PARTICIPAÇÔES S.A, Quarter = 2005-03-31   Downloading | Reading file

    ## Warning in max.default(structure(numeric(0), class = "Date"), na.rm =
    ## FALSE): no non-missing arguments to max; returning -Inf

And now we can check the resulting `tibble`:

    head(df.reports )

    ## # A tibble: 4 x 10
    ##                  company.name company.code  type.info   min.date
    ##                         <chr>        <int>      <chr>     <date>
    ## 1                BANESTES S/A         1155 individual 2005-03-31
    ## 2 CIA. IGUAÇU DE CAFÉ SOLÚVEL         3336 individual 2005-03-31
    ## 3                     MUNDIAL         5312 individual 2005-03-31
    ## 4   TELEMAR PARTICIPAÇÔES S.A        18678 individual 2005-03-31
    ## # ... with 6 more variables: max.date <date>, n.quarters <int>,
    ## #   assets <list>, liabilities <list>, income <list>, df.cashflow <list>

Every row of `df.reports` will provide information for one company.
Metadata about the corresponding dataframes such as min/max dates is
available in the first columns. Keeping a tabular structure facilitates
the organization and future processing of all financial data. We can use
tibble `df.reports` for creating other dataframes in the long format
containing data for all companies. See next, where we create dataframes
with the assets and liabilities of all companies:

    df.assets <- do.call(what = rbind, args = df.reports$assets)
    df.liabilities <- do.call(what = rbind, args = df.reports$liabilities)

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
      group_by(company.name, ref.date) %>%
      summarise(Liq.Index = acc.value[acc.number == '1.01']/ acc.value[acc.number == '2.01'])

    my.tab

    ## # A tibble: 12 x 3
    ## # Groups:   company.name [?]
    ##                   company.name   ref.date Liq.Index
    ##                          <chr>     <date>     <dbl>
    ##  1                BANESTES S/A 2005-03-31 0.7985816
    ##  2                BANESTES S/A 2005-06-30 0.8393188
    ##  3                BANESTES S/A 2005-09-30 0.9151590
    ##  4 CIA. IGUAÇU DE CAFÉ SOLÚVEL 2005-03-31 2.3459918
    ##  5 CIA. IGUAÇU DE CAFÉ SOLÚVEL 2005-06-30 2.7291873
    ##  6 CIA. IGUAÇU DE CAFÉ SOLÚVEL 2005-09-30 2.1644541
    ##  7                     MUNDIAL 2005-03-31 0.7903105
    ##  8                     MUNDIAL 2005-06-30 0.8555824
    ##  9                     MUNDIAL 2005-09-30 0.9052814
    ## 10   TELEMAR PARTICIPAÇÔES S.A 2005-03-31 1.5650393
    ## 11   TELEMAR PARTICIPAÇÔES S.A 2005-06-30 0.9419386
    ## 12   TELEMAR PARTICIPAÇÔES S.A 2005-09-30 1.3275712

Now we can visualize the information using `ggplot2`:

    library(ggplot2)

    p <- ggplot(my.tab, aes(x = ref.date, y = Liq.Index, fill = company.name)) +
      geom_col(position = 'dodge' )
    print(p)

![](/img/2017-09-29-_Package-GetITRData_files/figure-markdown_strict/unnamed-chunk-12-1.png)

As we can see, CIA IGUACU is the company with highest liquidity, being
able to pay its short term debt with the current assets in all quarters.
We can certainly do a lot more interesting studies based on this
dataset.

Exporting financial data
------------------------

The package includes function `gitrd.export.ITR.data` for exporting the
financial data to an Excel file. Users can choose between the long and
wide format. See next:

    my.basename <- 'MyExcelData'
    my.format <- 'xlsx' # only supported so far
    gitrd.export.ITR.data(data.in = df.reports, 
                          base.file.name = my.basename,
                          type.export = my.format,
                          format.data = 'long')

The resulting Excel file contains all data available in `df.reports`.
