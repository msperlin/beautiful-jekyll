---
layout: post
title: "Simple bash script for a fresh install of R and its dependencies in Linux"
subtitle: " "
author: "Marcelo Perlin"
output: html_document
image: /img/Rlogo.png
tags: [R, linux]
---

I've been working with Linux for some time but always in a dual boot setup. While I used Linux-Mint at home, my university computer always had Windows. Most of the times it was not a problem working in one or the other and share files between computers with Dropbox. 

After getting constantly frustated with Windows updates, crashes and slow-downs, I decided to make the full switch. All my computers are now Linux based. I am very happy with my choice and regret not making the switch earlier.

Since I formatted all my three computers (home/laptop/work), I wrote a small bash file to automate the process of installing R and its dependencies. I use lots of R packages in a daily basis. For some of them, it is required to install dependencies using the terminal. Each time that a `install.package()` failed, I saved the name of the required software and added it to the bash file. While my bash file will not cover all dependencies for all packages, it will suffice for a great proportion.

The steps for using it are:

1) Copy the contents of the code presented next in a file called `InstallR.sh`. Do notice that the name of the release, in this case trusty, is added to the cran address. Try not running the bash file twice, or it will append the CRAN address more than one time in /etc/apt/sources.list. 

```
#!/bin/bash
# Adds R to apt and install it
#
# Instructions:
# sudo chmod 700 InstallR.sh
# ./FirstTimeInstallR.sh

# Install R

sudo echo "deb http://cran.rstudio.com/bin/linux/ubuntu trusty/" | sudo tee -a /etc/apt/sources.list

gpg --keyserver keyserver.ubuntu.com --recv-key E084DAB9
gpg -a --export E084DAB9 | sudo apt-key add -

sudo apt-get update
sudo apt-get install -y r-base r-base-dev r-cran-xml r-cran-rjava libcurl4-openssl-dev
sudo apt-get install -y libssl-dev libxml2-dev openjdk-7-* libgdal-dev libproj-dev libgsl-dev
sudo apt-get install -y xml2 default-jre default-jdk mesa-common-dev libglu1-mesa-dev freeglut3-dev 
sudo apt-get install -y mesa-common-dev libx11-dev r-cran-rgl r-cran-rglpk r-cran-rsymphony r-cran-plyr 
sudo apt-get install -y  r-cran-reshape  r-cran-reshape2 r-cran-rmysql

sudo R CMD javareconf 

# install RStudio 1-0.143-amd64
# Link and version at: https://www.rstudio.com/products/rstudio/download2/

sudo apt-get install gdebi-core
wget https://download1.rstudio.org/rstudio-1.0.143-amd64.deb
sudo gdebi -n rstudio-1.0.143-amd64.deb
rm rstudio-1.0.143-amd64.deb
```

2) Change the permissions of the file so that it can be executed:

```
sudo chmod 700 InstallR.sh
```

3) Execute it as `sudo`

```
sudo ./InstallR.sh
```

That's it. I hope others will find this simple bash script useful as well. 
