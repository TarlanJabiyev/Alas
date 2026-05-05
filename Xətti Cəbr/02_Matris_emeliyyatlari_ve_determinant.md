# Matris Əməliyyatları və Determinant

## 1. Sadə Əməliyyatlar

Matrislərin toplanması ($A + B$) və çıxılması ($A - B$) eyni ölçülü matrislər arasında aparılır. Hər indeksdəki element yalnız öz indeksində olan element ilə əməliyyata girir.

Matrisin hər hansı bir ədədə (skalyara) vurulması da eyni qayda ilə həyata keçirilir. Bu zaman matrisin bütün elementləri həmin skalyara vurulur.
**Hadamard hasili (Element-bə-element vurulma):** İki matrisin eyni mövqedəki elementlərinin bir-birinə vurulması ilə əldə edilir. Kodlaşdırmada bunu `A * B` kimi yazırıq (lakin bu, xətti cəbrdəki *əsl matris hasili* deyil).

## 2. Matrislərin Həqiqi Vurulması (Dot Product / Matrix Multiplication)

$C = A \cdot B$
Bu əməliyyat yalnız o zaman mümkündür ki, birinci matrisin ($A$) sütunlarının sayı ikinci matrisin ($B$) sətirlərinin sayına bərabər olsun.
Nəticədə alınan matrisin $C_{i,j}$ elementi, $A$-nın $i$-ci sətirinin $B$-nin $j$-ci sütununa skalyar vurulması (dot product) ilə tapılır.

**Xassələri (Ətraflı):**

1. **Assosiativlik (Birgəlik) xassəsi:** $(AB)C = A(BC)$
   *İzahı:* Üç və ya daha çox matrisi bir-birinə vurarkən əməliyyatın hansı cütlüklərdən başlamasının (mötərizələrin mövqeyinin) yekun nəticəyə təsiri yoxdur. Tətbiqi proqramlaşdırmada hesablamanın sürətini optimallaşdırmaq üçün bu xassədən geniş istifadə olunur.
2. **Distributivlik (Paylama) xassəsi:** $A(B + C) = AB + AC$ və $(A + B)C = AC + BC$
   *İzahı:* Bir matrisi digər matrislərin cəminə vurmaq, hər bir matrisi tək-tək vurub toplamağa bərabərdir.
3. **Kommutativlik (Yerdəyişmə) xassəsi ümumən yoxdur:** Əksər hallarda $AB \neq BA$.
   *İzahı:* Həqiqi ədədlərdən (məs. $5 \times 4 = 4 \times 5$) fərqli olaraq, matris vurulmasında sıralama kritikdir. Yalnız xüsusi hallarda (məsələn matrislərdən biri *Vahid* matrisdirsə və ya matrisi öz *tərsi* ilə vururamsa) bu qayda poza bilər.
4. **Vahid matrisə vurulma:** $A \cdot I = I \cdot A = A$
   *İzahı:* Vahid matris ($I$) skalyar hesablama sistemindəki "1" rəqəminin rolunu oynayır. Hər hansı kvadrat matrisi ona vurduqda matrisin özü alınır.

## 3. Matrisin İzi (Trace)

Kvadrat matrisin **izi** ($Tr(A)$), onun əsas diaqonalı üzərində yerləşən elementlərin cəminə bərabərdir. İzi hesablamaq üçün matris mütləq **kvadrat** ($n \times n$) olmalıdır.

**Riyazi ifadəsi:**
Əgər $A$ matrisi $n \times n$ ölçülü kvadrat matrisdirsə:

$$
Tr(A) = \sum_{i=1}^{n} a_{ii} = a_{11} + a_{22} + \dots + a_{nn}
$$

#### Əsas Xassələri:

1. **Xəttilik (Linearity):**
   - $Tr(A + B) = Tr(A) + Tr(B)$
   - $Tr(c \cdot A) = c \cdot Tr(A)$ (burada $c$ skalyar ədəddir)
2. **Transponirə edilmiş matrisin izi:**
   - $Tr(A) = Tr(A^T)$
   - Matrisin sətir və sütunlarının yerini dəyişmək diaqonal elementlərinə təsir etmir.
3. **Dövri xassə:**
   - $Tr(AB) = Tr(BA)$
   - **Vacib qeyd:** Baxmayaraq ki, ümumən $AB \neq BA$, onların izləri həmişə bərabərdir. Bu xassə $Tr(ABC) = Tr(BCA) = Tr(CAB)$ şəklində daha çox matris üçün də keçərlidir.

#### Misal:

$A = \begin{bmatrix} 5 & 2 & 1 \\ 0 & -3 & 8 \\ 4 & 1 & 7 \end{bmatrix}$ matrisinin izini tapaq:

$$
Tr(A) = 5 + (-3) + 7 = 9
$$

## 4. Determinant və Onun Xassələri

Determinant yalnız kvadrat matrislər üçün hesablanır və fəzanın (həcmin və ya sahənin) xətti çevrilməsi zamanı miqyasın (scale) nə qədər dəyişdiyini göstərən ölçü faktorudur.

**Həndəsi mənası:** Məsələn, $2 \times 2$ matrisin determinantı həmin matrisin sütun vektorlarının əmələ gətirdiyi paraleloqramın sahəsinə bərabərdir. Əgər $\det(A) = 0$-dırsa, bu o deməkdir ki, fəza "çöküb" (məsələn, sahə xəttə çevrilib) və matrisin **tərsi yoxdur** (sinqulyar matris).

