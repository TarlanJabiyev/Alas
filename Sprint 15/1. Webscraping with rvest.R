library(tidyverse)
library(rvest)

# read_html(): HTML səhifəsini oxumaq
starwars <- read_html("https://rvest.tidyverse.org/articles/starwars.html")

# html_elements(): css seçicisinə və ya 
# XPath ifadəsinə uyğun elementləri tapın
films <- starwars %>% html_elements("section")

# html_element(): hər filmə bir element çıxarmaq. 
# Başlıq <h2> daxilindəki mətnlə verilir.
title <- films %>% 
  html_element("h2") %>% 
  html_text2()

# html_attr(): atributlardan məlumat almaq üçün. 
# Həmişə sətri qaytarır və biz onu readr funksiyası ilə ədədə çeviririk
episode <- films %>% 
  html_element("h2") %>% 
  html_attr("data-id") %>% 
  parse_number()


# html_table(): səhifədə cədvəl məlumatları varsa, onu birbaşa cədvəl data kimi götürə bilir
html <- read_html("https://en.wikipedia.org/w/index.php?title=The_Lego_Movie&oldid=998422565")

html %>% 
  html_element(".tracklist") %>% 
  html_table()


#####

html <- read_html('https://bit.ly/3lz6ZRe')

html %>% html_element('#exampleTable') 

text <- html %>% 
  html_element('div.rightColumn') %>%
  html_text2()
cat(text)


html %>% html_element('table') # left table 
html %>% html_elements('table') # set of both tables

html %>% html_element('.someTable') # left table
html %>% html_elements('.someTable') # set of both tables

html %>% html_element('#steve') # right table 
html %>% html_elements('#steve') # set with only the right table 

html %>% html_element('tr.headerRow') # left table first row
html %>% html_elements('tr.headerRow') # first rows of both tables

html %>% html_element('.someTable.blue') # right table    
html %>% html_elements('.someTable.blue') # set with only the right table    

tables <- html %>% 
  html_elements('table') %>% 
  html_table()

# Linklər adətən <a> teqləri ilə təmsil olunur, burada link href atributu kimi saxlanılır.
html %>% 
  html_elements('a') %>% 
  html_attr('href')

