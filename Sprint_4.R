# Xətalarla İş ----

if (1 != 2) {
  stop("xəta!")
}


try({
  a <- 1
  b <- "x"
  a + b
})


hesab_1 <- try(1 + 2)
class(hesab_1)
inherits(hesab_1, "try-error")

hesab_2 <- try("a" + "b")
class(hesab_2)
inherits(hesab_2, "try-error")

hesab_2 <- try("a" + "b", silent = TRUE)
class(hesab_2)
inherits(hesab_2, "try-error")


tryCatch(
  {
    cat(sqrt(4))
  }, 
  warning = function(w) {
    cat("Warning:", w$message, "\n")
  }, 
  error = function(e) {
    cat("Error:", e$message, "\n")
  }, 
  finally = {
    cat("Hesablama prosesi tamamlandı", "\n")
  }
)

for (i in 1:5) {
  tryCatch(
    {
      if (i == 3) {
        stop("3-cü iterasiyada xəta baş verdi.")
      } else {
        cat(paste("İterasiya", i), "\n")
      }
    }, 
    error = function(e) {
      cat("Error on iteration", i, ": ", e$message, "\n")
    }
  )
}

vector <- c()
for (i in 1:6) {
  result <- tryCatch(
    {
      if (i == 3) {
        stop("3-cü iterasiyada error!")
      }
      i ** 2
    }, 
    error = function(e) {
      cat("Error:", e$message, "\n")
      NA
    }
  )
  vector <- c(vector, result)
}
vector

tryCatch(
  {
    number <- 6
    if (number > 5) {
      stop(simpleError("Number is too large!"))
    }
    sqrt(number)
  }, 
  error = function(e) {
    if (inherits(e, "simpleError")) { # "simpleError", "try-error"
      cat("Custom Error handled:", e$message, "\n")
    } else {
      cat("Other error handled:", e$message, "\n")
    }
  })


func_1 <- function(input) {
  if (!is.numeric(input)) {
    stop("input numeric olmalıdır")
  }
  hesab <- ((input - 25) * 0.75) + 25
  return(hesab)
}

func_1(51)
func_1("51")

tryCatch(
  {
    cat(func_1("51"))
  },
  error = function(e) {
    cat(e$message)
  }
)


# Apply funksiyaları ailəsi ----

### apply()

matrix_1 <- matrix(1:30, nrow = 5, ncol = 6)
df_1 <- as.data.frame(matrix_1)
df_1

apply(df_1, MARGIN = 2, FUN = sum) # MARGIN - 1,2

df_1[2:3,c(4,6)] <- NA
df_1

apply(df_1, 1, mean, na.rm = T)


#### lapply()

lapply(df_1, sum, na.rm = T)

unlist(lapply(df_1, sum, na.rm = T))


list_1 <- list(A = matrix_1, B = c(1:5,NA), C = 8)
list_1

lapply(list_1, sum, na.rm = T)

lapply(list_1, function(x) x*2)


### sapply()

beaver_data <- list(beaver1 = beaver1, 
                    beaver2 = beaver2)

lapply(beaver_data, function(x) apply(x, 2, mean))
lapply(beaver_data, function(x) round(apply(x, 2, mean), 2))

sapply(beaver_data, function(x) round(apply(x, 2, mean), 2))

sapply(list_1, sum, na.rm = T)


### mapply()

x <- c(A = 20, B = 1, C = 40)
y <- c(J = 430, K = 50, L = 10)

func_1 <- function(u, v) {
  (u + v) * 2
}
mapply(func_1, x, y)


# Reduce() ----

library(purrr) 

nums <- 1:4
Reduce(function(x, y) x + y, nums)

nums <- c(3, 7, 2, 5)
Reduce(function(x, y) if (x > y) x else y, nums)

func_4 <- function(x, y) x * y
nums <- 1:4
Reduce(func_4, nums) 

sözlər <- c("Salam", "Alas", "Academy")
Reduce(function(x, y) paste(x, y, sep = " "), sözlər)  

nums <- c(10, 20, 30, 40)
total <- Reduce(function(x, y) x + y, nums)
total / length(nums)  

nums <- 1:5
Reduce(function(x, y) x * y, nums)  

words <- c("alma", "armud", "nar", "üzüm")
Reduce(function(x, y) if (nchar(x) > nchar(y)) x else y, words)  

chars <- c("P", "y", "t", "h", "o", "n")
Reduce(function(x, y) paste0(x, y), chars)  
