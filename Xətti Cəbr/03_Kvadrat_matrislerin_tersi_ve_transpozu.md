# Kvadrat Matrislərin Tərsi, Transpozu və Xətti Tənliklər Sitemi

## 1. Matrisin Transpozu (Transpose)

Transpoz əməliyyatı sadə bir fırlanmadır (reflection). $A$ matrisinin $A^T$ formasına salınması sətirlərin sütuna çevrilməsidir.

**Simmetrik Matrislər:**
Əgər eyni kvadrat matris üçün $A^T = A$ olarsa, həmin matris *simmetrik matris* adlanır. Simmetrik matrislərin elementləri əsas diaqonala nəzərən simmetrik formada olur. (Məs. Korelyasiya (Correlation) matrisiləri maşın öyrənməsində hər zaman simmetrikdir).

**Əks-Simmetrik (Skew-symmetric) Matrislər:**
Əgər $A^T = -A$ olarsa.

## 2. Matrisin Tərsi (Inverse)

Yalnız kvadrat və determinantı $0$-dan fərqli olan matrislərin tərsi mövcud ola bilər.
$A \cdot A^{-1} = I$ (Vahid matris).

**Bölgü Yoxdur!**
Xətti cəbrdə matrislər arasında rəsmi mənada "bölmə" əməliyyatı yoxdur. Bunun əvəzinə tərsinə vurmaqdan istifadə edirik (yəni $B / A \implies B \cdot A^{-1}$).

### Tərsin Hesablanması Analitik Olaraq

Matrisin tərsi $A^{-1} = \frac{1}{\det(A)} Adj(A)$ düsturu ilə tapılır. Burada $Adj(A)$ Kofaktor matrisinin transpozudur (Adjugate matrix).

#### Misal: $2 \times 2$ matrisin tərsi

$A = \begin{bmatrix} 1 & 2 \\ 3 & 4 \end{bmatrix}$ matrisinin tərsini tapaq:

1. **Determinantı hesablayaq:** $\det(A) = (1 \cdot 4) - (2 \cdot 3) = 4 - 6 = -2$ (Sıfır deyil, deməli tərsi var).
2. **Tərs matris düsturu ($2 \times 2$ üçün):**
   $$
   A^{-1} = \frac{1}{\det(A)} \begin{bmatrix} d & -b \\ -c & a \end{bmatrix} = \frac{1}{-2} \begin{bmatrix} 4 & -2 \\ -3 & 1 \end{bmatrix}
   $$
3. **Yekun nəticə:**
   $$
   A^{-1} = \begin{bmatrix} -2 & 1 \\ 1.5 & -0.5 \end{bmatrix}
   $$

**Yoxlama:** $A \cdot A^{-1} = \begin{bmatrix} 1 & 2 \\ 3 & 4 \end{bmatrix} \begin{bmatrix} -2 & 1 \\ 1.5 & -0.5 \end{bmatrix} = \begin{bmatrix} 1 & 0 \\ 0 & 1 \end{bmatrix} = I$

## 3. Xətti Tənliklər Sisteminin Həlli

Bilirik ki, mürəkkəb xətti tənliklər sistemini klassik tənlik daxilindən əvəzetmələrin edilməsi ilə tapmaq praktik deyil. Biz matris formullarını istifadə edirik.

Sistem:
$A\mathbf{x} = \mathbf{b}$

Burada $A$ **əmsallar matrisi**, $\mathbf{x}$ məchullar vektoru, $\mathbf{b}$ isə nəticə (cavab) vektorudur.
Çıxarış: hər iki tərəfi soldan $A^{-1}$-ə vursaq:

$$
A^{-1} A \mathbf{x} = A^{-1} \mathbf{b}
$$

$$
I \mathbf{x} = A^{-1} \mathbf{b}
$$

$$
\mathbf{x} = A^{-1} \mathbf{b}
$$

Beləliklə, $\mathbf{x}$ bütün məchulların cavablarını özündə saxlayan vektor olaraq tapılır.

#### Misal: Sistem tənliyin matris üsulu ilə həlli

Aşağıdakı tənliklər sistemini həll edək:
$\begin{cases} 2x + y = 5 \\ 3x + 2y = 8 \end{cases}$

1. **Matris formasına salaq ($A\mathbf{x} = \mathbf{b}$):**

   $$
   \begin{bmatrix} 2 & 1 \\ 3 & 2 \end{bmatrix} \begin{bmatrix} x \\ y \end{bmatrix} = \begin{bmatrix} 5 \\ 8 \end{bmatrix}
   $$
2. **Əmsallar matrisinin ($A$) tərsini tapaq:**
   $\det(A) = (2 \cdot 2) - (1 \cdot 3) = 1$

   $$
   A^{-1} = \frac{1}{1} \begin{bmatrix} 2 & -1 \\ -3 & 2 \end{bmatrix} = \begin{bmatrix} 2 & -1 \\ -3 & 2 \end{bmatrix}
   $$
3. **Məchullar vektorunu tapaq ($\mathbf{x} = A^{-1} \mathbf{b}$):**

   $$
   \begin{bmatrix} x \\ y \end{bmatrix} = \begin{bmatrix} 2 & -1 \\ -3 & 2 \end{bmatrix} \begin{bmatrix} 5 \\ 8 \end{bmatrix} = \begin{bmatrix} (2 \cdot 5) + (-1 \cdot 8) \\ (-3 \cdot 5) + (2 \cdot 8) \end{bmatrix}
   $$

   $$
   \begin{bmatrix} x \\ y \end{bmatrix} = \begin{bmatrix} 10 - 8 \\ -15 + 16 \end{bmatrix} = \begin{bmatrix} 2 \\ 1 \end{bmatrix}
   $$

**Cavab:** $x = 2, y = 1$.
