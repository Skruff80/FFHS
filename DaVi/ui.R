library(shiny)
library(shinydashboard)
library(shinythemes)
library(data.table)
library(ggplot2)
library(leaflet)
library(dplyr)
library(plotly)


shinyUI(
  dashboardPage(
################## Dashboard Titel
    
    dashboardHeader(title = "DaVi, Data Vislualization, MAS/CAS Web4B 2019, BE1, FS20 - Semesterarbeit - Marcel Greuter", 
                    titleWidth = 900),
  
    
################## Linke Seite des Dashboards <- Menue
    dashboardSidebar(
      sidebarMenu(
        
        
        # Menu Auswahl
        # tabName = "dashboard" ist wichtig, ansonsten wird der chart nicht angezeigt! dashboardBody(tabItems( tabItem(tabName = "dashboard" ist der Bezug
        menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
        
        # Dash Untermenue
        menuSubItem("Coffee Products", tabName = "products", icon = icon("fas fa-coffee")),
        
        menuSubItem("Detailed Analysis", tabName = "detailiedanalysis",icon = icon("fas fa-chart-line")),
        
        menuSubItem("Raw Data", tabName = "rawdata", icon = icon("fas fa-database")),
        
        
        # Falls das menuSubItem benoetigt wird, muss das menuItem mit dem badgelabel entfernt werden!
        
        #       menuSubItem("Source code for app", tabName = "sourcecode", icon = icon("far fa-file-code")), 
        
        menuItem("Source code for app", tabName = "sourcecode", icon = icon("far fa-file-code"), 
                 badgeLabel = "New", badgeColor = "green"), 
        
################## Day Counter -> Slider
        sliderInput("DatesMerge",
                    "Dailycounter:",
                    min = as.Date("2018-01-22","%Y-%m-%d"),
                    max = as.Date("2020-05-18","%Y-%m-%d"),
                    value= c(as.Date("2018-09-14","%Y-%m-%d"),as.Date("2020-05-18","%Y-%m-%d")),
                    timeFormat="%Y-%m-%d")
      )
    ),
    
################## Main Screen wo die Charts etz. Dargestellt werden

    dashboardBody(
      tabItems(
        tabItem(tabName = "dashboard",
                fluidRow(
                  # Infobox mit der Anzahl Kaffees
                  #                  infoBox("Coffee Extractions in Total", "info_box1", subtitle = "Cantina Plant II", icon = icon("fas fa-coffee")),
                  
                  box(title = "Machine Info",status = "primary", tableOutput("machine_info"),column(12), height = 300),
                  
                  infoBoxOutput("info_box2",width = 6),
                  
                  infoBoxOutput("info_box1",width = 6),
                  
                  
                  
                  fluidRow(
                    infoBoxOutput("info_box3", width = 6)
                  ),
                  
                  fluidRow(
                    
                    box(title = "Machine Location", collapsible = TRUE, status = "primary", leafletOutput("map", height = 500), width = 6),
                    
                    
                    box(title = "Product Highscore",collapsible = TRUE, status = "primary", plotlyOutput("plot_highscore", height = 500), width = )
                          )
                         ),
                
                fluidRow(
                  box(title = "Dailycounter", collapsible = TRUE, status = "primary", plotlyOutput("plot_daycount"), width = 12)
                )
        ),
        
        tabItem(tabName = "products",
                h1("Coffee Products"),
                fluidRow(
                  box(checkboxGroupInput('var', label = "1. Select Class", 
                                         choices = c("Ristretto", "Espresso","Coffee","Cappuccino (Time Optimized)","Americano","Espresso Macchiato",
                                                     "Latte Macchiato","Milk Coffee (Time Optimized)","White Americano","White Americano (Water First)"), 
                                     selected = "Espresso")
                      ),
                  box(radioButtons("colour", label = "2. Select the color of histogram",
                                   choices = c("Green", "Red",
                                               "Blue"), selected = "Green"),width = 6, height = 140),
                  
                  box(sliderInput("bin", "3. Select the number of histogram BINs by using the slider below", min=1, max=70, value=44), height = 146, 
                  )
                ),
        
                tabsetPanel(type = "tab",
                            #                          tabPanel("Extraction Times", 
                            box(title = "Histogram of ExtractionTimes", solidHeader = TRUE,plotOutput("myhist"))
                            )
        ),
        
        tabItem(tabName = "detailiedanalysis",
                h1("Detailed Analysis"),
                tabsetPanel(type = "tab",
                            tabPanel("Summary",
                                    box(verbatimTextOutput("summ"),width = 12))
                            
                )
        ),
        
        # Raw Data Inhalt
        tabItem(tabName = "rawdata",
                h1("Raw Data"),
                tabsetPanel(type = "tab",
                            tabPanel("Data", 
                                     box(title = "ProductList-B1-134564", solidHeader = TRUE, tableOutput('coffeedata'), height = 550),
                                     box(title = "ProductHighscore-B1-134564", solidHeader = TRUE, tableOutput("product_score"), height = 550),
                                     box(title = "Machine-Consumption", solidHeader = TRUE, tableOutput("machine_consumption"),width = 12, heigth =550)
                            ),
                            
                            tabPanel("Structure", 
                                     box(title = "Data Structure",solidHeader = TRUE, width = 4, tableOutput('structure')))
                            
 #                           tabPanel("Plot", plotOutput("plot"))
                )
               ),
        
        tabItem(tabName = "sourcecode",
                tabsetPanel(type = "tab",
                            tabPanel("server.R",
                                     box(verbatimTextOutput("serversourcecode"))),
                            #                              box(title = "Server.R source code", solidHeader = TRUE, width = 4, tableOutput("serversourcecode"))),
                            tabPanel("ui.R",
                                     box(verbatimTextOutput("uisourcecode"), width = 10)
                                     #                              box(title = "ui.R source code", solidHeader = TRUE, width = 4, tableOutput("uicode"))
                            )
                )
        )
  
      ),
   
    )
    
    
    
        ) 
  )



