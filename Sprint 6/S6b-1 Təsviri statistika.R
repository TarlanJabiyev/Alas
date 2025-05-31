# Statistik göstəricilərin yaradılması ----

data <- read.csv("demographics.csv") 

View(data)

str(data)


### Aritmatik orta(mean)

mean(data$income)


### standart sapma və variansın hesablanması

sd(data$income)
var(data$income) #sd(data$income)^2


### minimum, maksimum və aralığın hesablanması

min(data$income)
max(data$income)
range(data$income)
max(data$income) - min(data$income) 


### median
median(data$income)


### "psych" və "pastecs" paketləri

library(psych)
library(pastecs)

describe(data)
describe(data, na.rm = TRUE, check = F)

describeBy(data$income, data$gender)
describeBy(data$income, data$educ)


# Skewness və Kurtosis müəyyənləşdirilməsi ----

library(e1071)

skewness(data$income)
kurtosis(data$income)


# Quantiles hesablanması ----

quantile(data$income)
quantile(data$income, probs = c(0.05, 0.95))


# Mode'un tapılması ----

library(modeest) 

mlv(data$income, method="mfv")
mlv(data$gender, method="mfv")


# Qrup üzrə statistik göstəricilərin əldə edilməsi ----

###ailə vəziyyətinə görə(married/unmarried) yaş dəyişəninin statistik göstəricələrinin hesablanması

aggregate(data$age, by=list(data$marital), FUN=mean) # ortalama(mean)

aggregate(data$age, by=list(data$marital), FUN=sd)  # standart sapma(sd)

aggregate(data$age, by=list(data$marital), FUN=median) # median

aggregate(data$age, by=list(data$marital), FUN=var) # variance

aggregate(data$age, by=list(data$marital, data$gender), FUN=mean) #birləşdirmək
