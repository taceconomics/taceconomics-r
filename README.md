# TAC ECONOMICS R Package

This is TAC ECONOMICS' R package. This package uses the TAC ECONOMICS API.

License provided by MIT.

For more information please contact info@taceconomics.com

# Installation

To install the [devtools](https://cran.r-project.org/package=devtools) package:

    install.packages("devtools")
    library(devtools)
    install_github("taceconomics/taceconomics-r")
	

# Usage

Import the TAC ECONOMICS package and set your apikey to be able to query datas :

	library(taceconomics)
	taceconomics.apikey(YOUR_APIKEY)
	
You can now query a data using the function getdata() which return the query with xts format, or by using the taceconomics.api call to get raw data :

	getdata("weo/NGDP_RPCH","EGY")
	taceconomics.api('data/weo/NGDP_RPCH/EGY')

	
# List of all Available path 

you can make a query by using the basic url path(https://api.taceconomics.io/) whith :

PATH | Description |
|---|---|
| data/datasets | List all available datasets |
| data/countries | List all countries |
| data/regions | List all regions defined |
| data/currencies | List all currencies defined |
| data/search | Search options, see bloc search below fo further details |
| data/dataset_id | List all symbols for the dataset_id |
| data/dataset_id/symbol/country_id | Get data for the specified symbol and country |

With our taceconomics package, you can query those paths using :

	taceconomics.api('data/datasets')$data
	taceconomics.api('data/countries')$data
	taceconomics.api('data/regions')$data
	taceconomics.api('data/weo')$data
	taceconomics.api('data/weo/NGDP_RPCH/EGY')$data

When querying datas, you have a list of defined options :

OPTION | Description | value | 
|---|---|---|
| api_key | Set your apikey | Your TACECONOMICS_APIKEY |
| start_date | Set the starting date of the queried datas | date on format '%yyyy-%MM-%dd' |
| end_date | Set the ending date of the queried datas | date on format '%yyyy-%MM-%dd' |
| collapse | returned frequency of the query | one of 'A','Q','M','W','D'. Default base frequency of the indicator |
| collapse_mode | aggregation mode if needed | one of 'mean','start_of_period','end_of_period','median'. Default 'mean' |
| transform | transformation to apply to the query | one of 'diff','diff_yoy','growth','growth_yoy'|


	taceconomics.api('data/eia/BREPUUS/wld?start_date=2020&frequency=Q')$data

You can also search for a specific symbol, dataset, country or list all results for a keywords.

PATH | Description |
|---|---|
| data/search | starting path to look for a specific search |

OPTION | Description | value | 
|---|---|---|
| q | look for all results containing the specified keyword(s) | a (list of) keyword(s) (ex : brent) |
| symbol | list of all symbols containing the specified string | a string ( ex : brent) |
| dataset | list of all symbols in the specified dataset | a string (ex : weo) |
| country | list of all symbols available for the specified country | a country ISO 3 code (ex : FRA) |

	taceconomics.api("data/search?q=brent")$data
	taceconomics.api("data/search?dataset=eia")$data






