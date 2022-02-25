
taceconomics.base_url <- function(base_url) {
  if (!missing(base_url)) {
    options(taceconomics.base_url = base_url)
  }
  invisible(getOption("taceconomics.base_url", "https://api.taceconomics.io/v2"))
}


taceconomics.apikey <- function(apikey) {
  if (!missing(apikey)) {
    options(taceconomics.apikey=apikey)
  }
  invisible(getOption("taceconomics.apikey"))
}


taceconomics.api <- function(path, method="GET", data=NULL) {

  if(!is.element(method, c("GET", "POST"))) {
    return(NULL)
  }

  headers = NULL
  if (!is.null(taceconomics.apikey())) {
    headers <- c(headers, list("x-api-key" = taceconomics.apikey()))
  }

  url = paste(taceconomics.base_url(), path, sep="/")
  req = httr::VERB(method, url, config=do.call(httr::add_headers, headers), body=data)

  if( httr::status_code(req) == 200 ) {
    data = content(req, "text", encoding="UTF-8")
    data = jsonlite::fromJSON(data)
    return(data)
  }

  return(NULL)
}

taceconomics.format_code <- function(code) {
  dataset = NULL
  symbol  = NULL
  key     = NULL
  codes   = strsplit(code, "/")
  if(length(codes[[1]]) == 1) {
    return(NULL)
  } else if(length(codes[[1]]) == 2) {
    dataset = codes[[1]][1]
    symbol  = codes[[1]][2]
    if(is.null(dataset)) return(NULL)
    if(is.null(symbol)) return(NULL)
  } else if(length(codes[[1]]) == 3) {
    dataset = codes[[1]][1]
    symbol  = codes[[1]][2]
    key     = codes[[1]][3]
    if(is.null(dataset)) return(NULL)
    if(is.null(symbol)) return(NULL)
    if(is.null(key)) return(NULL)
  }
  list(dataset=dataset, symbol=symbol, key=key)
}



getcountries <- function() {
  r = taceconomics.api("data/countries")
  if("errors" %in% names(r)) return(r)
  return(r$data)
}


getregions <- function(region=NULL) {
  if(is.null(region)) {
    r = taceconomics.api("data/regions")
  } else {
    r = taceconomics.api(paste("data/regions", region, sep="/"))
  }
  if("errors" %in% names(r)) return(r)
  return(r$data)
}

getsymbols <- function(dataset) {
  path = paste("data", dataset, "symbols", sep="/")
  r = taceconomics.api(path)
  if("errors" %in% names(r)) return(r)
  return(r$data)
}


searchsymbols <- function(terms) {
  path = paste("data/search", terms, sep="/")
  r = taceconomics.api(path)
  if("errors" %in% names(r)) return(r)
  return(r$data)
}

getdata <- function(code, countries=NULL) {

  if(length(countries)==1) {
    full_code = paste(code, countries, sep="/")
    dat = getdata(full_code)
    return(dat)
  }

  if(length(countries)>1) {
    dat = NULL
    for(country in countries) {
      full_code = paste(code, country, sep="/")
      x = getdata(full_code)
      dat = cbind(dat,x)
    }
    if(!is.null(ncol(dat))) colnames(dat) = countries
    return(dat)
  }

  codes = taceconomics.format_code(code)
  if(is.null(codes)) return(NULL)

  path = paste("data", codes$dataset, codes$symbol, sep="/")
  if(!is.null(codes$key)) {
    path = paste(path, codes$key, sep="/")
  }

  r = taceconomics.api(path)
  if(is.null(r)) {
    dat = xts(NA, as.Date("2000-01-01", format="%Y-%m-%d"))
  } else {
    dat = xts(r$data$value, as.Date(r$data$timestamp, format="%Y-%m-%d"))
  }

  if(length(dat)>1) {
    freq = switch( periodicity(dat)$scale
                 , "daily"     = "day"
                 , "weekly"    = "week"
                 , "monthly"   = "month"
                 , "quarterly" = "quarter"
                 , "yearly"    = "year"   )
    seqdate = seq(start(dat), end(dat), by = freq)
    seqdate = xts(data.frame(seqdate=rep(NA,length(seqdate))),order.by = seqdate)
    dat = cbind(seqdate,dat)[,-1]
  }

  if(is.null(codes$key)) {
    colnames(dat) = paste(toupper(codes$dataset), toupper(codes$symbol), sep="/")
  } else {
    colnames(dat) = paste(toupper(codes$dataset), toupper(codes$symbol), toupper(codes$key), sep="/")
  }

  return(dat)
}


putdata <- function(code, data) {

  codes = taceconomics.format_code(code)
  if(is.null(codes)) return(NULL)

  symbol = paste(toupper(codes$symbol), sep="/")
  if(!is.null(codes$key)) {
    symbol = paste(toupper(codes$symbol), toupper(codes$key), sep="/")
  }

  d = data
  dates = time(d)
  d = data.frame(row.names=NULL, symbol=symbol, timestamp=dates, d)
  if(ncol(d)==3) colnames(d) = c("symbol", "timestamp", "value")
  data_json = jsonlite::toJSON(list(data=d), digits=NA)

  p = paste("data", codes$dataset, symbol, sep="/")
  r = taceconomics.api(p, method="POST", data=data_json)

  r
}
