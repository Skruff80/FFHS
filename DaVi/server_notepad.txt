library(shiny)
library(shinydashboard)
library(shinythemes)
library(data.table)
library(ggplot2)
library(leaflet)
library(dplyr)
library(ggthemes)
library(plotly)


################## Einlesen der Datensaetze

coffeedata = fread("https://raw.githubusercontent.com/Skruff80/FFHS/master/KantineWII/ProductList-B1-134564.csv")

product_highscore = fread("https://raw.githubusercontent.com/Skruff80/FFHS/master/KantineWII/ProductHighscore-B1-134564.csv")

machine_info = fread("https://raw.githubusercontent.com/Skruff80/FFHS/master/KantineWII/Maschine_Info.csv")

serversourcecode = fread("https://raw.githubusercontent.com/Skruff80/FFHS/master/DaVi/server.R")

machine_consumption = fread("https://raw.githubusercontent.com/Skruff80/FFHS/master/KantineWII/Machines-ConsumptionCoffee.csv", header = TRUE)


################## Formatierung ins richtige Format

mydf = data.frame(coffeedata)

setDF(coffeedata)
setDF(machine_info)

coffeedata$Date = as.Date(coffeedata$Date, "%d.%m.%Y")


################## dailycounter berechnen

countcoffee <- function(timeStamps) {
  Dates <- as.Date(strftime(coffeedata$Date, "%Y-%m-%d"))
  allDates <- seq(from = min(Dates), to = max(Dates), by = "day")
  coffee.count <- sapply(allDates, FUN = function(X) sum(Dates == X))
  data.frame(day = allDates, coffee.count = coffee.count)}

dailycounter = countcoffee(df$coffee.date)



shinyServer(function(input,output){
 
################## GGPLOT2 dailycounter
  
  output$plot_daycount = renderPlotly({
    DatesMerge <- as.Date(input$DatesMerge, format = "%Y-%m-%d")
    sub_data <- subset(dailycounter, day >= DatesMerge[1] & day <= DatesMerge[2])
    ggplot(sub_data, aes(x = day, y = coffee.count)) + 
      ylab("Products")+
      geom_line(color = "brown", size = 1) +
      theme_light() +
      scale_x_date(breaks = "1 month", date_labels = "%d-%m-%Y")
    
  })
   
  
################## Histogramm of Extraction Times  
  
  output$myhist <- renderPlot({
    
    coffeedata_plot <- coffeedata[coffeedata$Product_Category %in% input$var, ]
    
    hist(coffeedata_plot$Extraction_Time[coffeedata_plot$Extraction_Time > 5], col = input$colour, 
         xlim = c(0, max(coffeedata_plot$Extraction_Time )), 
         main = "Histogram of Exctraction Times", 
         breaks = seq(0, max(coffeedata_plot$Extraction_Time ),l=input$bin+1), 
         xlab = "Seconds [s]"
         #    xlab = names(coffeedata_plot$Product_Category )
    )
    })   

    
################## GGPLOT2 Bar Product Highscore
  
  output$plot_highscore = renderPlotly({
#    ggplot(product_highscore, aes(x=as.factor(Product_Category), y=Amount, fill= Product_Category)) +
    ggplot(product_highscore, aes(x=as.factor(Product_Category), y=Amount, fill= Product_Category)) +
      geom_bar(stat = "identity") +
      scale_fill_manual(values = c("#000000", "#736F6E", 
                                   "#C0C0C0", "#98AFC7", "#6698FF", "#153E7E", "#ecbb45","#ff8c00","#e38559","#0a674f",
                                  "#421a92","#68838b","#ff7f50","#6878a0")) +
      theme_light() +
      theme(
        legend.position = "none") +
      ylab("Products in Total")+
      xlab("")+
      coord_flip()
  })
  
  
  
################## Raw Data
  
  output$coffeedata = renderTable({
    coffeedata[1:14,]
  })
  
  output$product_score = renderTable({
    product_highscore
  })
  
  output$machine_consumption = renderTable({
    machine_consumption
  }) 
  
  
################## Detailed Analysis
  
  output$summ = renderPrint({
    summary(coffeedata)
  })
  
  output$structure = renderPrint({
    str(coffeedata)
  })
  
  output$serversourcecode = renderPrint({
    serversourcecode = read.csv("https://raw.githubusercontent.com/Skruff80/FFHS/master/DaVi/server.R",
                                header = FALSE, comment.char = "#",)
    
    serversourcecode
  })
  
  output$uisourcecode = renderPrint({
    uisourcecode = read.csv("https://raw.githubusercontent.com/Skruff80/FFHS/master/DaVi/ui.R",
                            header = FALSE, comment.char = "#",)
    uisourcecode
  })
  
################## Leaflet GMaps 
  
  output$map = renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      setView(lng = 8.42040, lat = 47.035843, zoom = 12) %>%
      addMarkers(lng = 8.42040, lat = 47.035843, 
                 label = "B1-134564, Cantina Plant II",
                 labelOptions = labelOptions(noHide = TRUE))
    #      popup = "B1-134564, Cantina Plant II")
    
  })
  
################## Infoboxen
  output$info_box2 <- renderInfoBox({
    infoBox("Most consumed drink",
            paste(product_highscore[1,1],
                                        "with a total of ", product_highscore[1,3]," cups", "from ", 
                                        min(coffeedata$Date) ,"until", max(coffeedata$Date)), 
            icon = icon("fas fa-coffee"))
  })
    
  output$info_box1 = renderInfoBox({
    infoBox("Total coffee count", paste(sum(product_highscore$Amount),"pcs"),icon = icon("bar-chart-o"))
  })
  
################## Machine Info Infobox
  output$machine_info = renderTable({
    machine_info
  })
  
  output$info_box3 = renderInfoBox({
    infoBox("Total used coffee", paste(machine_consumption[3,5], "kg"))
  })
  
})
