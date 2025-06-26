library(tidyverse)

# “esquisse” paketi ----

library(esquisse)

data <- mpg

data %>% esquisser()


# “highcharter” paketi ----

library(highcharter)
#https://api.highcharts.com/highcharts/series

data %>% 
  hchart("line", hcaes(y = hwy)) %>% 
  hc_colors(color = "red")

data %>%
  hchart("line", hcaes(y = hwy, name = model, group = drv)) %>% 
  hc_colors(c("brown", "forestgreen", "steelblue")) %>%
  hc_plotOptions(
    line = list(
      dataLabels = list(
        enabled = TRUE,
        format = '{point.model}', 
        rotation = 300,       
        style = list(fontSize = "9px")
      )
    )
  ) %>%
  hc_title(text = "Highway Fuel Economy (hwy)")


data %>% 
  hchart("scatter", hcaes(x = displ, y = cty)) %>%
  hc_colors(color = "red") %>%
  #hc_xAxis(visible = F) %>%
  #hc_yAxis(visible = F) %>% 
  hc_title(text = "Yanacaq iqtisadiyyatı datası") %>%
  hc_plotOptions(
    scatter = list(
      dataLabels = list(
        enabled = TRUE,
        format = '{point.model}',  
        style = list(fontSize = "7px")
      )
    )
  )


data %>% 
  hchart("area", hcaes(y = hwy)) %>% 
  hc_colors(color = "green") %>%
  hc_plotOptions(
    area = list(
      dataLabels = list(
        enabled = TRUE,
        format = '{point.model}',
        style = list(fontSize = "9px")
      )
    )
  ) %>%
  hc_title(text = "Highway Fuel Economy by Model")

data %>%
  group_by(class) %>%
  arrange(class, hwy) %>%
  mutate(n = 1:n()) %>% 
  hchart("area", hcaes(x = n, y = hwy, group = class)) %>%
  hc_colors(c("brown", "forestgreen", "orange", "purple", "red", "gray", "steelblue")) %>%
  hc_plotOptions(
    area = list(
      dataLabels = list(
        enabled = TRUE,
        format = '{point.model}',  
        rotation = 270, 
        style = list(fontSize = "9px", fontWeight = "normal")
      )
    )
  ) %>% 
  hc_title(text = "Highway Fuel Economy by Class")


data %>% 
  group_by(manufacturer, model) %>% 
  summarise(max_cyl = max(cyl)) %>% 
  hchart("bar", hcaes(x = manufacturer, y = max_cyl, 
                      color = manufacturer),
         dataLabels = list(
           enabled = T, 
           format = "{point.max_cyl}",
           style = list(fontSize = '8px')
         )) %>%
  hc_title(text = "Number of Cylinders by Manufacturer")


data %>% 
  hchart("column", hcaes(x = manufacturer, y = cyl, 
                         group = drv),
         dataLabels = list(
           enabled = T, 
           format = "{point.model}",
           style = list(fontSize = '8px'), 
           x = 0, y = -1
         )) 

data %>% 
  group_by(manufacturer, model, drv) %>% 
  summarise(mean_hwy = mean(hwy, na.rm=T)) %>% 
  hchart("column", hcaes(x = manufacturer, y = mean_hwy, 
                         group = drv)) %>% 
  hc_plotOptions(
    column = list(
      stacking = "normal",
      dataLabels = list(
        enabled = TRUE,
        format = "{point.model}", 
        style = list(fontSize = '8px'),
        x = 0, y = -1
      )
    )
  ) %>%
  hc_title(text = "Average Highway Fuel Economy by Manufacturer and Drive Type")


data %>% 
  group_by(class) %>% 
  summarise(mean_hwy = mean(hwy, na.rm=T)) %>% 
  ungroup() %>% 
  hchart("pie", hcaes(x = class, y = mean_hwy)) %>% 
  hc_plotOptions(
    pie = list(
      dataLabels = list(
        enabled = TRUE,
        format = "<b>{point.name}<br>{point.y:.1f}",  
        distance = -45, 
        style = list(
          fontSize = '10px',
          #color = 'white',  
          textOutline = "none"
        )
      )
    )
  ) %>%
  hc_title(text = "Average Highway MPG by Vehicle Class")


data %>% 
  group_by(manufacturer) %>% 
  summarise(n = n()) %>% 
  ungroup() %>% 
  hchart("treemap", hcaes(name = manufacturer, value = n)) 
