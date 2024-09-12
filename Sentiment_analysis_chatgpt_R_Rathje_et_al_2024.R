## Install Required Packages
install.packages("httr")   # Installs the 'httr' package for making HTTP requests (needed to talk to the API)
install.packages("tidyverse")   # Installs 'tidyverse', a collection of R packages for data manipulation and visualization
library(httr)   # Loads the 'httr' package so you can use its functions
library(tidyverse)   # Loads 'tidyverse' package

#########################
##### GPT prompting #####
#########################

# Note: code we are using was adapted by this blog post: https://rpubs.com/nirmal/setting_chat_gpt_R.  
# We highly recommend you read over that blog post in detail if you are stuck at any of these steps  

# First, you must get your ChatGPT API key from here: https://platform.openai.com/overview  
# You will need this key to access OpenAI's API, which allows you to send and receive prompts from GPT

# Then, put your API key in the quotes below:  
my_API <- ""   # Replace the empty quotes with your actual API key from OpenAI

# The "hey_chatGPT" function will help you access the API and prompt GPT
hey_chatGPT <- function(answer_my_question) {
  chat_GPT_answer <- POST(   # This sends a POST request to OpenAI's API
    url = "https://api.openai.com/v1/chat/completions",   # This is the endpoint where we send our question
    add_headers(Authorization = paste("Bearer", my_API)),   # Here we add the API key to authenticate the request
    content_type_json(),   # Specifies that the content we are sending and receiving is in JSON format
    encode = "json",   # This encodes the body of the request in JSON format
    body = list(   # The body contains the information we send to the API
      model = "gpt-4o",   # Specifies which version of GPT model to use
      temperature = 0,   # Temperature controls randomness; 0 means the model will be more deterministic (less creative)
      messages = list(
        list(
          role = "user",   # This specifies that the input is coming from the user
          content = answer_my_question   # The actual question you want to ask GPT
        )
      )
    )
  )
  str_trim(content(chat_GPT_answer)$choices[[1]]$message$content)   # Extracts and returns GPT’s answer to your question
}

# Read in your dataset
data <- read_csv("")   # Replace the file path with your actual CSV file location


# Create a variable "sentiment analysis"
data$sentiment <- NA

# Run a loop over the dataset's "review" column and prompt ChatGPT
for (i in 1:nrow(data)) {
  print(i)
  # Replace "abstract" with the exact name of the column if it differs
  prompt <- paste("Is the sentiment of this text positive, neutral, or negative? Answer only with a number: 1 if positive, 2 if neutral, and 3 if negative. Here is the text:", data$review[i])
  result <- hey_chatGPT(prompt)
  
  while (length(result) == 0) {
    result <- hey_chatGPT(prompt)
    print(result)
  }
  
  print(result)
  data$sentiment[i] <- result
}

write_csv(data, "", col_names = TRUE) # Replace the folder/name of the new file


