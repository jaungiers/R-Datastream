#' ---
#' title: "R-DataStream API Library"
#' author: "Jakob Aungiers"
#' date: "22/01/2016"
#' ---

suppressMessages(library('RCurl'))
suppressMessages(library('jsonlite'))

ds_username <- '' #DataStream Username
ds_password <- '' #DataStream Password

url_base <- 'http://product.datastream.com/DSWSClient/V1/DSService.svc/rest/'

getToken <- function(u, p) {
	url_params <- paste('Token?username=', u, '&password=', p, sep='')
	resp <- getURL(paste(url_base, url_params, sep=''))
	return(resp)
}

getData <- function(token, instrument, datatype) {
	url_params <- paste('Data?token=', token, '&instrument=', instrument, '&datatypes=', datatype, sep='')
	resp <- getURL(paste(url_base, gsub('\\+', '%2b', url_params), sep=''))
	return(resp)
}

ds_token <- fromJSON(getToken(ds_username, ds_password))$TokenValue

data <- fromJSON(getData(ds_token, 'MSACWFL', 'MSPI'))
print(data$DataTypeValues)