---
layout: post
title: "Using R to study tennis players"
subtitle: "Looking at winning records of ATP top players and Brazilian tennists"
author: "Marcelo Perlin"
output: md_document
image: /img/tennis.jpg
tags: [R, tennis]
---

In the previous post about tennis, we studied how changes in ball's
composition in hard and grass courts affected the game back in 2000. In
this post, we will analyse a different dataset from the same repository,
and look at the players winning records in ATP matches. We will again
separate the result by the type of court.

The data
--------

I'm again using the great repository of tennis data of [Jeff
Sackmann](https://github.com/JeffSackmann/). In this case, however, I'm
using the [ATP repository](https://github.com/JeffSackmann/tennis_atp)
that contains ATP match data since 1968 until 2017. Again, I thank Jeff
Sackmann for making this dataset publicly available.

First, let's download and unzip the dataset. This is a large file with
35MB and it takes some time.

    zip.file <- 'TennisData_ATP.zip'

    # download file
    if (!file.exists(zip.file)){
      download.file('https://github.com/JeffSackmann/tennis_atp/archive/master.zip', destfile = zip.file)
      
    }

    # unzip it
    dir.out <- 'tennis_atp-master/'
    if (!dir.exists(dir.out)) unzip(zip.file)

Lets have a look at the contents of the zip file.

    my.f <- list.files(dir.out, pattern = '*.csv', full.names = T)
    print(my.f)

    ##   [1] "tennis_atp-master/atp_matches_1968.csv"           
    ##   [2] "tennis_atp-master/atp_matches_1969.csv"           
    ##   [3] "tennis_atp-master/atp_matches_1970.csv"           
    ##   [4] "tennis_atp-master/atp_matches_1971.csv"           
    ##   [5] "tennis_atp-master/atp_matches_1972.csv"           
    ##   [6] "tennis_atp-master/atp_matches_1973.csv"           
    ##   [7] "tennis_atp-master/atp_matches_1974.csv"           
    ##   [8] "tennis_atp-master/atp_matches_1975.csv"           
    ##   [9] "tennis_atp-master/atp_matches_1976.csv"           
    ##  [10] "tennis_atp-master/atp_matches_1977.csv"           
    ##  [11] "tennis_atp-master/atp_matches_1978.csv"           
    ##  [12] "tennis_atp-master/atp_matches_1979.csv"           
    ##  [13] "tennis_atp-master/atp_matches_1980.csv"           
    ##  [14] "tennis_atp-master/atp_matches_1981.csv"           
    ##  [15] "tennis_atp-master/atp_matches_1982.csv"           
    ##  [16] "tennis_atp-master/atp_matches_1983.csv"           
    ##  [17] "tennis_atp-master/atp_matches_1984.csv"           
    ##  [18] "tennis_atp-master/atp_matches_1985.csv"           
    ##  [19] "tennis_atp-master/atp_matches_1986.csv"           
    ##  [20] "tennis_atp-master/atp_matches_1987.csv"           
    ##  [21] "tennis_atp-master/atp_matches_1988.csv"           
    ##  [22] "tennis_atp-master/atp_matches_1989.csv"           
    ##  [23] "tennis_atp-master/atp_matches_1990.csv"           
    ##  [24] "tennis_atp-master/atp_matches_1991.csv"           
    ##  [25] "tennis_atp-master/atp_matches_1992.csv"           
    ##  [26] "tennis_atp-master/atp_matches_1993.csv"           
    ##  [27] "tennis_atp-master/atp_matches_1994.csv"           
    ##  [28] "tennis_atp-master/atp_matches_1995.csv"           
    ##  [29] "tennis_atp-master/atp_matches_1996.csv"           
    ##  [30] "tennis_atp-master/atp_matches_1997.csv"           
    ##  [31] "tennis_atp-master/atp_matches_1998.csv"           
    ##  [32] "tennis_atp-master/atp_matches_1999.csv"           
    ##  [33] "tennis_atp-master/atp_matches_2000.csv"           
    ##  [34] "tennis_atp-master/atp_matches_2001.csv"           
    ##  [35] "tennis_atp-master/atp_matches_2002.csv"           
    ##  [36] "tennis_atp-master/atp_matches_2003.csv"           
    ##  [37] "tennis_atp-master/atp_matches_2004.csv"           
    ##  [38] "tennis_atp-master/atp_matches_2005.csv"           
    ##  [39] "tennis_atp-master/atp_matches_2006.csv"           
    ##  [40] "tennis_atp-master/atp_matches_2007.csv"           
    ##  [41] "tennis_atp-master/atp_matches_2008.csv"           
    ##  [42] "tennis_atp-master/atp_matches_2009.csv"           
    ##  [43] "tennis_atp-master/atp_matches_2010.csv"           
    ##  [44] "tennis_atp-master/atp_matches_2011.csv"           
    ##  [45] "tennis_atp-master/atp_matches_2012.csv"           
    ##  [46] "tennis_atp-master/atp_matches_2013.csv"           
    ##  [47] "tennis_atp-master/atp_matches_2014.csv"           
    ##  [48] "tennis_atp-master/atp_matches_2015.csv"           
    ##  [49] "tennis_atp-master/atp_matches_2016.csv"           
    ##  [50] "tennis_atp-master/atp_matches_2017.csv"           
    ##  [51] "tennis_atp-master/atp_matches_futures_1991.csv"   
    ##  [52] "tennis_atp-master/atp_matches_futures_1992.csv"   
    ##  [53] "tennis_atp-master/atp_matches_futures_1993.csv"   
    ##  [54] "tennis_atp-master/atp_matches_futures_1994.csv"   
    ##  [55] "tennis_atp-master/atp_matches_futures_1995.csv"   
    ##  [56] "tennis_atp-master/atp_matches_futures_1996.csv"   
    ##  [57] "tennis_atp-master/atp_matches_futures_1997.csv"   
    ##  [58] "tennis_atp-master/atp_matches_futures_1998.csv"   
    ##  [59] "tennis_atp-master/atp_matches_futures_1999.csv"   
    ##  [60] "tennis_atp-master/atp_matches_futures_2000.csv"   
    ##  [61] "tennis_atp-master/atp_matches_futures_2001.csv"   
    ##  [62] "tennis_atp-master/atp_matches_futures_2002.csv"   
    ##  [63] "tennis_atp-master/atp_matches_futures_2003.csv"   
    ##  [64] "tennis_atp-master/atp_matches_futures_2004.csv"   
    ##  [65] "tennis_atp-master/atp_matches_futures_2005.csv"   
    ##  [66] "tennis_atp-master/atp_matches_futures_2006.csv"   
    ##  [67] "tennis_atp-master/atp_matches_futures_2007.csv"   
    ##  [68] "tennis_atp-master/atp_matches_futures_2008.csv"   
    ##  [69] "tennis_atp-master/atp_matches_futures_2009.csv"   
    ##  [70] "tennis_atp-master/atp_matches_futures_2010.csv"   
    ##  [71] "tennis_atp-master/atp_matches_futures_2011.csv"   
    ##  [72] "tennis_atp-master/atp_matches_futures_2012.csv"   
    ##  [73] "tennis_atp-master/atp_matches_futures_2013.csv"   
    ##  [74] "tennis_atp-master/atp_matches_futures_2014.csv"   
    ##  [75] "tennis_atp-master/atp_matches_futures_2015.csv"   
    ##  [76] "tennis_atp-master/atp_matches_futures_2016.csv"   
    ##  [77] "tennis_atp-master/atp_matches_futures_2017.csv"   
    ##  [78] "tennis_atp-master/atp_matches_qual_chall_1991.csv"
    ##  [79] "tennis_atp-master/atp_matches_qual_chall_1992.csv"
    ##  [80] "tennis_atp-master/atp_matches_qual_chall_1993.csv"
    ##  [81] "tennis_atp-master/atp_matches_qual_chall_1994.csv"
    ##  [82] "tennis_atp-master/atp_matches_qual_chall_1995.csv"
    ##  [83] "tennis_atp-master/atp_matches_qual_chall_1996.csv"
    ##  [84] "tennis_atp-master/atp_matches_qual_chall_1997.csv"
    ##  [85] "tennis_atp-master/atp_matches_qual_chall_1998.csv"
    ##  [86] "tennis_atp-master/atp_matches_qual_chall_1999.csv"
    ##  [87] "tennis_atp-master/atp_matches_qual_chall_2000.csv"
    ##  [88] "tennis_atp-master/atp_matches_qual_chall_2001.csv"
    ##  [89] "tennis_atp-master/atp_matches_qual_chall_2002.csv"
    ##  [90] "tennis_atp-master/atp_matches_qual_chall_2003.csv"
    ##  [91] "tennis_atp-master/atp_matches_qual_chall_2004.csv"
    ##  [92] "tennis_atp-master/atp_matches_qual_chall_2005.csv"
    ##  [93] "tennis_atp-master/atp_matches_qual_chall_2006.csv"
    ##  [94] "tennis_atp-master/atp_matches_qual_chall_2007.csv"
    ##  [95] "tennis_atp-master/atp_matches_qual_chall_2008.csv"
    ##  [96] "tennis_atp-master/atp_matches_qual_chall_2009.csv"
    ##  [97] "tennis_atp-master/atp_matches_qual_chall_2010.csv"
    ##  [98] "tennis_atp-master/atp_matches_qual_chall_2011.csv"
    ##  [99] "tennis_atp-master/atp_matches_qual_chall_2012.csv"
    ## [100] "tennis_atp-master/atp_matches_qual_chall_2013.csv"
    ## [101] "tennis_atp-master/atp_matches_qual_chall_2014.csv"
    ## [102] "tennis_atp-master/atp_matches_qual_chall_2015.csv"
    ## [103] "tennis_atp-master/atp_matches_qual_chall_2016.csv"
    ## [104] "tennis_atp-master/atp_matches_qual_chall_2017.csv"
    ## [105] "tennis_atp-master/atp_players.csv"                
    ## [106] "tennis_atp-master/atp_rankings_00s.csv"           
    ## [107] "tennis_atp-master/atp_rankings_10s.csv"           
    ## [108] "tennis_atp-master/atp_rankings_70s.csv"           
    ## [109] "tennis_atp-master/atp_rankings_80s.csv"           
    ## [110] "tennis_atp-master/atp_rankings_90s.csv"           
    ## [111] "tennis_atp-master/atp_rankings_current.csv"

Again, same as with the other post, we see a lot of files. The names are
quite suggesting and it is clear that not all files contains matches
data. Let's restrict the analysis just for the files with the string
`atp_matches`. This includes main matches, qualifications and futures
games.

    library(stringr)

    # restrict just for main atp matches
    my.f <- my.f[str_detect(my.f, 'matches')]
    my.f

    ##   [1] "tennis_atp-master/atp_matches_1968.csv"           
    ##   [2] "tennis_atp-master/atp_matches_1969.csv"           
    ##   [3] "tennis_atp-master/atp_matches_1970.csv"           
    ##   [4] "tennis_atp-master/atp_matches_1971.csv"           
    ##   [5] "tennis_atp-master/atp_matches_1972.csv"           
    ##   [6] "tennis_atp-master/atp_matches_1973.csv"           
    ##   [7] "tennis_atp-master/atp_matches_1974.csv"           
    ##   [8] "tennis_atp-master/atp_matches_1975.csv"           
    ##   [9] "tennis_atp-master/atp_matches_1976.csv"           
    ##  [10] "tennis_atp-master/atp_matches_1977.csv"           
    ##  [11] "tennis_atp-master/atp_matches_1978.csv"           
    ##  [12] "tennis_atp-master/atp_matches_1979.csv"           
    ##  [13] "tennis_atp-master/atp_matches_1980.csv"           
    ##  [14] "tennis_atp-master/atp_matches_1981.csv"           
    ##  [15] "tennis_atp-master/atp_matches_1982.csv"           
    ##  [16] "tennis_atp-master/atp_matches_1983.csv"           
    ##  [17] "tennis_atp-master/atp_matches_1984.csv"           
    ##  [18] "tennis_atp-master/atp_matches_1985.csv"           
    ##  [19] "tennis_atp-master/atp_matches_1986.csv"           
    ##  [20] "tennis_atp-master/atp_matches_1987.csv"           
    ##  [21] "tennis_atp-master/atp_matches_1988.csv"           
    ##  [22] "tennis_atp-master/atp_matches_1989.csv"           
    ##  [23] "tennis_atp-master/atp_matches_1990.csv"           
    ##  [24] "tennis_atp-master/atp_matches_1991.csv"           
    ##  [25] "tennis_atp-master/atp_matches_1992.csv"           
    ##  [26] "tennis_atp-master/atp_matches_1993.csv"           
    ##  [27] "tennis_atp-master/atp_matches_1994.csv"           
    ##  [28] "tennis_atp-master/atp_matches_1995.csv"           
    ##  [29] "tennis_atp-master/atp_matches_1996.csv"           
    ##  [30] "tennis_atp-master/atp_matches_1997.csv"           
    ##  [31] "tennis_atp-master/atp_matches_1998.csv"           
    ##  [32] "tennis_atp-master/atp_matches_1999.csv"           
    ##  [33] "tennis_atp-master/atp_matches_2000.csv"           
    ##  [34] "tennis_atp-master/atp_matches_2001.csv"           
    ##  [35] "tennis_atp-master/atp_matches_2002.csv"           
    ##  [36] "tennis_atp-master/atp_matches_2003.csv"           
    ##  [37] "tennis_atp-master/atp_matches_2004.csv"           
    ##  [38] "tennis_atp-master/atp_matches_2005.csv"           
    ##  [39] "tennis_atp-master/atp_matches_2006.csv"           
    ##  [40] "tennis_atp-master/atp_matches_2007.csv"           
    ##  [41] "tennis_atp-master/atp_matches_2008.csv"           
    ##  [42] "tennis_atp-master/atp_matches_2009.csv"           
    ##  [43] "tennis_atp-master/atp_matches_2010.csv"           
    ##  [44] "tennis_atp-master/atp_matches_2011.csv"           
    ##  [45] "tennis_atp-master/atp_matches_2012.csv"           
    ##  [46] "tennis_atp-master/atp_matches_2013.csv"           
    ##  [47] "tennis_atp-master/atp_matches_2014.csv"           
    ##  [48] "tennis_atp-master/atp_matches_2015.csv"           
    ##  [49] "tennis_atp-master/atp_matches_2016.csv"           
    ##  [50] "tennis_atp-master/atp_matches_2017.csv"           
    ##  [51] "tennis_atp-master/atp_matches_futures_1991.csv"   
    ##  [52] "tennis_atp-master/atp_matches_futures_1992.csv"   
    ##  [53] "tennis_atp-master/atp_matches_futures_1993.csv"   
    ##  [54] "tennis_atp-master/atp_matches_futures_1994.csv"   
    ##  [55] "tennis_atp-master/atp_matches_futures_1995.csv"   
    ##  [56] "tennis_atp-master/atp_matches_futures_1996.csv"   
    ##  [57] "tennis_atp-master/atp_matches_futures_1997.csv"   
    ##  [58] "tennis_atp-master/atp_matches_futures_1998.csv"   
    ##  [59] "tennis_atp-master/atp_matches_futures_1999.csv"   
    ##  [60] "tennis_atp-master/atp_matches_futures_2000.csv"   
    ##  [61] "tennis_atp-master/atp_matches_futures_2001.csv"   
    ##  [62] "tennis_atp-master/atp_matches_futures_2002.csv"   
    ##  [63] "tennis_atp-master/atp_matches_futures_2003.csv"   
    ##  [64] "tennis_atp-master/atp_matches_futures_2004.csv"   
    ##  [65] "tennis_atp-master/atp_matches_futures_2005.csv"   
    ##  [66] "tennis_atp-master/atp_matches_futures_2006.csv"   
    ##  [67] "tennis_atp-master/atp_matches_futures_2007.csv"   
    ##  [68] "tennis_atp-master/atp_matches_futures_2008.csv"   
    ##  [69] "tennis_atp-master/atp_matches_futures_2009.csv"   
    ##  [70] "tennis_atp-master/atp_matches_futures_2010.csv"   
    ##  [71] "tennis_atp-master/atp_matches_futures_2011.csv"   
    ##  [72] "tennis_atp-master/atp_matches_futures_2012.csv"   
    ##  [73] "tennis_atp-master/atp_matches_futures_2013.csv"   
    ##  [74] "tennis_atp-master/atp_matches_futures_2014.csv"   
    ##  [75] "tennis_atp-master/atp_matches_futures_2015.csv"   
    ##  [76] "tennis_atp-master/atp_matches_futures_2016.csv"   
    ##  [77] "tennis_atp-master/atp_matches_futures_2017.csv"   
    ##  [78] "tennis_atp-master/atp_matches_qual_chall_1991.csv"
    ##  [79] "tennis_atp-master/atp_matches_qual_chall_1992.csv"
    ##  [80] "tennis_atp-master/atp_matches_qual_chall_1993.csv"
    ##  [81] "tennis_atp-master/atp_matches_qual_chall_1994.csv"
    ##  [82] "tennis_atp-master/atp_matches_qual_chall_1995.csv"
    ##  [83] "tennis_atp-master/atp_matches_qual_chall_1996.csv"
    ##  [84] "tennis_atp-master/atp_matches_qual_chall_1997.csv"
    ##  [85] "tennis_atp-master/atp_matches_qual_chall_1998.csv"
    ##  [86] "tennis_atp-master/atp_matches_qual_chall_1999.csv"
    ##  [87] "tennis_atp-master/atp_matches_qual_chall_2000.csv"
    ##  [88] "tennis_atp-master/atp_matches_qual_chall_2001.csv"
    ##  [89] "tennis_atp-master/atp_matches_qual_chall_2002.csv"
    ##  [90] "tennis_atp-master/atp_matches_qual_chall_2003.csv"
    ##  [91] "tennis_atp-master/atp_matches_qual_chall_2004.csv"
    ##  [92] "tennis_atp-master/atp_matches_qual_chall_2005.csv"
    ##  [93] "tennis_atp-master/atp_matches_qual_chall_2006.csv"
    ##  [94] "tennis_atp-master/atp_matches_qual_chall_2007.csv"
    ##  [95] "tennis_atp-master/atp_matches_qual_chall_2008.csv"
    ##  [96] "tennis_atp-master/atp_matches_qual_chall_2009.csv"
    ##  [97] "tennis_atp-master/atp_matches_qual_chall_2010.csv"
    ##  [98] "tennis_atp-master/atp_matches_qual_chall_2011.csv"
    ##  [99] "tennis_atp-master/atp_matches_qual_chall_2012.csv"
    ## [100] "tennis_atp-master/atp_matches_qual_chall_2013.csv"
    ## [101] "tennis_atp-master/atp_matches_qual_chall_2014.csv"
    ## [102] "tennis_atp-master/atp_matches_qual_chall_2015.csv"
    ## [103] "tennis_atp-master/atp_matches_qual_chall_2016.csv"
    ## [104] "tennis_atp-master/atp_matches_qual_chall_2017.csv"

As you can see, I used string matching function `str_detect` from
`stringr` to find and keep just the csv files with the string *matches*
in its name. Now, let's load all files into a single dataframe.

    library(readr)
    library(dplyr)

    # set cols (missing some)
    my.cols <- cols(
      .default = col_integer(),
      tourney_id = col_character(),
      tourney_name = col_character(),
      surface = col_character(),
      tourney_level = col_character(),
      winner_entry = col_character(),
      winner_name = col_character(),
      winner_hand = col_character(),
      winner_ioc = col_character(),
      winner_age = col_double(),
      loser_entry = col_character(),
      loser_name = col_character(),
      loser_hand = col_character(),
      loser_ioc = col_character(),
      loser_age = col_double(),
      score = col_character(),
      round = col_character()
    )

    # load all files with lapply and do.call (some cols don't match in all files)
    df.matches <- do.call(bind_rows,lapply(my.f, read_csv, col_types = my.cols))

    # create year column
    df.matches$Date <- as.Date(as.character(df.matches$tourney_date),'%Y%m%d')
    df.matches$Year <- format(df.matches$Date,'%Y')

Let's see what the data offers.

    str(df.matches)

    ## Classes 'tbl_df', 'tbl' and 'data.frame':    667965 obs. of  51 variables:
    ##  $ tourney_id        : chr  "1968-580" "1968-580" "1968-580" "1968-580" ...
    ##  $ tourney_name      : chr  "Australian Chps." "Australian Chps." "Australian Chps." "Australian Chps." ...
    ##  $ surface           : chr  "Grass" "Grass" "Grass" "Grass" ...
    ##  $ draw_size         : int  64 64 64 64 64 64 64 64 64 64 ...
    ##  $ tourney_level     : chr  "G" "G" "G" "G" ...
    ##  $ tourney_date      : int  19680119 19680119 19680119 19680119 19680119 19680119 19680119 19680119 19680119 19680119 ...
    ##  $ match_num         : int  1 2 3 4 5 6 7 8 9 10 ...
    ##  $ winner_id         : int  110023 109803 100257 100105 109966 107759 100101 100025 108519 109799 ...
    ##  $ winner_seed       : int  NA NA NA 5 NA NA 12 3 NA NA ...
    ##  $ winner_entry      : chr  NA NA NA NA ...
    ##  $ winner_name       : chr  "Richard Coulthard" "John Brown" "Ross Case" "Allan Stone" ...
    ##  $ winner_hand       : chr  "R" "R" "R" "R" ...
    ##  $ winner_ht         : int  NA NA NA NA NA NA NA 173 NA NA ...
    ##  $ winner_ioc        : chr  "AUS" "AUS" "AUS" "AUS" ...
    ##  $ winner_age        : num  NA 27.5 16.2 22.3 29.9 ...
    ##  $ winner_rank       : int  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ winner_rank_points: int  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ loser_id          : int  107760 106964 110024 110025 110026 110027 110028 108430 110029 110030 ...
    ##  $ loser_seed        : int  NA NA 15 NA NA NA NA NA NA NA ...
    ##  $ loser_entry       : chr  NA NA NA NA ...
    ##  $ loser_name        : chr  "Max Senior" "Ernie Mccabe" "Gondo Widjojo" "Robert Layton" ...
    ##  $ loser_hand        : chr  "R" "R" "R" "R" ...
    ##  $ loser_ht          : int  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ loser_ioc         : chr  "AUS" "AUS" "INA" "AUS" ...
    ##  $ loser_age         : num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ loser_rank        : int  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ loser_rank_points : int  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ score             : chr  "12-10 7-5 4-6 7-5" "6-3 6-2 6-4" "6-4 3-6 6-3 7-5" "6-4 6-2 6-1" ...
    ##  $ best_of           : int  5 5 5 5 5 5 5 5 5 5 ...
    ##  $ round             : chr  "R64" "R64" "R64" "R64" ...
    ##  $ minutes           : int  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ w_ace             : int  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ w_df              : int  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ w_svpt            : int  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ w_1stIn           : int  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ w_1stWon          : int  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ w_2ndWon          : int  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ w_SvGms           : int  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ w_bpSaved         : int  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ w_bpFaced         : int  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ l_ace             : int  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ l_df              : int  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ l_svpt            : int  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ l_1stIn           : int  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ l_1stWon          : int  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ l_2ndWon          : int  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ l_SvGms           : int  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ l_bpSaved         : int  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ l_bpFaced         : int  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ Date              : Date, format: "1968-01-19" "1968-01-19" ...
    ##  $ Year              : chr  "1968" "1968" "1968" "1968" ...

Again, lots of information. Looks like the games are separated by rows,
where the columns have a lot of information about the matches. This
dataset is not as detailed as the last one with point by point data, but
still quite impressive.

Looking at top players winning percentages
==========================================

For our first analysis, lets look at the winning percentages of the top
10 players from the ATP rankings. For that, I will use package `rvest`
to scrape the information about the top ATP players from the [ATP
website](http://www.atpworldtour.com/en/rankings/singles).

    library(rvest)

    ## Loading required package: xml2

    ## 
    ## Attaching package: 'rvest'

    ## The following object is masked from 'package:readr':
    ## 
    ##     guess_encoding

    library(stringr)

    n.players <- 10

    my.url <- 'http://www.atpworldtour.com/en/rankings/singles'

    atp.players <- read_html(my.url) %>%
      html_nodes(".player-cell") %>%
      html_text() %>%
      str_replace_all('\\n','') %>%
      str_trim()

    name.player <- atp.players[1:n.players]
    print(name.player)

    ##  [1] "Andy Murray"    "Novak Djokovic" "Stan Wawrinka"  "Milos Raonic"  
    ##  [5] "Kei Nishikori"  "Rafael Nadal"   "Marin Cilic"    "Dominic Thiem" 
    ##  [9] "Roger Federer"  "Gael Monfils"

As you can see, we have to usual suspects. Andy Murray is now leading in
the first position, which was held previously by Djokovic for a long
period of time. I really like to see Dominic Thiem in the top ten as he
is the youngest with 23 year, a solid game, and lots of potential.
Federer is the oldest of the list, with 35 years old, but the most
talented. It is amazing how he can still stay competitive given the age
difference.

Back to the R analysis, a problem with this approach of scraping the
names from the ATP website is that they don't necessarily match the
names in the ATP files. As an example, the swiss player *Stan Wawrinka*
is named *Stanislas Wawrinka* in the csv files, while in the ATP website
is *Stan Wawrinka*. This means that directly trying to match the names
in `name.player` with the names in `df.matches` may not work. This is
classic case of data from difference sources that don't share the same
unique identifiers.

I usually solve this problem using a lookup table built manually in a
csv file, where I store the matching identifiers in the different
datasets. If the number of unique cases is small, it is quite doable.
For this analysis, however, we have 12325 players, which is definitely
too much. Manually creating a lookup table would be very demanding.

The solution I often in this case is to make the computer look for the
best *imperfect match* among the different identifiers (names). This is
also known as calculating **string distances** - the number of require
edits so that a string matches other, and can be accomplished in many
different ways. In this example I'll use function `amatch` from package
`stringdist`, with the basic options.

    library(stringdist)

    # get unique names from losers and winners
    unique.players <- unique(c(df.matches$winner_name, 
                               df.matches$loser_name ))

    # find the index of the closest string for each name in name.player
    idx <- amatch(name.player, unique.players, maxDist = 5)

Lets look at the result:

    print(data.frame(name.from.web = name.player,
                     name.from.atp = unique.players[idx] ))

    ##     name.from.web      name.from.atp
    ## 1     Andy Murray        Andy Murray
    ## 2  Novak Djokovic     Novak Djokovic
    ## 3   Stan Wawrinka Stanislas Wawrinka
    ## 4    Milos Raonic       Milos Raonic
    ## 5   Kei Nishikori      Kei Nishikori
    ## 6    Rafael Nadal       Rafael Nadal
    ## 7     Marin Cilic        Marin Cilic
    ## 8   Dominic Thiem      Dominic Thiem
    ## 9   Roger Federer      Roger Federer
    ## 10   Gael Monfils       Gael Monfils

Beautiful! For our case of just 10 players, it worked perfectly. The
name of Stan Wawrinka\_ was matched correctly. Be aware, however, that
this procedure of string matching is not guaranteed to work 100% of the
cases. You could also set NA values using the options in `amatch` but it
is still not guaranteed to work well. You should always manually check
the result.

Going forward, let's copy the players name from one to the other and use
a loop and `dplyr` to calculate yearly winning percentages of each
player, also separating by the type of surface. Using a loop here might
look odd, but this was the simplest solution I've found as you cannot
use `dplyr` directly. The dataframe `df.matches` is unique in the sense
that it has two informations in each row, you have a win for someone and
a loss to another player (see columns `winner_name` and `loser_name`).
If I use `dplyr` directly, I would miss the games where two players in
the list played each other. There is probably a way to adjust the
dataframe, but I just find it easier to loop over the players.

    # copy players name
    name.player <- unique.players[idx]

    # create table with players
    my.tab <- tibble()
    for (i.player in name.player) {
      
      temp <- filter(df.matches, (winner_name==i.player)|(loser_name==i.player))
      temp$Name <- i.player
      temp.tab <- temp %>% 
        group_by(Name, Year,surface) %>%
        summarise(`Percentage of wins` = sum(winner_name == Name)/n(),
                  `Number of matches` = n()) %>%
        filter(`Number of matches` > 0 ) %>%
        filter(surface %in% c('Hard','Clay'))
      
      my.tab <- bind_rows(my.tab,
                          temp.tab)
        
    }

    # use atp ranking in names e.g. Andy Murray (1)
    my.tab$Name <- paste0(my.tab$Name, 
                          ' (', 
                          match(my.tab$Name, name.player),
                          ')' )

    my.tab <- my.tab[complete.cases(my.tab), ]

Lets plot it!

    library(ggplot2)

    p <- ggplot(my.tab, aes(x = as.numeric(Year), y = `Percentage of wins`, color=surface))
    p <- p + geom_point() + geom_smooth()
    p <- p + facet_grid(surface~Name)
    p <- p + ylim(c(0.25,1)) + xlim(c(2005,2016))
    print(p)

![](/img/2017-02-13-R-and-Tennis-Players_files/figure-markdown_strict/unnamed-chunk-10-1.png)

We can see a few patterns. First, the winning consistency of top ten
player is higher in hard courts. For example, look at Murray and
Djokovic. It is easier for them to keep the same proportion of wins in
hard courts than it is in clay. My best guess is that hard courts are
more predictable and the ball is faster and bounces lower, making it
easier for top players to hit winners and other point-finishing strokes
such as drop shots. Be aware that this could also be due to the
different number of matches in each court. We could test the difference
of volatility statistically but I rather keep the analysis simple and
visual.

Also, not surprisingly, Nadal, [the king of
clay](https://www.youtube.com/watch?v=7mknZrjakM8), presents the highest
winning percentage in clay, before 2012. His game strategy uses strength
and heavy top spin balls that are difficult to counter. See
[here](https://www.quora.com/Why-is-Nadal-so-dominant-on-clay) for a
more detailed analysis on why he is so dominant on clay. The bad side of
his strategy and type of play is that it is based heavily on his
muscular strength. As his age increases, it is difficult to maintain the
same level. This explains the increased proportion of defeats after
2012.

The effect of age is also perceived for Roger Federer. But, given that
his style of play is not based just on strength, I think that he can
still beat a lot of players. Just look at the his recent title win at
the 2017 Australian open.

Now, look how Dojokovic is consistent in clay and hard courts. He is
definitely the player with the best stats. I predict that, if he works
for it, he will have no problem in taking the \#1 spot once again from
Murray.

Looking at Brazilian tennis players
===================================

In this section we will analyse the stats of Brazilian tennis players in
ATP rankings. The following code can be easily executed for any country
as the data is scraped from the ATP website. Just change the object
`my.country` for your case.

    my.country <- 'BRA'
    n.players <- 5
    my.url <- paste0('http://www.atpworldtour.com/en/rankings/singles?rankDate=2017-02-06&rankRange=0-500&countryCode=',my.country)

    atp.players <- read_html(my.url) %>%
      html_nodes(".player-cell") %>%
      html_text() %>%
      str_replace_all('\\n','') %>%
      str_trim()

    name.player <- atp.players[1:n.players]
    name.player

    ## [1] "Thiago Monteiro"     "Rogerio Dutra Silva" "Thomaz Bellucci"    
    ## [4] "Joao Souza"          "Andre Ghem"

The top five Brazilian players in ATP are Thiago Monteiro, Rogerio Dutra
Silva, Thomas Belluci, João Souza and Andre Ghem, in that order. We
should be proud of all of them. I can only imagine the dedication and
effort necessary to be a professional tennis player. You can see more
details about each
[here](http://www.atpworldtour.com/en/rankings/singles?rankDate=2017-02-06&rankRange=1-5000&countryCode=BRA).

At this point, it makes sense to create a function to analyse the
dataframe, as we will use it again later.

    plot.winning.perc <- function(name.player, 
                                  df.matches, 
                                  min.games.per.year = 0,
                                  min.year = 2005,
                                  max.year = 2016){
      require(stringdist)
      require(stringr)
      require(dplyr)
      require(ggplot2)
      
      # create year column
      df.matches$Date <- as.Date(as.character(df.matches$tourney_date),'%Y%m%d')
      df.matches$Year <- format(df.matches$Date,'%Y')
      
      # get unique names from losers and winners
      unique.players <- unique(c(df.matches$winner_name, 
                                 df.matches$loser_name ))
      
      # find the index of the closest string for each name in name.player
      idx <- amatch(name.player, unique.players, maxDist = 5)
      #print(data.frame(name.from.web = name.player,
       #                name.from.atp = unique.players[idx] ))
      
      my.tab <- tibble()
      for (i.player in name.player) {
        
        temp <- filter(df.matches, (winner_name==i.player)|(loser_name==i.player))
        temp$Name <- i.player
        temp.tab <- temp %>% 
          group_by(Name, Year,surface) %>%
          summarise(`Percentage of wins` = sum(winner_name == Name)/n(),
                    `Number of matches` = n()) %>%
          filter(`Number of matches` > min.games.per.year ) %>%
          filter(surface %in% c('Hard','Clay'))
        
        my.tab <- bind_rows(my.tab,
                            temp.tab)
        
      }
      
      p <- ggplot(my.tab, aes(x = as.numeric(Year), y = `Percentage of wins`, color=surface))
      p <- p + geom_point() + geom_smooth()
      p <- p + facet_grid(surface~Name)
      p <- p + ylim(c(0.25,1)) + xlim(c(min.year,max.year))
      
      return(p)
      
    }

Now, we use the previous function for the new names of players.

    # plot winnign percentages
    p <- plot.winning.perc(name.player, df.matches)
    print(p)

![](/img/2017-02-13-R-and-Tennis-Players_files/figure-markdown_strict/brplayers-1.png)

From this list, the youngest Brazilian player, and with most potential
in my opinion, is Thiago Monteiro. He is 22 and has lots of time to
improve his game. In 2016 he beated Tsonga in a great match [here in
Brazil](http://www.atpworldtour.com/en/news/monteiro-upsets-tsonga-in-rio-de-janeiro).

The records of Guga (Gustavo Kurten)
------------------------------------

For last, lets look at stats of the the best and most cherished singles
player from Brazil, [Gustavo Kuerten -
Guga](https://en.wikipedia.org/wiki/Gustavo_Kuerten). Guga is
internationally famous and reached \#1 in the ATP ranking in 2000. A
very charismatic player, with a fantastic backhand. It is not far
fetched to say that Guga brought Tennis to Brazil, making it a more
popular sport.

Guga had a hip injury back in 2001. He tried surgery, but it didn't
worked out and he wasn't able to maintain the higher level of tennis
that is necessary in the professional circuit. He retired in february of
2008. His story is very inspiring, growing up in the state of Santa
Catarina, in a time where tennis was not a popular sport in Brazil and
funding opportunities were scarce. His [biography (in
portuguese)](https://www.amazon.com/Gustavo-Kuerten/e/B00VOUXHS2) is an
excellent read.

Let's have a look in the data.

    name.player <- 'Gustavo Kuerten'

    p <- plot.winning.perc(name.player, df.matches, min.year = 1990)
    print(p)

![](/img/2017-02-13-R-and-Tennis-Players_files/figure-markdown_strict/guga-1.png)

As expected, a winning journey until 2001, when losses start to
accumulate.

Conlusion
---------

The data repository of Jeff Sackmann is great. I really only scratched
the surface with some simple graphical analysis. I think there is a lot
of space for modeling as well, that is, creating a model that can
predict the winning records of a player. I'm thinking about an
econometric model using historical statistics of players such as past
winning records, forehand/backhand winners, and so on. But I'm sure you
can use other approaches as well.

From the computational side, it would be interesting to create a CRAN
package to analyse this dataset. Just like in this post, all data could
be fetched from the ATP website and the repository of Jeff. One could
check the winning records of players with just a simple function call. I
just checked and there is nothing like it in CRAN. A shiny app would
also be interesting. I'll keep it in mind for the future.

I hope you liked this post. Any comments or suggestions, please share in
the comments section.
