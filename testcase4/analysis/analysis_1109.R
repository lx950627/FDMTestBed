# R Analysis of SAT-NAV Networks
# Network performance analysis
# 2017-Nov-03

# set path
setwd("/mnt/hgfs/FDMTestBed/testcase4");
#setwd("D://SHARE//Single");
#setwd("D://SHARE//MPTCP");


rm( list = ls (all = TRUE));
data <- read.csv("result.csv", header = T, stringsAsFactors = FALSE, sep=",")
rownames(data) <- c("total_time","total_packets","min_delay","max_delay","avg_delay",
                    "avg_jitter","sd_delay","avg_bit_rate","avg_pkt_rate");

data <- t(data);
data <- as.data.frame(data);
data <- data.frame(rownames(data),data);
colnames(data)[1] <- "hostname";

# BW Calculation
# install.packages("ggplot2")
library("ggplot2")
#data$hostname <- factor(data$hostname)
r <- ggplot(data=data, aes(x = hostname, y=avg_bit_rate, fill = hostname, group = factor(1)))
r <- r + geom_bar(stat = "identity")
r <- r + labs(title = "Throughput", x = "Hosts", y = "Average Bit Rate /Kbps");
r
ggsave("ss3.png")

# satisfactory Caluculation
req = c(6,4,7,3,4,4,3,3,3,3);
sat = rep(0,10);
for (i in seq(1, length(data$avg_bit_rate))){
  sat[i] = data$avg_bit_rate[i] / 1000 / req[i];
}
data <- cbind(data,sat);
#data$hostname <- factor(data$hostname)
s1 <- ggplot(data=data, aes(x = hostname, y=sat, fill = sat, group = factor(1)))
s1 <- s1 + geom_bar(stat = "identity")
s1 <- s1 + scale_fill_gradient(low='red', high='green')
s1 <- s1 + labs(title = "Satisfactory", x = "Hosts", y = "Satisfactory Value");
s1
ggsave("ss5.png")


# plot with standard deviation

value <- function(a,b){
  sgn <- sign(a - b);
  rr <- a - b;
  rr[sgn == -1] <- 0;
  return(rr);
}


s <- ggplot(data=data, aes(x=hostname, y=avg_delay, fill = avg_delay));
s <- s + geom_bar(position=position_dodge(), stat="identity");
s <- s + geom_errorbar(aes(ymin=value(avg_delay,sd_delay), ymax= avg_delay + sd_delay),
                       width=.2,                    # Width of the error bars
                       position=position_dodge(.9));
s <- s + scale_fill_gradient(low='green', high='red')
s <- s + labs(title = "Delay", x = "Hosts", y = "Average Delay/s");
ggsave("ss4.png")


# analysis
avg_delay <- mean(data$avg_delay);
avg_delay
satisfa <- mean(data$sat);
satisfa

# Test case 4
#Type | Average Delay | Satisfactory
#Single TCP | 1.95ms | 0.735
#MPTCP | 41.7ms | 0.666
#FDM | 34.59ms | 0.656
