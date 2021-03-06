#library package and source function
library("GoFKernel")
library("cmprsk")
library(xlsx)
library("binom")
library("survival")
library(Gmisc)
setwd("~/COMET_trial/COMET_trial_simulation/COMET_trial_6_12")
source("trial_simulation_06_24.R")


#redo the survival analysis
#ipsilateral invasive cancer-free survival
#for Lumpectomy
N <- 10000
y.seq.inva <- runif(N,0,1)
y.seq.dcis <- runif(N,0,1)
y.seq.con <- runif(N,0,1)
#for ipsilateral invasive cancer recurrence
LO.inva <- fun.inver(y.seq.inva,1)
#for ipsilateral dcis recurrence
LO.dcis <- fun.inver(y.seq.dcis,2)
#for Contralateral recurrence
LO.con <- fun.inver(y.seq.con,3)
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

event <- LO.type_event
event <- ifelse(event=="Ipsilateral Invasive",1,0)
time <- LO.time_to_event
id <- 1:N
mydat <- data.frame(id, time, event)
#Surv(mydat$time, mydat$event)
fit1 <- survfit(Surv(mydat$time, mydat$event)~1 ,data=mydat)
plot(fit1,xlim=c(0,20),ylim=c(0,1),col="black")
par(new=TRUE)
T <- seq(0,20,0.001)
plot(T, 1-fun.all(T,1),
     main = "Ipsilateral invasive cancer-free survival of LO",lty=1,type='l',xlab="Years",
     ylab="Probability",
     pch=1,col="blue",xaxs="i",xlim=c(0,20),ylim=c(0,1))

legend("bottomright",
       legend=c("Survial Analysis","Simulation curve"),
       col =c("black","blue"),inset=.02,cex=0.5,lty =1)


#for Lumpectomy and Radiation
event2 <- LRT.type_event
event2 <- ifelse(event2=="Ipsilateral Invasive",1,0)
time2 <- LRT.time_to_event
id2 <- 1:N
mydat2 <- data.frame(id2, time2, event2)

fit2<- survfit(Surv(mydat2$time2, mydat2$event2)~1 ,data=mydat2)
plot(fit2,xlim=c(0,20),ylim=c(0,1))
par(new=TRUE)
T <- seq(0,20,0.001)
plot(T, 1-fun.all(T,4),
     main = "Ipsilateral invasive cancer-free survival of LRT",lty=1,type='l',xlab="Years",
     ylab="Probability",
     pch=1,col="blue",xaxs="i",xlim=c(0,20),ylim=c(0,1))

legend("bottomright",
       legend=c("Survial Analysis","Simulation curve"),
       col =c("black","blue"),inset=.02,cex=0.5,lty=1)


#use KM estimator and also get CI
#extract confidence interval
#for Lumpectomy
#for year2
lo.ci.2 <- paste(round(fit1$surv[round(fit1$time,3)==2],3),"(",
                 round(fit1$lower[round(fit1$time,3)==2],3),",",
                 round(fit1$upper[round(fit1$time,3)==2],3),")")
#for year5
lo.ci.5 <- paste(round(mean(fit1$surv[round(fit1$time,2)==5]),3),"(",
                 round(mean(fit1$lower[round(fit1$time,2)==5]),3),",",
                 round(mean(fit1$upper[round(fit1$time,2)==5]),3),")")
#for year10
lo.ci.10 <- paste(round(mean(fit1$surv[round(fit1$time,2)==10]),3),"(",
                 round(mean(fit1$lower[round(fit1$time,2)==10]),3),",",
                 round(mean(fit1$upper[round(fit1$time,2)==10]),3),")")


#for Lumpectomy+Radiation
#for year2
lrt.ci.2 <- paste(round(mean(fit2$surv[round(fit2$time,2)==2]),3),"(",
                  round(mean(fit2$lower[round(fit2$time,2)==2]),3),",",
                  round(mean(fit2$upper[round(fit2$time,2)==2]),3),")")

#for year5
lrt.ci.5 <- paste(round(mean(fit2$surv[round(fit2$time,2)==5]),3),"(",
                  round(mean(fit2$lower[round(fit2$time,2)==5]),3),",",
                  round(mean(fit2$upper[round(fit2$time,2)==5]),3),")")

#for year10
lrt.ci.10 <- paste(round(mean(fit2$surv[round(fit2$time,1)==10]),3),"(",
                  round(mean(fit2$lower[round(fit2$time,1)==10]),3),",",
                  round(mean(fit2$upper[round(fit2$time,1)==10]),3),")")

