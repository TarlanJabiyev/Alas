library(tidyverse)
library(RSelenium)
library(wdman)
library(netstat)

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

remDr$navigate("https://login.jupitered.com/")

element <- remDr$findElement(using = "id", value = "tab_staff")
remDr$mouseMoveToLocation(webElement = element)
remDr$click(buttonId = "RIGHT")

username <- remDr$findElement(using = "id", value = "text_username1") 
username$clearElement()
username$sendKeysToElement(list("shiny"))

password <- remDr$findElement(using = "id", value = "text_password1") 
password$clearElement()
password$sendKeysToElement(list("q1!w2@e3#r4$t5%"))

lock <- remDr$findElement(using = "id", value = "timeoutin1_label")
remDr$mouseMoveToLocation(webElement = lock)
remDr$click(buttonId = "RIGHT")

minutes <- remDr$findElements(
  using = "xpath",
  value = "//*[text() = 'Lock screen if idle 60 minutes']")
minutes[[1]]$clickElement()

button <- remDr$findElement(using = "id", value = "loginbtn")
remDr$mouseMoveToLocation(webElement = button)
remDr$click(buttonId = "RIGHT")
