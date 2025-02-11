input <-
  if (has_qgis()) {
    if (qgis_use_json_input()) " (using JSON input)" else " (NOT using JSON input)"
  } else ""

test_that(glue("qgis_run_algorithm() works{input}"), {
  skip_if_not(has_qgis())

  tmp_gpkg <- qgis_tmp_vector(".gpkg")

  result <- expect_output(
    qgis_run_algorithm(
      "native:reprojectlayer",
      INPUT = system.file("longlake/longlake.gpkg", package = "qgisprocess"),
      TARGET_CRS = "EPSG:4326",
      OUTPUT = tmp_gpkg,
      .quiet = FALSE
    ),
    "Running\\s+"
  )
  expect_true(file.exists(tmp_gpkg))

  unlink(tmp_gpkg)

  result <- expect_output(
    qgis_run_algorithm(
      "native:reprojectlayer",
      INPUT = system.file("longlake/longlake.gpkg", package = "qgisprocess"),
      TARGET_CRS = "EPSG:4326",
      OUTPUT = tmp_gpkg,
      .quiet = TRUE
    ),
    NA
  )
  expect_true(file.exists(tmp_gpkg))
  unlink(tmp_gpkg)
})

test_that(glue("qgis_run_algorithm() ignores unknown inputs{input}"), {
  skip_if_not(has_qgis())

  expect_message(
    qgis_run_algorithm(
      "native:buffer",
      NOT_AN_INPUT = "some value",
      INPUT = system.file("longlake/longlake.gpkg", package = "qgisprocess"),
      DISTANCE = 100,
      .quiet = TRUE
    ),
    "Ignoring unknown input"
  )
})

test_that(glue("qgis_run_algorithm accepts multiple input arguments{input}"), {
  skip_if_not(has_qgis())
  skip_if_not_installed("sf")

  v_1 <- sf::read_sf(system.file("longlake/longlake.gpkg", package = "qgisprocess"))
  v_2 <- v_3 <- v_1
  v_2$geom = v_2$geom + 1000
  sf::st_crs(v_2) <- sf::st_crs(v_1)
  v_3$geom <- v_3$geom - 1000
  sf::st_crs(v_3) <- sf::st_crs(v_1)
  out <- qgis_run_algorithm(
    "native:mergevectorlayers",
    LAYERS = v_1, LAYERS = v_2, LAYERS = v_3,
    .quiet = TRUE
  )
  tmp <- sf::read_sf(qgis_output(out, "OUTPUT"))
  expect_equal(nrow(tmp), 3)
})

test_that(glue("qgis_run_algorithm runs with qgis:relief, for which the acceptable value of COLORS is NULL{input}"), {
  skip_if_not(has_qgis())

  relief_args <- qgis_arguments("qgis:relief")
  expect_identical(relief_args["COLORS", ]$acceptable_values, list(NULL))

  capture.output({
    result <- qgis_run_algorithm(
      "qgis:relief",
      INPUT=system.file("longlake/longlake_depth.tif", package = "qgisprocess"),
      Z_FACTOR=1,
      AUTO_COLORS=FALSE,
      COLORS="-0.5, 0, 170, 0, 0; 0, 0.5, 85, 255, 255; 0.5, 1, 0, 255, 0; 1, 2.5, 85, 85, 255"
    )
  })

  expect_s3_class(result$OUTPUT, "qgis_outputRaster")
  expect_s3_class(result$FREQUENCY_DISTRIBUTION, "qgis_outputFile")
  expect_true(file.exists(result$OUTPUT))
  expect_true(file.exists(result$FREQUENCY_DISTRIBUTION))

})


test_that(glue("qgis_run_algorithm succeeds when it needs a QGIS project{input}"), {
  skip_if_not(has_qgis())
  # Until Issue #68 is resolved (native:printlayouttopdf segfaults on MacOS):
  skip_on_os("mac")
  # QGIS 3.28.2 (and a series of QGIS 3.29 builds) always segfault
  # see https://github.com/qgis/QGIS/issues/51383
  qversion <- qgis_version()
  skip_if(
    stringr::str_detect(qversion, "^3\\.28\\.2-"),
    paste(
      "QGIS version",
      qversion,
      "is reported to segfault with 'native:printlayouttopdf'."
    )
  )

  tmp_pdf <- qgis_tmp_file(".pdf")

  capture.output({
    result <- qgis_run_algorithm(
      "native:printlayouttopdf",
      LAYOUT = "Layout 1",
      OUTPUT = tmp_pdf,
      PROJECT_PATH = system.file("extdata/longlake.qgs", package = "qgisprocess")
    )
  })

  expect_true(file.exists(tmp_pdf))
  expect_identical(tmp_pdf, as.character(result$OUTPUT))
  unlink(tmp_pdf)
})
