---
layout: post
title: "Serving shiny apps in the internet with your own server"
subtitle: " "
author: "Marcelo S. Perlin"
output: md_document
image: img/shiny.png
tags: [R, shiny, webserver, digital ocean]
---

In this post I'll share my experience in setting up my own virtual
server for hosting shiny applications in [Digital
Ocean](https://www.digitalocean.com/). First, context. I'm working in a
academic project where we build a package for accessing financial data
and corporate events directly from B3, the Brazilian financial exchange.
The objective is to set a reproducible standard and facilite data
acquisition of a large, and very interesting, dataset. The result is
[GetDFPData](https://msperlin.github.io/2017-12-06-_Package-GetDFPData/).
Since many researchers and students in Brazil are not knowledgeable in
R, we needed to make it easier for people to use the software. A shiny
app hosted in the internet is perfect for that. The app is available at
<http://www.msperlin.com/shiny/GetDFPData/>.

You can host your own shiny app for free in
[www.shiny.io](https://www.shinyapps.io/), but that comes with some
[usage limitations](https://www.shinyapps.io/#pricing). While searching
for alternatives, I've found this [great
post](https://deanattali.com/2015/05/09/setup-rstudio-shiny-server-digital-ocean/)
by [Dean Attali](https://deanattali.com/) that clearly explains the
steps for setting up a web server in a virtual machine from Digital
Ocean. Despite being a 2015 post, it works perfectly. The best thing is
that it only costs $5 per month, with the first two months for free.

Once the server is up and running, I can control it using ssh
(terminal), send/retrieve files with github and dropbox, and run code
with Rstudio server, which is basically a Rstudio session in a browser.
Now I have my own corner in the internet, where I can server all my
shiny apps with full control. I'm not only using the server for hosting
web applications, but also running CRON jobs for periodically gather
data for another project, which has to run a R script every day. No
longer I have to worry or remember to turn on my computer every day. I'm
sure I'll find many more uses to it in the future.

I'm very happy in choosing the longer, more difficult path in publishing
a shiny app in the internet. I learned a lot along the way. At first it
felt overwhelming to configure every aspect of the server. But, if you
know a bit of Linux, setting up your own webserver is not that
difficult. I recommend everyone to give it a try.
