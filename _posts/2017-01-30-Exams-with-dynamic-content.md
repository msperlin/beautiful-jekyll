---
layout: post
title: "Building and maintaining exams with dynamic content"
subtitle: "An introduction to package exams"
author: "Marcelo Perlin"
output: md_document
image: /img/exam_sample.png  
tags: [R, exams, RndTexExams]
---

Part of my job as a researcher and teacher is to periodically apply and
grade exams in my classroom. Being constantly in the shoes of an
examiner, you soon quickly realize that students are clever in finding
ways to do well in an exam without effort. These days, photos and pdf
versions of past exams and exercises are shared online in facebook,
whatsapp groups, instagram and what not. As weird as it may sound, the
distribution of information in the digital era creates a problem for
examiners. If you use the same exam from past year, it is likely that
students will simply memorize the answers from a digital record.
Moreover, some students will also cheat by looking for answers during
the test. Either way, keeping the same exam over time and across
students, is not advisable.

This issue really bothered me. For large classes, there isn't a way to
evaluate the work of students as cost effective as online or printed
exams. I'm strongly in favor of meritocracy in academia and I think that
a grade in an exam should, on average, be good indicator of the
knowledge that the students retained during coursework. Otherwise,
what's the point of doing all of it?

In the past, I manually created different versions of questions and
wrote new ones in order to avoid cheating and memorization of questions.
But, year after year, it became clear to me that this was a time
consuming task that took more energy than what I would like to invest.
Besides teaching, I also do research and work on administrative issues
within my department. Sometimes, specially around deadlines, you simply
don't have the time and mental energy to come up with different versions
of an existing exam.

