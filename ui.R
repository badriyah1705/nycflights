# New York City Flight 2013 with R Shiny
# author: "Badriyah (b4dria@gmail.com)"
# date: "03/31/2021"


library(shiny)
library(shinythemes)
library(DT)
library(dplyr)
library(tidyverse)
library(nycflights13)
library(plotly)
library(ggplot2)
library(maps)
library(hexbin)

# Define UI for application
shinyUI(fluidPage(theme = shinytheme("cerulean"),
                  titlePanel("Relational Data Using nycflights13"),

                  #s: navbar
                  navbarPage("NYC Flights",
                             # s : menu 1 --
                             tabPanel(icon("home"),
                                      fluidRow(
                                        column(4,tags$img(src="port.jpeg",width="1000",height="1200",class="img-responsive"),align="center"),
                                        column(4,tags$img(src="tabel.png",width="1000",height="1000",class="img-responsive"),align="center"),
                                        column(4,tags$img(src="nyc.png",width="1000",height="1200",class="img-responsive"),align="center")
                                        
                                        
                                      ),
                                      br(),
                                      fluidRow(column(12,
                                                      uiOutput("homefile"),
                                                     align="left")
                                      )
                             ),
                             # s : menu 2 --
                             navbarMenu(title = "Data Info",
                                      
                                                             tabPanel("Airlines","Airlines",
                                                                      br(),
                                                                      br(),
                                                                      DT::dataTableOutput("AirlinesData")
                                                             ),
                                                             tabPanel("US Airports",
                                                                      br(),
                                                                      plotlyOutput("us_airportmap"),
                                                                      br(),
                                                                      DT::dataTableOutput("AirportsData")
                                                             ),
                                                             tabPanel("Planes", "Planes",
                                                                      br(),
                                                                      br(),
                                                                      DT::dataTableOutput("PlanesData")
                                                             ),
                                                             tabPanel("Weather","Weather",
                                                                      br(),
                                                                      br(),
                                                                      DT::dataTableOutput("WeathersData")
                                                             )
                                                  
                                      

                             ),
                             # e : menu 2 --
                             # s : menu 3 --
                             tabPanel("Flights",
                                      h3("Flights Info"),
                                      hr(),
                                      fluidRow(column(3,class="bg-primary",br(),
                                                      selectInput(inputId = "airport",
                                                                  label = "select NYC airport",
                                                                  choices = c("EWR", "LGA", "JFK"),
                                                                  selected = "JFK"),
                                                      selectInput(inputId = "month",
                                                                  label = "select month",
                                                                  choices = c(1:12),
                                                                  selected = "1"),
                                                      selectInput(inputId = "day",
                                                                  label = "select day",
                                                                  choices = c(1:31),
                                                                  selected = "1"),
                                                      br()
                                      ),
                                      column(9, tabsetPanel(id = 'tabs2',
                                                            tabPanel("Map",
                                                                     br(), uiOutput("info_2"),
                                                                     plotlyOutput("flightmap")
                                                            ),
                                                             tabPanel("Data",
                                                                      br(),
                                                                      DT::dataTableOutput("FlightsData")
                                                             ),

                                                             tabPanel("Graph",
                                                                      br(),
                                                                      h4('How many flights a day ?'),
                                                                      plotlyOutput("graph_flight_count")

                                                             )
                                              )
                                      )
                                      )

                             ),
                             # e : menu 3 --
                             # s : menu 4 --
                             tabPanel("Delay",
                                      h3("Delay Info"),
                                      hr(),
                                      fluidRow(column(3,class="bg-primary",br(),
                                                      selectInput(inputId = "airport1",
                                                                  label = "select NYC airport",
                                                                  choices = c("EWR", "LGA", "JFK"),
                                                                  selected = "JFK"),
                                                      selectInput(inputId = "month1",
                                                                  label = "select month",
                                                                  choices = c(1:12),
                                                                  selected = "1"),
                                                      br()
                                      ),
                                      column(9, tabsetPanel(id = 'tabs2',
                                                            tabPanel("Dep. Delay Graph",
                                                                     br(),
                                                                     h4("Departure Delay by Carriers"),
                                                                     DT::dataTableOutput("Delay_Dep_Data_Sumarry"),
                                                                     br(),
                                                                     plotlyOutput("dep_graph_count"),
                                                                     br(),
                                                                     fluidRow(column(6,
                                                                     plotlyOutput("dep_graph_time")),
                                                                     column(6,
                                                                     plotlyOutput("dep_graph_avgtime"))
                                                                     )

                                                            ),
                                                            tabPanel("Dep. Delay Data",
                                                                     br(),
                                                                     h4("Departure Delay Data"),
                                                                     DT::dataTableOutput("Delay_Dep_Data")

                                                            ),
                                                            tabPanel("Arr. Delay Graph",
                                                                     br(),
                                                                     h4("Arrival Delay by Carriers"),
                                                                     DT::dataTableOutput("Delay_Arr_Data_Sumarry"),
                                                                     br(),
                                                                     plotlyOutput("arr_graph_count"),
                                                                     br(),
                                                                     fluidRow(column(6,
                                                                                     plotlyOutput("arr_graph_time")),
                                                                              column(6,
                                                                                     plotlyOutput("arr_graph_avgtime"))
                                                                     )

                                                            ),
                                                            tabPanel("Arrival Delay Data",
                                                                     br(),
                                                                     h4("Arrival Delay Data"),
                                                                     DT::dataTableOutput("Delay_Arr_Data")
                                                            )
                                      )
                                      )
                                      )

                             ),
                             # e : menu 4 --
                             # s : menu 5 --
                             tabPanel("More",
                                      navlistPanel(
                                        "Additional Information",
                                        tabPanel("The spatial distribution of delays by destination",
                                                 h3("Here’s a map of the United States and The spatial distribution of delays by destination"),
                                                 plotOutput("distro")
                                        ),
                                        tabPanel("A relationship between the age of a plane and its delays",
                                                 h3("Looks as though planes that are roughly 5 to 10 years old have higher delays"), 
                                                 plotOutput("distro2"), 
                                        ),
                                        tabPanel("There was a large series of storms (derechos) in the southeastern US (see June 12-13, 2013 derecho series)",
                                                 h3("The following plot show that the largest delays were in Tennessee (Nashville), the Southeast, and the Midwest, which were the locations of the derechos."), 
                                                 plotOutput("distro3")
                                        )
                                      )
                                      
                                      
                                      
                                      
                                      
                                      
                                      
                                      
                                      
                                      
                                      
                             ), #tabPanel
                             # e : menu 5
                             
                             
                             
                             
                             # s : menu 6 --
                             tabPanel("About",
                                      h3("About Us"),
                                      hr(),
                                      uiOutput("aboutfile")
                             ),
                             # e : menu 6--
                             
                             tags$script(HTML("var header = $('.navbar > .container-fluid');
                       header.append('<div style=\"float:right;margin-top:5px\"><h4></h4></div>');
                       console.log(header)"))
                  )
                  # e: navbar
))
