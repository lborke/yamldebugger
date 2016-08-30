
#' YAML initialization function.
#'
#' @param RootPath current working directory with Qs for debugging
#'
#' @param show_keywords boolean trigger for showing / not showing the standard keywords
#'
#' @return the list with data needed in the further process.
#'
#' @examples
#' d_init = yaml.debugger.init("c:/test", show_keywords = TRUE)
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


#' Load list of Q folders. RootPath is required where the Qs are located.
#'
#' @param RootPath current working directory with Qs for debugging
#'
#' @param show_qnames boolean trigger for showing / not showing the found Q names in the folder RootPath
#'
#' @return the list with Q names needed in the further process.
#'
#' @examples
#' qnames = yaml.debugger.get.qnames(d_init$RootPath)
yaml.debugger.get.qnames = function(RootPath, show_qnames = TRUE) {

  sProject = "[^\b]" # no empty strings

  listofQl = list.dirs(RootPath, full.names = FALSE)
  listofQl = listofQl[grepl(sProject, listofQl, ignore.case = TRUE)]

  if (show_qnames) {
    print( paste(length(listofQl), "Q folder(s) found:") )
    print(listofQl)
  }

  return(listofQl)
}

