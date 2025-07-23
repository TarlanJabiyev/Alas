# RSelenium Troubleshooting Guide and Solutions
# Fix for the PhantomJS BitBucket API error

# Load required libraries
library(RSelenium)
library(wdman)
library(netstat)

# =============================================================================
# SOLUTION 1: Fix the PhantomJS/BitBucket API Error
# =============================================================================

# Your specific error: BitBucket API returns 402 Payment Required
# This happens because wdman tries to access deprecated PhantomJS repo

# IMMEDIATE FIX - Use this code instead:
fix_rselenium_setup <- function() {
  cat("Setting up RSelenium with proper Chrome driver...\n")
  
  # Method 1: Use specific ChromeDriver without version auto-detection
  tryCatch({
    # Get free port
    port <- netstat::free_port()
    
    # Start Chrome driver manually
    driver <- wdman::chrome(port = port, verbose = FALSE, check = FALSE)
    
    # Connect to the driver
    remDr <- RSelenium::remoteDriver(
      remoteServerAddr = "localhost",
      port = port,
      browserName = "chrome"
    )
    
    # Open connection
    remDr$open()
    
    cat("✓ RSelenium setup successful!\n")
    return(list(driver = driver, client = remDr))
    
  }, error = function(e) {
    cat("Method 1 failed, trying Method 2...\n")
    return(NULL)
  })
}

# SOLUTION 2: Windows-Compatible Chrome Driver Setup
manual_chrome_setup <- function() {
  cat("Setting up Chrome driver manually...\n")
  
  # Check Chrome installation on Windows
  chrome_paths <- c(
    "C:/Program Files/Google/Chrome/Application/chrome.exe",
    "C:/Program Files (x86)/Google/Chrome/Application/chrome.exe",
    paste0(Sys.getenv("LOCALAPPDATA"), "/Google/Chrome/Application/chrome.exe")
  )
  
  chrome_found <- FALSE
  for (path in chrome_paths) {
    if (file.exists(path)) {
      chrome_found <- TRUE
      cat("Chrome found at:", path, "\n")
      break
    }
  }
  
  if (!chrome_found) {
    cat("Chrome not found. Please install Google Chrome.\n")
    return(NULL)
  }
  
  # Use binman to manage drivers
  tryCatch({
    # Get available Chrome versions
    chrome_versions <- binman::list_versions("chromedriver")
    
    # Detect OS and get appropriate version
    os_type <- Sys.info()["sysname"]
    if (os_type == "Windows") {
      latest_version <- chrome_versions$win32[1]
    } else if (os_type == "Darwin") {
      latest_version <- chrome_versions$mac64[1]
    } else {
      latest_version <- chrome_versions$linux64[1]
    }
    
    cat("Using ChromeDriver version:", latest_version, "\n")
    
    # Start driver
    port <- netstat::free_port()
    driver <- wdman::chrome(
      port = port,
      version = latest_version,
      verbose = FALSE,
      check = FALSE
    )
    
    remDr <- RSelenium::remoteDriver(
      remoteServerAddr = "localhost",
      port = port,
      browserName = "chrome"
    )
    
    remDr$open()
    
    cat("✓ Manual Chrome setup successful!\n")
    return(list(driver = driver, client = remDr))
    
  }, error = function(e) {
    cat("Manual setup failed:", e$message, "\n")
    return(NULL)
  })
}

