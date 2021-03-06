library("GoFKernel")
setwd("~/Desktop/function3")
library(xlsx)
raw.LO.inva <- read.xlsx("points of LO.xlsx",sheetIndex=1)
LO.xy.inva <- raw.LO.inva[,1:2]
raw.LRT.inva <- read.xlsx("LRT_inva.xlsx",sheetIndex=1)
LRT.xy.inva <- raw.LRT.inva[,1:2]
raw.LO.dcis <- read.xlsx("LO_dcis.xlsx",sheetIndex=1)
LO.xy.dcis <- raw.LO.dcis[,1:2]
raw.LRT.dcis <- read.xlsx("LRT_dcis.xlsx",sheetIndex=1)
LRT.xy.dcis <- raw.LRT.dcis[,1:2]
raw.LO.con <- read.xlsx("LO.con.xlsx",sheetIndex=1)
LO.xy.con <- raw.LO.con[,1:2]
raw.LRT.con <- read.xlsx("LRT.con.xlsx",sheetIndex=1)
LRT.xy.con <- raw.LRT.con[,1:2]

#linear interpolation
fun.LO.inva <- approxfun(x=c(0,LO.xy.inva$x,60),y=c(0,LO.xy.inva$y/100,1), method="linear")
fun.LO.dcis <- approxfun(x=c(0,LO.xy.dcis$x,60),y=c(0,LO.xy.dcis$y/100,1), method="linear")
fun.LO.con <- approxfun(x=c(0,LO.xy.con$x,60),y=c(0,LO.xy.con$y/100,1), method="linear")

fun.LRT.inva <- approxfun(x=c(0,LRT.xy.inva$x,60),y=c(0,LRT.xy.inva$y/100,1), method="linear")
fun.LRT.dcis <- approxfun(x=c(0,LRT.xy.dcis$x,60),y=c(0,LRT.xy.dcis$y/100,1), method="linear")
fun.LRT.con <- approxfun(x=c(0,LRT.xy.con$x,60),y=c(0,LRT.xy.con$y/100,1), method="linear")

#get the inverse of these function
inver.LO.inva <- inverse(fun.LO.inva,lower=0,upper=60)
inver.LO.dcis <- inverse(fun.LO.dcis,lower=0,upper=60)
inver.LO.con <- inverse(fun.LO.con,lower=0,upper=60)

inver.LRT.inva <- inverse(fun.LRT.inva,lower=0,upper=60)
inver.LRT.dcis <- inverse(fun.LRT.dcis,lower=0,upper=60)
inver.LRT.con <- inverse(fun.LRT.con,lower=0,upper=60)

#return a list of output from the function
#1 for LO.inva
#2 for LO.dcis
#3 for LO.con
#4 for LRT.inva
#5 for LRT.dcis
#5 fot LRT.con
fun.all <- function(u,type)
{
  if(type==1)
  {
    fun = fun.LO.inva
  }
  if(type==2)
  {
    fun = fun.LO.dcis
  }
  if(type==3)
  {
    fun = fun.LO.con
  }
  if(type==4)
  {
    fun = fun.LRT.inva
  }
  if(type==5)
  {
    fun = fun.LRT.dcis
  }
  if(type==6)
  {
    fun = fun.LRT.con
  }
  y.value <- rep(NA,length(u))
  for(j in 1:length(u))
  {
    y.value[j] <- fun(u[j])
  }
  return(y.value)
}

#compare empirical cdf from simulation to the true cdf
#Cumulative incidence rate of Invasive LO
x.seq <- seq(0,60,0.01)
y.LO.inva <- fun.all(x.seq,1)
plot(x.seq, y.LO.inva, xlab = "Years",ylab = "cumulative incidence",
     main = "Cumulative incidence rate of Invasive LO",lty=1,type='l',pch=1,col="red")
par(new=TRUE)
plot(c(0,LO.xy.inva$x),c(0,LO.xy.inva$y/100),col="purple",pch=1,cex=0.6,xlab = "Years",
     ylab = "cumulative incidence",ylim=c(0,1),xlim=c(0,60))
legend("topleft",
       legend=c("Interpolation","Observed data"),
       col =c("red","purple"),inset=.02,cex=0.6,pch=1)


#Cumulative incidence rate of DCIS LO
y.LO.dcis <- fun.all(x.seq,2)
plot(x.seq, y.LO.dcis, xlab = "Years",ylab = "cumulative incidence",
     main = "Cumulative incidence rate of DCIS LO",lty=1,type='l',pch=1,col="red")
par(new=TRUE)
plot(c(0,LO.xy.dcis$x),c(0,LO.xy.dcis$y/100),col="purple",pch=1,cex=0.6,xlab = "Years",
     ylab = "cumulative incidence",ylim=c(0,1),xlim=c(0,60))
