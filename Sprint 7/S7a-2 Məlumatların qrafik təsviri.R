# Histograms ----

data <- read.csv("demographics.csv")


hist(data$income)

hist(data$age)


###  rənglərin dəyişdirilməsi

hist(data$income,
     main = "Income",
     xlab = "Values",
     ylab = "Frequency",
     col = "red",
     border = "black")


### y oxundakı sıxlıq

hist(data$income,
     main = "Income",
     xlab = "Values",
     ylab = "Frequency",
     probability = T,
     breaks = 40,
     col = "red",
     border = "black")


# Kumulyativ tezlik xətti diaqramları ----

income_table <- data.frame(table(data$income))

str(income_table)

names(income_table) <- c("income","Freq")


### Kumulyativ sayları və faizlərin hesablanması

cumul <- cumsum(income_table$Freq)
cumperc <- cumul/nrow(data)


### ilkin income_table matriksinə kumulyativ tezliklər sütununu əlavə edin

income_table <- cbind(income_table, cumperc)


### kumulyativ tezliklər xəttini tərtib edin (hamar)

plot(x = income_table$income, 
     y = income_table$cumperc, 
     type = "l",          
     col = "blue",
     lwd = 2)



#### eyni analizi male və female üçün ayrı-ayrı edək

male <- data[data$gender=="Male",]

income_table_male <- data.frame(table(male$income))
income_table_male$income <- sort(unique(male$income))
income_table_male <- income_table_male[,c("income","Freq")]

cumul_m <- cumsum(income_table_male$Freq)
cumperc_m <- cumul_m/nrow(male)
income_table_male <- cbind(income_table_male, cumperc_m)


female <- data[data$gender=="Female",]

income_table_female <- data.frame(table(female$income))
income_table_female$income <- sort(unique(female$income))
income_table_female <- income_table_female[,c("income","Freq")]

cumul_fm <- cumsum(income_table_female$Freq)
cumperc_fm <- cumul_fm/nrow(female)
income_table_female <- cbind(income_table_female, cumperc_fm)


### diaqramın qurulması

plot(income_table_male$income, income_table_male$cumperc_m,
     type = "l", col = "blue", lwd = 2,
     xlab = "Income", 
     ylab = "Cumulative Percentage",
     main = "Cumulative Income by Gender")  

lines(income_table_female$income, income_table_female$cumperc_fm,
      col = "red", lwd = 2)


### qrafikə "legend" əlavə edilməsi

legend("bottomright",
       legend = c("Male", "Female"),
       col = c("blue", "red"),
       lwd = 2)


### ggplot2 paketi ilə eyni qrafikin qurulması

library(ggplot2)

legend <- scale_color_manual("Legend", values = c(Male = "blue",
                                                  Female = "red"))
ggplot()+
  geom_line(data = income_table_male, aes(x=income, y=cumperc_m,
                                          color="Male"), size=1.3)+
  geom_line(data = income_table_female, aes(x=income, y=cumperc_fm,
                                            color="Female"), size=1.3) + 
  legend


# "Boxplot" diaqramı ----

boxplot(data$income)

outliers <- boxplot(data$income)$out

median <- median(data$income)

up_outliers <- outliers[outliers>median]
down_outliers <- outliers[outliers<median]

val <- quantile(data$income,0.75) + 1.5*IQR(data$income)
data[data$income %in% up_outliers,"income"] <- val

val <- quantile(data$income,0.25) - 1.5*IQR(data$income)
data[data$income %in% down_outliers,"income"] <- val

boxplot(data$income)


boxplot(income ~ gender,
        data = data,
        names = c("Female", "Male"),
        col = c("lightblue", "lightpink"),
        #outline = FALSE,
        main = "Income by Gender",
        xlab = "Gender",
        ylab = "Income")


### outliers rənglənməsi (ggplot2 paketi ilə)

library(ggplot2)

ggplot() +
  geom_boxplot(data=data, aes(x=age, y=income, fill=gender), 
               outlier.colour="red")+
  scale_x_discrete(labels=c("Female", "Male"))
