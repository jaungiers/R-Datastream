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
	data <- fromJSON(gsub('NaN', 0, resp)) #Convert any incomplete time series from NaN's to 0's to allow for valid JSON parse
	values <- data$DataTypeValues$SymbolValues[[1]]$Value[[1]]
	dates <- as.POSIXct(as.numeric(substr(data$Dates, 7, 16)), origin='1970-01-01', 'UTC')
	df <- data.frame(dates, values)
	return(df)
}

getDataMatrix <- function(username, password, instruments, datatypes, daterange) {
	token <- fromJSON(getToken(username, password))$TokenValue
	lInstruments <- paste(instruments, collapse=',')
	lDatatypes <- paste(datatypes, collapse=',')
	url_params <- paste('Data?token=', token,
						'&instrument=', lInstruments,
						'&datatypes=', lDatatypes,
						'&start=', daterange[1],
						'&end=', daterange[2],
						'&freq=', daterange[3],
						'&datekind=TimeSeries&props=IsList',
						sep='')
	resp <- getURL(paste(url_base, gsub('\\+', '%2b', url_params), sep=''))
	data <- fromJSON(gsub('NaN', 0, resp)) #Convert any incomplete time series from NaN's to 0's to allow for valid JSON parse
	dates <- as.POSIXct(as.numeric(substr(data$Dates, 7, 16)), origin='1970-01-01', 'UTC')

	matrix.list <- c()
	for(i in 1:length(instruments)) {
		matrix.list[[instruments[i]]] <- data.frame(dates)
	}

	len.dTypes <- length(data$DataTypeValues$DataType)
	for(i in 1:len.dTypes) {
		for(j in 1:length(instruments)) {
			if(data$DataTypeValues$DataType[i] == '') {
				matrix.list[[j]] <- data$DataTypeValues$SymbolValues[[i]]$Value[[j]]
			} else {
				matrix.list[[j]][data$DataTypeValues$DataType[i]] <- data$DataTypeValues$SymbolValues[[i]]$Value[[j]]
			}
		}
	}

	return(matrix.list)
}