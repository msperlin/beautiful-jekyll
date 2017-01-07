---
layout: post
title: "Searching for predatory journals and publishers with R"
subtitle: "Using package predatory"
author: "Marcelo Perlin"
output: md_document
image: /img/2017-01-07-predatory_files/predatory-publisher.png
bibliography: MyBib.bib
tags: [R, predatory journals]
---

The recent rise of publications in predatory journals is a big issue in
the academic community and it hurts the development of science. This is
especially true for developing countries such as Brazil, where the
academic evaluation system is not yet well established. Surprinsingly,
even standard impact assessment systems such as JCR and SJR are not
immune to predatory publishers.

![source: [here](https://forbetterscience.wordpress.com/2015/10/28/is-frontiers-a-potential-predatory-publisher/)
](/img/2017-01-07-predatory_files/predatory-publisher.png)

One of the problems in doing empirical research regarding predatory
journals is that the only available resource for their identification is
[Beall's list](https://scholarlyoa.com/). While it is certainly useful
and its author deserves all the credit we can give him, the information
in the site is unstructured as it only shows the names and links of
predatory publishers and journals.

As part of a research paper related to the analysis of predatory
publications in Brazil, I'm building a database of predatory journals
based on Beall's site. While the stand-alone journals are easy to
collect information using web scrapping algorithms, the part of the site
for predatory publishers is not. In this sections, each website has its
own format for several journals and it would be impossible to get
information from all of them in the same way. In order to solve that, we
are doing manual collection of the required information and storing it
in a csv file.

Based on this file, the package predatory makes it easy for researchers
and librarians to check whether a particular journal or publisher is in
Beall's list or not. Not only that, it also allows direct access to the
database that we are building. A shiny app is also available in
<https://msperlin.shinyapps.io/shiny-predatory/>.

***BE AWARE*** that the database is not yet complete. The collection of
the data is manual and it takes time. The package will be updated in a
regular basis.

Examples of usage
-----------------

### Name or issn lookup

Let's say you have the name of a journal called *Biomedical Laboratory
and Clinical Research* that you want to check whether it is in Beall's
list or not. For that, you can simply use the following code:

    library(predatory)

    ## Thank you for using predatory! I also built a simple shiny app with similar funcionality.
    ## It is available at:
    ## 
    ## https://msperlin.shinyapps.io/shiny-predatory/

    name <- 'Biomedical Laboratory and Clinical Research'
    temp <- find.predatory(x = name)

    ## 
    ## Found 1 row(s)

    temp

    ## # A tibble: 1 × 3
    ##          publisher                                journal_name      issn
    ##              <chr>                                       <chr>     <chr>
    ## 1 1088 Email Press Biomedical Laboratory and Clinical Research 2473-3423

As you can see, this journal is published by 1088 Email Press and has an
issn of 2473-3423.

Another example would be to look for a journal based on its ISSN number.
Let's try the value *0028-0836*.

    my.issn <- '00208-0836'
    temp <- find.predatory(x = my.issn, by = 'issn')

    ## 
    ## Found 0 row(s)

    temp

    ## # A tibble: 0 × 3
    ## # ... with 3 variables: publisher <chr>, journal_name <chr>, issn <chr>

This time, however, the search returned a dataframe with 0 length. The
result is not surprising since the issn belongs to the journal
[Nature](http://www.nature.com/nature/index.html).

### Partial lookup

Another possibility of usage is to look for all predatory journals
within a particular subject. Let's try all journals that have the word
*finance* in its title.

    my.str <- 'finance'
    temp <- find.predatory(x = my.str)

    ## 
    ## Found 134 row(s)

    head(temp)

    ## # A tibble: 6 × 3
    ##                                  publisher
    ##                                      <chr>
    ## 1 Academic and Business Research Institute
    ## 2 Academic and Business Research Institute
    ## 3       Academic and Scientific Publishing
    ## 4       Academic and Scientific Publishing
    ## 5       Academic and Scientific Publishing
    ## 6       Academic and Scientific Publishing
    ## # ... with 2 more variables: journal_name <chr>, issn <chr>

This time we found 134 journals that are related to finance.

Acessing the database of predatory journals
-------------------------------------------

The database of predatory journals is available within the package. It
is stored as a *csv* file in the *inst/extdat* folder. If you are
interested in its contents, you can find it using command
`system.file("extdata", 'predpub.csv', package = "predatory")` or simply
calling function *Get\_PredPubTable* from the package, as follows:

    df.predpub <- get.predpubTable()

    head(df.predpub)

    ## # A tibble: 6 × 3
    ##          publisher
    ##              <chr>
    ## 1 1088 Email Press
    ## 2 1088 Email Press
    ## 3 1088 Email Press
    ## 4 1088 Email Press
    ## 5 1088 Email Press
    ## 6 1088 Email Press
    ## # ... with 2 more variables: journal_name <chr>, issn <chr>

    str(df.predpub)

    ## Classes 'tbl_df', 'tbl' and 'data.frame':    9789 obs. of  3 variables:
    ##  $ publisher   : chr  "1088 Email Press" "1088 Email Press" "1088 Email Press" "1088 Email Press" ...
    ##  $ journal_name: chr  "Advanced Research on Economics and Management" "Biomedical Laboratory and Clinical Research" "International Journal of Advanced Science, Industry and Society" "Journal of Advanced Education" ...
    ##  $ issn        : chr  "2473-3474" "2473-3423" "2473-3431" "Pending" ...
    ##  - attr(*, "spec")=List of 2
    ##   ..$ cols   :List of 3
    ##   .. ..$ publisher   : list()
    ##   .. .. ..- attr(*, "class")= chr  "collector_character" "collector"
    ##   .. ..$ journal_name: list()
    ##   .. .. ..- attr(*, "class")= chr  "collector_character" "collector"
    ##   .. ..$ issn        : list()
    ##   .. .. ..- attr(*, "class")= chr  "collector_character" "collector"
    ##   ..$ default: list()
    ##   .. ..- attr(*, "class")= chr  "collector_guess" "collector"
    ##   ..- attr(*, "class")= chr "col_spec"

Happy hunting!
