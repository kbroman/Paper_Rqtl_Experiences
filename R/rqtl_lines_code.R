# plot of lines of code in R/qtl, over time

library(broman)
source("colors.R")

lines <- read.csv("../Data/lines_code_by_version.csv")
lines <- lines[nrow(lines):1,]
library(lubridate)
lines[,2] <- dmy(as.character(lines[,2]))

pdf("../rqtl_lines_code.pdf", width=6.5, height=3.5, pointsize=10, onefile=TRUE)
par(mar=c(2.6, 4.3, 0.3, 0.1),las=1,fg="black",col="black",col.axis="black",col.lab="darkslateblue",
    bg=bgcolor,bty="n")

yat <- seq(0, 35000, by=5000)

yr <- 2000:2014
idea <- as.numeric(dmy("23 Feb 2000"))
R100 <- as.numeric(dmy("29 Feb 2000"))
svn <- as.numeric(dmy("16 Jan 2008"))
git <- as.numeric(dmy("12 Feb 2009"))
xaxis <- as.numeric(ymd(paste0(yr, "-1-1")))
xat <- (xaxis + as.numeric(ymd(paste0(yr-1, "-12-31"))))/2

grayplot(lines[,2], lines[,3], xlab="Year", ylab="Lines of code", yat=yat, xat=NA,
         hlines=yat, pch=21, col="black", bg=color2[1], ylim=c(0, max(lines[,3:5])*1.02),
         mgp.x=c(1.6, 0.4, 0), vlines=xat, yaxs="i", vlines.col="gray65",
         hlines.col="white", bgcolor="gray85",
         xlim=range(xaxis), xaxs="i", mgp.y=c(3.3, 0.4, 0))
for(i in 4:5)
  points(lines[,2], lines[,i], pch=21, col="black", bg=color2[i-2])

u <- par("usr")
for(i in 2:length(xaxis)) {
  col <- ifelse(i %% 2, "gray75", "gray55")
  h <- diff(u[3:4])*0.05
  start <- max(c(xaxis[i-1], u[1]))
  end <- min(c(xaxis[i], u[2]))
  rect(start, u[3], end, u[3]-h, xpd=TRUE,
       col=col, border=col, lend=1, ljoin=1)
  text((start + end)/2, u[3]-h/2, yr[i-1], col="black", xpd=TRUE, cex=0.8)
}
abline(h=0, col="black")

xd <- diff(range(xaxis))*0.02
text(rep(as.numeric(lines[1,2]) - xd, 3), lines[1,3:5], c("R", "C", "man"),
     col="black", adj=c(1, 0.5))

top <- u[3]+diff(u[3:4])*0.07
bot <- u[3]+diff(u[3:4])*0.01
txt <- u[3]+diff(u[3:4])*0.09
col <- rgb(0, 90, 90, maxColorValue=255)
arrows(idea,top,idea, bot, len=0.1, col=col, lwd=2)
arrows(svn, top, svn, bot, len=0.1, col=col, lwd=2)
arrows(git, top, git, bot, len=0.1, col=col, lwd=2)
text(idea, txt, "idea", adj=c(0, 0), col=col)
text(svn, txt, "svn", adj=c(0.5, 0), col=col)
text(git, txt, "git", adj=c(0.5, 0), col=col)

dev.off()
