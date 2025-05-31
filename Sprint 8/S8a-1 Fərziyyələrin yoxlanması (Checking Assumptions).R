# Normallıq fərziyyəsinin numerikal metodla yoxlanılması ----

data <- read.csv("demographics.csv")


#Shapiro-Wilk normallıq testi ilə (income) dəyişəninin normal paylanıb-paylanmadığını yoxlayacağıq.

shapiro.test(data$income)

#Hipotez:
  #H0 (Null fərziyyə): income dəyişəni normal paylanır.
  #H1 (Alternativ fərziyyə): income dəyişəni normal paylanmır.

#W = 0,48832: Bu, 1-dən çox uzaqdır, normal paylanmaya zəif uyğunluğu göstərir.
#p-dəyəri < 2.2e-16(0.00000000000000022): Bu, olduqca kiçikdir, hər hansı ümumi əhəmiyyət səviyyəsindən 
#(məsələn, 0.05, 0.01) çox aşağıdır, yəni normallığın sıfır hipotezi yüksək inamla rədd edilir.

#Qərar:
  #p-value < 0.05 - H0 rədd edilir.
  #Deməli, income dəyişəni normal paylanmır.


# Normallıq fərziyyəsinin qrafik  metodla yoxlanılması ----

hist(data$income, 
     breaks = 30, 
     col = "lightblue", 
     main = "Income Dəyişəninin Histogramı",
     xlab = "Income")


qqnorm(data$income, 
       main = "QQ Plot - Income")
qqline(data$income, 
       col = "red", 
       lwd = 2)
#Əgər nöqtələr qırmızı düz xətt boyunca düzülmürsə, bu normaldan sapma olduğunu göstərir.
