% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/qgis-algorithm.R
\name{qgis_has_algorithm}
\alias{qgis_has_algorithm}
\alias{qgis_algorithms}
\alias{qgis_has_provider}
\alias{qgis_providers}
\alias{assert_qgis_algorithm}
\title{Run algorithms using 'qgis_process'}
\usage{
qgis_has_algorithm(algorithm)

qgis_algorithms(query = FALSE, quiet = TRUE)

qgis_has_provider(provider, query = FALSE, quiet = TRUE)

qgis_providers(provider)

assert_qgis_algorithm(algorithm)
}
\arguments{
\item{algorithm}{A qualified algorithm name (e.g., "native:filedownloader") or
a path to a QGIS model file.}

\item{query}{Use \code{TRUE} to refresh the cached value.}

\item{quiet}{Use \code{TRUE} to suppress output from processing algorithms.}

\item{provider}{A provider identifier (e.g., "native")}
}
\description{
Run QGIS algorithms.
See the \href{https://docs.qgis.org/testing/en/docs/user_manual/processing_algs/qgis/index.html}{QGIS docs}
for a detailed description of the algorithms provided
'out of the box' on QGIS (versions >= 3.14).
}
\examples{
if (has_qgis()) qgis_has_algorithm("native:filedownloader")
if (has_qgis()) qgis_algorithms()
if (has_qgis()) qgis_has_provider("native")
if (has_qgis()) qgis_providers()

}
