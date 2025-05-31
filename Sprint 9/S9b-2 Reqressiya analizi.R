# Ardıcıl reqressiya ----

stud <- read.csv("students.csv")

# "hierarchical" reqressiya analizi

# asılı dəyişən(dependent variable): test nəticəsi (score)
# izah edici dəyişənlər(explainers): iq, çalışma saatları (hours) və gender

# 1: iq
# 2: iq və çalışma saatları (hours)
# 3: iq, çalışma saatları (hours) və gender

fit1 <- lm(score ~ iq,                  data = stud)
fit2 <- lm(score ~ iq + hours,          data = stud)
fit3 <- lm(score ~ iq + hours + gender, data = stud)

summary(fit1)
summary(fit2)
summary(fit3)

#ANOVA ilə model müqayisəsi
anova(fit1, fit2, fit3)
#Model 1dən Model 2ə keçərkən p dəyəri 0.05dən kiçikdir. Yəni, “hours” dəyişəni modeli əhəmiyyətli dərəcədə yaxşılaşdırır.
#Model 2dən Model 3ə keçərkən p dəyəri 0.05dən kiçikdir. Yəni, “gender” dəyişəni də modelə statistik əhəmiyyətli əlavə təsir göstərir.

#AIC və BIC ilə model müqayisəsi
AIC(fit1, fit2, fit3)
BIC(fit1, fit2, fit3)
#AIC və BIC nə qədər aşağıdırsa, model bir o qədər yaxşı uyğunlaşır.


# "Binomial/Logistic" reqressiya ----

mobi <- read.csv("mobilenet.csv")

#asılı dəyişən(dependent variable): mobil internetin olub-olmaması (1/0)
#müstəqil dəyişənlər(explainers): 
  #gəlir, 
  #internetdən istifadə saatları 
  #internetdən istifadə yeri ev (0), ofis (1)

model <- glm(mobile ~ income + hours + where, 
             data = mobi, 
             family=binomial())

summary(model)

#"Null deviance" - bizə cavab dəyişəninin (response variable) yalnız intercept olan bir model 
#                  tərəfindən nə qədər yaxşı proqnozlaşdırıla biləcəyini izah edir.

#"Residual deviance" - bizə cavab dəyişəninin (response variable) p proqnozlaşdırıcı dəyişənləri
#                      olan bir model tərəfindən nə qədər yaxşı proqnozlaşdırıla biləcəyini izah edir. 
#                      Dəyər nə qədər aşağı olarsa, model cavab dəyişəninin  
#                      dəyərini bir o qədər yaxşı proqnozlaşdıra bilər.

pred_prob <- predict(model, type = "response")
pred_label <- ifelse(pred_prob > 0.5, 1, 0)
mobi$pred <- pred_label

table(mobi$mobile, mobi$pred)
