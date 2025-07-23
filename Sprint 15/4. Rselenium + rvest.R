library(tidyverse)
library(RSelenium)
library(wdman)
library(netstat)  
library(rvest)
library(data.table) 

chrDrv <- chrome(
  port = free_port(), 
  check = F
)

remDr <- remoteDriver(
  remoteServerAddr = "localhost",
  port = free_port(),
  browserName = "chrome"
)

remDr$open()

remDr$navigate("https://salaries.texastribune.org/search/?q=%22Department+of+Public+Safety%22")

data_table <- remDr$findElement(using = 'id', 'pagination-table')

next_button <- remDr$findElement(using = 'xpath', '//a[@aria-label="Next Page"]')
next_button$clickElement() # təkrar kliklər üçün while loop yazaq

all_data <- list()
cond <- TRUE

while (cond == T) {
  data_table_html <- data_table$getPageSource()
  page <- data_table_html %>% unlist() %>% read_html()
  df <- page %>% html_table() %>% .[[2]]
  all_data <- rbindlist(list(all_data, df))
  
  #Sys.sleep(0.2)
  
  tryCatch(
    {
      next_button <- remDr$findElement(using = 'xpath', '//a[@aria-label="Next Page"]')
      next_button$clickElement()
    },
    error = function(e) {
      print("Script Complete!")
      cond <- FALSE
    }
  )
  
  if (cond == F){
    break
  }
}

colnames(all_data)[3] <- "Agency"

all_data$`Annual salary` <- all_data$`Annual salary` %>% 
  str_remove_all("[$,]") %>% 
  as.numeric()

all_data %>% 
  write_csv("Texas_Dept_of_Safety_Salaries.csv", na = "")
