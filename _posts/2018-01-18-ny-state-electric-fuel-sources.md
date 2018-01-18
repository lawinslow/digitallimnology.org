---
title: "NY State Electric Fuel Sources"
author: "Luke Winslow"
date: "January 18, 2018"
output: html_document
---


New York state has excellent open, online data available on the generation and consumption 
of electricity in the state. So I decided to look into what fuels go into generating electricity in New York.

## NY Fuel Mix Data

To start with, I created a quick function to download and process the historical fuel mix data on the [NY-ISO website](http://www.nyiso.com/). 
It comes as a bunch of individual CSV's, bulk zipped by month. It would be a pain to manually load, but a little code goes a long way.
As usual, I am using R here. Loading and processing code is a bit long, so I stuck it at the end of this post. 




## Overall fuel usage

First cut, I looked at the overall fuel usage timeseries. The NY-ISO website shows immediate and past-day fuel usage, but I really wanted
to see full season (and multi-year) usgae. To make it a bit more readable, I aggregated to a daily timestep first. The full 5-minute raw 
dataset was a bit dense at this scale. Thoughts/analysis after the figure. 




```r
### cheap and easy timeseries plot
d_daily = aggregate(d, list(date=as.character(trunc.POSIXt(d$datetime, units = 'days'))), FUN=mean)
d_daily$datetime = NULL
d_daily$date = as.Date(d_daily$date)
d_daily_long = reshape2::melt(d_daily, id.vars='date', variable.name='Fuel', value.name='Power')

ggplot(d_daily_long) + geom_line(aes(date, Power, color=Fuel), size=1) + theme_minimal()
```

![plot of chunk fuel usage](/figure/fuel usage-1.png)

### Notes and interpretation.

1. Dual fuel and natural gas is highly variable (dual fuel includes both fuel oil and natural gas supplies). These are
being used to respond to peaks in demand, such as during the summer. 

2. Interestingly, we see both a peak in demand (and Dual Fuel usage) in the summers as well as during the last winter month of 
2017/2018. During that time, we had a lot of power demand and a large natural gas demand for home heating. I think a lot of dual
fuel plants switched to heavier petroleum fuels during this time to ease off natural gas supplies. 

3. Nuclear doesn't vary much, beyond what I assume are long-term refueling and maintenance shutdowns. Not looking too closely, it seems
like they might schedule those longer-term maintenance periods during the spring. Probably very predictable low power requirements 
(lots of sun, no A/C demand, low heating demand). 

4. NY state doesn't use a lot of coal (captured under as "Other Fossil Fuels"). But within "Dual Fuel", it probably uses a lot of 
petroleum products during peak periods. Not clear the breakdown of natural gas/petroleum there.

5. Other renewables is pretty steady. These data don't capture behind-the-meter solar, so we don't see the variability we might if it did. 
This number must capture some pretty steady-output renewables. Maybe landfill gas production, geothermal, others. 

6. Wind plays a role, but it is highly variable. 

7. One point to make strongly, this is a **FAR LOWER** coal mix than other generation regions. Check out the fuel mix on the [MISO website](https://www.misoenergy.org/markets-and-operations/real-time-displays/). Currently shows > 50% coal at the time of writing. 


## Correlations among fuels. 

One question I had with this fuels analysis was: "What fuel sources are used to compensate for other variable energy sources, like solar 
and wind?" I did a simple correlation analysis to look at this with some interesting (and unexpected) results. Its not the most beautiful 
figure generaiton code, but it gets there. 

For those interested, I do a spearman rank correlation on the first difference of the timeseries. I do a rank-correlation so I don't have 
to worry too much about outliers and other weird data bits giving biased results. Further, I do the correlation on the differnces to 
see how they *change* together. Not just how the magnitudes correlate, which may be fairly seasonal (maybe everything is higher in the summer, 
not super interesting). I build a triangular matrix for visualization. 

I am running the analysis on daily aggregate data as, I am assuming 
that most of these generators aren't responding at the 5-minute scale. Also, the daily analysis just works out better at a first cut. 


```r
fuels = names(d)[-8]
cor_mat = matrix(NA, nrow = length(fuels), ncol = length(fuels))

for(i in seq_along(fuels)){
  for(j in i:length(fuels)){
    if(i == j){
      #do nothing    
    }else{
      cor_mat[i, j] = cor(diff(d_daily[,fuels[i]]), diff(d_daily[,fuels[j]]), method = 'spearman') 
    }
  }
}

#output figure
par(mar=c(6,7,1,1))

col = colorRamps::blue2red(27)
col[ceiling(length(col)/2)] = rgb(0,0,0,0)

mp = image(cor_mat, x = seq_along(fuels), y=seq_along(fuels), zlim=c(-0.7,0.7), xaxt='n', yaxt='n', ylab='', xlab='', col=col)

text(x=par()$usr[1]-0.05*(par()$usr[2]-par()$usr[1]), y=1:length(fuels), labels=fuels, srt=45, adj=1, xpd=TRUE, cex=0.8)
#axis(1, at=seq_along(fuels), labels = rep('', length(fuels)))
text(x=1:length(fuels), y=par()$usr[3]-0.05*(par()$usr[4]-par()$usr[3]), labels=fuels, srt=45, adj=1, xpd=TRUE, cex=0.8)
#axis(2, at=seq_along(fuels), labels = fuels)

for(i in seq_along(fuels)){
  for(j in i:length(fuels)){
    if(i == j){
      #nothing 
    }else{
      text(i, j, sprintf('%0.2f', cor_mat[i,j]), cex=0.8)
    }
  }
}
```

![plot of chunk fuelcorrelation](/figure/fuelcorrelation-1.png)

### My thoughts
1. Wind variability is compensated using hydro primarily. Though the other fuels also clearly play a role (except fossils and dual apparently). 

2. Other renewables is also largely compensatory with other fuels. It probably doesn't respond to demand, it generates what it can and when 
it drops, other fuels have to pick up the slack. 

3. You can see very clearly natural gas, hydro, and dual fuel are probably responding to demand and non-variable generation. (as is other fossil fuels)

4. Cool. I wish all the ISO's would publish this data (looking at you [MISO](https://www.misoenergy.org/)). 


## 5-minute scale analysis

The 5-minute scale analysis is still potentially interesting. Below shows the results (I skip the code, it is redundant with the above analysis). 
Note the color scale is tighter compared with above. 

![plot of chunk fuelcorrelationhighres](/figure/fuelcorrelationhighres-1.png)


### Notes and interpretation.
1. Natural gas and Dual Fuel are very correlated at a short-scale. This isn't really surprising as "Dual Fuel" is actually **also** natural gas. So 
they respond to the same price and need signals. 

2. Hydro and natural gas are moving together. Both are able to respond quickly to demand increases (and drops). 

3. In New York state, at a fine scale, it looks like hydro and natural gas/dual fuel are being used to respond to variations in wind power. Cool. 

4. Correlations were neglible for most other fuel combinations. Nuclear doesn't respond to *anything*. Not surprisingly. 


## Download and process code

The following code was what I used to grab and 



```r
library(lubridate)
library(httr)
library(dplyr)

yearmonths = seq.POSIXt(as.POSIXct('2016-01-01'), as.POSIXct('2018-01-01'), by='month')

download_fuels = function(yearmonth){
  durl = sprintf('http://mis.nyiso.com/public/csv/rtfuelmix/%0.4i%0.2i01rtfuelmix_csv.zip', year(yearmonth), month(yearmonth))
  tfile = tempfile(fileext='.zip')
  tdir = file.path(tempdir(), 'mix')
  dir.create(tdir)
  r = httr::GET(durl, httr::write_disk(tfile, overwrite = TRUE))
  files = unzip(tfile, exdir=tdir) 
  d = dplyr::bind_rows(lapply(files, read.csv, header=TRUE, as.is=TRUE))
  d$Gen.MWh = d$Gen.MW
  unlink(files)
  return(reshape2::dcast(d, Time.Stamp~Fuel.Category, value.var='Gen.MWh', fun.aggregate = sum))
}

out = lapply(yearmonths, download_fuels)
d = dplyr::bind_rows(out)
d$datetime = as.POSIXct(strptime(d$Time.Stamp, '%m/%d/%Y %H:%M'))
d$Time.Stamp = NULL
d = dplyr::arrange(d, datetime)

fuels = names(d)[-8]
cor_mat = matrix(NA, nrow = length(fuels), ncol = length(fuels))

for(i in seq_along(fuels)){
  for(j in i:length(fuels)){
    if(i == j){
      #do nothing    
    }else{
      cor_mat[i, j] = cor(diff(d[,fuels[i]]), diff(d[,fuels[j]]), method = 'spearman') 
    }
  }
}
```
