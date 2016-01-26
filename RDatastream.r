#' ---
#' title: "R-DataStream API Library"
#' author: "Jakob Aungiers"
#' date: "22/01/2016"
#' ---

suppressMessages(library('RCurl'))
suppressMessages(library('jsonlite'))

url_base <- 'http://product.datastream.com/DSWSClient/V1/DSService.svc/rest/'

getToken <- function(u, p) {
	url_params <- paste('Token?username=', u, '&password=', p, sep='')
	resp <- getURL(paste(url_base, url_params, sep=''))
	return(resp)
}

getData <- function(username, password, instrument, datatype, start, end, freq) {
	token <- fromJSON(getToken(username, password))$TokenValue
	url_params <- paste('Data?token=', token,
						'&instrument=', instrument,
						'&datatypes=', datatype,
						'&start=', start,
						'&end=', end,
						'&freq=', freq,
						'&datekind=TimeSeries',
						sep='')
	resp <- getURL(paste(url_base, gsub('\\+', '%2b', url_params), sep=''))
	data <- fromJSON(resp)
	values <- data$DataTypeValues$SymbolValues[[1]]$Value[[1]]
	dates <- as.POSIXct(as.numeric(substr(data$Dates, 7, 16)), origin='1970-01-01', 'UTC')
	df <- data.frame(dates, values)
	return(df)
}