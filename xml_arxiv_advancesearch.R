library(httr)

# Specify the URL
url <- "https://arxiv.org/search/advanced"

# Make a GET request
response <- GET(url)

# Check if the request was successful
if (http_status(response)$category == "Success") {
  # Read the HTML content
  html_content <- content(response, "text")
  
  # Display the HTML content
  cat(html_content)
} else {
  cat("Error:", http_status(response)$reason, "\n")
}





#######################################
library(httr)
library(rvest)
library(tibble)

# Specify the URL
child_url <- "https://arxiv.org/search/advanced?advanced=&terms-0-operator=AND&terms-0-term=&terms-0-field=title&classification-computer_science=y&classification-physics_archives=all&classification-include_cross_list=include&date-filter_by=all_dates&date-year=&date-from_date=&date-to_date=&date-date_type=submitted_date&abstracts=show&size=50&order=-announced_date_first"

# Make a GET request to the child URL
response <- GET(child_url)

# Check if the request was successful
if (http_status(response)$category == "Success") {
  # Read the HTML content
  html_content <- content(response, "text")
  
  # Parse HTML content with rvest
  page <- read_html(html_content)
  
  # Extract information about papers (titles, abstracts, categories)
  papers <- page %>% html_nodes(".arxiv-result")
  
  # Initialize lists to store data
  titles <- list()
  abstracts <- list()
  categories <- list()
  
  # Iterate over each paper entry
  for (paper in papers) {
    title <- paper %>% html_node(".title") %>% html_text() %>% trimws()
    abstract <- paper %>% html_node(".abstract") %>% html_text() %>% trimws()
    category <- paper %>% html_nodes(".primary-subject span") %>% html_text() %>% trimws()
    
    # Append to lists
    titles <- append(titles, title)
    abstracts <- append(abstracts, abstract)
    categories <- append(categories, category)
  }
  
  # Combine lists into vectors
  titles <- unlist(titles)
  abstracts <- unlist(abstracts)
  categories <- unlist(categories)
  
  # Create a data frame
  papers_df <- tibble(
    "Primary Category" = categories,
    "Categories" = categories,
    "Abstract" = abstracts,
    "Title" = titles
  )
  
  # Display the data frame
  print(papers_df)
  
  # Optionally, you can save the data frame to a CSV file
  write.csv(papers_df, "papers_data.csv", row.names = FALSE)
  
  cat("Data saved to papers_data.csv\n")
} else {
  cat("Error:", http_status(response)$reason, "\n")
}