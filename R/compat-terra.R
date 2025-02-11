
#' Convert terra objects to/from QGIS inputs/outputs
#'
#' @param x A [terra::rast()].
#' @param output The result from [qgis_run_algorithm()] or [qgis_output()].
#' @param ... Passed to [terra::rast()].
#' @inheritParams as_qgis_argument
#'
#' @export
#'
as_qgis_argument.SpatRaster <- function(x, spec = qgis_argument_spec(),
                                        use_json_input = FALSE) {
  as_qgis_argument_terra(x, spec)
}

as_qgis_argument_terra <- function(x, spec = qgis_argument_spec(),
                                   use_json_input = FALSE) {
  if (!isTRUE(spec$qgis_type %in% c("raster", "layer", "multilayer"))) {
    abort(glue("Can't convert '{ class(x)[1] }' object to QGIS type '{ spec$qgis_type }'"))
  }

  # try to use a filename if present (behaviour changed around terra 1.5.12)
  sources <- terra::sources(x)
  if (!is.character(sources)) {
    sources <- sources$source
  }

  if (!identical(sources, "") && length(sources) == 1) {
    file_ext <- stringr::str_to_lower(tools::file_ext(sources))
    if (file_ext %in% c("grd", "asc", "sdat", "rst", "nc", "tif", "tiff", "gtiff", "envi", "bil", "img")) {
      return(sources)
    }
  }

  path <- qgis_tmp_raster()
  terra::writeRaster(x, path)
  structure(path, class = "qgis_tempfile_arg")
}

#' @rdname as_qgis_argument.SpatRaster
#' @export
qgis_as_terra <- function(output, ...) {
  UseMethod("qgis_as_terra")
}

#' @rdname as_qgis_argument.SpatRaster
#' @export
qgis_as_terra.qgis_outputRaster <- function(output, ...) {
  terra::rast(unclass(output), ...)
}

#' @rdname as_qgis_argument.SpatRaster
#' @export
qgis_as_terra.qgis_outputLayer <- function(output, ...) {
  terra::rast(unclass(output), ...)
}

#' @rdname as_qgis_argument.SpatRaster
#' @export
qgis_as_terra.qgis_result <- function(output, ...) {
  result <- qgis_result_single(output, c("qgis_outputRaster", "qgis_outputLayer"))
  terra::rast(unclass(result), ...)
}

#' @export
as_qgis_argument.SpatExtent <- function(x, spec = qgis_argument_spec(),
                                        use_json_input = FALSE) {
  if (!isTRUE(spec$qgis_type %in% c("extent"))) {
    abort(glue("Can't convert 'SpatExtent' object to QGIS type '{ spec$qgis_type }'"))
  }

  ex <- as.vector(terra::ext(x))

  glue("{ex[['xmin']]},{ex[['xmax']]},{ex[['ymin']]},{ex[['ymax']]}")
}
