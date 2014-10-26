library(ggplot2)
library(RCurl)

url3 <- paste0("https://raw.githubusercontent.com/jrwolf/","IT497/master/", "fitstats.csv")
exam3 <- getURL(url3)
examdata3 <- read.csv(textConnection(exam3), sep = ",", header = T)

ggplot(examdata3, aes(x = Miles, y = Steps)) + geom_point(shape = 1) + ggtitle("Miles versus Steps")
