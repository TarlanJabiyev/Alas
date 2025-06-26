library(tidyverse) #library(ggplot2)
library(hrbrthemes)
library(plotly)

data <- mpg

#set x,y
data %>% 
  ggplot(aes(displ, cty))

#add geometry
data %>% 
  ggplot(aes(displ, cty)) +
  geom_point()

#add colour
data %>% 
  ggplot(aes(displ, cty)) +
  geom_point(color = "red")

#add size 
data %>% 
  ggplot(aes(displ, cty)) +
  geom_point(color = "red",
             aes(size = hwy))

#add labs 
data %>% 
  ggplot(aes(displ, cty)) +
  geom_point(color = "red",
             aes(size = hwy)) +
  labs(x = "mühərrikin həcmi", 
       y = "millər",
       title = "Yanacaq iqtisadiyyatı məlumatları",
       subtitle = "Scatterplot")

#add scales 
data %>% 
  ggplot(aes(displ, cty)) +
  geom_point(color = "red",
             aes(size = hwy)) +
  labs(x = "mühərrikin həcmi", 
       y = "millər",
       title = "Yanacaq iqtisadiyyatı məlumatları",
       subtitle = "Scatterplot") +
  scale_y_continuous(breaks = seq(0,50,2)) +
  scale_x_percent()

# add facet
data %>% 
  mutate(total = hwy + cty) %>% 
  ggplot(aes(total)) + 
  geom_histogram(aes(fill = class), colour = "Black") + 
  facet_grid(class ~ .) 

p <- data %>% 
  ggplot(aes(x=hwy, y=cty, colour=class))
p + geom_point(size=2)

p + geom_point(size=2) +
  facet_grid(class~., scales="free") +
  theme(legend.position="none")

p + geom_point(size=2) + 
  facet_grid(.~year, scales="free") +
  theme(legend.position="none")

p + geom_point(size=2) + 
  #geom_smooth(method = "lm") +
  facet_grid(class ~ year, scales="free") +
  theme(legend.position="none")


# “plotly” paketi ----

p1 <- data %>% 
  ggplot(aes(displ, cty)) +
  geom_point(color = "yellow",
             aes(size = hwy)) +
  labs(x = "mühərrikin həcmi", 
       y = "millər",
       title = "Yanacaq iqtisadiyyatı məlumatları",
       subtitle = "Scatterplot") +
  theme_ft_rc()

p1 %>% ggplotly()


# Histogram

p2 <- data %>% 
  ggplot(aes(hwy)) + 
  geom_histogram(aes(fill=trans), 
                 colour="Black") +
  scale_x_continuous(breaks = seq(0,60,5)) +
  scale_y_continuous(breaks = seq(0,60,2))

p2 %>% ggplotly()


# Boxplot

p3 <- data %>% 
  ggplot(aes(y = hwy, colour = class)) + 
  geom_boxplot(size = 1) + #coord_flip() +
  theme_ft_rc()

p3 %>% ggplotly()


# Plotları birləşdirmək ----
library(patchwork)

p1
p2
p3

p1 + p2

p1 + p2 + p3 + 
  plot_layout(nrow=2,byrow=F)

p1 / p3

p2 | (p1 / p3)

(p2 | (p1 / p3)) +
  plot_annotation('Title')

(p2 | (p1 / p3)) +
  plot_annotation(tag_levels='1')
