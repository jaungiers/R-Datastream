# R-Datastream
Simple framework library for communicating between Thompson Reuters Datastream service API and R.

## Requirements
This package makes use of RCurl and jsonlite libraries. Please make sure you have those installed before using this package. Both libraries can be installed by typing:

`install.packages('RCurl')`

`install.packages('jsonlite')`

## Usage
To use the package you will need to have access to Thompson Reuters Datastream. After importing the RDatastream.r file you can retrieve a DataFrame with the query data by calling:

`getData(username, password, instrument, datatype, data_start, data_end, frequency)`