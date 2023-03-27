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

	import(taceconomics)
	taceconomics.apikey(TACECONOMICS_APIKEY)
	
You can now query a data using the function getdata() or by using the Path as defined in the next chapter :
	getdata("weo/NGDP_RPCH","EGY")
	taceconomics.api('data/weo/NGDP_RPCH/EGY')

	
# List of all Available path 

you can make a query by using the basic url path(https://api.taceconomics.io/) whith :

PATH | Description |
|---|---|
| data/datasets | List all available datasets |
| data/countries | List all countries |
| data/regions | List all regions defined |
| data/regions | List all regions defined |
| data/dataset_id | List all symbols for the dataset_id |
| data/dataset_id/symbol/country_id | Get data for the specified symbol and country |

There is also a list of associated options :

OPTION | Description | value | 
|---|---|
| api_key | Set your apikey | Your TACECONOMICS_APIKEY
| start_date | Set the starting date of the queried datas | date on format '%YYYY-%MM-%d'
| end_date | Set the ending date of the queried datas | date on format '%YYYY-%MM-%d'


# Exemple of query

Get from World Economic Outlook (WEO) the gdp growth for Egypt until 2022:
	https://api.taceconomics.io/data/weo/NGDP_RPCH/EGY?api_key=TACECONOMICS_APIKEY&end_date='2022-01-01'






