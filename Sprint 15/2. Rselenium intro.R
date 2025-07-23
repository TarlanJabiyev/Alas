library(tidyverse)
library(RSelenium)
library(wdman)
library(netstat)

#selenium()

#chtomeCommand <- chrome(retcommand = T, verbose = F, check = F)

#https://googlechromelabs.github.io/chrome-for-testing/

#binman::list_versions("chromedriver")


#rs_driver_object <- rsDriver(
#  browser = "chrome",
#  chromever = "138.0.7204.94",
#  verbose = F,
#  port = free_port()
#)
#remDr <- rs_driver_object$client


#tryCatch({
#  rs_driver_object <- rsDriver(
#    browser = "chrome",
#    port = free_port(),
#    verbose = F,
#    check = F 
#  )
#  
#  cat("✓ RSelenium setup successful!\n")
#  return(rs_driver_object)
#  
#}, error = function(e) {
#  cat("❌ Setup failed:", e$message, "\n")
#  
#  # Try alternative method
#  cat("Trying alternative method...\n")
#  
#  tryCatch({
#    # Use wdman directly
#    chrDrv <- wdman::chrome(port = free_port(), check = F)
#    
#    remDr <- RSelenium::remoteDriver(
#      remoteServerAddr = "localhost",
#      port = free_port(),
#      browserName = "chrome"
#    )
#    
#    remDr$open()
#    
#    cat("✓ Alternative method successful!\n")
#    return(list(server = chrDrv, client = remDr))
#    
#  }, error = function(e2) {
#    cat("❌ Alternative method also failed:", e2$message, "\n")
#    return(NULL)
#  })
#})


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

remDr$navigate("https://opendata.az/@dsk/main-economic-indicators-of-hunting-farms")
