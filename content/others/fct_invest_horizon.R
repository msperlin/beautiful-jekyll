sample.horizon <- function(price.vec, n.horizon, n.sim = 1000, rf.year = 0.0) {
  
  #cat(paste0('\nSimulating n.horizon = ', n.horizon))
  require(dplyr)
  
  rf_dailly <- ((1+rf.year)^(1/255))^n.horizon
  
  n.row <- length(price.vec)
  
  df.out <- data_frame()
  for (i.sim in 1:n.sim) {
    idx.1 <- sample(1:(n.row-n.horizon), 1)
    idx.2 <- idx.1 + n.horizon
    
    df.out <- bind_rows(df.out, data_frame(n.horizon = n.horizon/255,
                                           test = price.vec[idx.2] > price.vec[idx.1]*rf_dailly,
                                           ret = price.vec[idx.2]/price.vec[idx.1] -1))
    
  }
  
  return(df.out)
}

get.figs.invest.horizon <- function(ticker.in, first.date = '1950-01-01', 
                                    last.date = Sys.Date(), max.horizon = 10, n.points = 25, 
                                    rf.year = 0) {
  
  require(BatchGetSymbols)
  require(purrr)
  require(ggplot2)
  require(scales)
  
  my.df <- BatchGetSymbols(tickers = ticker.in, 
                           first.date = first.date, 
                           last.date = Sys.Date(), thresh.bad.data = 0.1)[[2]]
  
  my.df <- na.omit(my.df)
  
  my.l <- map2(list(my.df$price.adjusted), 
               seq(1, max.horizon, length.out = n.points), sample.horizon, rf.year = rf.year)
  
  
  df.res <- do.call(what = bind_rows, args = my.l) %>%
    group_by(n.horizon) %>%
    summarise(prob = sum(test)/n())
  
  p1 <- ggplot(data = df.res, aes(x = n.horizon, y = prob)) +
    geom_point() + geom_smooth() + 
    labs(x = 'Investment Horizon (years)', y = 'Chance of Profit', 
         title = paste0('Asset: ', ticker.in),
         subtitle = paste0(min(my.df$ref.date), ' -> ', max(my.df$ref.date)) ) + 
    scale_y_continuous(labels=percent)
  
  df.plot <- do.call(what = bind_rows, args = my.l)
  p2 <- ggplot(data = df.plot, aes(x = factor(floor(n.horizon)), y = ret)) +
    geom_boxplot() + 
    labs(x = 'Investment Horizon (Years)', 
         y = 'Distribution of Returns', 
         title = paste0('Asset: ', ticker.in),
         subtitle = paste0(min(my.df$ref.date), ' -> ', max(my.df$ref.date)) ) + 
    scale_y_continuous(labels=percent)
  
  return(list(p1 = p1, p2 = p2))
  
}