# SOLUTION 3: Docker-based Setup (Most Reliable)
setup_selenium_docker <- function(browser = "chrome") {
  cat("Setting up RSelenium with Docker (recommended)...\n")
  
  # Check if Docker is available (Windows compatible)
  docker_available <- tryCatch({
    system("docker --version", ignore.stderr = TRUE, ignore.stdout = TRUE) == 0
  }, error = function(e) FALSE)
  
  if (!docker_available) {
    cat("Docker not available. Please install Docker Desktop for Windows.\n")
    cat("Download from: https://www.docker.com/products/docker-desktop\n")
    return(NULL)
  }
  
  # Stop existing container
  system("docker stop selenium-chrome", ignore.stderr = TRUE)
  system("docker rm selenium-chrome", ignore.stderr = TRUE)
  
  # Run Selenium container
  docker_cmd <- paste(
    "docker run -d --name selenium-chrome",
    "-p 4444:4444 -p 7900:7900",
    "--shm-size=2g",
    "selenium/standalone-chrome:latest"
  )
  
  system(docker_cmd)
  
  # Wait for container to start
  cat("Waiting for Docker container to start...\n")
  Sys.sleep(10)
  
  # Connect to Docker container
  tryCatch({
    remDr <- RSelenium::remoteDriver(
      remoteServerAddr = "localhost",
      port = 4444L,
      browserName = "chrome"
    )
    
    remDr$open()
    
    cat("✓ Docker setup successful!\n")
    cat("You can view the browser at: http://localhost:7900 (password: secret)\n")
    
    return(remDr)
    
  }, error = function(e) {
    cat("Docker connection failed:", e$message, "\n")
    return(NULL)
  })
}

# =============================================================================
# WINDOWS-SPECIFIC SIMPLE SOLUTION
# =============================================================================

# Simple Windows solution - use this if you just want it to work!
windows_simple_setup <- function() {
  cat("Setting up RSelenium for Windows (simple method)...\n")
  
  # Check if Chrome is installed
  chrome_paths <- c(
    "C:/Program Files/Google/Chrome/Application/chrome.exe",
    "C:/Program Files (x86)/Google/Chrome/Application/chrome.exe",
    paste0(Sys.getenv("LOCALAPPDATA"), "/Google/Chrome/Application/chrome.exe")
  )
  
  chrome_found <- any(sapply(chrome_paths, file.exists))
  
  if (!chrome_found) {
    cat("❌ Chrome not found. Please install Google Chrome first.\n")
    cat("Download from: https://www.google.com/chrome/\n")
    return(NULL)
  }
  
  tryCatch({
    # Use the latest ChromeDriver without version checking
    port <- netstat::free_port()
    
    # Start Chrome driver (this bypasses the PhantomJS issue)
    rD <- RSelenium::rsDriver(
      browser = "chrome",
      port = port,
      verbose = FALSE,
      check = FALSE  # This is key - skips the problematic version check
    )
    
    cat("✓ RSelenium setup successful!\n")
    return(rD)
    
  }, error = function(e) {
    cat("❌ Setup failed:", e$message, "\n")
    
    # Try alternative method
    cat("Trying alternative method...\n")
    
    tryCatch({
      # Use wdman directly
      port <- netstat::free_port()
      cDrv <- wdman::chrome(port = port, check = FALSE)
      
      remDr <- RSelenium::remoteDriver(
        remoteServerAddr = "localhost",
        port = port,
        browserName = "chrome"
      )
      
      remDr$open()
      
      cat("✓ Alternative method successful!\n")
      return(list(server = cDrv, client = remDr))
      
    }, error = function(e2) {
      cat("❌ Alternative method also failed:", e2$message, "\n")
      return(NULL)
    })
  })
}

# =============================================================================
# WORKING EXAMPLE - Use this to replace your failing code
# =============================================================================

# Replace your original code with this (Windows-optimized):
create_selenium_session <- function() {
  cat("Creating RSelenium session...\n")
  
  # Try simple Windows setup first
  result <- windows_simple_setup()
  if (!is.null(result)) {
    # Return the client object
    if (is.list(result) && "client" %in% names(result)) {
      return(result$client)
    } else if (is.list(result) && "client" %in% names(result)) {
      return(result$client)
    } else {
      return(result)
    }
  }
  
  # Try manual setup
  result <- manual_chrome_setup()
  if (!is.null(result)) {
    return(result$client)
  }
  
  # Try basic fix
  result <- fix_rselenium_setup()
  if (!is.null(result)) {
    return(result$client)
  }
  
  cat("❌ All methods failed. Please check the troubleshooting section below.\n")
  return(NULL)
}

