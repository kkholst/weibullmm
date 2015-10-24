source("load.R")

n <- 600
parm <- c("v.a"=1, "v.c"=1, "v.e"=1)
zyg <- rep(c(1,0),each=2*n)
parid <- rep(1:(2*n),each=2)
x <- rnorm(4*n)
eta.a0 <- rep(rnorm(2*n,sd=parm["v.a"]^0.5),each=2) # MZ
eta.a1 <- rep(rnorm(2*n,sd=(0.5*parm["v.a"])^0.5),each=2) #DZ part1
eta.a2 <- rnorm(4*n,sd=(0.5*parm["v.a"])^0.5) # DZ part2
eta.a <- eta.a0*zyg + (eta.a1+eta.a2)*(1-zyg)
eta.c <- rep(rnorm(2*n,sd=parm["v.c"]^0.5),each=2)
eta.e <- rnorm(4*n,sd=parm["v.e"]^0.5)
lambda <- exp(-2.6)
p <- exp(3.51)
d <- sim.phwreg2(lambda=lambda,p=p,X=cbind(x,eta.a,eta.c,eta.e),cens=Inf)
D <- data.frame(agemena=d$t,id=parid,zyg=zyg,twinnum=rep(1:2,2*n))
W <- reshape(D, direction="wide", timevar="twinnum",idvar=c("id","zyg"))
## with(W[W$zyg==0,], plot(agemena.1,agemena.2,col=Col("black"),pch=16,xlim=c(8,20), ylim=c(8,20)))
## with(W[W$zyg==1,], points(agemena.1,agemena.2,col=Col("red"),pch=16))

c1 <- with(W[W$zyg==0,], cor(agemena.1,agemena.2,method="spearman"))
c2 <- with(W[W$zyg==1,], cor(agemena.1,agemena.2,method="spearman"))


##h0 <- parm[1]/(sum(parm)+1.65)
##h <- 2*(c2-c1)

YX <- as.matrix(d)
n <- NROW(YX)
DZ <- abs(zyg-1)
MZ <- zyg
Z <- cbind(## A
           a1=1/sqrt(2)*rep(c(1,0),n/2)*DZ,
           a2=1/sqrt(2)*rep(c(0,1),n/2)*DZ,
           a3=MZ+1/sqrt(2)*DZ,
           ## C
           c1=rep(1,n),
           ## E
           e1=rep(c(1,0),n/2),
           e2=rep(c(0,1),n/2)  
           )
dd <- cbind(D,x,Z); dd$status <- 1; 

a1 <- weibullmm(Surv(agemena,status)~x, random=~f(a1,a)+f(a2,a)+f(a3,a)+c1+f(e1,e)+f(e2,e), id="id", data=dd,
iter=50,
init=c(0,0,0,0.1,0.1,0.1), stepsize=0.5, nsim=50)
