if(!require(shiny)){
  install.packages("shiny")
  require(shiny)
}

if(!require(shinycssloaders)){
  install.packages("shinycssloaders")
  require(shinycssloaders)
}

if(!require(cNORM)){
  install.packages("cNORM")
  require(cNORM)
}

if(!require(DT)){
  install.packages("DT")
  require(cNORM)
}
title <- "cNORM-Shiny"

# Define UI for cNORM-Application
shinyUI(fluidPage(

  # Set tab title
  title = "cNORM - Shiny",

  # Tabsetpanel for single tabs
  tabsetPanel(
    # Tab for data input
    tabPanel("Data Input", sidebarLayout(
      sidebarPanel(
        img(src = "logo.png", align = "right"), tags$h3("Data Input"), tags$p("Please choose a data set for your calculations. You can use an inbuilt example or load your own file:"), selectizeInput("Example",
          label = "Example:",
          choices = c("", "elfe", "ppvt", "CDC"), selected = character(0),
          multiple = FALSE
        ), hr(),
        fileInput("file", "Choose a file", multiple = FALSE, accept = c(".csv", ".xlsx", ".xls", ".rda", ".sav")),
        tags$p(tags$b("HINT: If you choose a file from your own directory, the chosen example will not be used during the session anymore!")),
        hr(),tags$p(tags$b("The built-in example data:")),
        tags$ul(tags$li("'elfe' includes norming sample data of a reading comprehension in elementary school, based on a multiple choice sentence completion task with raw scores ranging from 0 to 28 "),
        tags$li("'ppvt' uses data from the Peabody Picture Vocabulary Test (Revision IV) ranging from age 2.5 to 17.5 with raw scores from 0 to 228"),
        tags$li("'CDC' is a data collection of BMI, weight and growth development from 2 to 18; large sample based on epidemiological studies of the Center of Disease Control (CDC)"))
      ),
      mainPanel(htmlOutput("introduction"), DT::DTOutput("table"))
    )),

    # Panel for Data Preparation (choosing and visualizing)
    tabPanel(
      "Preparation",
      # Define layout for sidebar
      sidebarLayout(

        # Define sidebar panel for choosing grouping, raw values and scale
        sidebarPanel(
          tags$h3("Choose"),
          uiOutput("GroupingVariable"),
          tags$p("Variable which is used to divide the observations into groups, for example variable age by rounding to a half or a full year"),
          tags$br(),
          uiOutput("RawValues"),
          tags$br(),
          uiOutput("WeightVariable"),
          tags$div(class = "body", checked = NA,
          tags$span("Optional weighting variable, please consult vignette on "),
          tags$a(href="https://cran.r-project.org/web/packages/cNORM/vignettes/WeightedRegression.html", "WeightedRegression"),
          ),
          tags$br(),
          selectInput("Scale", label = "Norm Scale", choices = c("T", "IQ", "z"), selected = "T"),
          actionButton(inputId = "DoDataPreparation", label = "Prepare Data"),
          downloadButton("downloadData", "Download Data"),
          tags$br(),
          tags$br(),
          # Additional options (explanatory variable with default grouping, ranking method, number of powers)
          tags$h3("Additional options"),
          uiOutput("ExplanatoryVariable"),
          tags$p("As default, the explanatory variable is set to grouping variable. If available, use a continuous explanatory variable like age."),
          tags$b("HINT! The range of values of the explanatory variable have to correpsond with the values of the grouping variable, i. e. specify the group means."),
          tags$br(),
          tags$br(),
          tags$br(),
          selectInput(
            inputId = "NumberOfPowers",
            label = "Power degree for location",
            choices = c(1:5),
            selected = 5
          ),
          tags$p("This variable specifies the power parameter for the norm score in the Taylor polynomial. As default number of power is set to 4. Higher values might lead to a closer fit, but yield the danger of overfitting."),
          tags$br(),
          selectInput(
            inputId = "NumberOfPowersAge",
            label = "Power degree for age",
            choices = c(1:5),
            selected = 3
          ),
          tags$p("This variable specifies the power parameter for the explanatory variable in the Taylor polynomial, usually age. Since age trajectories are usually less complex, it can be reduced to 3 or 2 in most use cases, leading to simpler and more robust models."),
          tags$br(),
          selectInput("Method", label = "Ranking method", choices = c("Blom (1985)", "Tukey (1949)", "Van der Warden (1952)", "Rankit (Bliss, 1967)", "Levenbach (1953)", "Filliben (1975)", "Yu & Huang (2001)"), selected = "Rankit (Bliss, 1967)"),
          selectInput(
            inputId = "RankingOrder",
            label = "Ranking order of the raw score",
            choices = c("Ascending", "Descending"),
            selected = 1
          )
        ),
        # Main panel for showing prepared data
        mainPanel(withSpinner(DT::DTOutput("preparedData"), type = 5))
      )
    ),

    # Defines panel for best model output
    # Tab returns bestModel with information function and plot of real and predicted raw values
    navbarMenu(
      "Modeling & Validation",
      tabPanel(
      "Model",
      sidebarLayout(
        sidebarPanel(
          tags$h3("Model Data"),
          tags$p("Here, you can calculate a regression model that models the original data as close as possible, while smoothing the curves and eliminating noise. The plots display the percentile curves and the information criteria for the different models, beginning with the model with one terms up to the maximum. A high R2 with as few terms as possible is preferable."),
          tags$br(), tags$b("HINT: Please ensure that the data is loaded and prepared, before starting the modeling. In case of k > 4, the calculation will take a few seconds. Look out for an 'elbow' in the information function chart and try that number of terms for your model. Avoid intersecting percentile curves."),
          tags$br(), tags$br(),

          actionButton(
            inputId = "CalcBestModel",
            label = "Model Data"
          ),

          downloadButton("downloadModel", "Download Model"),

          tags$br(),
          # Additional options (R^2, terms, type for printSubset)
          tags$h3("Additional options"),
          numericInput(
            inputId = "ChosenDetCoeff",
            label = "Coefficient of Determination", value = 0.99, min = 0, max = 1, step = 0.01
          ),
          uiOutput("NumberOfTerms"),
          selectInput(inputId = "chosenTypePlotSubset", "Type of plot", choices = c("Adjusted R2 by Number of Predictors", "Log Transformed Mallow's Cp by Adjusted R2", "Bayesian Information Criterion (BIC) by Adjusted R2", "RMSE by Number of Predictors"), selected = "RMSE by Number of Predictors")
        ),
        mainPanel(
          withSpinner(verbatimTextOutput("BestModel1"), type = 5),
          verbatimTextOutput("BestModel2"),
          verbatimTextOutput("BestModel3"),
          verbatimTextOutput("BestModel4"),
          verbatimTextOutput("BestModel5"),
          #verbatimTextOutput("BestModel6"),
          #verbatimTextOutput("BestModel7"),
          tags$br(),
          # tags$h4("Information Function, Subset Specifics and Fitted Values"),
          # tags$p("The plot shows the informationcriteria for the different models, beginning with the model with one terms up to the maximum. The model should have a high R2 with as few terms as possible. The information of the plot is again displayed as a table below the chart. On the bottom of the page, you can see, how well the observed data are fitted by the model."),
          # plotOutput("PlotPercentiles", width = "100%", height = "600px"),
          withSpinner(plotOutput("modelPlot", width = "100%", height = "600px"), type = 5),
          tags$br(),

          withSpinner(plotOutput("PlotWL", width = "100%", height = "600px"), type = 5),
          tags$br(),
          withSpinner(DT::DTOutput("PrintSubset"), type = 5),
          tags$br()
          )
      )
    ),

    tabPanel(
      "Cross-Validation",
      sidebarLayout(
        sidebarPanel(
          tags$h3("Cross Validation"),
          tags$p("This function helps in selecting the number of terms for the model by doing repeated cross validation with 80 percent of the data as training data and 20 percent as the validation data. The cases are drawn randomly but stratified by norm group. Successive models are retrieved with increasing number of terms and the RMSE of raw scores (fitted by the regression model) is plotted for the training, validation and the complete dataset. Additionally to this analysis on the raw score level, it is possible (default) to estimate the mean norm score reliability and crossfit measures. "),
          tags$p("HINT: The function has a high computational load when computing norm scores and takes some time to finish. Time increases with number of maximum terms, sample size and number of repetitions."),
          actionButton(
            inputId = "CrossValidation",

            label = "Cross Validation"
          ),
          tags$br(),
          tags$h3("Additional options"),
          sliderInput("MaxTermsCV", "Maximum number of terms:",
                      min = 1, max = 24, value = 10
          ),
          tags$br(),
          checkboxInput("NormsCV", "Check norm scores:", TRUE),
          tags$br(),
          sliderInput("RepetitionsCV", "Repetitions:",
                      min = 1, max = 20, value = 1
          )
        ),
        mainPanel(
          withSpinner(plotOutput("PlotCV", width = "100%", height = "800px"), type = 5),
          tags$br(),
          withSpinner(DT::DTOutput("TableCV"), type = 5)
        )
      )
    )
    ),

    navbarMenu(
      "Visualization",
      tabPanel("Percentiles", sidebarLayout(
        sidebarPanel(
          tags$h3("Percentiles"), tags$p("The chart shows how well the model generally fits the observed data. The observed percentiles are represented as dots, the continuous norm curves as lines. In case of intersecting norm curves the model is inconsistent. Please change the number of terms in the 'Best Model' tab in order to find a consistent model. You can use the 'Series' option to look out for suitable parameters."),
          tags$br(),
          textInput(inputId = "PercentilesForPercentiles", "Choose percentiles"),
          tags$p("Please seperate the values by a comma or space.")
        ),
        mainPanel(plotOutput("PlotPercentiles", width = "100%", height = "800px"))
      )),

      tabPanel("Series", sidebarLayout(
        sidebarPanel(
          tags$h3("Percentile Series"),
          tags$p("In oder to facilitate model selection, the chart displays percentile curves of the different models."),
          tags$br(), sliderInput("terms", "Number of terms:",
            min = 1, max = 24, value = 5
          ), tags$br(), tags$br(),
          tags$p("Please use the slider to change the number of terms in the model. Please select a model with non-intersecting percentile curves. Avoid undulating curves, as these indicate model overfit."),
          tags$br(), tags$b("After choosing the best fitting number of terms, please rerun the model calculation with a fixed number of terms before generating norm tables.")
        ),
        mainPanel(plotOutput("Series", width = "100%", height = "800px"))
      )),


      tabPanel("Norm Curves", sidebarLayout(
        sidebarPanel(
          tags$h3("Norm Curves"), tags$p("The chart is comparable to the percentile plot. It only shows the norm curves for some selected norm scores."),
          textInput(inputId = "PercentilesForNormCurves", label = "Choose percentiles for norm curves", value = ""),
          tags$p("Please seperate the values by a comma or space. The percentile values are automatically transformed to the norm scale used in the data preparation. In order to get curves specific z values, you can use the following percentiles:"),
          tags$div(
            HTML("<div align=center><table width=100%><tr><td align = right><b>z</b></td><td align = right>-2</td><td align = right>-1</td><td align = right>0</td><td align = right>1</td><td align = right>2</td></tr><tr><td align = right><b>percentile</b></td><td align = right> 2.276</td><td align = right> 15.87</td><td align = right> 50.00</td><td align = right> 84.13</td><td align = right> 97.724</td></tr></table></div>")
          )
        ),
        mainPanel(plotOutput("NormCurves", width = "100%", height = "800px"))
      )),
      tabPanel("Density", sidebarLayout(sidebarPanel(
        tags$h3("Density"), tags$p("The plot shows the probability density function of the raw scores based on the regression model. Like the 'Derivative Plot', it can be used to identify violations of model validity or to better visualize deviations of the test results from the normal distribution. As a default, the lowest, highest and a medium group is shown."),
        tags$br(),
        textInput(inputId = "densities", "Choose groups"),
        tags$p("Please seperate the values by a comma or space.")
      ), mainPanel(
        withSpinner(
          plotOutput("PlotDensity", width = "100%", height = "800px"),
          type = 5
        )
      ))),
      tabPanel("Derivative Plot", sidebarLayout(sidebarPanel(tags$h3("Derivative Plot"), tags$p("To check whether the mapping between latent person variables and test scores is biunique, the regression function can be searched numerically within each group for bijectivity violations using the 'checkConsistency' function. In addition, it is also possible to plot the first partial derivative of the regression function to l and search for negative values. Look out for values lower than 0. These indicate violations of the model.")), mainPanel(
        withSpinner(plotOutput("PlotDerivatives", width = "100%", height = "600px"), type = 5)
      ))),

      tabPanel("Norm Scores", sidebarLayout(sidebarPanel(
        tags$h3("Norm Scores Plot"), tags$p("The plot shows the observed and predicted norm scores. You can identify, how well the model is able to predict the norm scores of the dataset. The duration of the computation increases with the size of the dataset."),
        tags$br(),
        checkboxInput("grouping", "Plot by group", FALSE),
        checkboxInput("differences", "Plot differences", FALSE), tags$br(),
        actionButton(
          inputId = "normScoreButton",

          label = "Update"
        )
      ), mainPanel(
        withSpinner(
          plotOutput("PlotNormScores", width = "100%", height = "800px"),
          type = 5
        )
      ))),

      tabPanel("Raw Scores", sidebarLayout(sidebarPanel(
        tags$h3("Raw Scores Plot"), tags$p("The plot shows the observed and predicted raw scores. You can identify, how well the model is able to predict the raw scores of the original dataset."),
        tags$br(),
        checkboxInput("grouping1", "Plot by group", FALSE),
        checkboxInput("differences1", "Plot differences", FALSE), tags$br(),
        actionButton(
          inputId = "rawScoreButton",

          label = "Update"
      )), mainPanel(
        withSpinner(
          plotOutput("PlotRawScores", width = "100%", height = "800px"),
          type = 5
        )
      )))
    ),


    # NavbarMenu for predicting norm and raw values and raw/norm tables
    navbarMenu(
      "Prediction",
      tabPanel("Norm value prediction", sidebarLayout(sidebarPanel(tags$h3("Prediction of singel norm values"), uiOutput("InputNormValue")), mainPanel(verbatimTextOutput("NormValue")))),
      tabPanel("Raw value prediction", sidebarLayout(sidebarPanel(tags$h3("Prediction of single raw values"), uiOutput("InputRawValue")), mainPanel(verbatimTextOutput("RawValue")))),
      tabPanel("Norm table", sidebarLayout(sidebarPanel(tags$h3("Norm table compilation"), uiOutput("InputNormTable")), mainPanel(DT::DTOutput("NormTable")))),
      tabPanel("Raw table", sidebarLayout(sidebarPanel(tags$h3("Raw table compilation"), uiOutput("InputRawTable")), mainPanel(DT::DTOutput("RawTable"))))
    )
  )
))
