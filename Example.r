#' Test Harness for R-Datastream code
source('C:\\WORK\\R\\RDatastream.r')

ds_username <- '' #Datastream Username
ds_password <- '' #Datastream Password

query <- getData(ds_username, ds_password, 'MSACWFL', 'MSPI', '-30D', '-1D', 'D')

print(query)