#' Test Harness for R-Datastream code
source('C:\\WORK\\R\\RDatastream.r')

ds_username <- '' #Datastream Username
ds_password <- '' #Datastream Password

#query.single <- getData(ds_username, ds_password, 'MSACWFL', 'MSPI', '-30D', '-1D', 'D')
instruments <- c('MSACWFL', 'MSWRLDL')
datatypes <- c('MSPI', 'MSPE')
daterange <- c('2015-01-01', '2016-01-24', 'D') #Start date, End date, Frequency (D, W, M, Q or Y)
query.multiple <- getDataMatrix(ds_username, ds_password, instruments, datatypes, daterange)

#Returns a List of DataFrames, where each DataFrame is composed of columns:
#Date, DataType-1, DataType-2...DataType-N. And each row is the corresponding data for each data and DataTypes
print(query.multiple)