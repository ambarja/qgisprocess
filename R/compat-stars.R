
#' Convert raster objects to/from QGIS inputs/outputs
#'
#' @param x A stars or stars_proxy object.
#' @inheritParams as_qgis_argument
#'
#' @export
#'
as_qgis_argument.stars <- function(x, spec = qgis_argument_spec(),
                                   use_json_input = FALSE) {
  as_qgis_argument_stars(x, spec, use_json_input)
}

#' @rdname as_qgis_argument.stars
#' @export
as_qgis_argument.stars_proxy <- function(x, spec = qgis_argument_spec(),
                                         use_json_input = FALSE) {
  as_qgis_argument_stars(x, spec, use_json_input)
}

as_qgis_argument_stars <- function(x, spec = qgis_argument_spec(), use_json_input = FALSE) {
  if (!isTRUE(spec$qgis_type %in% c("raster", "layer", "multilayer"))) {
    abort(glue("Can't convert '{ class(x)[1] }' object to QGIS type '{ spec$qgis_type }'"))
  }

  # try to use a filename if present
  if (inherits(x, "stars_proxy") && (length(x) == 1)) {
    file <- unclass(x)[[1]]
    file_ext <- stringr::str_to_lower(tools::file_ext(file))
    if (file_ext %in% c("grd", "asc", "sdat", "rst", "nc", "tif", "tiff", "gtiff", "envi", "bil", "img")) {
      return(file)
    }
  }

  path <- qgis_tmp_raster()
  stars::write_stars(x, path)
  structure(path, class = "qgis_tempfile_arg")
}

# dynamically registered in zzz.R
st_as_stars.qgis_outputRaster <- function(output, ...) {
  stars::read_stars(unclass(output), ...)
}

# dynamically registered in zzz.R
st_as_stars.qgis_outputLayer <- function(output, ...) {
  stars::read_stars(unclass(output), ...)
}

# dynamically registered in zzz.R
st_as_stars.qgis_result <- function(output, ...) {
  result <- qgis_result_single(output, c("qgis_outputRaster", "qgis_outputLayer"))
  stars::read_stars(unclass(result), ...)
}

