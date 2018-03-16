---
layout: post
title: "Writing papers about packages"
subtitle: "Some advices from a referee"
author: "Marcelo S. Perlin"
image: img/packages.jpg
tags: [R, research]
---

Back in 2007 I wrote a [Matlab package](https://github.com/msperlin/MS_Regress-Matlab) for estimating regime switching models. I was just starting to learn to code and this project was my way of doing it. After publishing it in FEX (Matlab file exchange site) I got so many repeated questions on my email that eventually realized it would be easier to write a manual for people to read. Some time and effort would be spend writing it, but less time replying to repeated questions on my email.

This [manual](https://papers.ssrn.com/sol3/papers.cfm?abstract_id=1714016) about the code became, by far, my most cited paper in [Google Scholar](https://scholar.google.com.br/citations?user=n3LTk-UAAAAJ&hl=en). It is not even published, just a permanent working paper. When attending conferences and seminars, I was always surprised to hear that people knew me as the _matlab regime switching_ guy.

Moving forward a few years, I stopped using Matlab for R and I continue to invest a lot of time writing papers about packages and publishing them in standard scientific journals. You can see a list of those [here](https://msperlin.github.io/content/loc_publications/).

I can testify for a greater contribution and impact for research papers about code. I strongly believe that it will become more popular in the years to come. The new generation of researchers is far more aware of code than the previous. In that sense, nothing beats R and CRAN at the diversity and depth of packages.

In this subject, I frequently review papers in the same topic and I see common mistakes that researchers do when writing their papers. Here's some tips for those that wish to pursue such a publication:

- *A problem must be clearly stated*: Every paper is a solution to a problem. This is also true for a paper about code. Identify it and make it painfully clear how the code solves it. In other words, do your homework.

- *The paper is NOT an extended manual*: Don't write a paper simply showing its functions. We have that from CRAN (or other repository).

- *Make sure you know what's available*: How people did it before? Is there a competing package? How does your code improves it?

- *A bibliometric study is mandatory*.: Same as the previous point. Looking at the previous published research papers, can you find out how they handled the problem your code solves?

- *Not everyone uses R, so make it easier for people  to use you software*: Make sure you keep a simple and accessible code. Explain what is R and why you should use it. Case in point, not everyone know what a _tibble_ is.

- *Think about your example of usage*: You should always add a reproducible example of usage. This is what everyone will try! Make sure it is a simple example, not too deep in the literature. Something everyone can understand. Your code should also be accessible and reproducible.

It is a lot of work to publish a research paper about code. But, it is all worth it! The impact is much greater than a standard research paper. Your academic career will certainly move forward with it.