#KM estimator and also get CI of Lumpectomy and ART
LO.km <- c(lo.ci.2,lo.ci.5,lo.ci.10)
lrt.km <- c(lrt.ci.2,lrt.ci.5,lrt.ci.10)
KM <- data.frame(LO.km,lrt.km)

colnames(KM)[1] <- "K-M Estimator for Lumpectomy"
colnames(KM)[2] <- "K-M Estimator for Lumpectomy+Radiation"
rownames(KM)[1] <- "Year2"
rownames(KM)[2] <- "Year5"
rownames(KM)[3] <- "Year10"




#Estimate fraction for UC
ipsi.frac <- function(n.sim=5, N=10000,year=10,type=1)
{
  ipsi.frac <- rep(NA,n.sim)
  for(i in 1:n.sim)
  {
    y.seq.inva <- runif(N,0,1)
    LO.inva <- fun.inver(y.seq.inva,type)
    ipsi.frac[i] <- sum(LO.inva<year)/N
  }
  return(frac=ipsi.frac)
}

#for Lumpectomy the ipasilateral recurrence rate
set.seed(123)
LO.frac.2 <- ipsi.frac(n.sim=5, N=10000,year=2,type=1)
LO.frac.5 <- ipsi.frac(n.sim=5, N=10000,year=5,type=1)
LO.frac.10 <- ipsi.frac(n.sim=5, N=10000,year=10,type=1)

LOest.2 <- mean(LO.frac.2)
LOest.5 <- mean(LO.frac.5)
LOest.10 <- mean(LO.frac.10)

#CI
binom.confint(round(N*LOest.2),N,level=0.95,methods = "exact")
binom.confint(round(N*LOest.5),N,level=0.95,methods = "exact")
binom.confint(round(N*LOest.10),N,level=0.95,methods = "exact")

Lo.est.ci <- rbind(binom.confint(round(N*LOest.2),N,level=0.95,methods = "exact"),
      binom.confint(round(N*LOest.5),N,level=0.95,methods = "exact"),
      binom.confint(round(N*LOest.10),N,level=0.95,methods = "exact"))[,4:6]

rownames(Lo.est.ci)[1] <- "Year2"
rownames(Lo.est.ci)[2] <- "Year5"
rownames(Lo.est.ci)[3] <- "Year10"

#for Lumpectomy the ipasilateral recurrence rate
#for Lumpectomy+radiation the ipasilateral recurrence rate
set.seed(123)
LRT.frac.2 <- ipsi.frac(n.sim=50, N=10000,year=2,type=4)
LRT.frac.5 <- ipsi.frac(n.sim=50, N=10000,year=5,type=4)
LRT.frac.10 <- ipsi.frac(n.sim=50, N=10000,year=10,type=4)

LRTest.2 <- mean(LRT.frac.2)
LRTest.5 <- mean(LRT.frac.5)
LRTest.10 <- mean(LRT.frac.10)


#CI
binom.confint(round(N*LRTest.2),N,level=0.95,methods = "exact")
binom.confint(round(N*LRTest.5),N,level=0.95,methods = "exact")
binom.confint(round(N*LRTest.10),N,level=0.95,methods = "exact")

Lrt.est.ci <- rbind(binom.confint(round(N*LRTest.2),N,level=0.95,methods = "exact"),
                   binom.confint(round(N*LRTest.5),N,level=0.95,methods = "exact"),
                   binom.confint(round(N*LRTest.10),N,level=0.95,methods = "exact"))[,4:6]

rownames(Lrt.est.ci)[1] <- "Year2"
rownames(Lrt.est.ci)[2] <- "Year5"
rownames(Lrt.est.ci)[3] <- "Year10"

#Estimate fraction for AS
ASest.2 <- cum.cal(ti=2,deltat=1/12,N7=10000,n.sim = 5,
                   beta=0.8,psi=0.7,rho=0.19,lambda=0.1)$mean.pro

ASest.5 <- cum.cal(ti=5,deltat=1/12,N7=10000,n.sim = 5,
                   beta=0.8,psi=0.7,rho=0.19,lambda=0.1)$mean.pro

ASest.10 <- cum.cal(ti=10,deltat=1/12,N7=10000,n.sim = 5,
                    beta=0.8,psi=0.7,rho=0.19,lambda=0.1)$mean.pro


