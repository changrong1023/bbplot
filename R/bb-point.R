##' layer
##'
##' bbplot layers
##' @title layer
##' @rdname layer
##' @param mapping aesthetic mapping
##' @param data layer data
##' @param position one of 'identity' or 'jitter'
##' @param ... addition parameter for the layer
##' @return A modified bbplot object
##' @importFrom graphics points
##' @export
##' @author Guangchuang Yu
bb_point <- function(mapping = NULL, data = NULL, position = "identity", ...) {
    structure(list(mapping = mapping,
                   data = data,
                   position = position,
                   params = list(...),
                   layer = ly_point
                   ),
              class = "bb_layer")
}

ly_point <- function(plot, mapping = NULL, data = NULL, position = "identity", ...) {
    position <- match.arg(position, c("identity", "jitter"))

    data <- bb_data(plot, data)
    mapping <- bb_mapping(plot, mapping)

    x <- data[[xvar(mapping)]]
    y <- data[[yvar(mapping)]]

    if (position == "jitter") {
        x <- jitter(x)
        y <- jitter(y)
    }

    params <- list(...)
    params <- modifyList(params, list(x = x, y = y))

    if (!is.null(mapping$col)) {
        col_vec <- bb_col(mapping, data)
        params <- modifyList(params, list(col = col_vec))
    }

    ly <- function() do.call(points, params)
    add_layer(plot, ly, "point layer")
}

##' @method bbplot_add bb_layer
##' @export
bbplot_add.bb_layer <- function(object, plot) {
    ly <- object$layer
    params <- c(object, unlist(object$params))
    params <- params[names(params) != 'params']
    params <- params[names(params) != 'layer']
    params$plot <- plot

    do.call(ly, params)
}

