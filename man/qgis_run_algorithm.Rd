% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/qgis-run-algorithm.R
\name{qgis_run_algorithm}
\alias{qgis_run_algorithm}
\title{Run algorithms using 'qgis_process'}
\usage{
qgis_run_algorithm(
  algorithm,
  ...,
  PROJECT_PATH = NULL,
  ELLIPSOID = NULL,
  .raw_json_input = NULL,
  .quiet = FALSE
)
}
\arguments{
\item{algorithm}{A qualified algorithm name (e.g., "native:filedownloader") or
a path to a QGIS model file.}

\item{...}{Named key-value pairs as arguments for each algorithm. Features of
\code{\link[rlang:list2]{rlang::list2()}} are supported. These arguments
are converted to strings using \code{\link[=as_qgis_argument]{as_qgis_argument()}}.}

\item{PROJECT_PATH, ELLIPSOID}{Global values for QGIS project file and
ellipsoid name for distance calculations.}

\item{.raw_json_input}{The raw JSON to use as input in place of \code{...}.}

\item{.quiet}{Use \code{TRUE} to suppress output from processing algorithms.}
}
\description{
Run QGIS algorithms.
See the \href{https://docs.qgis.org/testing/en/docs/user_manual/processing_algs/qgis/index.html}{QGIS docs}
for a detailed description of the algorithms provided
'out of the box' on QGIS (versions >= 3.14).
}
\examples{
if (has_qgis()) {
  qgis_run_algorithm(
    "native:buffer",
    INPUT = system.file("longlake/longlake_depth.gpkg", package = "qgisprocess"),
    DISTANCE = 10
  )
}

}
