---
layout: post
title: "Writing an R book and self-publishing it in Amazon"
subtitle: "My experience and some advices about the process"
author: "Marcelo Perlin"
output: md_document
image: /img/MyBook_printed.jpg
tags: [R, book, self-publish]
---

Many people, including my university colleagues and friends, have asked
me about the process of writing a book and self publishing it in Amazon.
You can find the details about the book
[here](https://www.amazon.com/Processamento-Modelagem-Dados-Financeiros-Portuguese-ebook/dp/B01N4VXYPM/ref=sr_1_1?ie=UTF8&qid=1487077106&sr=8-1&keywords=processamento)
and
[here](https://sites.google.com/view/r-financas/p%C3%A1gina-inicial).
Given so much interest, I'm going to report the whole process in this
post.

First, motivation. **Why did I write a book?**

I am a university professor. Writing is a major part of my work and I
really enjoy it. Think about it, it is a magical process. I press a
specific and long combination of strokes in my keyboard and that
translates into information distributed all over the world. This
information helps people in a particular problem, just as I have been
helped in the past by reading the work of other people.

A longer answer, I wrote the book because I simply felt like studying
and learning more about R. Writing a book is an excellent opportunity
for doing so as it forces you to think about a topic and communicate it
clearly and objectively. After reading the [book from
Grangrud](https://www.amazon.com/Reproducible-Research-Studio-Second-Chapman/dp/1498715370),
I got some inspiration for writing my own book about R, reproducible
research and Finance. My experience in the academia tells me that people
often learn programming by themselves, without any consideration for the
structure and re-usability of the code. You can see examples of it when
you download code from other researchers. In most cases, it is a big
mess and I often found it easier (and less risky) to rewrite it all from
scratch. So, writing a book is a way to show to people how to use R for
data analysis in finance and how to organize code that can be used
later, saving lots of time of development. As I mentioned in a [previous
post](https://msperlin.github.io/2017-02-06-My-Book-is-out/), another
argument for writing the book is that, even if I didn't publish it, I
would still have very good class notes for my graduate students or
perhaps a pdf to host in my website.

Off course you may wonder about the financial side. After all, I am a
finance professor and finance is the science of money. While you can
make money selling books, the financial incentives for writing a new
technical book are quite low. In financial terms, writing a technical
book is a project with negative expected Net Present Value (NPV). This
means that, from the *ex ante* point of view of a potential writer,
working in a technical book simply does not create financial value.
There is a high production cost in terms of how much time you spend
writing and formatting the book and a high uncertainty about the future
royalties. If you look at it from the financial side, it is just a bad
gamble. This is why you should only write a book about something you
love and want to learn more about. Otherwise, it can become a big
frustration.

The writing process
-------------------

The first step in writing my book was to set out a summary, that is, the
names of the chapters. The first part of it was pretty obvious, it
covered the basics of using R: packages, objects, functions, loops and
so on. The rest of the topics were all based on my experience. I asked
the question **What are the most important data tasks that a finance
student should learn?**. Once you have a TOC (table of contents) ready,
it is all about filling up the book with content.

I really enjoyed the process of writing the book. Taking a long term
project such as a book requires discipline. One strategy that really
helped me was to work very early in the morning. As soon as the sun
rised at 0630, I'm up and in my way to the university. From 07:00 am to
0900 am, nothing really happens at the university, giving me plenty of
time to write peacefully. Some days I could write all morning, if I felt
like it and had a free schedule. One tip for anyone that is thinking
about writing a book (or article), only write when you fell like
writing. It is really difficult to write well if your mind is not into
it. Not having a deadline for this project meant that I could take my
time in developing it.

As for software, the first version of the book was written in
[TexStudio](http://www.texstudio.org/) with the content in `Sweave`
files (.Rnw), and a [simple
hack](https://www.r-bloggers.com/use-sweave-with-texmaker-and-make-synctex-work-properly-with-it/)
to call Sweave from R and compile the resulting tex file. I'm used to
work with latex, so the choice for textudio was obvious. I like this
latex editor as it integrates nicely with grammar checking tools and
latex compilation. Why not `knitr`? Well, at the time I was very
comfortable with `Sweave`. It offered everything I needed. I didn't see
a reason for change. Clearly, I was wrong. Once I started to investigate
how to format better the code in the book, it became clear that I should
be using `knitr`, which has all these extra options that are not
available in `Sweave`. I switched it as soon as I realized the increase of options I had
with `knitr`.

After 6 months of work, I had a first readable version of the book. This
is when I started to investigate how to turn a latex file into an ebook
file. To my surprise, this is not easy! It could be the case that I had
lots of code and figures from the compilation. I tried all the existing
software and, to my frustration, it just didn't work. When I didn't got
an error message that stopped the conversion, the resulting *epub* file
look awful in the kindle reader. The warning and error messages from the
latex2ebook compiler also didn't help a lot.

By looking for solutions in the internet and with a bit of luck, I've
found that Yihui Xie had just published his [bookdown
package](https://bookdown.org/). I tried out the first chapters and it
worked perfectly! The great thing about `bookdown` is that you can
output to pdf, html or epub with the same files. I was very happy that,
finally, I would be able to get all formats that I needed in a single
platform. I'm not going to go into the details about how to use
`bookdown`. You can find the official tutorial
[here](https://bookdown.org/yihui/bookdown/). It is worth to point out
that the written content is just RMarkdown so, if you know latex, you'll
fell right at home. So, I rewrote the whole book, switching from 
latex/knitr to Rmarkdown.

The only feature in `bookdown` that didn't work out of the box was the
equation in the kindle format. The formulas just didn't print well. The
weird part is that they looked fine in any other ebook reader, but not
in Kindle. Apparently, there is no solution for this problem besides
using figure files for the equations. What I did to solve it was to use
R switches within the book so that the epub compilation used a figure
file created in [codecogs](https://www.codecogs.com/latex/eqneditor.php)
and the latex/html compilation used the normal code for equations. See
here an example of code for the first equation in chapter 9.

![An example of how to get equations in Epub and
pdf](/img/screenshot-ebook-figures.png)

As you can see, I used a switch in the `knitr` command as in
`include=identical(knitr:::pandoc_to(), 'epub3')` to run each code
conditional to the type of output. As for inline equations, I just used
straight text to indicate coefficients such as *beta*, *alpha*. I know I
could have used the same strategy, but I didn't fell the need since
there were so few inline equations in the text.

After switching to bookdown, I added a couple more chapters in the
following months. A comment here is that I tried writing in RStudio but
it didn't worked out for me. Perhaps it was due to the large files I was
handling, but it felt really clunky, slow and not reactive. Also, the
grammar check system in Rstudio needs a lot of work. I tried going back
to Texstudio but it didn't had support for markdown highlighting. I then
switched software by doing the writing in
[notepad++](https://notepad-plus-plus.org/) + [markdown
extension](https://github.com/Edditoria/markdown_npp) and only used
RStudio to compile the book. If you haven't tried notepad++, give it a
go. I really like it and I find myself using it more and more.

Publishing in Amazon
--------------------

Around october of 2016, the content of the book started to take a good
shape and it was time to investigate where and how to publish it. I got
in touch with a major local publisher here in Brazil and, after one
month, they informed me that they were not interested in the book. While
I could try other publishers, I really didn't felt like going through
another month of evaluation. I studied for while and decided to
**self-publish the book**.

One positive aspect of self publishing is that big publishers downsized
over the years and good professionals are now in the market for hire.
This means that a large range of good editors and designers are
available to the independent author. In my case, I fought the urge to do
the cover myself and searched for a cover designer. After a lot of
search, I hired [Capista](http://capista.com.br/capas-de-livros/) to do
the book cover. I really liked his portfolio and, he offers a discount
for self-publish authors, which is very nice of him.

I also hired professionals to check the text for mistakes and grammar.
This is particular important as grammar mistakes are normal and expected
in large documents. But, selecting a reviewer was an interactive
process. I searched the web and hired tree different reviewers and
offered them three different chapters of the book. Once I had all
revisions, I selected the reviewer the offered the best result and sent
him the rest of the chapters. You can find his site
[here](http://revisaotextual.com.br/). I'm glad I did this way, It would
be a nightmare if I hired the wrong person to do this job.

The main advantage of self publication is that the royalties for the
author are higher and the cost to publish are lower. This setup
translates into a lower price of the book and more sells. Specific to
Brazil, where the exchange rate of dollar to Real (the Brazilian
currency) is very unfavourable, it makes sense to offer a lower priced
book. This way, it is easier for students and instructor to acquire and
use the book.

Since ebooks is a growing market, you can find lots of tutorials about
this topic in the internet, [like this
one](https://www.cnet.com/how-to/how-to-self-publish-an-ebook/) and
[this
one](http://www.thecreativepenn.com/how-to-self-publish-an-ebook/). The
problem here is that they are mostly about self-publishing *text*
ebooks, as in fiction stories. The only article I've found about
self-publishing technical books is [this
one](http://cacm.acm.org/magazines/2015/2/182651-do-it-yourself-textbook-publishing/abstract#),
where the author describe their rather good experience in publishing a
software-engineering textbook.

I checked [Lulu](https://www.lulu.com/),
[Smashwords](https://www.smashwords.com/) and [Amazon
KDP](https://kdp.amazon.com/). What made my choice towards Amazon was
that it was a established platform, where almost everyone is registered.
Buying an Ebook in Amazon is just one click away. Also, I've found that
the KDP (self publish) program of Amazon is quite good. If the ebook
sells for less than 9 dollars and is enrolled in the [Amazon unlimited
program](https://www.amazon.com/Browse-Kindle-Unlimited-Books/b?ie=UTF8&node=9069934011),
the author gets 70% of the sticker price in royalties, which is a nice
percentage! A bit of information, the normal royalty rate for an author
of a publishing company is around 5%-10% of the book price. Just a quick
comparison, for each ebook sold at
$9, the author gets $6.3 (70%\*9). In other
scenario, assuming an author has a publisher that offered 10% royalty,
you would get the same royalty for a a book priced at $63 (6.3/10%). The
big difference here is that a $9 ebook sells a lot more than a $63
ebook, resulting in higher royalties and higher impact. More people read
your book and you make more money. My only disappointment with Amazon is
that the printed books are shipped from the USA. A buyer of the printed
book in Brazil will need to wait at least 10-15 days to get the book.
But, overall, I find this to be a small cost to bear.

When the final version of the content of the book was ready, I started
to organize everything I needed in order to publish the book. This is
the list:

1.  A ISBN number - A unique id that indexes your book, one for the
    ebook and another for the print version. In order to get an ISBN,
    you need to find the [representation of ISBN in your
    country](https://www.isbn-international.org/). Amazon also offers
    their own ISBN, but I don't advise to use it. Having your own ISBN
    gives you more control. Just get one yourself. It is easy and cheap.
    In my case, I sent the request from the
    [website](http://www.isbn.bn.br/website/) by filling up forms in
    less than 10 minutes and got the number in five days.

2.  Cover - The cover is processed as a figure file (.jpg). An important
    information here is that you need to define the size of you book and
    the number of pages at this stage. In my case, I used a 7x11 inches
    configuration for 200+ pages. It looks quite nice. Have a look:

	![My book and my spanish iguana!](/img/MyBook_printed.jpg)

	Beautiful cover! Isn't it? Once you have the figure file, you just add
	it to the *book creator* system in amazon. At this stage, you will also
	need a summary about the book and its author and a picture for the back
	cover of the printed version.

3.  Registration in Amazon. The site asks you a lot of information. It
    took me at least half an hour to fill up the forms, which also
    includes tax details for us and non-us residents.

4.  Description of the book. This is the text that goes in the webpage
    of the book in Amazon. In my case, I just used the same text as the
    back cover.

5.  [A book
    site](https://sites.google.com/view/r-financas/p%C3%A1gina-inicial).
    I wanted to distribute the code from the book and also exercises
    over the web. I used [Google Sites](https://sites.google.com/), but
    I'm sure you have plenty of options here. On a side note, I'm also
    considering writing a CRAN package for distributing this content.

For the ebook, the next step is easy. Just upload the cover, the `.epub`
file from `bookdown`, write the description and other details and you
are good to go. With everything ready to go, you can check the ebook
page by page with the online viewer. I didn't have any problems at this
stage. As for the print version, it is far more complicated. In my case,
I used the pdf file to build the printed version. Once you upload the
pdf, you can check the result in a online viewer. This is the final
proof of the book and shows how it would look like when printed. There
are lots of error checking from the system and, if you got an error, you
cannot publish the book. I've spent a lot of time formatting everything
so that the book comes out perfectly. The problem is that, each attempt
to solve errors demanded processing time. At least 10 minutes to reach
the whole cycle of compiling the pdf, uploading and checking the result.
So, every time I tried to solve an error, I got the result 10 minutes
later. I repeated this process over and over until I had a perfect book.

The publication
---------------

The book was launched in the sixth of February 2017. I advertised it in
here, my [blog](https://msperlin.github.io/), Facebook and email. I was
very surprised with the strong reception. In the first and second day,
it became the **best seller** book in the section of finance in the
Brazilian Amazon. I am really happy for the success of the book. Right
now, the sales have gone down, which is normal and expected, but I'm
getting all sorts of good responses. What surprised me is that, even
though the book was published primarily for Brazil, I'm receiving lots
of replies (and sales) of people from other Portuguese speaking
countries such as Cabo Verde and Portugal!

Some advices
------------

If I could go back in time and advice myself about the book, this is
what I would have said. I hope these advices are helpful for others as
well.

-   From the first version, make up your mind about book size and
    letter size. This decision will impact everything else. Problems are
    easier to detect and solve if you stick to a single format.

-   RStudio and `bookdown` are your friends. I'm not aware of any other
    free platform that offers anything like it for developing a
    technical book.

-   When possible, use `tidy=TRUE` in the chunks of code. This simple
    command forces the code within the boundaries of the pdf. Sometimes
    it doesn't look good so you always need to manually check the chunks
    with lots of code.

-   Avoid using function `str` in the content. For some reason, it does
    not respect the boundaries of the page. There is a solution but it
    would not look good in the book.

-   Use a dark theme for writing. Your eyes will hurt less and you will
    be able to write more.

-   Talk to people that understands the material you are writing about.
    Listen to their advices and make changes when necessary. Don't over
    commit to sections that you are not sure will be included.

-   For all figure files in your book, always get the highest possible
    resolution (at least 300 dpi). Amazon will not let you publish
    figures with low resolution.

-   Don't even try to do yourself the book cover or grammar check. Hire
    someone to do it for you. Your future self will thank you later!

Whats next?
-----------

I really enjoyed the experience of self-publishing a book and I strongly
advise for anyone to give it a try. A cautionary note, **I never worked
with a established publisher and, therefore, I cannot talk about how it
is or compare it to self-publish**. If someone has had that experience,
fell free to use the comments to discuss it.

The impact of a technical book is uncertain. Only time will tell if the
book is successful or not. I have high hopes though. The feedback from
the community has been strongly positive. I also have been working on
extra material such as exercises and slides that are going to be
distributed for free. This should motivate professors to use the book in
class and increase distribution.

I hope this post was helpful and enlightening for potential authors.
Comments or suggestions, please use the comment section or drop me an
email at [marceloperlin@gmail.com](marceloperlin@gmail.com).

Best, Marcelo.
