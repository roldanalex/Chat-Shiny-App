
ui <- fluidPage(
  theme = shinytheme("superhero"),
  shinyjs::useShinyjs(),
  useShinyalert(),
  tags$head(
    # tags$link(rel = "stylesheet", type = "text/css", href = "style.css")
    tags$link(rel="shortcut icon", href="favicon.ico"), #Icon for browser tab
    #Including Google analytics and Cookie control
    includeCSS("www/style.css"),
    tags$title("GTP Assistant")
  ),
  extendShinyjs(text = jsCode, functions = c()),
  fluidRow(
    column(width = 6,
           h2("GTP Assistant")),
    column(
      width = 6,
      align = "right",
      br(),
      htmlOutput("logged_usr")
    )
  ),
  div(
    style = "height : 500px;",
      fluidRow(
        column(
          width = 10,
          verbatimTextOutput("chat_window"),
          tags$head(tags$style("")),
          uiOutput("notify")
        ),
        column(
          width = 2,
          h5("Active Users"),
          hr(),
          textOutput("users"))
        )
      ),
  fluidRow(column(
    width = 10,
    textInput(
      "text_msg", "", 
      value = "", width = "100%",
      placeholder = "Enter you prompt")
    ),
  column(width = 2,
         br(),
         actionButton("send", "Send",
                      width = "100%")))
  )