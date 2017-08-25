---
layout: post
title: "A simple function for installing R packages based on a folder with R scripts"
subtitle: ""
author: "Marcelo Perlin"
image: /img/packages.jpg
tags: [R, packages]
---

Whenever I buy a new computer or format an old one, I have the problem of reinstalling my R packages. If you are a heavy user, you will likely have a significant amount of packages used by your scripts. When you try to run a script in a fresh install of R, it will tell you that you don't have the proper packages installed. Needless to say that manually installing them is boring.

I've found a very simple solution to this problem. I wrote a function that takes as input a folder in the computer and searches for all .R and .Rmd files in all subfolders. It then reads each one and finds all occurrences of `library(pkgnamehere)` and `require(pkgnamehere)`. It proceeds by checking if the package is locally available and, if not, installs it from CRAN. I'm not sure if this is a new solution but, if you find it interesting and worthy of a CRAN package, let me know in the comment sections. I'm sure I can significantly improve it.

So, whenever I have a fresh computer, I just run the following script:

```{r}

#install.packages('stringr')

#my.path <- 'C:/Dropbox/' # windows
folder.in <- '/home/msperlin/Dropbox' # linux 

reinstall.pkgs(folder.in)
```

and all necessary packages are installed. The needed functions are given next:

```{r}
reinstall.pkgs <- function(folder.in) {
  my.pattern <- '\\.R$|\\.Rmd'
  
  target.files <- list.files(path = folder.in, pattern = my.pattern  , recursive = T, full.names = T)
  
  all.pkgs <- unlist(sapply(X = target.files, FUN = find.pkgs, USE.NAMES = F))
  all.pkgs <- unique(all.pkgs)
  
  out <- sapply(X = all.pkgs, FUN = check.install.pkgs)
  
  return(TRUE)
}

find.pkgs <- function(str.in){
  
  require(stringr)
  
  txt.out <- paste(readLines(str.in), collapse = '\n')
  
  out.req.1 <- str_match_all(txt.out, pattern = 'require\\(\"(.*?)\"\\)')[[1]]
  out.req.2 <- str_match_all(txt.out, pattern = 'require\\((.*?)\\)')[[1]]
  
  pkg.out.require <- as.vector(c(out.req.1[,2], out.req.2[,2]))
  
  out1 <- str_match_all(txt.out, pattern = 'library\\(\"(.*?)\"\\)')[[1]]
  out2 <- str_match_all(txt.out, pattern = 'library\\((.*?)\\)')[[1]]
  pkg.out.library <- as.vector(c(out1[,2], out2[,2]))
  
  pkg.out <- c(pkg.out.require, pkg.out.library)
  
  pkg.out <- str_replace_all(pkg.out, pattern = fixed("'"), replacement = '' )

  return(pkg.out)
}

check.install.pkgs <- function(pkg.in){
  cat('\nInstalling', pkg.in)
  
  my.installed.pkgs <- installed.packages()
  
  if ( !(pkg.in %in% my.installed.pkgs[,1]) ){
    cat('- Installing', pkg.in)
    install.packages(pkg.in)
  } else { cat('- Already installed')}
  
}
```


