---
layout: post
title: "New package in CRAN: PkgsFromFiles"
subtitle: ""
author: "Marcelo S. Perlin"
output: md_document
image: /img/2018-10-13-NewPackage-PkgsFromFiles_files/figure-markdown_strict/unnamed-chunk-5-1.png
tags: [R, GetLattesData]
---

Its been a while since I develop a CRAN package and this weekend I decided
to work on a idea I had some time ago. The result is package
`PkgsFromFiles`.

When working with different computers at home or work, one of the
problems I have is installing missing packages across different
computers. As an example, a script that works in my **work computer** may
not work in my **home computer**. This is specially annoying when I have a
fresh install of the operating system or R. In this case, I must
manually install all packages, case by case. Instead of focusing on the
script at hand, I spend considerable time finding and installing missing
packages. When using laptops for teaching R, many times I had to wait
for the installation of a package before continuing the class. With my
new package, PkgsFromFiles, I can scan any folder of my computer and
install all necessary packages **before** using them, as we will soon
learn.

One of the available solutions to this problem is to use package
[pacman](https://CRAN.R-project.org/package=pacman). It includes
function `p_load` that will check if a package is available and, if not,
install it from CRAN. However, for me, I like using `library` and
`require` as it is consistent with my code format. Also, in a fresh R
install, I rather install all my required packages in a single run so
that I don't have to wait later.

Package PkgsFromFiles solves this issue by finding and parsing all R
related files (.R, .Rmd, .Rnw) from a given folder. It finds all calls
to library() and require() and installs all packages that are not
available locally.

Installation
============

    # from cran (soon!)
    install.packages('PkgsFromFiles')

    # from github
    if (!require(devtools)) install.packages('devtools')
    devtools::install_github('msperlin/PkgsFromFiles')

Usage
=====

The main function of the package is `pff_find_and_install_pkgs`, which
will search and install missing packages from R files at a given
directory. As an example, we'll use my research folder from Dropbox. It
contains all R script I have ever used in my research work. Let's try it
out:

    # Evaluation is disable so it passes CRAN CHECKS, but you should be able to run it in your computer
    library(PkgsFromFiles)

    # target folder
    my.dir <- '~/Dropbox/01-Pesquisa/'

    df <- pff_find_and_install_pkgs(folder.in = my.dir)

    ## 
    ## Searching folder  ~/Dropbox/01-Pesquisa/
    ##  Found 32 files in 11 folders
    ##       R Scripts: 32 files
    ##       Rmarkdown files: 0 files
    ##       Sweave files: 0 files
    ## Checking available pkgs from https://cloud.r-project.org
    ## Checking and installing missing pkgs
    ## Installing dplyr Already installed
    ## Installing stringr   Already installed
    ## Installing GetDFPData    Already installed
    ## Installing xlsx  Already installed
    ## Installing googlesheets  Already installed
    ## Installing dplyr Already installed
    ## Installing purrr Already installed
    ## Installing tidyverse Already installed
    ## Installing purrr Already installed
    ## Installing dplyr Already installed
    ## Installing stringr   Already installed
    ## Installing purrr Already installed
    ## Installing purrr Already installed
    ## Installing GetDFPData    Already installed
    ## Installing dplyr Already installed
    ## Installing stringr   Already installed
    ## Installing BatchGetSymbols   Already installed
    ## Installing lubridate Already installed
    ## Installing purrr Already installed
    ## Installing GetDFPData    Already installed
    ## Installing dplyr Already installed
    ## Installing stringr   Already installed
    ## Installing plm   Already installed
    ## Installing stargazer Already installed
    ## Installing RoogleVision  Instalation failed, pkg not in CRAN
    ## Installing dplyr Already installed
    ## Installing rvest Already installed
    ## Installing tidyverse Already installed
    ## Installing furrr Already installed
    ## Installing XML   Already installed
    ## Installing tidyverse Already installed
    ## Installing furrr Already installed
    ## Installing fst   Already installed
    ## Installing rvest Already installed
    ## Installing tidyverse Already installed
    ## Installing purrr Already installed
    ## Installing XML   Already installed
    ## Installing fst   Already installed
    ## Installing furrr Already installed
    ## Installing stringr   Already installed
    ## Installing tidyverse Already installed
    ## Installing furrr Already installed
    ## Installing fst   Already installed
    ## Installing lubridate Already installed
    ## Installing ggplot2   Already installed
    ## Installing GetDFPData    Already installed
    ## Installing genderBR  Already installed
    ## Installing BatchGetSymbols   Already installed
    ## Installing tidyverse Already installed
    ## Installing furrr Already installed
    ## Installing fst   Already installed
    ## Installing lubridate Already installed
    ## Installing ggplot2   Already installed
    ## Installing GetDFPData    Already installed
    ## Installing tidyverse Already installed
    ## Installing furrr Already installed
    ## Installing fst   Already installed
    ## Installing lubridate Already installed
    ## Installing ggplot2   Already installed
    ## Installing GetDFPData    Already installed
    ## Installing sandwich  Already installed
    ## Installing stargazer Already installed
    ## Installing tidyverse Already installed
    ## Installing furrr Already installed
    ## Installing fst   Already installed
    ## Installing lubridate Already installed
    ## Installing ggplot2   Already installed
    ## Installing plm   Already installed
    ## Installing stargazer Already installed
    ## Installing lmtest    Already installed
    ## Installing MatchIt   Already installed
    ## Installing stringr   Already installed
    ## Installing tidyverse Already installed
    ## Installing furrr Already installed
    ## Installing fst   Already installed
    ## Installing lubridate Already installed
    ## Installing ggplot2   Already installed
    ## Installing GetDFPData    Already installed
    ## Installing genderBR  Already installed
    ## Installing BatchGetSymbols   Already installed
    ## Installing tidyverse Already installed
    ## Installing furrr Already installed
    ## Installing fst   Already installed
    ## Installing lubridate Already installed
    ## Installing ggplot2   Already installed
    ## Installing GetDFPData    Already installed
    ## Installing tidyverse Already installed
    ## Installing furrr Already installed
    ## Installing fst   Already installed
    ## Installing lubridate Already installed
    ## Installing ggplot2   Already installed
    ## Installing GetDFPData    Already installed
    ## Installing plm   Already installed
    ## Installing stargazer Already installed
    ## Installing tidyverse Already installed
    ## Installing purrr Already installed
    ## Installing furrr Already installed
    ## Installing tidyverse Already installed
    ## Installing purrr Already installed
    ## Installing furrr Already installed
    ## Installing tidyverse Already installed
    ## Installing purrr Already installed
    ## Installing GetLattesData Already installed
    ## Installing furrr Already installed
    ## Installing tidyverse Already installed
    ## Installing purrr Already installed
    ## Installing GetLattesData Already installed
    ## Installing furrr Already installed
    ## Installing lubridate Already installed
    ## Installing tidyverse Already installed
    ## Installing lubridate Already installed
    ## Installing lubridate Already installed
    ## Installing RSelenium Already installed
    ## Installing stringr   Already installed
    ## Installing RSelenium Already installed
    ## Installing stringr   Already installed
    ## Installing XML   Already installed
    ## Installing httr  Already installed
    ## Installing stringr   Already installed
    ## Installing XML   Already installed
    ## Installing dplyr Already installed
    ## Installing stringr   Already installed
    ## Installing tidyverse Already installed
    ## Installing GetDFPData    Already installed
    ## Installing xlsx  Already installed
    ## Installing stringr   Already installed
    ## Installing XML   Already installed
    ## 
    ## Summary:
    ##  Found 126 packages already installed
    ##  Had to install 0 packages
    ##  Instalation failed for 1 packages
    ##      1 due to package not being found in CRAN
    ##      0 due to missing dependencies or other problems
    ## 
    ## Check output dataframe for more details about failed packages

As you can see, function `pff_find_and_install_pkgs` will find all R
related files recursively in the given folder. In this case, I have all
packages locally so no installation was required. A summary in text is
shown at the end of execution.

The output of the function is a dataframe with the details of the
operation. Have a look:

    dplyr::glimpse(df)

    ## Observations: 127
    ## Variables: 3
    ## $ pkg            <chr> "dplyr", "stringr", "GetDFPData", "xlsx", "goog...
    ## $ status.message <chr> "Already installed", "Already installed", "Alre...
    ## $ installation   <lgl> TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE,...

The package also includes function `pff_find_R_files_from_folder`, which
will find all packages used in R related files from a given folder. It
outputs a dataframe with several information about packages used in the
found scripts.

    df.files <- pff_find_R_files_from_folder(folder.in = my.dir)

    ## 
    ## Searching folder  ~/Dropbox/01-Pesquisa/
    ##  Found 32 files in 11 folders
    ##       R Scripts: 32 files
    ##       Rmarkdown files: 0 files
    ##       Sweave files: 0 files

    dplyr::glimpse(df.files)

    ## Observations: 32
    ## Variables: 5
    ## $ files      <chr> "/home/msperlin/Dropbox/01-Pesquisa//01-Working Pap...
    ## $ file.names <chr> "01-Build_Presidents_Table.R", "02-DownloadPictures...
    ## $ extensions <chr> "R", "R", "R", "R", "R", "R", "R", "R", "R", "R", "...
    ## $ pkgs       <chr> "dplyr ; stringr ; GetDFPData ; xlsx", "googlesheet...
    ## $ n.pkgs     <int> 4, 4, 1, 3, 6, 6, 2, 4, 3, 6, 9, 6, 8, 5, 4, 1, 9, ...

I also wrote a simple function for plotting the most used packages for a
given folder:

    # target folder
    my.dir <- '~/Dropbox/01-Pesquisa/'

    # plot most used pkgs
    p <- pff_plot_summary_pkgs(folder.in = my.dir)

    ## 
    ## Searching folder  ~/Dropbox/01-Pesquisa/
    ##  Found 32 files in 11 folders
    ##       R Scripts: 32 files
    ##       Rmarkdown files: 0 files
    ##       Sweave files: 0 files

    print(p)

![](/img/2018-10-13-NewPackage-PkgsFromFiles_files/figure-markdown_strict/unnamed-chunk-5-1.png)

As you can see, I'm a big fan of the `tidyverse`!

Hope you guys find the package useful! Fell free to send any question to
the comment section of the post or my email (<marceloperlin@gmail.com>).