#CI
AS.est.ci <- rbind(binom.confint(round(N*ASest.2),N,level=0.95,methods = "exact"),
                    binom.confint(round(N*ASest.5),N,level=0.95,methods = "exact"),
                    binom.confint(round(N*ASest.10),N,level=0.95,methods = "exact"))[,4:6]

rownames(AS.est.ci)[1] <- "Year2"
rownames(AS.est.ci)[2] <- "Year5"
rownames(AS.est.ci)[3] <- "Year10"

#create final table
Lo.est.ci.fi <- paste(round(Lo.est.ci$mean,2),"(",round(Lo.est.ci$lower,3),",",
                       round(Lo.est.ci$upper,3),")")

Lrt.est.ci.fi <- paste(round(Lrt.est.ci$mean,2),"(",round(Lrt.est.ci$lower,3),",",
                       round(Lrt.est.ci$upper,3),")")

AS.est.ci.fi <- paste(round(AS.est.ci$mean,2),"(",round(AS.est.ci$lower,3),",",
                      round(AS.est.ci$upper,3),")")

ipsi.recur.final <- data.frame(Lo.est.ci.fi,Lrt.est.ci.fi,AS.est.ci.fi)
rownames(ipsi.recur.final)[1] <- "Year2"
rownames(ipsi.recur.final)[2] <- "Year5"
rownames(ipsi.recur.final)[3] <- "Year10"


colnames(ipsi.recur.final)[1] <- "Recurrence Rate for Lx"
colnames(ipsi.recur.final)[2] <- "Recurrence Rate for LRT"
colnames(ipsi.recur.final)[3] <- "Recurrence Rate for AS"


#Figure(Both AS & UC) for cumulative incidence
#instead of randomly allocating, assign all to 1)LX+LRT+MX
#2)all to LX
#3)all to LRT

#For all assign to Lumpectomy
#for ipsilateral invasive
#for AS
T <- seq(0.1,60,0.5)
fun.AS <- function(u)
{
  AS.value <- rep(NA,length(u))
  for(j in 1:length(u))
  {
    AS.value[j] <- cum.cal(ti=u[j],deltat=1/12,N7=10000,n.sim = 1,
                           beta=0.8,psi=0.7,rho=0.19,lambda=0.1)$mean.pro
  }
  return(AS.value)
}

cum.inva.AS <- fun.AS(c(T))

plot(c(0,T), c(0,cum.inva.AS),
     main = "Cumulative Incidence rate for Ipsilateral invasive cancer",lty=1,type='l',xlab="Years",
     ylab="cumulative incidence",
     pch=1,col="blue",ylim=c(0,1),xlim=c(0,20))

par(new=TRUE)
y.seq <- runif(10000,0,1)
x.LO.inva <- fun.inver(y.seq,1)
plot(ecdf(x.LO.inva[order(x.LO.inva)]), xlab = "Years",ylab = "cumulative incidence",
     main = "Cumulative Incidence rate for Ipsilateral invasive cancer",col="black",
     ylim=c(0,1),xlim=c(0,20))

legend("topright",
              legend=c("Lumpectomy Arm","AS Arm"),
              col =c("black","blue"),inset=.02,cex=0.5,lty =1)

#for Con Assume the same



#for LRT
#for ipsilateral Invasive
plot(c(0,T), c(0,cum.inva.AS),
     main = "Cumulative Incidence rate for Ipsilateral invasive cancer",lty=1,type='l',xlab="Years",
     ylab="cumulative incidence",
     pch=1,col="blue",ylim=c(0,1),xlim=c(0,20))

par(new=TRUE)
y.seq <- runif(10000,0,1)
x.LRT.inva <- fun.inver(y.seq,4)
plot(ecdf(x.LRT.inva[order(x.LRT.inva)]), xlab = "Years",ylab = "cumulative incidence",
     main = "Cumulative Incidence rate for Ipsilateral invasive cancer",col=1,
     ylim=c(0,1),xlim=c(0,20),lty=1)
legend("topright",
       legend=c("Lumpectomy+Radiation Arm","AS Arm"),
       col =c("black","blue"),inset=.02,cex=0.5,lty =1)


#for LRT
#for contralateral cancer
y.seq <- runif(10000,0,1)
x.AS.con <- fun.inver(y.seq,3)
plot(x.AS.con[order(x.AS.con)], y.seq[order(x.AS.con)], xlab = "Years",ylab = "cumulative incidence",
     main = "Cumulative Incidence rate for Contralateral cancer",type="l",col="blue",
     ylim=c(0,1),xlim=c(0,20),lty=1)

