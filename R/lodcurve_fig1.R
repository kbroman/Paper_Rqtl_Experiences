# figure 1: LOD curve + phe x gen plot

library(qtl)
library(qtlcharts)
library(beeswarm)

data(grav)
grav <- calc.genoprob(grav, step=1)
phe <- paste0("T", 6*60)
out <- scanone(grav, phe=phe, method="hk")
out.mar <- scanone(calc.genoprob(grav), phe=phe, method="hk")
max.mar <- max(out)
marker <- rownames(max(out.mar))

pdf("../fig1.pdf", width=7, height=3.8, pointsize=10, onefile=TRUE)
par(mar=c(3.1,3.1,2.6,0.6), col.lab="darkslateblue")

layout(cbind(1, 2), width=c(2.5, 1))
source("myplotscanone.R")
myplotscanone(out, col="gray90", bgrect="gray90", bandcol="gray80",
              ylab="", mgp=c(2.2, 1, 0), lwd=0, yaxt="n", xaxt="n")
title(ylab="LOD score", mgp=c(2, 1, 0))
yat <- pretty(out[,3])
abline(h=yat, col="white")
axis(side=2, at=yat, mgp=c(0, 0.3, 0.1), tick=FALSE, las=1)
plot(out, add=TRUE, col="darkslateblue")
u <- par("usr")
text(u[1]-diff(u[1:2])*0.1, u[4]+diff(u[3:4])*0.06, "A",
     font=2, xpd=TRUE, cex=1.3)
rect(u[1], u[3], u[2], u[4])

marloc <- xaxisloc.scanone(out, max.mar[1], max.mar[2])
points(marloc, max.mar[3], pch=21, lwd=2, bg="violetred")
text(marloc+diff(u[1:2])*0.02, max.mar[3], marker, adj=c(0, 0.5))

# phe x gen
g <- pull.geno(fill.geno(grav))[,marker]
g <- factor(c("LL", "CC")[g], levels=c("LL", "CC"))
y <- pull.pheno(grav, phe)

cex <- 0.7

z <- beeswarm(y ~ g, method="center", col="white",
              xlab="", ylab="", xaxt="n", yaxt="n",
              cex=cex)

u <- par("usr")
rect(u[1], u[3], u[2], u[4], col="gray90")

text(u[1]-diff(u[1:2])*0.1*2.5, u[4]+diff(u[3:4])*0.06, "B",
     font=2, xpd=TRUE, cex=1.3)

abline(v=seq(1, 2), col="gray80", lwd=3)
yat <- pretty(y)
abline(h=yat, col="white")
axis(side=2, at=yat, mgp=c(0, 0.3, 0.1), tick=FALSE, las=1)
title(ylab="Phenotype", mgp=c(2.5, 0, 0))
title(xlab="Genotype", mgp=c(2.2, 0, 0))
axis(side=1, at=1:2, c("LL","CC"), mgp=c(0, 0.25, 0.1), tick=FALSE)
points(z$x, z$y, pch=21, bg="slateblue", cex=cex)
rect(u[1], u[3], u[2], u[4])
dev.off()
