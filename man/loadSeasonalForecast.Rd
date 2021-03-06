% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/loadSeasonalForecast.R
\name{loadSeasonalForecast}
\alias{loadSeasonalForecast}
\title{Load a seasonal forecast}
\usage{
loadSeasonalForecast(dataset, var, dictionary = FALSE, members = NULL,
  lonLim = NULL, latLim = NULL, season = NULL, years = NULL,
  leadMonth = 1, time = "none", aggr.d = "none", aggr.m = "none")
}
\arguments{
\item{dataset}{A character string indicating the database to be accessed. This is usually a path to a local file or a URL 
pointing to a netCDF or NcML file in the case of netCDF and/or gridded datasets. For station data in standard ASCII format,
this is the path to the directory the dataset lives in.}

\item{var}{Variable code (character string). This is the name of the variable according to the R standard naming
(see the next argument). For variables with vertical levels, the vertical level is specified next to the variable name followed
 by the \dQuote{@} symbol (e.g. \code{var = "z@700"} for geopotential heigth at 700 mb isobaric surface pressure level).
 It is also possible to enter the variable name as originally coded in the dataset to skip data homogenization.}

\item{dictionary}{Default to FALSE, if TRUE a dictionary is used and the .dic file is stored in the same path than the
dataset. If the .dic file is stored elsewhere, then the argument is the full path to the .dic file (including the extension,
e.g.: \code{"/path/to/the/dictionary_file.dic"}). This is the case for instance when the dataset is stored in a remote URL,
and we have a locally stored dictionary for that particular dataset. If FALSE no variable homogenization takes place,
and the raw variable, as originally stored in the dataset, will be returned. See details for dictionary specification.}

\item{members}{A vector of integers indicating the members to be loaded.
Default to \code{NULL}, which loads all available members 
. For instance, \code{members=1:5} will retrieve the first five members of dataset.
 Discontinuous member selection (e.g. \code{members=c(1,5,7)}) is allowed. If the requested dataset is not a forecast
  or the requested variable is static (e.g. orography) it will be ignored.}

\item{lonLim}{Vector of length = 2, with minimum and maximum longitude coordinates, in decimal degrees, of the bounding box selected.
For single-point queries, a numeric value with the longitude coordinate. If \code{NULL} (default), the whole longitudinal range
 is selected (Note that this may lead to a large output object size).}

\item{latLim}{Same as \code{lonLim}, but for the selection of the latitudinal range.}

\item{season}{An integer vector specifying the desired season (in months, January = 1 ..., December = 12).
Options include one to several (contiguous) months. Default to \code{NULL}, indicating a full year selection (same as \code{season = 1:12}).}

\item{years}{Optional vector of years to select. Default (\code{NULL}) to all available years. If the requested variable is static (e.g. orography)
it will be ignored.}

\item{leadMonth}{Integer value indicating the lead forecast time, 
relative to the first month of \code{season}. Note that \code{leadMonth=1} for \code{season=1} (January)
 corresponds to the December initialization. Default to 1 (i.e., 1 lead month forecast)..}

\item{time}{A character vector indicating the temporal filtering/aggregation 
of the output data. Default to \code{"none"}, which returns the original time 
series as stored in the dataset. For sub-daily variables, instantantaneous data at 
selected verification times can be filtered using one of the character strings 
\code{"00"}, \code{"03"}, \code{"06"}, \code{"09"}, \code{"12"}, \code{"15"},
 \code{"18"}, \code{"21"},and \code{"00"} when applicable. If daily aggregated data are 
required use \code{"DD"}. If the requested variable is static (e.g. orography) it will be ignored. 
See the next arguments for time aggregation options.}

\item{aggr.d}{Character string. Function of aggregation of sub-daily data for daily data calculation. 
Currently accepted values are \code{"none"}, \code{"mean"}, \code{"min"}, \code{"max"} and \code{"sum"}.}

\item{aggr.m}{Same as \code{aggr.d}, bun indicating the aggregation function to compute monthly from daily data.
If \code{aggr.m = "none"} (the default), no monthly aggregation is undertaken.}
}
\value{
A list with the following components providing the necessary information for data representation and analysis.
\itemize{
\item{Variable}{A list with two elements, and some other attributes including units and temporal aggregation details:}
     \itemize{ 
         \item \code{varName} A character string indicating which is the variable returned. Same as value provided 
         for argument \code{var}
         \item \code{level} A numeric value indicating the vertical level of the variable (\code{NULL} for 2D variables)
     } 
\item{Data}{A N-dimensional array. The number of dimensions (N) depends on the type of request given that 
dimensions of length one are dropped. Thus, N can take values from 4 (several members for a 
rectangular domain with different values for longitude, latitude, ensemble and time dimensions)
 to 1 (atomic vector), for single-point and single-member selections, for which only the time dimension is required.
  The dimensions are labelled by the \dQuote{dimnames} attribute, 
  and are always arranged in canonical order (i.e.: [member, time, level, lat, lon]).}
\item{xyCoords}{A list with \code{x} and \code{y} components, as required by many standard mapping
 functions in R (see e.g. \code{\link[graphics]{image}}).
  In addition, the attribute \code{projection} provides projection information details.}
\item{Dates}{A list with two \code{POSIXct} time elements of the same length as the \sQuote{time} 
dimension in \code{Data}, defining the time boundaries of the time axis coordinates in the 
interval \emph{[start, end)}, or if the loaded field is static, a character string indicating it. See details.}
\item{InitializationDates}{A \code{POSIXct} time object corresponding to the initialization
 times selected. Only for forecast datasets. NA for static variables (e.g. orography). See details.}
\item{Members}{A character vector with the names of the ensemble members returned,
 in the same order as arranged in the \code{Data} array. Only for forecast datasets. NA for static variables (e.g. orography). See details.
}
}
Additionally, there are three global attributes with metadata, (\code{"dataset"}, which is always present.
 In addition \code{"source"} and \code{"URL"} are added for datasets from the User Data Gateway.
}
\description{
Load a user-defined spatio-temporal slice from a seasonal forecast
}
\section{Variable homogenization}{
 

The different nature of the various databases, models and variables, 
and the idiosyncratic naming and storage conventions often applied by the different 
modelling centres, makes necessary a previous homogeneization across datasets in 
order to implement a truly user-friendly toolbox for data access. 
This package achieves this aim by defining a common \code{vocabulary} to all 
climate datasets. The particular variables of each dataset are translated -and transformed if necessary- 
to the standard variables by means of a dictionary, provided by the argument \code{dictionary}.
In essence, the \file{dictionary} is a csv file particular for each individual dataset, 
containing the necessary information for performing the unit conversions to match the standard variable 
definitions contained in the vocabulary (see \code{\link{UDG.vocabulary}}). This feature is described in more detail
 in the \href{https://github.com/SantanderMetGroup/loadeR/wiki/Homogeneization}{loadeR wiki}..
}

\section{Temporal filtering and aggregation}{


The argument \code{time} controls the temporal filtering/aggregation options that may apply for a variable.
    In case of daily mean data, this can be obtained in two different ways:
       \enumerate{
       \item For variables that are already stored as daily means in the dataset, both \code{"DD"} and \code{"none"}
        return the required daily output
      \item In case of subdaily data, if \code{"DD"} is chosen, the function will compute the daily value using the
       aggregation function indicated in the argument \code{aggr.d}, printing an information message on screen.
        This function is normally the \code{"mean"} providing daily averages, although if the variable is a flux 
        (e.g. precipitation or radiation, (\code{var} = \code{"tp"}, \code{"rsds"} or \code{"rlds"} using the standard UDG naming),
         the aggregation function may be \code{"sum"} (i.e., it will return the daily accumulated value).
         In the same way, if the variable is a daily maximum/minimum (i.e., \code{var = "tasmax"} / \code{var = "tasmin"}), 
         the corresponding function (\code{aggr.d = "max"} or \code{aggr.d = "min"}) could be applied to the subdaily outputs
          on a daily basis to obtain absolute maximum/minimum daily values.
          }
}

\section{Geolocation parameters}{


 Regarding the selection of the spatial domain,
 it is possible to select the whole spatial domain of the dataset by defining the arguments \code{lonLim=NULL}
 and \code{latLim=NULL}. More often, rectangular domains are defined by the minimum and maximum coordinates
 in longitude and latitude (for instance \code{lonLim=c(-10,10)} and \code{latLim=c(35,45)} indicates a
 rectangular window centered in the Iberian Peninsula), and single grid-cell values
 (for instance \code{lonLim=-3.21} and \code{latLim=41.087} for retrieving the data in the closest grid
 point to the point coordinate -3.21E, 41.087N. In the last two cases, the function
 operates by finding the nearest (euclidean distance) grid-points to the coordinates introduced.
 
 In the case of station data (\code{\link{loadStationData}}), the logic is the same, taking into account that in the case
 of rectangular domains, all stations falling inside that window will be loaded. For single-point selections,
 the closest station will be chosen, and a note on-screen will inform about the distance from the selected point
 to the chosen station.
 
 In case of irregular grids (e.g. the typical RCM rotated pole projections), the regular coordinates are included in the
 \code{x} and \code{y} elements of the \code{xyCoords} list, while the corresponding geographical coordinates are insode two matrices inside 
 the \code{lon} and \code{lat} elements.
}

\section{Deaccumulation}{


In case of variables that are deaccumulated (e.g. precipitation amount and radiations in System4 models), 
it must be noted that the original forecast dates correspond to the start of each verification step.
 Thus, the first value is always zero, and then it starts accumulating. The deaccumulation routine computes a 
 lagged difference between forecast dates (R function \code{\link{diff}}) to provide the deaccumulated series. 
 Therefore, the first value is always lost. To avoid a systematic loss of the first day, when a deaccumulable
  variable is requested the function internally loads the previous time step (e.g., \code{season = c(12,1,2)}
  for daily precipitation, the forecast date 30-Nov is also loaded, being the first value of the series
   -1st December- the difference between 1 december and 30 november in the model). 
   As a result, in \code{leadMonth = 0} requests, the first day of the series is lost,
    because there is not a previous forecast time in the initialization to start deaccumulating.
}

\section{Definition of temporal slices}{


The function has been implemented to access seasonal slices, as determined by the \code{season} argument.
 Seasons can be defined in several ways: A single month (e.g. \code{season=1} for January, a standard season
  (e.g. \code{season=c(1,2,3)} for JFM, or \code{season=c(12,1,2)} for DJF), or any period of consecutive months
   (e.g. \code{season=c(1:6)}, for the first half of the year). Seasons are returned for a given year period
    (defined by the years argument, e.g. \code{years=1981:2000}) with a homogeneous forecast lead time 
    (as given by the leadMonth argument; e.g. \code{leadMonth=1} for one-month lead time) with respect to the first
   month of the selected season. For example, \code{season=c(1,2,3)} for \code{years=1995:2000} and \code{leadMonth=1}
   will return the following series: JFM 1995 from the December 1994 runtime forecast, ..., JFM 2000 from the 
   December 1999 runtime forecast.
   
   \strong{Year-crossing seasons}
    
   It is possible to work with year-crossing seasons, such as DJF. In this case, \code{season=c(12,1,2)}
    for \code{years=1995:2000} and \code{leadMonth=1} will return the following series: DJF 1994/1995 
    (from the November 1994 runtime forecast), ..., DJF 1999/2000 (from the November 1999 runtime forecast). 
   
   \strong{Full initialization length}
     
    In case the whole year/forecast extent is needed (instead of a particular season), the argument \code{season} can be omitted.
    In this case, its default value is \code{NULL}, equivalent to setting \code{season = 1:12}, or \code{season = 1:n}, 
    being \emph{n} the remaining number of forecast months since the given lead month in the case of seasonal forecasts
    . The same applies to the argument \code{years}, being all the available years returned when omitted.
    
  \strong{Initialization times}
  
  The characteristics of the \code{InitializationDates} output vary depending on the dataset. In the case of models that have simultaneous
   initializations for different members (e.g. System4), the output is just a vector of initialization times (one per year selected).
    Unlike the simultaneous initializations scheme, the lagged runtime configuration of members used by some other models (e.g. CFSv2)
   results in different initialization times for the same forecast times of different members. In this case, the \code{InitializationDates}
    are included in a list whose elements are named as the corresponding member.
}

\author{
J. Bedia
}
