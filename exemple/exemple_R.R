library(taceconomics)
library(reshape2)

# List of all defined API paths :
# https://github.com/taceconomics/taceconomics-r

# you api_key
taceconomics.apikey("apikey_datalab")

######################################################################
#                             Basic Usage
######################################################################
# Search data of interest
search = "brent"
s = taceconomics.api(sprintf("data/search?q=%s",search))$data

# Get Description for specific symbol
symbol = "brent_f"
taceconomics.api(sprintf("data/search?symbol=%s",symbol))$data["description"]

symbol = "ei_cphi_m_cp"
taceconomics.api(sprintf("data/search?symbol=%s",symbol))$data[c("symbol","description")]

# Get single data
brent_tac = getdata("stf/brent_f/WLD")
brent_eia = getdata("EIA/BREPUUS/WLD")

# Get single data with additional options
options = "collapse=Q&transform=growth_yoy"
brent_eia = getdata(sprintf("EIA/BREPUUS/WLD?%s",options))


# Search all symbol for a defined dataset
ds = "stf"
s = taceconomics.api(sprintf("data/search?dataset=%s",ds))$data



######################################################################
#                        Advanced manipulations
######################################################################

# Define lists of countries and symbols of interest
list_cnt     = c('FRA','DEU','ITA')
list_symbols = c('eurostat/ei_cphi_m_cp-hi00xef_nsa_rt1','eurostat/ei_cphi_m_cp-hi00xes_nsa_rt12')

# Combine those lists
list_codes = apply(expand.grid(list_symbols, list_cnt), 1, paste, collapse="/")

# Get and merge all codes in list_code to a single dataframe
# Set the options if necessary (otherwise options = "")
options = "?collapse=A&transform=diff"
res = NULL
for(code in list_codes) {
  xx = getdata(paste0(code,options))
  res = cbind(res,xx)
}

# Transform the res dataframe in a panel
res_panel = data.frame(timestamp = index(res),res )
res_panel = melt(res_panel,id.vars = "timestamp")

# Add Explicit columns dataset/symbol/country_id based on codes
# res_panel["dataset"]    = sapply(strsplit(as.character(res_panel$variable), ".", fixed = TRUE), "[", 1)
# res_panel["symbol"]     = sapply(strsplit(as.character(res_panel$variable), ".", fixed = TRUE), "[", 2)
# res_panel["country_id"] = sapply(strsplit(as.character(res_panel$variable), ".", fixed = TRUE), "[", 3)


# To create a panel data more efficiently
res = NULL
for(code in list_codes) {
  xx = taceconomics.api(paste0("data/",code,options))
  xx = cbind(xx$data, xx$symbol, xx$country_id, xx$dataset)
  res = rbind(res,xx)
}
