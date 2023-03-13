# How to call the new (as of 2023-03-01) ChatGPT API from R
# Get your API key over here: https://platform.openai.com/
api_key <- Sys.getenv("OPENAI_API")

library(httr)
library(stringr)

# Calls the ChatGPT API with the given prompt and returns the answer
ask_chatgpt <- function(prompt) {
  response <- POST(
    url = "https://api.openai.com/v1/chat/completions", 
    add_headers(Authorization = paste("Bearer", api_key)),
    content_type_json(),
    encode = "json",
    body = list(
      model = "gpt-3.5-turbo",
      messages = list(list(
        role = "user", 
        content = prompt
      ))
    )
  )
  str_trim(content(response)$choices[[1]]$message$content)
}

answer <- ask_chatgpt("Write a machine learning model to analyze hand signs")
cat(answer)


# install.packages("devtools")
devtools::install_github("agstn/dataxray")

library(dataxray)
library(ggplot2)

diamonds %>% 
  make_xray() %>% 
  view_xray()