### Hesablanma üsulları:

- **$2 \times 2$ matris üçün:** $\det(A) = ad - bc$
- **$3 \times 3$ matris üçün (Kofaktor açılışı):**
  $$
  \det(A) = a(ei - fh) - b(di - fg) + c(dh - eg)
  $$

### Əsas Xassələr (Detallı):

1. **Vurma xassəsi:** $\det(AB) = \det(A) \cdot \det(B)$
   *İzah:* İki çevrilmənin birgə miqyas dəyişimi, onların tək-tək miqyas dəyişimlərinin hasilinə bərabərdir.
2. **Transponirə xassəsi:** $\det(A^T) = \det(A)$
   *İzah:* Sətir və sütunların yerini dəyişmək determinantın qiymətinə təsir etmir.
3. **Vahid matris:** $\det(I) = 1$
4. **Sətir əməliyyatlarının təsiri:**
   - İki sətirin (və ya sütunun) yerini dəyişdikdə determinant **işarəsini dəyişir**.
   - Bir sətiri $k$ skalyarına vurduqda, determinant da $k$ dəfə artır.
   - Bir sətirin üzərinə digər sətirin mislini əlavə etdikdə **determinant dəyişmir** (bu, hesablamanı sadələşdirmək üçün ən çox istifadə olunan xassədir).
5. **Skalyar vurma:** $\det(k \cdot A) = k^n \cdot \det(A)$ (burada $n$ matrisin tərtibidir).
   *İzah:* Bütün matrisi $k$-ya vurmaq, hər bir sətiri $k$-ya vurmaq deməkdir ($n$ sayda sətir olduğu üçün $k^n$ alınır).
6. **Sıfıra bərabərlik halları:**
   - Hər hansı sətir və ya sütun tamamilə $0$-dırsa, $\det(A) = 0$.
   - İki sətir və ya sütun eynidirsə (və ya mütənasibdirsə), $\det(A) = 0$.

### Misallar və Nümunələr

#### Misal 1: $2 \times 2$ matrisin determinantı

$A = \begin{bmatrix} 3 & 4 \\ 2 & 5 \end{bmatrix}$ matrisinin determinantını tapaq:

$$
\det(A) = (3 \cdot 5) - (4 \cdot 2) = 15 - 8 = 7
$$

#### Misal 2: $3 \times 3$ matrisin determinantı (Kofaktor açılışı)

$B = \begin{bmatrix} 1 & 2 & 3 \\ 0 & 1 & 4 \\ 5 & 6 & 0 \end{bmatrix}$ matrisinin determinantını 1-ci sütun üzrə kofaktor açılışı ilə hesablayaq:

> **Strateji Qeyd:** Determinantı istənilən sətir və ya sütun üzrə açmaq olar və nəticə dəyişməz qalır. Lakin hesablama prosesini sadələşdirmək üçün adətən tərkibində **ən çox sıfır (0)** olan sətir və ya sütun seçilir.

1. **1-ci sütun, 1-ci sətir elementi (1):** Bu elementin sətir və sütununu silsək, qalan $2 \times 2$ matris: $\begin{vmatrix} 1 & 4 \\ 6 & 0 \end{vmatrix}$.
2. **1-ci sütun, 2-ci sətir elementi (0):** Bu elementin sətir və sütununu silsək, qalan $2 \times 2$ matris: $\begin{vmatrix} 2 & 3 \\ 6 & 0 \end{vmatrix}$ (lakin 0-a vurulduğu üçün nəticə onsuz da 0 olacaq).
3. **1-ci sütun, 3-cü sətir elementi (5):** Bu elementin sətir və sütununu silsək, qalan $2 \times 2$ matris: $\begin{vmatrix} 2 & 3 \\ 1 & 4 \end{vmatrix}$.

**Tam hesablama:**

$$
\det(B) = 1 \cdot \begin{vmatrix} 1 & 4 \\ 6 & 0 \end{vmatrix} - 0 \cdot \begin{vmatrix} 2 & 3 \\ 6 & 0 \end{vmatrix} + 5 \cdot \begin{vmatrix} 2 & 3 \\ 1 & 4 \end{vmatrix}
$$

$$
\det(B) = 1 \cdot (1 \cdot 0 - 6 \cdot 4) - 0 + 5 \cdot (2 \cdot 4 - 1 \cdot 3)
$$

$$
\det(B) = 1 \cdot (-24) + 5 \cdot (8 - 3)
$$

$$
\det(B) = -24 + 5 \cdot 5 = -24 + 25 = 1
$$

#### Misal 3: Xassələrin tətbiqi

Tutaq ki, $A$ matrisi $3 \times 3$ ölçülüdür və $\det(A) = 4$. Aşağıdakıları tapaq:

1. **Skalyar vurma:** $\det(2A) = 2^3 \cdot \det(A) = 8 \cdot 4 = 32$
2. **Transponirə:** $\det(A^T) = \det(A) = 4$
3. **Hasilin determinantı:** Əgər $\det(B) = 3$ olarsa, $\det(AB) = 4 \cdot 3 = 12$
