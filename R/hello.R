# Hello, world!
#
# This is an example function named 'hello'
# which prints 'Hello, world!'.
#
# You can learn more about package authoring with RStudio at:
#
#   http://r-pkgs.had.co.nz/
#
# Some useful keyboard shortcuts for package authoring:
#
#   Build and Reload Package:  'Ctrl + Shift + B'
#   Check Package:             'Ctrl + Shift + E'
#   Test Package:              'Ctrl + Shift + T'


#' Hello world function.
#'
#' @return Output "Hello, world!".
#' @examples
#' hello()
#' @export
hello <- function() {
  print("Hello, world!")
}

#' Another testfunction.
#'
#' @return Output "test2".
#' @examples
#' testfunction()
#' @export
testfunction <- function() {
  print("test2")
}


#' YAML initialization function.
#'
#' @param current working directory with Qs for debugging
#'
#' @param boolean trigger for showing / not showing the standard keywords
#'
#' @return list with data needed in the further process.
#'
#' @examples
#' d_init = yaml.debugger.init("c:/test", show_keywords = TRUE)
#'
#' @export
yaml.debugger.init = function(RootPath = "C:/r/test", show_keywords = FALSE) {
  # specify the path where your quantlets are stored

  allKeywords = tolower(allKeywords)

  if (show_keywords) {
    print(allKeywords)
  }

  res = list()
  res$RootPath = RootPath
  res$allKeywords = allKeywords

  return(res)
}