legend("topleft",
       legend=c("Interpolation","Observed data"),
       col =c("red","purple"),inset=.02,cex=0.6,pch=1)

#Cumulative incidence rate of Contralateral LO
y.LO.con <- fun.all(x.seq,3)
plot(x.seq, y.LO.con, xlab = "Years",ylab = "cumulative incidence",
     main = "Cumulative incidence rate of Contralateral LO",lty=1,type='l',pch=1,col="red")
par(new=TRUE)
plot(c(0,LO.xy.con$x),c(0,LO.xy.con$y/100),col="purple",pch=1,cex=0.6,xlab = "Years",
     ylab = "cumulative incidence",ylim=c(0,1),xlim=c(0,60))
legend("topleft",
       legend=c("Interpolation","Observed data"),
       col =c("red","purple"),inset=.02,cex=0.6,pch=1)


#Cumulative incidence rate of Invasive LRT
x.seq <- seq(0,60,0.01)
y.LRT.inva <- fun.all(x.seq,4)
plot(x.seq, y.LRT.inva, xlab = "Years",ylab = "cumulative incidence",
     main = "Cumulative incidence rate of Invasive LRT",lty=1,type='l',pch=1,col="red")
par(new=TRUE)
plot(c(0,LRT.xy.inva$x),c(0,LRT.xy.inva$y/100),col="purple",pch=1,cex=0.6,xlab = "Years",
     ylab = "cumulative incidence",ylim=c(0,1),xlim=c(0,60))
legend("topleft",
       legend=c("Interpolation","Observed data"),
       col =c("red","purple"),inset=.02,cex=0.6,pch=1)


#Cumulative incidence rate of DCIS LRT
y.LRT.dcis <- fun.all(x.seq,5)
plot(x.seq, y.LRT.dcis, xlab = "Years",ylab = "cumulative incidence",
     main = "Cumulative incidence rate of DCIS LRT",lty=1,type='l',pch=1,col="red")
par(new=TRUE)
plot(c(0,LRT.xy.dcis$x),c(0,LRT.xy.dcis$y/100),col="purple",pch=1,cex=0.6,xlab = "Years",
     ylab = "cumulative incidence",ylim=c(0,1),xlim=c(0,60))
legend("topleft",
       legend=c("Interpolation","Observed data"),
       col =c("red","purple"),inset=.02,cex=0.6,pch=1)

#Cumulative incidence rate of Contralateral LRT
y.LRT.con <- fun.all(x.seq,6)
plot(x.seq, y.LRT.con, xlab = "Years",ylab = "cumulative incidence",
     main = "Cumulative incidence rate of Contralateral LRT",lty=1,type='l',pch=1,col="red")
par(new=TRUE)
plot(c(0,LRT.xy.con$x),c(0,LRT.xy.con$y/100),col="purple",pch=1,cex=0.6,xlab = "Years",
     ylab = "cumulative incidence",ylim=c(0,1),xlim=c(0,60))
legend("topleft",
       legend=c("Interpolation","Observed data"),
       col =c("red","purple"),inset=.02,cex=0.6,pch=1)

#get the inverse of these function
inver.LO.inva <- inverse(fun.LO.inva,lower=0,upper=60)
inver.LO.dcis <- inverse(fun.LO.dcis,lower=0,upper=60)
inver.LO.con <- inverse(fun.LO.con,lower=0,upper=60)

inver.LRT.inva <- inverse(fun.LRT.inva,lower=0,upper=60)
inver.LRT.dcis <- inverse(fun.LRT.dcis,lower=0,upper=60)
inver.LRT.con <- inverse(fun.LRT.con,lower=0,upper=60)

#check whether the inverse function is correct or not
#return a list of xvalue from the function
#1 for LO.inva
#2 for LO.dcis
#3 for LO.con
#4 for LRT.inva
#5 for LRT.dcis
#5 fot LRT.con
fun.inver <- function(u,type)
{
  if(type==1)
  {
    fun = inver.LO.inva
  }
  if(type==2)
  {
    fun = inver.LO.dcis
  }
  if(type==3)
  {
    fun = inver.LO.con
  }
  if(type==4)
  {
    fun = inver.LRT.inva
  }
  if(type==5)
  {
    fun = inver.LRT.dcis
  }
  if(type==6)
  {
    fun = inver.LRT.con
  }
  x.value <- rep(NA,length(u))
  for(j in 1:length(u))
  {
    x.value[j] <- fun(u[j])
  }
  return(x.value)
}

