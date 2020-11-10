library(ggplot2)
library(plotly)
library(dplyr)
library(forcats)
library(shinydashboard)
library(shiny)
library(shinycssloaders)
library(ggrepel)
library(shinyWidgets)

master_df <- read.csv("CBB_Data_2020.csv",check.names=FALSE)
gamelogs_df <- read.csv("GameLog_Data_2020.csv",check.names=FALSE)

master_df$Class <- factor(master_df$Class, levels = c("Freshman", "Sophmore", "Junior", "Senior"))
master_df$Conf <- as.character(master_df$Conf)

gamelogs_df$Class <- factor(gamelogs_df$Class, levels = c("Freshman", "Sophmore", "Junior", "Senior"))