# Vektorlar və Matrislər

## 1. Giriş

Xətti cəbr Data Elmləri, Maşın Öyrənməsi (Machine Learning), Kompüter Qrafikası və bir çox mühəndislik sahələrinin təməlini təşkil edir. Məlumatları ən effektiv şəkildə saxlamaq və işləmək üçün biz **vektorlar** və **matrislər** dən istifadə edirik.

### Skalyar, Vektor, Matris və Tenzor (Tensor)

- **Skalyar:** Yalnız ölçüsü (böyüklüyü) olan tək bir ədəddir (məsələn, temperatur, kütlə). $x \in \mathbb{R}$
- **Vektor:** Həm ölçüsü, həm də istiqaməti olan, 1 ölçülü (1D) ədədlər massividir.
- **Matris:** 2 ölçülü (2D) təşkil olunmuş sətir və sütunlardan ibarət düzbucaqlı cədvəldir.
- **Tenzor:** 3 və ya daha çox ölçülü vahidlərdir (məsələn, rəngli bir şəkil 3 ölçülü tenzordur: Hündürlük $\times$ Genişlik $\times$ RGB kanalları).

## 2. Vektorlar

Vektorlar riyaziyyatda fəza üzərində bir nöqtəni və ya istiqaməti göstərir.

### Sütun və Sətir Vektorları

* **Sütun vektoru** ($n \times 1$ matris kimi düşünülə bilər):

$$
\mathbf{v} = \begin{bmatrix} v_1 \\ v_2 \\ \vdots \\ v_n \end{bmatrix}
$$

* **Sətir vektoru** ($1 \times n$ matris):

$$
\mathbf{u} = \begin{bmatrix} u_1 & u_2 & \dots & u_n \end{bmatrix}
$$

### Vektorun Modulu (Uzunluğu)

Pifaqor teoremi əsasında hesablanır:

$$
\|\mathbf{v}\| = \sqrt{v_1^2 + v_2^2 + \dots + v_n^2}
$$

## 3. Matrislər

Matrislər xətti tənliklər sistemini təmsil etmək və xətti çevrilmələri (linear transformations) həyata keçirmək üçün istifadə olunur.

$A$ matrisinin elementi $A_{i,j}$ kimi oxunur (burada $i$ sətir indeksini, $j$ isə sütun indeksini bildirir).

$$
A = \begin{bmatrix}
A_{1,1} & A_{1,2} & A_{1,3} \\
A_{2,1} & A_{2,2} & A_{2,3}
\end{bmatrix}
$$

Bu matris $2 \times 3$ ölçülüdür.

## 4. Xüsusi Matris Növləri

- **Kvadrat Matris:** Sətir və sütun sayı bərabər olan matrisdir ($n \times n$).
  *Nümunə ($2 \times 2$):* $\begin{bmatrix} 4 & 5 \\ 1 & 8 \end{bmatrix}$
- **Diaqonal Matris:** Əsas diaqonal (yəni sol yuxarıdan sağ aşağıya doğru olan ox) xaricindəki bütün elementləri sıfır olan kvadrat matrisdir.
  *Nümunə:* $\begin{bmatrix} 3 & 0 & 0 \\ 0 & 5 & 0 \\ 0 & 0 & -2 \end{bmatrix}$
- **Vahid Matris ($I$):** Diaqonal elementləri 1, qalan bütün elementləri 0 olan kvadrat matris. Skalyar cəbrdəki '1' rəqəmi kimidir.
  *Nümunə ($3 \times 3$):* $I_3 = \begin{bmatrix} 1 & 0 & 0 \\ 0 & 1 & 0 \\ 0 & 0 & 1 \end{bmatrix}$
- **Sıfır Matris:** Bütün elementləri 0 olan matris. (Skalyar cəbrdəki '0').
  *Nümunə ($2 \times 3$):* $\begin{bmatrix} 0 & 0 & 0 \\ 0 & 0 & 0 \end{bmatrix}$
- **Üçbucaq Matrislər:** Əsas diaqonaldan yuxarıda (və ya aşağıda) qalan hissəsi yalnız sıfırlardan ibarət olan matrislər.
  *Nümunə (Yuxarı üçbucaq matris):* $\begin{bmatrix} 2 & 8 & -1 \\ 0 & 4 & 7 \\ 0 & 0 & 3 \end{bmatrix}$