#compare empirical cdf from simulation to the true cdf
#double check the inverse function is right or not
#Cumulative incidence rate of Invasive LO
y.seq <- runif(10000,0,1)
x.LO.inva <- fun.inver(y.seq,1)
plot(x.LO.inva, y.seq, xlab = "Years",ylab = "cumulative incidence",
     main = "Cumulative incidence rate of Invasive LO",lty=1,type='p',pch=1,col="red",
     ylim=c(0,1),xlim=c(0,60),cex=0.4)
par(new=TRUE)
plot(c(0,LO.xy.inva$x),c(0,LO.xy.inva$y/100),col="purple",pch=1,cex=0.6,xlab = "Years",
     ylab = "cumulative incidence",ylim=c(0,1),xlim=c(0,60))
legend("topleft",
       legend=c("Interpolation","Observed data"),
       col =c("red","purple"),inset=.02,cex=0.6,pch=1)


#Cumulative incidence rate of DCIS LO
x.LO.dcis <- fun.inver(y.seq,2)
plot(x.LO.dcis,y.seq, xlab = "Years",ylab = "cumulative incidence",
     main = "Cumulative incidence rate of DCIS LO",lty=1,type='p',pch=1,col="red",
     ylim=c(0,1),xlim=c(0,60),cex=0.4)
par(new=TRUE)
plot(c(0,LO.xy.dcis$x),c(0,LO.xy.dcis$y/100),col="purple",pch=1,cex=0.6,xlab = "Years",
     ylab = "cumulative incidence",ylim=c(0,1),xlim=c(0,60))
legend("topleft",
       legend=c("Interpolation","Observed data"),
       col =c("red","purple"),inset=.02,cex=0.6,pch=1)

#Cumulative incidence rate of Contralateral LO
x.LO.con <- fun.inver(y.seq,3)
plot(x.LO.con, y.seq, xlab = "Years",ylab = "cumulative incidence",
     main = "Cumulative incidence rate of Contralateral LO",lty=1,type='p',pch=1,col="red",
     ylim=c(0,1),xlim=c(0,60),cex=0.4)
par(new=TRUE)
plot(c(0,LO.xy.con$x),c(0,LO.xy.con$y/100),col="purple",pch=1,cex=0.6,xlab = "Years",
     ylab = "cumulative incidence",ylim=c(0,1),xlim=c(0,60))
legend("topleft",
       legend=c("Interpolation","Observed data"),
       col =c("red","purple"),inset=.02,cex=0.6,pch=1)


#Cumulative incidence rate of Invasive LRT
x.LRT.inva <- fun.inver(y.seq,4)
plot(x.LRT.inva, y.seq, xlab = "Years",ylab = "cumulative incidence",
     main = "Cumulative incidence rate of Invasive LRT",lty=1,type='p',pch=0.6,col="red",
     ylim=c(0,1),xlim=c(0,60),cex=0.4)
par(new=TRUE)
plot(c(0,LRT.xy.inva$x),c(0,LRT.xy.inva$y/100),col="purple",pch=1,cex=0.6,xlab = "Years",
     ylab = "cumulative incidence",ylim=c(0,1),xlim=c(0,60))
legend("topleft",
       legend=c("Interpolation","Observed data"),
       col =c("red","purple"),inset=.02,cex=0.6,pch=1)


#Cumulative incidence rate of DCIS LRT
x.LRT.dcis <- fun.inver(y.seq,5)
plot(x.LRT.dcis, y.seq, xlab = "Years",ylab = "cumulative incidence",
     main = "Cumulative incidence rate of DCIS LRT",lty=1,type='p',pch=0.6,col="red",
     ylim=c(0,1),xlim=c(0,60),cex=0.4)
par(new=TRUE)
plot(c(0,LRT.xy.dcis$x),c(0,LRT.xy.dcis$y/100),col="purple",pch=1,cex=0.6,xlab = "Years",
     ylab = "cumulative incidence",ylim=c(0,1),xlim=c(0,60))
legend("topleft",
       legend=c("Interpolation","Observed data"),
       col =c("red","purple"),inset=.02,cex=0.6,pch=1)

#Cumulative incidence rate of Contralateral LRT
x.LRT.con <- fun.inver(y.seq,6)
plot(x.LRT.con, y.seq, xlab = "Years",ylab = "cumulative incidence",
     main = "Cumulative incidence rate of Contralateral LRT",type='p',pch=0.6,
     ylim=c(0,1),xlim=c(0,60),col="red",cex=0.4)
par(new=TRUE)
plot(c(0,LRT.xy.con$x),c(0,LRT.xy.con$y/100),col="purple",pch=1,cex=0.6,xlab = "Years",
     ylab = "cumulative incidence",ylim=c(0,1),xlim=c(0,60))
