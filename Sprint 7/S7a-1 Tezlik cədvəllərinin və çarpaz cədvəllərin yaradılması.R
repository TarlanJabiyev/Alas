# Tezlik cədvəlləri (Frequency Tables) ----

data <- read.csv("demographics.csv")

###"educ"(education level) dəyişəni üçün cədvəl quracağıq 
### mütləq say (absolute (counts)), kumulyativ mütləq say (cumulative absolute), 
### nisbət/faiz (relative) və kumulyativ nisbət/faiz (cumulatitve relative)

educ_table <- table(data$educ, exclude = NULL) ### çatışmayan dəyərlər xaric edilir
educ_table

nrow(data[data$educ=="College degree",])
nrow(data[data$educ=="Did not complete high school",])
nrow(data[data$educ=="High school degree",])
nrow(data[data$educ=="Post-undergraduate degree",])
nrow(data[data$educ=="Some college",])


###kumulyativ sayların hesablanması

cumul <- cumsum(educ_table)
cumul


### nisbət/faiz (relative) hesablanması

relative <- prop.table(educ_table)
relative


### kumulyativ nisbət/faiz (relative) hesablanması

cumulfreq <- cumul/nrow(data) # cumsum(relative)
cumulfreq


### yekun cədvəlin yaradılması

educ_table <- cbind(Freq = educ_table, 
                    Cumul = cumul,
                    Relative = relative, 
                    CumFreq = cumulfreq)
educ_table


# Çarpaz cədvəllər qurulması (Cross Tables) ----

ct <- xtabs(~gender+carcat, data = data)
ftable(ct)
