
server <- function(input, output, session) {
  
  # renaming your user name ----
  observeEvent("", {
    username <- paste0("Username")
    shinyalert(
      inputId = "username" ,
      "Welcome to my Personal AI Assistant",
      html = TRUE,
      text = tagList(
        textInput("uname", "Please name yourself", value = username),
      ),
      closeOnEsc = FALSE,
      closeOnClickOutside = FALSE,
      showCancelButton = FALSE,
      showConfirmButton = TRUE,
      confirmButtonCol = "red"
    )
  })
  # ----
  
  # to display new user joined ----
  observeEvent(input$username, {
    val$users <- c(val$users, input$uname)
    paste0("New user joined : ", input$uname) -> new_usr
    showNotification(new_usr,
                     duration = 3,
                     type = "message")
    print(new_usr)
    print(val$users)
  })
  
  output$users <- renderText({paste(val$users, collapse = '\n')})
  # ----
  
  output$logged_usr <- renderText({
    paste("<b>Current User: ", input$uname, "</b>")
  })
  
  # sending msg ----
  observeEvent(input$send, {
    
    # if the txt msg is empty
    if (input$text_msg == "") {
      
      shinyalert(
        "Oops!", "Can't send a blank instruction",
        type = "error", closeOnEsc = TRUE,
        timer = 3000, closeOnClickOutside = TRUE,
        showCancelButton = FALSE, showConfirmButton = TRUE
        )
      
    } else{
      
      if(object.size(val$txt)>50000){
        
        val$txt <- intro
      
        }
      
      answer <- ask_chatgpt(input$text_msg)
      
      new_prompt <- paste(format(Sys.time(), "%d%b%y %H:%M"), "#", input$uname, ":" , input$text_msg)
      
      prompt_answ <- paste(format(Sys.time(), "%d%b%y %H:%M"), "# GTP Assistant :")
      
      new_answer <- paste(prompt_answ, answer, sep = "\n") 
      
      val$txt <- paste(val$txt, new_prompt, new_answer, " ", sep = "\n")
      
      updateTextInput(session, "text_msg", value = "")
      
    }
  })
  
  output$chat_window <- renderText({val$txt })
  # ----
  
  # update the active user list on exit ----
  session$onSessionEnded(function(){
    isolate({
      val$users <- val$users[val$users != input$uname]
      paste0("user : ", input$uname, " left the room") -> usr_left
      print(usr_left)
      print(val$users)
    })
  })
  # ----
  
}