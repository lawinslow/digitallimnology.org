---
title: "NLDAS Wind Problem"
author: "Luke Winslow"
date: "March 7, 2017"
output: html_document
---

## NLDAS

NLDAS (National Land Data Assimilation System) from [nasa](https://ldas.gsfc.nasa.gov/nldas/) is an awesome data product. 
Time and time again, I have found it to be an outstanding representation of meterological drivers across the US. At the very 
least, in the regions I am working. 

That being said, with NLDAS, I have struggled with one big thing: Wind speed. For some reason, in the upper midwest, myself and colleagues
have [found a step change in the wind speed data](https://github.com/USGS-R/mda.lakes/issues/70). This [seems to come
from](https://github.com/USGS-R/mda.lakes/issues/72) one of the source datasets, the North American Regional Reanalysis
[NARR](https://www.esrl.noaa.gov/psd/data/gridded/data.narr.html).

In earlier work, I've just used a simple multipler correction for data after 2001. But now that this new Macrosystems grant
from the NSF is operating at a continental scale, I need to figure out what's going on more broadly. I noticed the other
day that the step change in 2001 is of course different in the Northeastern United States, thus making my simple 
step change fix no longer applicable. 

Joy. 

So let's see how this step change looks across the whole dataset. To do that, I'll average wind speed for a few years before 2001 and 
compare it to average wind speed after 2001. This is kinda ugly because my desktop only has 32GB of RAM so I can't load the whole dataset
all at once. 



```r
library(ncdf4)

#this happens to be where I store my re-processed NLDAS data
uwind = nc_open('z:/big_datasets/NLDAS/driver_ncdf4_NLDAS/UGRD10m_110_HTGL.nc4')
vwind = nc_open('z:/big_datasets/NLDAS/driver_ncdf4_NLDAS/VGRD10m_110_HTGL.nc4')


time = ncvar_get(uwind, 'time')
time = as.POSIXct(time, origin='1970-01-01', tz='UTC')


#diff(range(which(time > as.POSIXct('1999-01-01') & time < as.POSIXct('2000-01-01'))))
#range(which(time > as.POSIXct('2001-01-01') & time < as.POSIXct('2003-01-01')))

earlyall = list()
for(i in 1995:2000){
  starti = min(which(time > as.POSIXct(paste0(i, '-01-01'))))
  
  early = ncvar_get(uwind, 'UGRD10m_110_HTGL', start=c(1,1,starti), count=c(464,224,8757))
  earlyall[[i]] = apply(early, 1:2, mean)
  gc()
  cat(i, '\n')
}
```

```
## 1995 
## 1996 
## 1997 
## 1998 
## 1999 
## 2000
```

```r
early = apply(abind::abind(earlyall[1995:2000], along = 0), 2:3, mean)


lateall = list()
for(i in 2001:2006){
  starti = min(which(time > as.POSIXct(paste0(i, '-01-01'))))
  
  late = ncvar_get(uwind, 'UGRD10m_110_HTGL', start=c(1,1,starti), count=c(464,224,8757))
  lateall[[i]] = apply(late, 1:2, mean)
  gc()
}

late = apply(abind::abind(lateall[2001:2006], along = 0), 2:3, mean)
```


So the change from before to after 2001 definitely varies regionally. Much of the northeast is 
apparently pretty close to 0 change across that time period (which is desirable). 


![plot of chunk plot](/figure/plot-1.png)
