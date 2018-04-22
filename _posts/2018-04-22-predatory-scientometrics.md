---
layout: post
title: "Predatory Journals and R"
subtitle: ""
author: "Marcelo S. Perlin"
image: img/predatory-publisher.png
tags: [R, Bealls list, predatory journals]
---

My paper about the penetration of predatory journals in Brazil, **Is predatory publishing a real threat? Evidence from a large database study**, just got [published in Scientometrics!](https://link.springer.com/article/10.1007/s11192-018-2750-6?wt_mc=Internal.Event.1.SEM.ArticleAuthorOnlineFirst). The working paper version is available in [SSRN](https://papers.ssrn.com/sol3/papers.cfm?abstract_id=3067958).

This is a nice example of a data-intensive scientific work cycle, from gathering data to reporting results. Everything was done in R, using web scrapping algorithms, parallel processing, tidyverse packages and more. This was a special project for me, given its implications in science making in Brazil. It took me nearly one year to produce and execute the whole code. It is also a nice case of the capabilities of package ggplot2 in producing publication-ready figures. As a side output, our database of predatory journals is available as a [shiny app](http://www.msperlin.com/shiny/predatory/).

More details about the study itself is available in the paper. Our abstract is as follows: 

>  Using a database of potential, possible, or probable predatory scholarly open-access journals, the objective of this research is to study the penetration of predatory publications in the Brazilian academic system and the profile of authors in a cross-section empirical study. Based on a massive amount of publications from Brazilian researchers of all disciplines during the 2000–2015 period, we were able to analyze the extent of predatory publications using an econometric modeling. Descriptive statistics indicate that predatory publications represent a small overall proportion, but grew exponentially in the last 5 years. Departing from prior studies, our analysis shows that experienced researchers with a high number of non-indexed publications and PhD obtained locally are more likely to publish in predatory journals. Further analysis shows that once a journal regarded as predatory is listed in the local ranking system, the Qualis, it starts to receive more publications than non-predatory ones.

