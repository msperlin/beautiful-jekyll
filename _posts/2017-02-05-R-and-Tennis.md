---
layout: post
title: "Using R to study the evolution of Tennis"
subtitle: "An analysis of point by point data"
author: "Marcelo Perlin"
output: md_document
image: /img/tennis.jpg  
tags: [R, tennis]
---


I'm a big fan of Tennis. When I'm not working in the university, you can
probably find me in my favourite tennis club,
[Sogipa](http://www.sogipa.com.br/web/). What is so great about Tennis?
It is a sport that challenges your physically and mentally. It forces
you to your limit in both aspects. The more you play, the more you love
it and the more you want to learn about the game.

Tennis is also very different from the university work, which is mainly
a brain effort of writing, speaking and coding. I find it very healthy
to be able to momentarily distance myself from the day to day work, even
for a few hours. As my close friends can testify, I won't shut up about
tennis and try to convince other people to start playing. Now, let's get
to part of this blog that matters.

In this post I will combine two things that I love, R and Tennis. As you
will see soon enough, you can find a large database of information about
tennis matches publicly available in the internet. In my first post in
this topic, I will describe the evolution and effects in the game over
time, specially a change in the equipment back in 2000.

The data
--------

The data gathered for this post is from the great repository of [Jeff
Sackmann](https://github.com/JeffSackmann/tennis_MatchChartingProject).
There you can find csv files with information from ATP matches, WTA and
more. Among the repository choices, the most impressive is the [Match
Charting
Project](https://github.com/JeffSackmann/tennis_MatchChartingProject).
It contains point by point data for thousands of matches. Yes, that's
right, all points of the match are registered following particular
guidelines. This is a collective effort, where the public can send
statistics to the project. The level of details is amazing, you can
simulate the whole match based on the csv files.

Now, lets get some code going. Our first step in this analysis is to
download and unzip the dataset.

    zip.file <- 'TennisData.zip'

    if (!file.exists(zip.file)){
      download.file('https://github.com/JeffSackmann/tennis_MatchChartingProject/archive/master.zip', destfile = zip.file)
      
    }

    unzip(zip.file)

Let's look at the contents of the folder from the zip file.

    list.files(path = 'tennis_MatchChartingProject-master/')

    ##  [1] "charting-m-matches.csv"              
    ##  [2] "charting-m-points.csv"               
    ##  [3] "charting-m-stats-KeyPointsReturn.csv"
    ##  [4] "charting-m-stats-KeyPointsServe.csv" 
    ##  [5] "charting-m-stats-NetPoints.csv"      
    ##  [6] "charting-m-stats-Overview.csv"       
    ##  [7] "charting-m-stats-Rally.csv"          
    ##  [8] "charting-m-stats-ReturnDepth.csv"    
    ##  [9] "charting-m-stats-ReturnOutcomes.csv" 
    ## [10] "charting-m-stats-ServeBasics.csv"    
    ## [11] "charting-m-stats-ServeDirection.csv" 
    ## [12] "charting-m-stats-ServeInfluence.csv" 
    ## [13] "charting-m-stats-ShotDir.csv"        
    ## [14] "charting-m-stats-ShotDirection.csv"  
    ## [15] "charting-m-stats-ShotDirOutcomes.csv"
    ## [16] "charting-m-stats-ShotTypes.csv"      
    ## [17] "charting-m-stats-SnV.csv"            
    ## [18] "charting-m-stats-SvBreakSplit.csv"   
    ## [19] "charting-m-stats-SvBreakTotal.csv"   
    ## [20] "charting-w-matches.csv"              
    ## [21] "charting-w-points.csv"               
    ## [22] "charting-w-stats-KeyPointsReturn.csv"
    ## [23] "charting-w-stats-KeyPointsServe.csv" 
    ## [24] "charting-w-stats-NetPoints.csv"      
    ## [25] "charting-w-stats-Overview.csv"       
    ## [26] "charting-w-stats-Rally.csv"          
    ## [27] "charting-w-stats-ReturnDepth.csv"    
    ## [28] "charting-w-stats-ReturnOutcomes.csv" 
    ## [29] "charting-w-stats-ServeBasics.csv"    
    ## [30] "charting-w-stats-ServeDirection.csv" 
    ## [31] "charting-w-stats-ServeInfluence.csv" 
    ## [32] "charting-w-stats-ShotDirection.csv"  
    ## [33] "charting-w-stats-ShotDirOutcomes.csv"
    ## [34] "charting-w-stats-ShotTypes.csv"      
    ## [35] "charting-w-stats-SnV.csv"            
    ## [36] "charting-w-stats-SvBreakSplit.csv"   
    ## [37] "charting-w-stats-SvBreakTotal.csv"   
    ## [38] "charting-w-ufe-fe.csv"               
    ## [39] "MatchChart 0.1.5.xlsm"               
    ## [40] "README.md"

That's a lot of files! But, once you read the manual, the structure is
quite simple. The `m` and `w` in each file means *men* (masculine) and
*women* (feminine) tennis matches. The files with `stats` in their names
are the product of a particular aspect of the game. All analysis that
resulted in these files are based on the **master files**
`charting-m-points.csv` and `charting-f-points.csv`.

These are the largest files from the repository, containing point by
point data. For example, the first row of column `1st` in
`charting-m-points.csv` shows the code `6b29f3f3f3b3f1f2f3b3u1*`. The
first letter indicates the first serve. The value 6 means a serve *down
the T*, that is, a serve in the "T" located in the middle of the court.
Each following shot is represented by a number that indicates direction
and depth (e.g. 4=out wide) and a letter that determines shot type (e.g.
f=forehand).

The game keeps moving forward and each pair of number and letter sets
the configuration of shots from the players, back and forth. Eventually,
the point ends when someone misses or hits a winner. For the example
code `6b29f3f3f3b3f1f2f3b3u1*`, the last symbol `*` indicates that
someone has hit a winner and that event ended the point. As you can see,
this is an extremely detailed registration of a match. We only scratched
the surface, there are many more details about the coding system in file
`MatchChart 0.1.5.xlsm`.

Our first analysis will be to look into the volume of registered games
over time. We will combine men and women data in the analysis.

    library(dplyr)
    library(ggplot2)
    library(readr)
    library(stringr)

    # files
    my.f.m <- 'tennis_MatchChartingProject-master/charting-m-matches.csv'
    my.f.w <- 'tennis_MatchChartingProject-master/charting-w-matches.csv'

    # set cols for read_csv
    my.cols <- cols(
      match_id = col_character(),
      `Player 1` = col_character(),
      `Player 2` = col_character(),
      `Pl 1 hand` = col_character(),
      `Pl 2 hand` = col_character(),
      Gender = col_character(),
      Date = col_character(),
      Tournament = col_character(),
      Round = col_character(),
      Time = col_character(),
      Court = col_character(),
      Surface = col_character(),
      Umpire = col_character(),
      `Best of` = col_integer(),
      `Final TB?` = col_integer(),
      `Charted by` = col_character()
    )

    # read and bind!
    my.df.matches <- bind_rows(read_csv(my.f.m, col_types = my.cols) %>% mutate(Gender = 'Men'),
                               read_csv(my.f.w, col_types = my.cols) %>% mutate(Gender = 'Women'))

    # create year col
    my.df.matches$Date <- as.Date(my.df.matches$Date,'%Y%m%d')
    my.df.matches$Year <- format(my.df.matches$Date,'%Y')

    # plot it!
    p <- my.df.matches %>%
      group_by(Year,Gender) %>%
      summarise(`Number of matches` = n()) %>%
      ggplot(aes(x=as.numeric(Year),y=`Number of matches`,color=factor(Gender))) +
      geom_line(size=2)

    print(p)

![](/img/2017-02-05-R-and-Tennis_files/figure-markdown_strict/matches-1.png)

As you can see, most of the data was registered for matches after 2010.
Interestingly, the number of men and women games follow a very similar
pattern. The drop in 2016 can be explained by the registration process.
It is likely that people watch recorded matches in order to fill out the
points. I would predict that the drop will be lower once the data is
again downloaded from the repository in 2017.

Now, lets look at the distribution of court types. First, as with any
open field in a database, there are lots of problems with the court type
field. If we just count the cases, we get:

    temp.tab <- table(my.df.matches$Surface)
    print(temp.tab)

    ## 
    ##            Carpet     Carpet (hard)              Clay Court des Princes 
    ##                 3                 1               583                 1 
    ##             Grass              hard              Hard        Hard Court 
    ##               259                 1              1410                 1 
    ##       Hard Indoor      Hard Outdoor       Indoor Clay       Indoor hard 
    ##                 1                 1                 1                10 
    ##       Indoor Hard      Outdoor Clay 
    ##                28                 1

Clearly there are registration errors. We can clean this up it by just
keeping the court types with more than 30 matches.

    # remove
    temp.tab <- temp.tab[temp.tab>30]
    surf.to.keep <- names(temp.tab)

    # find idx of Not 
    idx <- !(my.df.matches$Surface %in% surf.to.keep)

    # set to NA
    my.df.matches$Surface[idx] <- NA

And now we plot the result.

    # plot percentage of court type over years
    p <- ggplot(my.df.matches, aes(x = as.numeric(Year), fill = Surface))
    p <- p + geom_bar(position = 'fill') 

    print(p)

    ## Warning: Removed 1 rows containing non-finite values (stat_count).

![](/img/2017-02-05-R-and-Tennis_files/figure-markdown_strict/unnamed-chunk-5-1.png)

It seems that hard courts dominated the game over the years. I'm not
sure why that is. As a player, I find it easier to play in clay court as
you can slide with your legs and that puts lower pressure on the knees.
Perhaps hard courts are easier to maintain and that economic argument is
extrapolated to tournaments as well. If anyone has a better guess,
please leave it at the comments.

Tennis matches before and after 2000
------------------------------------

Tennis is a sport that depends on its equipment. As anyone who plays it
can testify, there is a lot of personal choices regarding brands, weight
distribution of the racket, strings, grips, brand of tennis balls and so
on. A particular type of player will benefit the most from a particular
type of racket and string.

The physical and mechanical details of tennis makes it that any change
in equipment will impact the game. A simple example: if you play more
than five games with a set of balls (usually three), they become flat
and travel differently in the air. The game becomes slower and that
makes it more difficulty to hit winner shots, giving an advantage to a
particular strategy of playing. This explains why new tennis balls are
constantly introduced within a professional game.

One of the biggest systematic changes in tennis happened around 2000.
The problem was that the game was losing audience. People were bored of
watching the same type of plays and strategies over and over. A tennis
match before 2000 was mostly composed of **aces**, when a player hit a
speedy and angular serve, without chance for the adversary to prepare
and return the ball or a **serve and volley** strategy, were the server
would hit a slower ball, but would immediately run to the net in order
to close the point. If you can find some example of this strategy
[here](https://www.youtube.com/watch?v=kOtC2UGY77I). I can personally
relate to that boredom. Most of the fun in watching matches happens when players 
are exchanging balls back and forth over the court, one trying to outsmart or overpower the other.

The success of both strategies, aces and serve-volley, are related to
the speed of the ball. Aces are easier to hit if the ball travels
faster. Likewise, a high velocity of the ball does not give chance for
the adversary to prepare and counter attack the serve-volley. If the
ball from the serve comes slower, the opponent can prepare and hit a
passing shot or a lob (high ball) that counters a possible net approach.

Back in 2000, the ITF (International Tennis Federation) changed its
regulation in order to introduce three new types of balls that would
decrease the speed in hard courts and increase it in clay courts. The
idea was to make it so that the tennis matches became more interesting
for the audience to watch. It is not clear if this change was also set
in women tennis, but we will study its effect in the data as well. You
can find more details about the change in [this
article](http://www.independent.co.uk/sport/tennis/itf-introduces-three-types-of-balls-to-counter-power-game-9206610.html).

### Percentage of aces

Now, let's look at the impact of this change over the percentage of aces
from the total points of the game. We will also separate the results by
type of surface and gender. Here, we will use the *stats* files from the
repository. The information we need is in *ServeBasics*.

    # filenames
    my.f.m <- 'tennis_MatchChartingProject-master/charting-m-stats-ServeBasics.csv'
    my.f.w <- 'tennis_MatchChartingProject-master/charting-w-stats-ServeBasics.csv'

    # set cols
    my.cols <- cols(
      match_id = col_character(),
      row = col_character(),
      pts = col_integer(),
      pts_won = col_integer(),
      aces = col_integer(),
      unret = col_integer(),
      forced_err = col_integer(),
      pts_won_lte_3_shots = col_integer(),
      wide = col_integer(),
      body = col_integer(),
      t = col_integer()
    )

    # build dataframe
    my.df.serve <- bind_rows(read_csv(my.f.m, col_types = my.cols) %>% mutate(Gender = 'Men'),
                             read_csv(my.f.w, col_types = my.cols) %>% mutate(Gender = 'Women'))

    # set dates
    my.df.serve$Date <- as.Date(my.df.serve$match_id,'%Y%m%d')
    my.df.serve$Year <- format(my.df.serve$Date,'%Y')

    # get surface
    idx <- match(my.df.serve$match_id, my.df.matches$match_id)
    my.df.serve$Surface <- my.df.matches$Surface[idx]

    # plot it!
    p <- filter(my.df.serve,str_detect(row,'Total'),!is.na(Surface)) %>%
      group_by(Year,Gender,Surface) %>%
      summarise(`Percent of Aces` = sum(aces)/sum(pts)) %>%
      ggplot(aes(x=as.numeric(Year),y=`Percent of Aces`,color = Gender)) +
      geom_point()+geom_smooth()+
      facet_wrap(~Surface)

    print(p)

![](/img/2017-02-05-R-and-Tennis_files/figure-markdown_strict/aces-1.png)

The previou result show exactly what we expected. Looking at man's
tennis, the proportion of aces in clay did not show a significant change
in 2000. As a matter of fact, the proportion has increased over the
years. Clearly there is a break for grass and hard courts in 2000. It
seems that players were investing heavily in making aces. This changed
dramatically once the new balls were introduced.

What I've found surprising from the figures is how the difference is not
that big. Back in 1995, an *average* men's tennis match in a hard court
had around 15% of all points from aces. This decreased to only around 8%
in 2016. I would be very surprised if someone from an audience even
noticed such a change. I was expecting a bigger difference. Perhaps,
looking at games from the top 50 players this difference would be more
noticeable.

As for the woman's tennis, I don't acknowledge the same effect. We see
from the previous figures that the percentage of aces in the match are
in its highest values in the past few years. This result suggests that
the balls were not changed in female matches.

### Percentage of Net points

Another information to analyze is the percentage of net points. If the
change in the balls also affected this part of the game, then we can
expect that the proportion of net points has decreased after 2000. As
mentioned before, a net approach is easier to counter if the balls
travels slower. Let's have a look in what the data tells us.

    # files 
    my.f.m <- 'tennis_MatchChartingProject-master/charting-m-stats-NetPoints.csv'
    my.f.w <- 'tennis_MatchChartingProject-master/charting-w-stats-NetPoints.csv'

    # set cols
    my.cols <- cols(
      match_id = col_character(),
      player = col_integer(),
      row = col_character(),
      net_pts = col_integer(),
      pts_won = col_integer(),
      net_winner = col_integer(),
      induced_forced = col_integer(),
      net_unforced = col_integer(),
      passed_at_net = col_integer(),
      passing_shot_induced_forced = col_integer(),
      total_shots = col_integer()
    )

    # load data from csv
    my.df.netpts <- bind_rows(read_csv(my.f.m, col_types = my.cols) %>% mutate(Gender = 'Men'),
                              read_csv(my.f.w, col_types = my.cols) %>% mutate(Gender = 'Women'))

    # get dates and years
    my.df.netpts$Date <- as.Date(my.df.netpts$match_id,'%Y%m%d')
    my.df.netpts$Year <- format(my.df.netpts$Date,'%Y')

    # get surface
    idx <- match(my.df.netpts$match_id, my.df.matches$match_id)
    my.df.netpts$Surface <- my.df.matches$Surface[idx]

    # plot it!
    p <- filter(my.df.netpts,!is.na(Surface)) %>%
      group_by(Year, Gender, Surface) %>%
      summarise(`Percentage of net points` = sum(net_pts)/sum(total_shots)) %>%
      ggplot(aes(x=as.numeric(Year),y=`Percentage of net points`, color = Gender)) +
      geom_point()+geom_smooth() + facet_wrap(~Surface)

    print(p)

![](/img/2017-02-05-R-and-Tennis_files/figure-markdown_strict/netpts-1.png)

As expected, we find similar information from the previous analysis. Not
much of a change in seen in clay courts after 2000. This is the opposite
of hard courts, where the percentage of net point decreased dramatically
after 2000. In this case, however, the different is much larger. The
percentage of net points back in 2000 was around 35%. That decreased to
approximately 20% in 2016. A steeper difference from the change in the
proportion of aces seen before.

As for women tennis, we again don't see a big change. This result also
suggests that the new balls were not implemented in woman's tennis.

Conclusion
----------

In this post I showed some simple graphical analysis of the evolution of
tennis over time. I find that the change in the tennis ball's
composition back in 2000 made a significant impact in the game,
specially in grass and hard courts. The proportion of aces and net
points changed significantly.

In the next post, scheduled for next week, I will make a data analysis
of tennis players. I will focus first in the big names such as Federer
and Djokovic and later will analyze the Brazilian scene and the records
of the greatest Brazilian player (so far, i hope :) ), [Gustavo Kuerten
-
Guga](https://www.google.com.br/search?q=tennis&newwindow=1&safe=off&source=lnms&tbm=isch&sa=X&ved=0ahUKEwjO6PrvqvbRAhUDRSYKHfR_AJkQ_AUICCgB&biw=1360&bih=648#newwindow=1&safe=off&tbm=isch&q=tennis+guga).
As you can see, I am a big fan of him.

I hope you enjoyed this post. Fell free to leave your message at the
comments.
