# Müstəqil Nümunə T testi - Independent-Sample T test ----

sp <- read.csv("spanish.csv")

#İspan dili dərsini götürən tələbələrlə götürməyənlər arasında qiymət ortalamasında ciddi fərqin olub-olmadığını müəyyən olunması.

#İlkin fərziyyələr:
  # asılı dəyişən hər iki qrupda normal paylanmışdır
  # asılı dəyişəndə heç bir qrupda mühüm "outliers" yoxdur
  # qrup variansı bərabərdir

# variansların homojenliyi fərziyyəsini yoxlamaq
library(car)
leveneTest(sp$score, sp$course)

#H0 hipotezi (varianslar bərabərdir) rədd edilmir. 
#Qruplar arasında varians fərqi statistik olaraq əhəmiyyətli deyil.


#Əgər qrup variansları bərabər olarsa t testini, 
#qrup variansları bərabər deyilsə, biz "Welch" testini həyata keçirəcəyik

t.test(sp$score~sp$course, var.equal=T)
t.test(sp$score~sp$course, var.equal=F)

#Nəticə:
  #p-value < 0.05 → Əhəmiyyətli fərq var
  #Təsadüfən fərq olma ehtimalı çox azdır.
  #Qruplar arasında statistik əhəmiyyətli fərq var.

#Hər iki testdə p-value çox kiçikdir (0.05-dən aşağı), bu da göstərir ki:
  #Qrupların ortalama balları arasında statistik olaraq əhəmiyyətli fərq var.
  #Kurs keçənlərin (yes) orta balı daha yüksəkdir.


# Boxplot ilə kurs keçib-keçməyənlər üzrə nəticələr
boxplot(score ~ course, data = sp,
        col = c("lightblue", "lightpink"),
        main = "Skorların kursa görə müqayisəsi",
        xlab = "Kurs Keçib?",
        ylab = "Skor")


# Qoşalaşmış Nümunə T testi - Paired-Sample T test ----

mat <- read.csv("math.csv")

#Riyaziyyat kursundan əvvəl və sonra nəticələrin ortalama balları arasında əhəmiyyətli fərqin olub-olmadığını yoxlamaq

#İlkin fərziyyələr:
  #asılı dəyişənlər arasındakı fərqlər normal paylanıb.
  #asılı dəyişənlər arasındakı fərqlərdə mühüm "outliers" yoxdur.

t.test(mat$grade2, mat$grade1, paired=T)

#p < 0.05 olduğuna görə: İki qiymət arasında statistik olaraq əhəmiyyətli fərq var.
#Ortalama fərq ≈ 1.18: 2-ci qiymət (grade2) ortalama olaraq 1.18 bal yüksəkdir 1-ci qiymətdən (grade1).
#Etibar intervalı: Həqiqi orta fərq 95% ehtimalla 1.12 ilə 1.23 arasındadır.

#Nəticə:
  #Şagirdlərin ikinci qiyməti (grade2) statistik olaraq əhəmiyyətli şəkildə artmışdır. 
  #Bu, təlim və ya müdaxilənin müsbət təsir etdiyini göstərə bilər.


# "One-Way ANOVA" ----

vit <- read.csv("vitamin1.csv")

#3 qrup (platsebo, aşağı doza, yüksək doza) arasında orta səy müqavimətinə 
#(effort resistance) görə fərq olub-olmadığını yoxlamaq

#İlkin fərziyyələr:
  #asılı dəyişən bütün qruplarda normal paylanmışdır
  #asılı dəyişəndə heç bir qrupda mühüm outliers yoxdur
  #qrup variansları bərabərdir

# varians bərabərliyinin yoxlanılması
leveneTest(vit$effort, vit$dose)

#H₀ (null hipotez): Qruplar arasında varyanslar eynidir.
#H₁ (alternativ hipotez): Qruplar arasında varyanslar fərqlidir.
#p > 0.05 olduğuna görə, H₀ rədd olunmur.

aov1 <- aov(effort ~ dose, data = vit)
summary(aov1)

#H₀ (null hipotez): Bütün doza qruplarının ortalamaları eynidir.
#H₁ (alternativ hipotez): Ən azı bir doza qrupu digərindən fərqlidir.

#Nəticə:
  #F qiyməti = 50.18, çox yüksəkdir.
  #p-dəyəri < 0.001 (yəni < 2e-16) olduğuna görə, H₀ rədd olunur.
  #Dozanın səviyyəsi effort dəyişəninə statistik olaraq əhəmiyyətli təsir göstərir.

#İndi Tukey HSD testi ilə hansı doza qruplarının bir-birindən fərqləndiyini araşdıraq:
TukeyHSD(aov1)  

#ANOVA testindən sonra aparılan Tukey HSD testi göstərir ki, doza qrupları 
#arasında cüt müqayisələrdə əhəmiyyətli fərqlər mövcuddur.

#Nəticələrin Yorumlanması:
  #High dose qrupunun effort səviyyəsi həm placebo, həm də low dose qruplarından significantly yüksəkdir.
  #Low dose və placebo qrupları arasında da statistik olaraq əhəmiyyətli fərq var (p = 0.043), lakin bu fərq nisbətən zəifdir.

#Yekun Qərar:
  #Dozanın miqdarı insanın göstərdiyi effort (cəhd/səylilik) səviyyəsinə mühüm təsir edir. 
  #Xüsusilə, high dose qəbul edənlər digərləri ilə müqayisədə daha çox effort göstərirlər.


# Boxplot ilə effort dəyişəninə görə dozaların təsiri
boxplot(effort ~ dose, data = vit,
        col = c("lightblue", "lightgreen", "lightpink"),
        main = "Doza növünə görə Effort səviyyəsi",
        xlab = "Doza növü",
        ylab = "Effort səviyyəsi")


# "Two-Way ANOVA" ----

vit <- read.csv("vitamin2.csv")

#"vitamin" və "gender" faktorlarının işçilərin effort müqavimətinə təsir edib-etmədiyini müəyyən etmək

#İlkin fərziyyələr:
  #asılı dəyişən bütün qruplarda normal paylanmışdır
  #asılı dəyişəndə heç bir qrupda mühüm outliers yoxdur
  #qrup variansları bərabərdir

#Bu model effort dəyişəninə dose, gender, və onların qarşılıqlı təsiri (dose:gender) təsir edirmi, onu yoxlayır.
aov2 <- aov(effort ~ dose + gender + dose * gender, data = vit)
summary(aov2)

#P dəyərlər hamısında kiçikdir: hər bir faktor (dose, gender) və onların qarşılıqlı təsiri (dose * gender) statistik olaraq əhəmiyyətlidir.
#Bu o deməkdir ki:
  #Müxtəlif doza səviyyələri effort-a fərqli təsir edir.
  #Genderlər arasında effort fərqi var.
  #Eyni doza müxtəlif genderlərdə eyni dərəcədə təsir göstərmir - interaksiyalı effekt mövcuddur.

# Boxplot
library(ggplot2)
ggplot(vit, aes(x = dose, y = effort, fill = gender)) +
  geom_boxplot() +
  labs(title = "Effort ~ Doza və Gender qarşılıqlı təsiri",
       x = "Doza növü", y = "Effort səviyyəsi")
