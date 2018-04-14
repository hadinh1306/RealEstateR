#' Get Review Details of Agents of your Choice
#'
#' @author Ha Dinh
#'
#' @description
#' This function inputs up to 5 agents' screenname,
#' then output the agents' information and their review stars.
#'
#' @param screennames Agent screenname(s) of your choice (at most 5 screennames)
#'
#'
#' @import rvest
#' @import httr
#'
#' @return A dataframe that includes details of agents, and their star reviews.
#'
#' @examples
#' \dontrun{screennames <- c("mwalley0", "pamelarporter", "klamping4", "Cincysrealtor")
#' reviews(screennames)}
#'
#' @export

reviews <- function(screennames){
  # call API key from get_zwsid
  zwsid <- getOption("ZWSID")

  df <- NULL

  # check conditions of screenname: a character input, with length 5 at most
  if (is.character(screennames) != TRUE){
    stop("Expect screennames input to be character.")
  }

  if (length(screennames) > 5){
    stop("Expect at most 5 screennames.")
  }

  # get all info of agents in a location
  for (s in screennames){
    uri <- paste0("http://www.zillow.com/webservice/ProReviews.htm?zws-id=", zwsid, "&screenname=", s, "&output=json")

    content_json <- httr::GET(uri) %>% httr::content("text")

    content <- jsonlite::fromJSON(content_json)

    status <- content$message$text

    title <- content$response$results$proInfo$title
    businessName <- content$response$results$proInfo$businessName
    businessAddress <- content$response$results$proInfo$address
    phone <- content$response$results$proInfo$phone

    name <- content$response$results$proInfo$name
    screenname <- content$response$results$screenname
    specialties <- content$response$results$proInfo$specialties
    serviceArea <- content$response$results$proInfo$serviceAreas
    recentSaleCount <- content$response$results$proInfo$recentSaleCount
    reviewCount <- content$response$results$proInfo$reviewCount
    localknowledgeRating <- content$response$results$proInfo$localknowledgeRating
    processexpertiseRating <- content$response$results$proInfo$processexpertiseRating
    responsivenessRating <- content$response$results$proInfo$responsivenessRating
    negotiationskillsRating <- content$response$results$proInfo$negotiationskillsRating

    df <-  rbind(df, tibble::tibble(status, name, screenname, title,
                                    businessName, businessAddress, phone,
                                    specialties, serviceArea =  list(serviceArea), recentSaleCount, reviewCount,
                                    localknowledgeRating, processexpertiseRating, responsivenessRating, negotiationskillsRating))

  }

  return(df)
}