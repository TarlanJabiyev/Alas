# One-Sample T test ----

data <- read.csv("demographics.csv") 

#Əsas fərziyyələr:
  #Dəyişən normal paylanmışdır.
  #Dəyişənin mühüm “outliers”-ləri yoxdur.

#Nəticənin izahı:
  #H₀ (null hipotez): μ = 70 (orta gəlir 70-dir)
  #H₁ (alternativ hipotez): μ ≠ 70

#Orta gəlirin 70-dən əhəmiyyətli dərəcədə fərqli olub-olmadığını yoxlayacağıq.
#Əgər p-value < 0.05 olarsa, null hipotezi rədd edirik, yəni gəlir 70-dən əhəmiyyətli dərəcədə fərqlənir.

t.test(data$income, mu=70)

#Izah:
# - Orta gəlir (78.59) nəzəri dəyər olan 70-dən yüksəkdir, lakin bu fərqin statistik baxımdan əhəmiyyətli olub-olmadığını p-value ilə qiymətləndiririk.
# - p-value = 0.08456 - Bu dəyər 0.05-dən böyükdür. 
#   Bu o deməkdir ki, 70-dən fərqli olması ehtimalı statistik cəhətdən əhəmiyyətli deyil.
# - 95% güvən intervalı (68.82 - 88.36):
#   Bu interval 70-i də əhatə edir, bu da o deməkdir ki, əminliklə 70-dən fərqlənir demək mümkün deyil.

#Nəticə (Yekun qərar):
  #H₀ hipotezi rədd edilmir.Yəni income dəyişəninin ortalaması 70-dən əhəmiyyətli dərəcədə fərqlənmir (α = 0.05 səviyyəsində baxsaq).
  #Qısaca - Müşahidə etdiyimiz orta gəlir 78.59 olsa da, bu fərq statistik cəhətdən əhəmiyyətli deyil – çünki p-value 0.05-dən böyükdür.


# "Binomial" Test ----

#Məqsəd: kişi-qadın nisbətinin 50/50 olub-olmadığını yoxlayacağıq.
mytable <- table(data$gender)
mytable

prop.table(mytable)

binom.test(mytable, p=0.50, conf.level=0.95)

#Izah:
# - Müşahidə edilən kişi nisbəti: 0.49 - bu, nəzəri 0.50 nisbətindən bir qədər azdır, lakin çox yaxın.
# - p-value = 0.6903 - bu dəyər çox böyükdür və 0.05-dən çox yuxarıdır.
#   Bu o deməkdir ki, müşahidə olunan 0.49 nisbəti ilə nəzəri 0.50 nisbəti arasında statistik olaraq əhəmiyyətli fərq yoxdur.
# - 95% güvən intervalı (0.446 - 0.535):
#   Bu interval 0.50 dəyərini əhatə edir, yəni kişi nisbətinin 0.50 ola bilmə ehtimalı var.

#Nəticə (Yekun qərar):
  #H₀ hipotezi rədd edilmir.Yəni, kişilərin nisbəti statistik olaraq 50% ilə uyğundur.
  #Qısaca - Bu test göstərdi ki, kişilərin sayı 250 olsa da, bu, təsadüfi dəyişkənliyin nəticəsi ola bilər. 
  #         Cinslərin 50/50 nisbətdə olması əvvəlki fərziyyə kimi qəbul oluna bilər - müşahidə olunan fərq əhəmiyyətli deyil.


#kişi subyektlərin nisbətinin 60% olub-olmadığını yoxlamaq.
binom.test(mytable, p=0.40, conf.level=0.95)

#Izah:
# - Müşahidə olunan kişi nisbəti təqribən 49%-dir, lakin biz yoxlayırıq ki, bu nisbət 40% ola bilərmi?
# - p-value = 0.00003786 - bu çox kiçik bir dəyərdir, 
#   yəni müşahidə etdiyimiz nəticə (49%) nəzəri ehtimal olan 40%-lə statistik baxımdan uyğun gəlmir.
# - 95% güvən intervalı (0.446 - 0.535) - bu interval 0.40-ı əhatə etmir, bu da H₀-nin rədd edilməsi üçün əlavə sübutdur.

#Nəticə (Yekun qərar):
  #H₀ hipotezi rədd edilmir.Yəni kişilərin nisbəti 40%-dən statistik cəhətdən əhəmiyyətli dərəcədə fərqlidir.
  #Qısaca - Əgər biri desə ki, "kişilərin nisbəti 40%-dir", 
  #         bu test göstərir ki, yox, deyil - əslində 49% müşahidə olunub və bu fərq təsadüfi deyil, əhəmiyyətlidir.


# "Chi-Square" Test ----

#Məqsəd: Təhsil səviyyəsinin (educ) bərabər ehtimallarla paylanıb-paylanmadığını yoxlamaq.
mytable <- table(data$educ) 
mytable

n <- length(mytable) 
n 
thprop <- 1/n 
thprop

chisq.test(mytable, p=rep(thprop, n))

#Izah:
# - Chi-Square statistikası çox böyükdür (71.529) - Bu o deməkdir ki, müşahidə olunan tezliklərlə nəzəri tezliklər arasında böyük fərq var.
# - p-value çox kiçikdir - 0.05-dən (və hətta 0.01-dən) çox kiçik, deməli bu fərq statistik olaraq əhəmiyyətlidir.

#Nəticə (Yekun qərar):
#H₀ hipotezi qəti şəkildə rədd edilir. Yəni təhsil səviyyələri bərabər ehtimalla (20% hər bir səviyyə üçün) paylanmayıb.
#Müşahidə olunan bölgü bərabər paylamadan əhəmiyyətli dərəcədə fərqlənir.
#Qısaca - Təhsil səviyyələrinin paylanması təsadüfi və bərabər deyil. 
#         Bəzi səviyyələr daha çox, bəziləri isə daha az təmsil olunub. Bu nəticə çox güclü statistik sübutla təsdiqlənir.


chisq.test(mytable, p=rep(thprop, n))$expected #gözlənilən dəyərlər - (nəzəri ehtimallara əsasən)
#Bu dəyərlər, bərabər ehtimallı paylama fərziyyəsinə əsasən hesablanıb. 
#Çünki 510 nəfər var və 5 təhsil səviyyəsi → hər biri üçün 510 / 5 = 102 nəfər gözlənilir.

chisq.test(mytable, p=rep(thprop, n))$residuals #qalıq dəyərlər = müşahidə - gözlənilən
#Müsbət qalıq - Gözləniləndən çox müşahidə edilib
#Mənfi qalıq - Gözləniləndən az müşahidə edilib

chisq.test(mytable, p=rep(thprop, n))$stdres #standartlaşdırılmış qalıqlar - Qalıqların standartlaşdırılmış forması (yəni z-score formasında)
# |z| > 2 - statistik olaraq əhəmiyyətli fərq var
# |z| > 3 - çox əhəmiyyətli fərq


#Qeyri-bərabər nəzəri ehtimallarla Chi-Square Test - nin yerinə yetirilməsi.
chisq.test(mytable, p=c(0.30,0.30,0.20,0.10,0.10)) 
chisq.test(mytable, p=c(0.30,0.30,0.20,0.10,0.10))$expected