# =============================================================================
# TROUBLESHOOTING FUNCTIONS
# =============================================================================

#' Check system requirements (Windows compatible)
check_system_requirements <- function() {
  cat("=== System Requirements Check ===\n")
  
  # Check Java (Windows compatible)
  java_ok <- tryCatch({
    system("java -version", ignore.stderr = TRUE, ignore.stdout = TRUE) == 0
  }, error = function(e) FALSE)
  cat("Java installed:", ifelse(java_ok, "✓", "❌"), "\n")
  
  # Check Chrome (Windows compatible)
  chrome_paths <- c(
    "C:/Program Files/Google/Chrome/Application/chrome.exe",
    "C:/Program Files (x86)/Google/Chrome/Application/chrome.exe",
    paste0(Sys.getenv("LOCALAPPDATA"), "/Google/Chrome/Application/chrome.exe")
  )
  
  chrome_ok <- any(sapply(chrome_paths, file.exists))
  cat("Chrome installed:", ifelse(chrome_ok, "✓", "❌"), "\n")
  
  # Check Docker (Windows compatible)
  docker_ok <- tryCatch({
    system("docker --version", ignore.stderr = TRUE, ignore.stdout = TRUE) == 0
  }, error = function(e) FALSE)
  cat("Docker available:", ifelse(docker_ok, "✓", "❌"), "\n")
  
  # Check R packages
  packages <- c("RSelenium", "wdman", "netstat", "binman")
  for (pkg in packages) {
    installed <- requireNamespace(pkg, quietly = TRUE)
    cat(paste0("Package ", pkg, ":"), ifelse(installed, "✓", "❌"), "\n")
  }
  
  return(list(java = java_ok, chrome = chrome_ok, docker = docker_ok))
}

#' Clean up existing processes
cleanup_selenium <- function() {
  cat("Cleaning up existing Selenium processes...\n")
  
  # Kill existing chromedriver processes
  system("pkill -f chromedriver", ignore.stderr = TRUE)
  
  # Stop Docker containers
  system("docker stop selenium-chrome", ignore.stderr = TRUE)
  system("docker rm selenium-chrome", ignore.stderr = TRUE)
  
  cat("Cleanup completed.\n")
}

# =============================================================================
# USAGE EXAMPLES
# =============================================================================

# Example 1: Basic usage (replaces your original code)
example_basic_usage <- function() {
  # Clean up first
  cleanup_selenium()
  
  # Create session
  remDr <- create_selenium_session()
  
  if (is.null(remDr)) {
    stop("Failed to create Selenium session")
  }
  
  # Test navigation
  remDr$navigate("https://www.google.com")
  Sys.sleep(2)
  
  # Get page title
  title <- remDr$getTitle()
  cat("Page title:", title[[1]], "\n")
  
  # Close session
  remDr$close()
  
  return(remDr)
}

# Example 2: Robust session with error handling
example_robust_session <- function() {
  tryCatch({
    # Check requirements first
    check_system_requirements()
    
    # Create session with retry logic
    remDr <- NULL
    attempts <- 0
    max_attempts <- 3
    
    while (is.null(remDr) && attempts < max_attempts) {
      attempts <- attempts + 1
      cat("Attempt", attempts, "of", max_attempts, "\n")
      
      cleanup_selenium()
      Sys.sleep(2)
      
      remDr <- create_selenium_session()
      
      if (is.null(remDr)) {
        Sys.sleep(5)
      }
    }
    
    if (is.null(remDr)) {
      stop("Failed to create Selenium session after", max_attempts, "attempts")
    }
    
    return(remDr)
    
  }, error = function(e) {
    cat("Error:", e$message, "\n")
    return(NULL)
  })
}

