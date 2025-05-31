# "Pearson" korrelyasiyası ----

hw <- read.csv("hw.csv") 

#Subyektlərin boyu və çəkisi arasındakı əlaqənin hesablanamsı və şərhi

#İlkin fərziyyələr:
  # dəyişənlər normal paylanmışdır
  # əhəmiyyətli dərəcədə “outliers” yoxdur
  # dəyişənlər arasındakı əlaqə təxminən xəttidir

cor.test(hw$height, hw$weight, method="pearson")

#r – Statistikada Pearson korrelyasiya əmsalını ifadə edən simvoldur.
#Tələffüz: "ar"
#Bu əmsal iki dəyişən arasındakı xətti (linear) əlaqəni ölçür.

#Korrelyasiya əmsalı (r = 0.807):
  #Çox güclü müsbət korrelyasiya deməkdir.
  #Yəni boy artdıqca çəkinin də artma meyli yüksəkdir.

#p-value < 0.05 (çox kiçikdir):
  #H0 fərziyyəsi (korrelyasiya yoxdur) rədd olunur.
  #Boy ilə çəki arasında statistik olaraq əhəmiyyətli bir əlaqə mövcuddur.

#95% etibar intervalı (0.71 – 0.88):
  #Əsl korrelyasiya əmsalının bu aralıqda olması ehtimalı 95%-dir.
  #Bu da əlaqənin sabit və güclü olduğunu göstərir.


# "Spearman" korrelyasiyası ----

#Boy və çəki arasında monoton (mütəmadi artan və ya azalan) əlaqə varmı?

cor.test(hw$height, hw$weight, method="spearman")

#"rho" (ρ) — yunanca "r" hərfinin kiçik formasıdır.
#Statistikada "rho" adətən Spearman korrelyasiya əmsalını ifadə etmək üçün istifadə olunur.
#Tələffüzü: "ro"

#Spearman rho = 0.808:
  #Bu, çox güclü müsbət monoton əlaqə deməkdir.
  #Yəni boy artdıqca çəki ümumiyyətlə artır. Əlaqə xətti olmaq məcburiyyətində deyil, amma ardıcıl bir istiqamət var.

#p-value < 0.05:
  #H0 fərziyyəsi (rho = 0) rədd olunur.
  #Statistik olaraq əhəmiyyətli bir əlaqə mövcuddur.


# "Kendall" korrelyasiyası ----

#Boy və çəki arasında monoton əlaqə varmı?

cor.test(hw$height, hw$weight, method="kendall")

#"tau" (τ) - Yunan əlifbasında olan bir hərfdir.
#Statistikada Kendall's Tau (τ) adlanan korrelyasiya əmsalını ifadə etmək üçün istifadə olunur.
#Tələffüzü: "tau" (avropa dillərində “taʊ” kimi oxunur, yəni “tao”)

#Tau = 0.6225 - Bu müsbət və güclü monoton əlaqədir.
  #Yəni boy artdıqca, çəki də ümumiyyətlə artır.
  #Dəyərlər arasındakı uyğun sıralama əlaqəsi nəzərə alınır.

#p-value < 0.05
  #H0 fərziyyəsi (tau = 0) rədd edilir.
  #Bu o deməkdir ki, boy və çəki arasında statistik olaraq əhəmiyyətli əlaqə var.


# "Partial" korrelyasiya ----

ice <- read.csv("icecream.csv") 

#Dondurma satışı ilə infarktların sayı arasında qismən korrelyasiyanı hesablayacağıq
#control variable: temperatur

#Əvvəlcə dəyişənlər arasında Pearson korrelyasiyasının hesablanamsı lazımdır
cor.test(ice$attacks, ice$icecream)

#Partial korrelyasiya
library(ppcor)
pcor.test(ice$attacks, ice$icecream, ice$temp, method="pearson")

#Temperaturun təsiri aradan qaldırıldıqda (yəni nəzarət etdikdə), 
#dondurma satışı ilə infarkt arasında demək olar ki, əhəmiyyətli əlaqə qalmır.

#Görünən yüksək korrelyasiya: Dondurma satışı ilə infarkt arasında yüksək r (0.87) var
#Ancaq:	Temperatur həm dondurma satışını, həm də infarktı artıran ortaq faktor ola bilər
#Partial korrelyasiya:	Temperaturun təsirini çıxarıb araşdırdıqda, real əlaqənin zəif olduğu ortaya çıxır (r = 0.18, p > 0.4)

#"Korrelasiya səbəb demək deyil" - yəni dondurma satışlarının artması birbaşa infarkt artmasına səbəb olmur. Əsas səbəb temperaturdur.


# Müstəqil dəyişən üçün "Chi-Square" testi ----

bf <- read.csv("breakfast.csv") 

table(bf$agecat,bf$bfast)

#"agecat" (yaş kateqoriyası) və "bfast" (səhər yeməyinə üstünlük) dəyişənləri üçün assosiasiya üçün Chi-Square Testni hesablayacağıq.
library(gmodels)
CrossTable(bf$agecat, bf$bfast, expected=T, prop.r=F, prop.c=F, prop.t=F, prop.chisq=F)

#Cədvəldə hər hüceyrədə:
  #1ci sətrdə: müşahidə olunan say (N)
  #2ci sətrdə: gözlənilən say (Expected N) - yaşla səhər yeməyi seçimi əlaqəsizdirsə, bu say olmalı idi.

#Məsələn:
  #Yaşı 31-45 olan 90 nəfər Breakfast Bar seçib.
  #Halbuki, əgər yaşla seçim arasında əlaqə olmasaydı, bu say 54 olmalı idi.
  #Bu fərqlər nə qədər böyükdürsə, Chi-Kvadrat statistikası da o qədər böyük olur.

#Chi-Square Statistikası:
  #Chi^2 = 309.34 - çox yüksəkdir.
  #d.f. = (4 yaş qrupu - 1) × (3 yemək növü - 1) = 3 × 2 = 6
  #p-value < 0.001 - çox əhəmiyyətlidir, yəni nəticə təsadüfi ola bilməz.

#Nəticə:
  #Yaş kateqoriyası ilə səhər yeməyi seçimi arasında statistik olaraq əhəmiyyətli bir əlaqə var. (p < 0.001)
  #Başqa sözlə, insanlar müxtəlif yaş qruplarında olduqca, seçdikləri səhər yeməyi növü də dəyişir.


#Cramér's V statistikası: yaş kateqoriyası ilə səhər yeməyi seçimi arasında effekt ölçüsünü (effect size) göstərir.

library(lsr) 
cramersV(bf$agecat, bf$bfast)

# Cramér's V    | Effekt ölçüsü                 |
# ------------- | ----------------------------- |
# 0.1 və aşağı  | Zəif (weak) əlaqə             |
# 0.1 - 0.3     | Orta (moderate) əlaqə         |
# 0.3 - 0.5     | Güclü (strong) əlaqə          |
# 0.5 və yuxarı | Çox güclü (very strong) əlaqə |

#V = 0.419 - güclü əlaqə var deməkdir.
#Bu, o deməkdir ki, yaş qrupları ilə səhər yeməyi seçimi arasında statistik cəhətdən güclü bir əlaqə müşahidə olunur.
