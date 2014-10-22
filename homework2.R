library(Quandl)
library(ggplot2)
library(reshape2)

SpendingDataUSA <- Quandl("ODA/USA_GGX", trim_start = "1980-12-31", trim_end = "2019-12-31")

SpendingDataUSA <-plyr :: rename(x = SpendingDataUSA, replace=c("Value" = "USA"))

SpendingDataCanada <- Quandl("ODA/CAN_GGX", trim_start = "1980-12-31", trim_end = "2019-12-31")

SpendingDataCanada <-plyr :: rename(x = SpendingDataCanada, replace=c("Value" = "Canada"))

SpendingDataMexico <- Quandl("ODA/MEX_GGX", trim_start = "1990-12-31", trim_end = "2019-12-31")

SpendingDataMexico <-plyr :: rename(x = SpendingDataMexico, replace = c("Value" = "Mexico"))

head(SpendingDataUSA, 40)

head(SpendingDataCanada, 40)

head(SpendingDataMexico, 30)

SpendingData <- merge(SpendingDataUSA, SpendingDataCanada, by.x = "Date", by.y = "Date", all.x = T, all.y = F)

SpendingData <- merge(SpendingData, SpendingDataMexico, by.x = "Date", by.y = "Date", all.x = T, all.y = F)

write.csv(SpendingData, "SpendingDataNorthAmerica.csv", row.names = FALSE)

class(SpendingData)

str(SpendingData)

summary(SpendingData)

data <- melt(SpendingData, id.vars = "Date", measure.vars = c("USA", "Canada", "Mexico"))

data <- plyr :: rename(x = data, replace=c("variable" = "Country", "value" = "Money_Spent"))

ggplot(data = data, aes(x = Date, y = Money_Spent, fill = Country)) + geom_bar(stat = "identity", position = position_dodge()) + ggtitle("Government Spending (North America)") + scale_fill_manual(values=c("blue", "red", "green"))

data1 <- SpendingData

data1$ChangeUSA <- 0

for (i in 1:39 ) {
  data1$ChangeUSA[i] <- data1$USA[i+1] - data1$USA[i]
}

data1$ChangeCanada <- 0

for (i in 1:39 ) {
  data1$ChangeCanada[i] <- data1$Canada[i+1] - data1$Canada[i]
}

data1$ChangeMexico <- 0

for (i in 1:39 ) {
  data1$ChangeMexico[i] <- data1$Mexico[i+1] - data1$Mexico[i]
}

data1$USA <- NULL
data1$Canada <- NULL
data1$Mexico <- NULL

data2 <- melt(data1, id.vars = "Date", measure.vars = c("ChangeUSA", "ChangeCanada", "ChangeMexico"))

data2 <- plyr :: rename(x = data2, replace=c("variable" = "Country", "value" = "Change_Money_Spent"))

ggplot(data = data2, aes(x = Date, y = Change_Money_Spent, fill = Country)) + geom_bar(stat = "identity", position = position_dodge()) + ggtitle("Government Spending (North America)") + scale_fill_manual(values=c("blue", "red", "green"))
