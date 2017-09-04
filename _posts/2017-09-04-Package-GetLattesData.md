---
layout: post
title: "Package `GetLattesData`"
subtitle: "Downloading and reading bibliometric data from Lattes"
author: "Marcelo Perlin"
output: md_document
image: /img/lattes.png
tags: [R, GetLattesData, Lattes, bibliometric studies]
---

[Lattes](http://lattes.cnpq.br/) is the largest and unique platform for
academic curriculumns. There you can find information about the academic
work of **ALL** Brazilian scholars. It includes institution of PhD,
current employer, field of work, all publications metadata and many
more. It is an unique and reliable source of information for
bibliometric studies.

I've been working with Lattes data for some time. Here I present a short
list of papers that have used this data.

-   [The Brazilian scientific output published in journals: A study
    based on a large CV
    database](http://www.sciencedirect.com/science/article/pii/S1751157716301559)

-   [The researchers, the publications and the journals of Finance in
    Brazil: An analysis based on resumes from the Lattes
    platform](http://bibliotecadigital.fgv.br/ojs/index.php/rbfin/article/view/47157)

-   [Análise do Perfil dos Acadêmicos e de suas Publicações Científicas
    em Administração (in
    Portuguese)](http://www.scielo.br/scielo.php?script=sci_arttext&pid=S1415-65552017000100062)

-   Predatory publications in the Brazilian academic system: an
    empirical analysis (Working paper)

Package `GetLattesData` is a wrap up of the functions that I've been
using for acessing the dataset. It's main innovation is the possibility
of downloading data directly from Lattes, without any kind of manual
work.

Installation
============

The package is not yet in CRAN. It should be there in a couple of days.
In the meanwhile, you can install it using devtools.

    #install.packages('devtools')
    devtools::install_github('msperlin/GetLattesData')

Example of usage
================

Let's consider a simple example of downloading information for a group
of scholars. I selected a couple of coleagues at my university. Their
Lattes id can be easilly found in [Lattes
website](http://lattes.cnpq.br/). After searching for a name, notice the
internet address of the resulting CV, such as
<http://buscatextual.cnpq.br/buscatextual/visualizacv.do?id=K4713546D3>.
Lattes ID is the final 10 digit code of this address. In our case, it is
`'K4713546D3'`.

Since we all work in the business department of UFRGS, the quality of
our publications is locally set by the Qualis ranking of field
`'ADMINISTRAÇÃO PÚBLICA E DE EMPRESAS, CIÊNCIAS CONTÁBEIS E TURISMO'`.
Qualis is the local journal ranking in Brazil. You can read more about
Qualis in [Wikipedia](https://en.wikipedia.org/wiki/Qualis_(CAPES)) and
[here](http://www.sciencedirect.com/science/article/pii/S1751157716301559)

Now, based on the two sets of information, vector of ids and field of
Qualis, we can use `GetLattesData` to download all up to date
information about the researchers:

    library(GetLattesData)

    # ids from EA-UFRGS
    my.ids <- c('K4713546D3', 'K4440252H7', 
                'K4783858A0', 'K4723925J2')

    # qualis for the field of management
    field.qualis = 'ADMINISTRAÇÃO PÚBLICA E DE EMPRESAS, CIÊNCIAS CONTÁBEIS E TURISMO'

    l.out <- gld_get_lattes_data(id.vec = my.ids, field.qualis = field.qualis)

    ## 
    ## Downloading file  /tmp/Rtmp9ODS2F/K4713546D3_2017-09-04.zip
    ## Downloading file  /tmp/Rtmp9ODS2F/K4440252H7_2017-09-04.zip
    ## Downloading file  /tmp/Rtmp9ODS2F/K4783858A0_2017-09-04.zip
    ## Downloading file  /tmp/Rtmp9ODS2F/K4723925J2_2017-09-04.zip
    ## Reading  K4713546D3_2017-09-04.zip -  Marcelo Scherer Perlin  found 18  papers
    ## Reading  K4440252H7_2017-09-04.zip -  Marcelo Brutti Righi    found 42  papers
    ## Reading  K4783858A0_2017-09-04.zip -  João Luiz Becker    found 58  papers
    ## Reading  K4723925J2_2017-09-04.zip -  Denis Borenstein    found 64  papers

The output `my.l` is a list with two items:

    names(l.out)

    ## [1] "tpesq"   "tpublic"

The first is a dataframe with information about researchers:

    tpesq <- l.out$tpesq
    str(tpesq)

    ## 'data.frame':    4 obs. of  9 variables:
    ##  $ name           : chr  "Marcelo Scherer Perlin" "Marcelo Brutti Righi" "João Luiz Becker" "Denis Borenstein"
    ##  $ last.update    : Date, format: "2017-08-29" "2017-08-02" ...
    ##  $ phd.institution: chr  "University of Reading" "Universidade Federal de Santa Maria" "University Of California At Los Angeles" "University of Strathclyde"
    ##  $ phd.start.year : chr  "2007" "2013" "1982" "1991"
    ##  $ phd.end.year   : chr  "2010" "2015" "1986" "1995"
    ##  $ country.origin : Factor w/ 1 level "Brasil": 1 1 1 1
    ##  $ Major Field    : chr  "CIENCIAS_SOCIAIS_APLICADAS" "CIENCIAS_SOCIAIS_APLICADAS" "CIENCIAS_SOCIAIS_APLICADAS" "ENGENHARIAS"
    ##  $ Minor Field    : chr  "Administração" "Administração" "Administração" "Engenharia de Produção"
    ##  $ id.file        : chr  "K4713546D3_2017-09-04.zip" "K4440252H7_2017-09-04.zip" "K4783858A0_2017-09-04.zip" "K4723925J2_2017-09-04.zip"

and the second dataframe containing information about all publications,
including Qualis and SJR:

    tpublic <- l.out$tpublic
    str(tpublic)

    ## 'data.frame':    182 obs. of  13 variables:
    ##  $ name         : chr  "Marcelo Scherer Perlin" "Marcelo Scherer Perlin" "Marcelo Scherer Perlin" "Marcelo Scherer Perlin" ...
    ##  $ article.title: chr  "Análise do Perfil dos Acadêmicos e de suas Publicações Científicas em Administração" "The Brazilian scientific output published in journals: A study based on a large CV database" "THE FORECASTING POWER OF INTERNET SEARCH QUERIES IN THE BRAZILIAN FINANCIAL MARKET" "A multistage stochastic programming asset-liability management model: an application to the Brazilian pension fund industry" ...
    ##  $ year         : chr  "2017" "2017" "2017" "2017" ...
    ##  $ language     : chr  "Português" "Inglês" "Inglês" "Inglês" ...
    ##  $ journal.title: chr  "RAC. Revista de Administração Contemporânea (Impresso)" "Journal of Informetrics" "RAM. REVISTA DE ADMINISTRAÇÃO MACKENZIE (ONLINE)" "OPTIMIZATION AND ENGINEERING" ...
    ##  $ ISSN         : chr  "1415-6555" "1751-1577" "1678-6971" "1389-4420" ...
    ##  $ start.page   : chr  "62" "18" "184" "349" ...
    ##  $ end.page     : chr  "83" "31" "210" "368" ...
    ##  $ order.aut    : chr  "2" "1" "3" "3" ...
    ##  $ n.authors    : chr  "3" "5" "3" "5" ...
    ##  $ qualis       : chr  "A2" NA "B1" "A2" ...
    ##  $ SJR          : num  NA 2.029 NA 0.481 NA ...
    ##  $ H.SJR        : int  NA 50 NA 29 NA NA 45 NA NA NA ...

An application of `GetLattesData`
---------------------------------

Based on `GetLattesData` and other packages, it is easy to create
academic reports for a large number of researchers. See next, where we
plot the number of publications for each researcher, conditioning on
Qualis ranking.

    library(ggplot2)

    p <- ggplot(tpublic, aes(x = qualis)) +
      geom_bar(position = 'identity') + facet_wrap(~name) +
      labs(x = paste0('Qualis: ', field.qualis))
    print(p)

![](/img/2017-09-04-Package-GetLattesData_files/figure-markdown_strict/unnamed-chunk-5-1.png)

We can also use `dplyr` to do some simple assessment of academic
productivity:

    library(dplyr)

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

    my.tab <- tpublic %>%
      group_by(name) %>%
      summarise(n.papers = n(),
                max.SJR = max(SJR, na.rm = T),
                mean.SJR = mean(SJR, na.rm = T),
                n.A1.qualis = sum(qualis == 'A1', na.rm = T),
                n.A2.qualis = sum(qualis == 'A2', na.rm = T),
                median.authorship = median(as.numeric(order.aut), na.rm = T ))

    knitr::kable(my.tab)

<table>
<thead>
<tr class="header">
<th align="left">name</th>
<th align="right">n.papers</th>
<th align="right">max.SJR</th>
<th align="right">mean.SJR</th>
<th align="right">n.A1.qualis</th>
<th align="right">n.A2.qualis</th>
<th align="right">median.authorship</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left">Denis Borenstein</td>
<td align="right">64</td>
<td align="right">3.674</td>
<td align="right">1.3165610</td>
<td align="right">22</td>
<td align="right">15</td>
<td align="right">2</td>
</tr>
<tr class="even">
<td align="left">João Luiz Becker</td>
<td align="right">58</td>
<td align="right">3.885</td>
<td align="right">0.8090000</td>
<td align="right">5</td>
<td align="right">13</td>
<td align="right">2</td>
</tr>
<tr class="odd">
<td align="left">Marcelo Brutti Righi</td>
<td align="right">42</td>
<td align="right">1.767</td>
<td align="right">0.3961111</td>
<td align="right">6</td>
<td align="right">14</td>
<td align="right">1</td>
</tr>
<tr class="even">
<td align="left">Marcelo Scherer Perlin</td>
<td align="right">18</td>
<td align="right">2.029</td>
<td align="right">0.7755000</td>
<td align="right">2</td>
<td align="right">3</td>
<td align="right">1</td>
</tr>
</tbody>
</table>
