---
layout: post
title: "Shiny+Exams"
subtitle: "Serving book exercises in the web with Shiny and Exams"
author: "Marcelo Perlin"
image: /img/CAPA_MarceloDadosFinanceiros01E.jpg 
tags: [R, shiny,exams,exercises,book]
---

As you may know, I recently published a [R book in amazon](https://www.amazon.com/dp/8592243513).
I decided to keep R exercises out of the book and serve them freely over the web. This was not a difficult decision since I'm still writing and revising all questions. My experience tell me that **good** exercises requires time to develop and I didn't want to rush it just for the sake of publishing the book. 

I'm a big fan of package Exams and, given that I already have some questions about R in this format, I should use it to build the exercises for my book. The reader is better served than using a _single version format_ as he/she can rebuild a different set of exercises each time, and take the same set of exercises over and over, if needed. The problem is that building a new exam in package Exams requires R and latex compilation. I could compile in my computer and provide pdf files of different versions in the website, but this is not really an elegant solution.

With that in mind, I was able to write a shiny app that distributes pdf files in the internet. I customized all templates so that they fit my needs. I have never seen anything like that, which is why I am posting it here. I'm still amazed of how much a few lines of code in Shiny can do.

The users can choose the chapter and the language. After clicking the "build" button, a custom call to `exams2pdf` is made and the user can download a zip file with the contents of the exercises.

Give it a try [here](https://msperlin.shinyapps.io/book_exercises/).

Curious about the code? All files are available in [github](https://github.com/msperlin/Book-Exercises).
