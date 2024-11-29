library(shiny)
library(ggplot2)
library(dplyr)

# Charger les données IRIS
file_path <- "IRIS.csv"
iris <- read.csv(file_path, header = FALSE)

# Renommer les colonnes
colnames(iris) <- c("longueur_sepale", "longueur_sepale_normalise",
                    "largeur_sepale", "largeur_sepale_normalise",
                    "longueur_petale", "longueur_petale_normalise",
                    "largeur_petale", "largeur_petale_normalise",
                    "espece")

# Interface utilisateur
ui <- fluidPage(
  titlePanel("Application Test : Shiny"),
  h3("Analyse sur la base de données IRIS"),
  p("👨🏾‍💻 Applications web avec Shiny !"),
  
  sidebarLayout(
    sidebarPanel(
      h4("Distribution selon une caractéristique"),
      selectInput("feature", "Choisissez la caractéristique à visualiser sur l'histogramme", 
                  choices = c("longueur_sepale", "longueur_petale", 
                              "largeur_petale", "largeur_sepale")),
      hr(),
      h4("Distribution à deux dimensions"),
      radioButtons("x_feature", "Abscisses (X)", 
                   choices = c("longueur_sepale", "longueur_petale", 
                               "largeur_petale", "largeur_sepale")),
      radioButtons("y_feature", "Ordonnées (Y)", 
                   choices = c("longueur_sepale", "longueur_petale", 
                               "largeur_petale", "largeur_sepale"))
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Table des données", tableOutput("data_table")),
        tabPanel("Statistiques et histogramme", plotOutput("histogram")),
        tabPanel("Scatter Plot", plotOutput("scatter_plot"))
      )
    )
  ),
  
  # Ajouter un pied de page
  div(style = "margin-top: 20px; text-align: center; font-size: 14px; color: gray;",
      "Auteur : Ludel TOPANOU")
)


# Serveur
server <- function(input, output, session) {
  # Tableau des données
  output$data_table <- renderTable({
    iris
  })
  
  # Histogramme
  output$histogram <- renderPlot({
    ggplot(iris, aes_string(x = input$feature)) +
      geom_histogram(binwidth = 0.5, fill = "orange", color = "white") +
      ggtitle(paste("Histogramme selon", input$feature)) +
      theme_minimal()
  })
  
  # Scatter plot
  output$scatter_plot <- renderPlot({
    ggplot(iris, aes_string(x = input$x_feature, y = input$y_feature, color = "espece")) +
      geom_point(size = 3) +
      ggtitle("Scatter Plot") +
      theme_minimal()
  })
}

# Lancer l'application
shinyApp(ui = ui, server = server)
