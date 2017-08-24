---
layout: post
title: "My experience in switching from Windows 10 to Linux Mint 18.2"
subtitle: " "
author: "Marcelo Perlin"
output: html_document
image: /img/linuxmint-logo.png
tags: [R, Linux mint, windows 10]
---

It has been 8 months since I switched from Windows 10 to Linux Mint. In this post I'll talk about my experience as a scholar and R user in this transition.

My work is, simply put, to communicate ideas. A typical day of work is a mixture of writing research papers, creating classroom material such as slides and exercises, and analyzing data. Most of my work happens in front of a computer.

Without a doubt, my greatest asset are my computer files. I reuse them over and over. Every new research script I write is a new version of something I've done in the past. The same for class slides and exercises. At each iteration, I add new material and update information. Said that, one problem in using Windows software is the proprietary format of Office packages. Once my Office license expired late 2016, I quick realized that I was not able to work on my files the same way I did before. While there are alternatives to Office products and online platforms, they don't work out of the box in all cases. As an example, if you have a ppt presentation with many figures, it is likely that you'll have to resize them individually when opening it in Libreoffice. So, by using Office, my work was trapped in that format.

Another problem with Windows is the amount of resources it needs to run. I have an old laptop that is just unworkable in Windows 10 due to its low specs. My desktop computer at work was also becaming slower. By switching to a less resource demanding operational system, I am able to work with low end computers and use them for a few more years. Maintaining windows systems is also a hassle. Every other year I needed to format, reinstall all software, download all dropbox files. If you have three or more computer to maintain, it become a burden to carry.

On the other side, I have been extremely impressed by what open source communities can build. After embracing R from a background in Matlab, [writing a book about R](https://sites.google.com/view/pafdR/home), I'm constantly overwhelmed by the high quality work that open source communities do. If you do not know, Linux Mint and others are all free operations systems, developed by a large group of people that don't necessarily make a living out of it. 

After some research, I decided to go with [Linux Mint](https://www.linuxmint.com/) due to its large ammount of users and my previous positive experience. Another distribution worth looking is [Debian](https://www.debian.org/), but I haven't tried it. You can find a lot of information about possible Linux distributions in [Distro Watch](https://distrowatch.com/).


## The positive side

- **My R code is the same**. The only change I had to make in the code is pathwise. While in Windows you use `C:/Documents`, in Linux is `/home/msperlin/Documents`. 

- **External R packages dependencies are easy to install**. Some R package that depend on external software can be installed using bash command `apt`. For example, package readxl can be installed with terminal command `sudo apt install r-cran-readxl`. Any external dependency to readxl that is missing in the computer will also be installed. This is very handy when you have R packages with heavy dependencies.

- **Linux Mint is blazing fast** ! My boot up is very quick and I'm able to start working fast.

- **It looks beautiful**. I know this is personal opinion, but I fell the Cinnamon desktop is much nicer to the eyes than Windows 10.

- **The system is very stable**. I never had any system problem such as the blue screen of Windows. I'm used to leave my computer running code 5 to 10 hours straight without any problem.

- **Everything can be done from the terminal, if you want to**. One of the good things about Linux Mint is that everything can be changed from the terminal as the whole configuration of the system are stored in editable text files. As an example, I wrote a simple bash script that installs all software that I need for work and configures the desktop to a dark theme. You can write a bash script to configure the computer anyway you want. If you buy a new computer, just run the bash script and it will be exactly how you wanted. In previous post I write about a simple bash script that [installs R and Rstudio](https://msperlin.github.io/2017-06-01-Instaling-R-in-Linux/).  

- **Software is always up to date**. It is simple to keep all software running the latest version using apt tools and the terminal. All you need to do is to call `sudo apt update` and `sudo apt upgrade` in the terminal. If you have many computers, it is very easy to keep then running the same version of software.  The closest you can find for Windows is [Chocolatey](https://chocolatey.org/), which, unfortunately, did not work well for me.

 
## The negative side

- **Collaborating with Office users**. Using LibreOffice I can, most of the time, open and edit work/excel files. But, if you have a more complicated file, there are going to be problems. My solution to this is to always be _charmingly_ annoying and convince others to use Latex or LibreOffice. If they don't want to, well, we will not collaborate. I'm aware of the luck I have in this option. Most people don't get to chose who they work with.

- **Relearn all software**. I used Windows for so many years that I knew by heart how to use its software. I had to relearn many things. I've found a good website, [AlternativeTo](http://alternativeto.net/) that can help a lot. So far, I can't name a Windows software that is not replaceable in Linux. Next I describe  what I use in Linux to do most of my work:

Writing research articles: Latex (textudio + texlive)
Writing other documents: Writer (libreoffice) and gedit
Spreadsheets: Calc (libreoffice)
Slides: Impress (libreoffice), Latex beamer and RMarkdown
Data Analysis: R+RStudio and Python+Spyder (ocasionally), 
Data storage: SQLITE and csv files
Remote access: RealVnc
Browser: Chrome

**Small number of games**. Occasionally, I used to play some computer games in the weekend. That, is no longer the case. While there has been an advance in the game front with Linux+Steam, most titles simply don't come to Linux.


## Conclusion

I'm very happy with my choice and advise everyone to make the switch. I'm more productive in Linux than I was in Windows. But, the transition is not easy. You'll need to learn many new things. Be confident that the positive payoff vastly outweigh the costs. 

I hope this post gives some pointers for those considering making the change. You can find [many tutorials](https://www.google.com.br/search?q=how+to+install+linux+mint&oq=how+to+install+linux+mint&aqs=chrome..69i57l2j69i60l3j69i59.2670j0j4&sourceid=chrome&ie=UTF-8) in the internet about how to install and use Linux mint.

