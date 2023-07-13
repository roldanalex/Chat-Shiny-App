library(shiny)
library(shinyjs)
library(shinyalert)
library(tidyverse)
library(shinythemes)
library(httr)
library(stringr)

val <- reactiveValues(txt = NULL, users = c(),
                      new_usr = NULL, usr_left =NULL)

api_key <- Sys.getenv("OPENAI_API")

intro <- "
#########################################
** Welcome to my Personal AI Assistant **
#########################################
"

val$txt <- intro

jsCode <- "
// send message on enter
jQuery(document).ready(function(){
  jQuery('#text_msg').keypress(function(evt){
    if (evt.keyCode == 13){
      // Enter, simulate clicking send
      jQuery('#send').click();
      jQuery('#text_msg').html('hihihi');
    }
  });
})
// auto scroll to bottom
var oldContent = null;
window.setInterval(function() {
  var elem = document.getElementById('chat_window');
  if (oldContent != elem.innerHTML){
    scrollToBottom();
  }
  oldContent = elem.innerHTML;
}, 300);
// Scroll to the bottom of the chat window.
function scrollToBottom(){
  var elem = document.getElementById('chat_window');
  elem.scrollTop = elem.scrollHeight;
}"

prompt_history <- list()

# Calls the ChatGPT API with the given prompt and returns the answer
ask_chatgpt <- function(prompt) {

  prompt_history <<- append(prompt_history, list(list(
    role = "user", 
    content = prompt
    )))

  response <- POST(
    url = Sys.getenv("OPENAI_COMPLETION_URL"),
    add_headers(Authorization = paste("Bearer", api_key)),
    content_type_json(),
    encode = "json",
    body = list(
      model = "gpt-3.5-turbo",
      messages = prompt_history
    )
  )

  result_prompt <- str_trim(content(response)$choices[[1]]$message$content)

  prompt_history <<- append(prompt_history, list(list(
    role = "assistant", 
    content = result_prompt
  )))

  return(result_prompt)

}