par(new=TRUE)
x.LRT.con <- fun.inver(y.seq,6)
plot(ecdf(x.LRT.con[order(x.LRT.con)]),xlab = "Years",ylab = "cumulative incidence",
     main = "Cumulative Incidence rate for Contralateral cancer",col=1,
     ylim=c(0,1),xlim=c(0,20),lty=1)

legend("topright",
       legend=c("Lumpectomy+Radiation Arm","AS Arm"),
       col =c("black","blue"),inset=.02,cex=0.5,lty =1)


#for Lx+Rx+MX
#Use the proportion in the slides
#Bilateral Mastectomy 9%
#Unilateral Mastectomy  17%
#lumpectomy 20%
#Lumpectomy + Radiation 50%

#Mastectomy 27.1%
#lumpectomy 20.8%
#Lumpectomy + Radiation 52.1%

#for ipsilateral invasive

plot(T, cum.inva.AS,
     main = "Cumulative Incidence rate for Ipsilateral invasive cancer",lty=1,type='l',xlab="Years",
     ylab="cumulative incidence",
     pch=1,col="blue",ylim=c(0,1),xlim=c(0,20))

par(new=TRUE)
y.seq.ipsimx <- runif(10000*0.271,0,1)
y.seq.ipsilx <- runif(10000*0.208,0,1)
y.seq.ipsiLRT <- runif(10000*0.521,0,1)

#not considering recurrence time for Mastectomy first
x.seq.lx <- fun.inver(y.seq.ipsilx,1)
x.seq.LRT <- fun.inver(y.seq.ipsiLRT,3)

#plot cumulative density function
x.ipsi <- c(x.seq.lx,x.seq.LRT)
T.ipsi <- seq(0.1,20,0.1)

fun.mix.cdf <- function(u)
{
  prob <- rep(NA,length(u))
  for(j in 1:length(u))
  {
    prob[j] <- sum(x.ipsi<=u[j])/length(x.ipsi)
  }
  return(prob)
}

plot(T.ipsi, fun.mix.cdf(T.ipsi), xlab = "Years",ylab = "cumulative incidence",
     main = "Cumulative Incidence rate for Ipsilateral invasive cancer",type="l",col=1,
     ylim=c(0,1),xlim=c(0,20),lty=1)

legend("topright",
       legend=c("Lumpectomy+Radiation+Mastectomy Arm","AS Arm"),
       col =c("black","blue"),inset=.02,cex=0.5,lty =1)


#considering recurrence time for Mastectomy 
x.seq.mx <- c(runif(10000*0.271*0.01,0,10),runif(10000*0.271*0.99,10,60))
x.ipsi.v2 <- c(x.seq.lx,x.seq.LRT,x.seq.mx)
T.ipsi <- seq(0.1,20,0.1)


#for ipsilateral invasive
plot(T, cum.inva.AS,
     main = "Cumulative Incidence rate for Ipsilateral invasive cancer",lty=1,type='l',xlab="Years",
     ylab="cumulative incidence",
     pch=1,col="blue",ylim=c(0,1),xlim=c(0,20))

par(new=TRUE)

fun.mix.cdf.v2 <- function(u)
{
  prob <- rep(NA,length(u))
  for(j in 1:length(u))
  {
    prob[j] <- sum(x.ipsi.v2<=u[j])/length(x.ipsi.v2)
  }
  return(prob)
}

plot(T.ipsi, fun.mix.cdf.v2(T.ipsi), xlab = "Years",ylab = "cumulative incidence",
     main = "Cumulative Incidence rate for Ipsilateral invasive cancer",type="l",col=1,
     ylim=c(0,1),xlim=c(0,20),lty=1)
legend("topright",
       legend=c("Lumpectomy+Radiation+Mastectomy Arm","AS Arm"),
       col =c("black","blue"),inset=.02,cex=0.5,lty =1)


#Compare the result with or without considering recurrence time for Mastectomy 
plot(T.ipsi, fun.mix.cdf.v2(T.ipsi), xlab = "Years",ylab = "cumulative incidence",
     main = "Cumulative Incidence rate for Ipsilateral invasive cancer",type="l",col=1,
     ylim=c(0,1),xlim=c(0,20),lty=1)
lines(T.ipsi, fun.mix.cdf(T.ipsi),col=6)
legend("topright",
       legend=c("LRT+Mx Considering recurrence after Mastectomy",
                "LRT+Mx Not Considering recurrence after Mastectomy"),
       col =c(1,6),inset=.02,cex=0.5,lty =1)

