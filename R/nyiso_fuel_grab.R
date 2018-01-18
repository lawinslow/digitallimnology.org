library(lubridate)
library(httr)
library(dplyr)
library(ggplot2)

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


### cheap and easy timeseries plot
d_daily = aggregate(d, list(date=as.character(trunc.POSIXt(d$datetime, units = 'days'))), FUN=mean)
d_daily$datetime = NULL
d_daily$date = as.Date(d_daily$date)
d_daily_long = reshape2::melt(d_daily, id.vars='date', variable.name='Fuel', value.name='Power')

ggplot(d_daily_long) + geom_line(aes(date, Power, color=Fuel), size=1) + theme_minimal()

ggsave('images/all_fuel_timeseries.png', width=12)

##

png('figure/fuel_correlation.png', res=300, height=1500, width=1800)
par(mar=c(6,7,1,1))

col = colorRamps::blue2red(27)
col[ceiling(length(col)/2)] = rgb(0,0,0,0)

mp = image(cor_mat, x = seq_along(fuels), y=seq_along(fuels), zlim=c(-0.3,0.3), xaxt='n', yaxt='n', ylab='', xlab='', col=col)

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
dev.off()

