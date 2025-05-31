# Çox xətti reqressiya - Multiple Linear Regression ----

stud <- read.csv("students.csv")

#asılı dəyişən (dependent variable) - y = "score"
#müstəqil dəyişənlər (independet variables) - x1 = "iq", x2 = "hours"

#Fromula:     y = β0 + β1*x1 + β2*x2 + ε
#         score = β0 + β1*iq + β2*hours + ε

fit <- lm(score ~ iq + hours, data = stud)
summary(fit)

## Əmsallar:
#Intercept - digər dəyişənlər 0 olduqda score -17.4 olur
#iq -  hər 1 vahid artdıqda score təxmini 0.156 vahid artır
#hours - hər əlavə 1 saat dərs çalışma score-u təxmini 0.42 vahid artır

## Modelin uyğunluğu:
#R-squared = 0.8399 - Model score dəyişkənliyinin 84%-ni izah edir.
#Adjusted R-squared = 0.8381 - Modelin güçü (dəyişən sayı nəzərə alınaraq hesablanıb).
#F-statistic = 469.4 - Model ümumilikdə statistik olaraq əhəmiyyətlidir (p-value < 2.2e-16).
#Residual standard error = 0.581 - Modelin orta xəta səviyyəsi aşağıdır.

#Nəticə: Həm IQ, həm də dərs saatı score göstəricisinə müsbət və əhəmiyyətli təsir göstərir. 
#        Model güclü uyğunluğa malikdir və əmsallar statistik cəhətdən əhəmiyyətlidir.


# Fərziyyələrin yoxlanması ----

#Əsas fərziyyələr:
  #1.Xəttilik - dəyişənlər arasında əlaqə xəttidir
  #2.Outliers - dəyişənlərin mühüm “outliers”-ləri yoxdur
  #3.Errorların müstəqilliyi – Durbin-Watson testi
  #4.Multikolinearlıq - VIF (Variance Inflation Factor) testi
  #5.Homoskedastiklik (Dəyişməz varians) - Scale-Location qrafiki
  #6.Normal Qalıqlar (Normality of residuals) - Q-Q Plot və Shapiro-Wilk testi

fit <- lm(score ~ iq + hours, data = stud)

#1.Xəttilik
plot(fit$fitted.values, fit$residuals)
plot(fit, which = 1)
#Əgər qrafikdə təsadüfi yayılmış bulud formasındadırsa - Xəttilik fərziyyəsi yerinə yetirilir.

#2.Outliers
plot(cooks.distance(fit))
abline(h = 4 / nrow(stud), col = "red", lty = 2)

plot(fit, which = 4)
abline(h = 4 / nrow(stud), col = "red", lty = 2)
#Qırmızı xəttin üstündə olan müşahidələr potensial outlier hesab olunur.

#3.Errorların müstəqilliyi
library(lmtest)
dwtest(fit)
#p-value > 0.05 - errorlar müstəqildir.
#p-value < 0.05 - avtokorrelyasiya var.

#4.Multikolinearlıq
library(car)
car::vif(fit)
#VIF > 5 - multikolinearlıq problemi var.

#5.Homoskedastiklik
plot(fit, which = 3)
#Qrafikdə qalıqların yayılması sabitdirsə - fərziyyə yerinə yetirilir.

#6.Normal Qalıqlar
plot(fit, which = 2)
#qrafikində nöqtələr düz xəttə yaxın yerləşibsə - qalıqlar normaldır.

shapiro.test(fit$residuals)
#p-value > 0.05 - normal paylanma fərziyyəsi qəbul edilir.
