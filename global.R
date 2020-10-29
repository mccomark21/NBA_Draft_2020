library(ggplot2)
library(plotly)
library(dplyr)
library(forcats)
library(shinydashboard)
library(shiny)

master_df <- read.csv("CBB_Data_2020.csv")

master_df$Class <- factor(master_df$Class, levels = c("Freshman", "Sophmore", "Junior", "Senior"))