legend("topleft",
       legend=c("Interpolation","Observed data"),
       col =c("red","purple"),inset=.02,cex=0.6,pch=1)


#Simulate the trial arms: 
#lumpectomy
#lumpectomy + radiation
#active surveillance. Rho=.19, psi=70%, beta=80%, lambda=.1/(5 years).

#assume independent
#according to the paper we should need survival data
#just accumulate the result
#may not be true
#time to progression multistate event
#use graph to show the result

#for LO
T <- seq(0,60,0.001)
plot(T, fun.all(T,3), xlab = "Years",ylab = "cumulative incidence",
     main = "Cumulative incidence rate of LO",lty=1,type='l',pch=1,col="red",ylim=c(0,1))
par(new=TRUE)
plot(T, fun.all(T,3)+fun.all(T,2), xlab = "Years",ylab = "cumulative incidence",
     lty=1,type='l',pch=1,col="purple",
     ylim=c(0,1))
par(new=TRUE)
plot(T, fun.all(T,1)+fun.all(T,2)+fun.all(T,3), xlab = "Years",ylab = "cumulative incidence"
     ,lty=1,type='l',pch=1,col="blue",
     ylim=c(0,1))

legend("topleft",
       legend=c("Contralateral Cancer","Contralateral Cancer+Ipsilateral DCIS",
                "Contralateral Cancer+Ipsilateral DCIS+Invasive"),
       col =c("red","purple","blue"),inset=.02,cex=0.3,pch=1)




#for LRT
plot(T, fun.all(T,6), xlab = "Years",ylab = "cumulative incidence",
     main = "Cumulative incidence rate of LRT",lty=1,type='l',pch=1,col="red",ylim=c(0,1))
par(new=TRUE)
plot(T, fun.all(T,5)+fun.all(T,6), xlab = "Years",ylab = "cumulative incidence",
     lty=1,type='l',pch=1,col="purple",
     ylim=c(0,1))
par(new=TRUE)
plot(T, fun.all(T,4)+fun.all(T,5)+fun.all(T,6), xlab = "Years",ylab = "cumulative incidence",
     lty=1,type='l',pch=1,col="blue",
     ylim=c(0,1))
legend("topleft",
       legend=c("Contralateral Cancer","Contralateral Cancer+Ipsilateral DCIS",
                "Contralateral Cancer+Ipsilateral DCIS+Invasive"),
       col =c("red","purple","blue"),inset=.02,cex=0.3,pch=1)



#Simulation of trials: for each woman, record time of first event, and type of first event. 
#Then compare “ipsilateral invasive cancer-free survival”, starting with a Kaplan Meier analysis.
#start with simulate 10000 women
#for LO
N <- 10000
y.seq <- runif(N,0,1)
#for ipsilateral invasive cancer recurrence
LO.inva <- fun.inver(y.seq,1)
#for ipsilateral dcis recurrence
LO.dcis <- fun.inver(y.seq,2)
#for Contralateral recurrence
LO.con <- fun.inver(y.seq,3)
LO.time_to_event <- rep(NA,N)
LO.type_event <- rep(NA,N)
for (i in 1:N)
{
  LO.time_to_event[i] <- min(LO.inva[i],LO.dcis[i],LO.con[i])
  if (LO.time_to_event[i]==LO.inva[i])
  {
    LO.type_event[i] <- "Ipsilateral Invasive"
  }
  if (LO.time_to_event[i]==LO.dcis[i])
  {
    LO.type_event[i] <- "Ipsilateral DCIS"
  }
  if (LO.time_to_event[i]==LO.con[i])
  {
    LO.type_event[i] <- "Contralateral Cancer"
  }
}


#for LRT
#for ipsilateral invasive cancer recurrence
LRT.inva <- fun.inver(y.seq,4)
#for ipsilateral dcis recurrence
LRT.dcis <- fun.inver(y.seq,5)
#for Contralateral recurrence
LRT.con <- fun.inver(y.seq,6)
LRT.time_to_event <- rep(NA,N)
LRT.type_event <- rep(NA,N)

for (i in 1:N)
{
  LRT.time_to_event[i] <- min(LRT.inva[i],LRT.dcis[i],LRT.con[i])
  if (LRT.time_to_event[i]==LRT.inva[i])
  {
    LRT.type_event[i] <- "Ipsilateral Invasive"
  }
  if (LRT.time_to_event[i]==LRT.dcis[i])
  {
    LO.type_event[i] <- "Ipsilateral DCIS"
  }
  if (LRT.time_to_event[i]==LO.con[i])
  {
    LRT.type_event[i] <- "Contralateral Cancer"
  }
}