Back in 2016 I decided to invest some to time to automatize this process
and try to come up with an elegant solution. Since I had all my exams in
a latex template called `examdesign`, I wrote package
[RndTexExams](https://CRAN.R-project.org/package=RndTexExams) that took
as input a .tex file and created `n` versions of exams by randomly
defining the order of questions, the answer list and textual content
based on a simple markup language. If you know latex, it is basically a
problem of finding regex patterns and restructuring a character object
that is later saved in a new and compilable latex file.

The package I wrote worked pretty well for me but, as with any first
version of a software, it had missing features. The output was only a
pdf file based on a template, it did not work with standard academic
platforms such as Blackboard and Moodle and, the most problematic in my
opinion, it was not designed to run embedded R code that could be parsed
by `knitr`, like in a Rmarkdown file.

This is when I tried out the package
[exams](https://CRAN.R-project.org/package=exams). While my solution
with `RndTexExams` was alright for a latex user, package exams is much
better at solving the problem of dynamic content in exams. Using the
`knitr` and `sweave` engines, the level of randomization and creation of
dynamic content is really amazing. By combining R code (and all the
capabilities of CRAN packages), you can do do anything your want in an
exam. You can get information on the web, use completely different
datasets for each exam and so on. The limit is set by your imagination.

An example of exam with dynamic content
---------------------------------------

As a quick example, I am going to show one question from the exercise
chapter of my book. When it is ready, I will be serving the exercises
with a web based shiny app, meaning that the reader will download a pdf
file with unique questions that is processed in a shiny server.

In this example questions, I'm asking the reader to use R to solve the
following problem:

    How many packages you can find today (2017-01-30) in CRAN?
    Use repository https://cloud.r-project.org/ for the solution.

The solution is pretty simple, all you need to do is to ask for the
number of rows for the object output from a call to
`available.packages()`. The reader can find the solution with the
command
`nrow(available.packages(repos='https://cloud.r-project.org/'))`.

Now, lets build the content of this simple question in a separate file.
You can either use .Rnw or .Rmd files with exam. I will choose the later
just to keep it simple. Here are the contents of a file called
**Question.Rmd**, available [here](/img/Question.Rmd).

    cat(paste0(readLines('Question.Rmd'), collapse = '\n'))

    ## ```{r data generation, echo = FALSE, results = "hide"}
    ## #possible.repo <- getCRANmirrors()$URL  # doenst work well for all repos
    ## 
    ## possible.repo <- c('https://cloud.r-project.org/',
    ##                   'http://mirror.fcaglp.unlp.edu.ar/CRAN/',
    ##                   'http://cran-r.c3sl.ufpr.br/',
    ##                   'http://cran.stat.sfu.ca/',
    ##                   'https://mirrors.dotsrc.org/cran/',
    ##                   'https://mirrors.cicku.me/CRAN/',
    ##                   'https://cran.ism.ac.jp/')
    ## 
    ## my.repo <- sample(possible.repo,1)
    ## 
    ## n.pkgs <- nrow(available.packages(repos = my.repo))
    ## 
    ## sol.q <- n.pkgs
    ## rnd.vec <- c(0, sample(-5000:-1,4))
    ## 
    ## my.answers <- paste0(sol.q+rnd.vec, ' packages')
    ## ```
    ## 
    ## Question
    ## ========
    ## 
    ## How many packages you can find today (`r Sys.Date()`) in CRAN? 
    ## 
    ## Use repository `r my.repo` for the solution.
    ## 
    ## ```{r questionlist, echo = FALSE, results = "asis"}
    ## exams::answerlist(my.answers, markup = "markdown")
    ## ```
    ## 
    ## Meta-information
    ## ================
    ## extype: schoice
    ## exsolution: 10000
    ## exname: numbero of cran pkgs
    ## exshuffle: TRUE

For the last piece of code, notice that I've set the solution of the
question in object `sol.q`. Later, in object `my.answers`, I use it
together with a random vector of integers to create five alternative
answers to the questions, where the first one is the correct. This
operation results in the following objects:

    my.repo <- 'https://cloud.r-project.org/'
    n.pkgs <- nrow(available.packages(repos = my.repo))
      
    sol.q <- n.pkgs
    rnd.vec <- c(0, sample(-5000:-1,4))
      
    my.answers <- paste0(sol.q+rnd.vec, ' packages')
    print(my.answers)

    ## [1] "10001 packages" "8687 packages"  "9883 packages"  "7157 packages" 
    ## [5] "8513 packages"

To conclude the question, I simply use `Sys.Date()` to get the system's
date and later set the correct answers using function `answerlist`. Some
metadata is also inserted at the last section of `Question.Rmd`. The
line `exshuffle: TRUE` sets a random order of possible answers in each
exam for this questions. Do notice that the solution is registered in
line `exsolution: 10000`, where the 1 in 10000 means correct answer in
the first element of `my.answers` and the 0s represent incorrect
answers.

Now that the file with content of the question is finished, let's set
some options and build the exam with `exams`. For simplicity, we will
repeate the same question five times.

    library(exams)

    my.f <-'Question.Rmd'
    n.ver <- 1
    name.exam <- 'exam_sample'
    my.dir <- 'exam-out/'

    my.exam <- exams2pdf(file = rep(my.f,5),
                         n = n.ver, 
                         dir = my.dir,
                         name = name.exam, 
                         verbose = TRUE)

    ## Exams generation initialized.
    ## 
    ## Output directory: /home/msperlin/Dropbox/My Blog/exam-out
    ## Exercise directory: /home/msperlin/Dropbox/My Blog
    ## Supplement directory: /tmp/RtmpaDj6Ju/file27145b4e0310
    ## Temporary directory: /tmp/RtmpaDj6Ju/file2714cb4b300
    ## Exercises: Question, Question, Question, Question, Question
    ## 
    ## Generation of individual exams.
    ## Exam 1: Question (srt) Question_1 (srt) Question_2 (srt) Question_3 (srt) Question_4 (srt) ... w ... done.

    f.out <- paste0(my.dir,name.exam,'1','.pdf')
    file.exists(f.out)

    ## [1] TRUE

The result of the previous code is a pdf file with the following
content:

![](/img/exam_sample.png)

One interesting information from this post is that you can find a small
difference in the number of packages in between the CRAN mirrors. My
best guess is that they synchronize with the master server in different
times of the day/week.

Looking at the contents of the pdf file, clearly some things are missing
from the exam, such as the title page and the instructions. You can add
all the bells and whistles with the inputs of function `exams2pdf` or
change it directly in the different file templates. One quick tip for
new users is that the answer sheet can be found by looping over the
values of the output from `exams2pdf`:

    df.answer.key <- data.frame()
    n.q <- 5 # number of questions
    for (i.ver in seq(n.ver)){
      
      exam.now <- my.exam[[i.ver]] 
      
      for (i.q in seq(n.q)){
        
        sol.now <- letters[which(exam.now[[i.q]]$metainfo$solution)]
        
        temp <- data.frame(i.ver = i.ver, i.q = i.q, solution = sol.now)
        df.answer.key <- rbind(df.answer.key, temp)  
      }
      
    }

    df.answer.key.wide <- tidyr::spread(df.answer.key, key = i.q, value = solution)
    df.answer.key.wide

    ##   i.ver 1 2 3 4 5
    ## 1     1 d e a c a

By using package `exams2pdf`, I can code different questions in the
`exams` format and not worry whether someone is going to copy it over
and distribute it in the internet. Students may know the content of each
question, but they will have to learn how to get to the correct answer
in order to solve it for their exam. Cheating is also impossible since
each student will have different versions and different answer sheets.
If I have a class of 100 students, I will build 100 different exams,
each one with unique answers.

As for maintainability, the time value of my exam questions increases
significantly. I can use them over and over, now that I can effortlessly
create as many versions of it as I need. Since it is all based in R
code, I can use the code from the class material in my exams. Going
further, I can also automatically grade the exams using the internet
(see the [vignette of
`RndTexExams`](https://cran.r-project.org/web/packages/RndTexExams/vignettes/rte-vignette_creating_exams.html)
for information on how to do that with Google spreadsheets.)

In this post I only scratched the surface of `exams`. Adding to the
description of its capabilities, you can **export** exams to standard
academic systems such as Moodle, Blackboard and others. You can also
print the exam in pdf, nops (a pdf that allows easy scanning), or html.
If you know a bit of latex or html, it is easy to customize the
templates to the needs of your particular exam.

As with all technical things, not everything is perfect. In my oppinio,
the main issue with the `exams` template is that requires some knowledge
of R and Knitr. While this is Ok for most people reading this blog, it
is not the case for the *average* professor. It may sound surprising to
the quantitative inclined people, but the great majority of professors
still use .docx and .xlsx files to write academic work such as articles
and exams. Why they don't use or learn better tools? Well, this is a
long answer, best suited for another post.

Package `exams` had a **big and positive impact on how I do my work**.
Based on a large database of questions that I've built, I can create a
new exam in 5 minutes and grade it for a large class in less than 1
minute. I am very thankful to its authors and this is one of the reasons
why I love posting packages in CRAN. It is my way of giving it back to
the community.

Concluding, package `exams` is great and I believe that every examiner
and professor should be using it. Thinking about the future, the
template of questions in `exams` has the potential of setting the
**language of exams**, a structure that could allow the user to output
questions in any format he wants, just as you can use Markdown to output
latex or word.

Sharing questions in a collaborative platform, such as Quora, should be
something for the developers (or R community) to think of. Questions
could be ranked according to popular vote. Users could contribute by
posting question files for other to use. Users would get a feedback on
their work and, at the same time, be able to use other people questions.
Students could also have access to it and independently study to a
particular topic, by building custom made exams with randomized content.

Summing up, if you are a teacher or examiner, I hope that this post
convinces you to try out package `exams`.
