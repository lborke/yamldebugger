
#' YAML postprocessing allowing fault tolerance.
#'
#' @param yaml_dset YAML data object
#'
#' @return the content of the data field which corresponds to the "Quantlet name"
yaml.getQName = function(yaml_dset) {
  accepted.fieldnames = c("name of quantlet", "nameofquantlet", "name_of_quantlet", "quantletname")

  names(yaml_dset) = tolower(names(yaml_dset))
  qname = ""

  for (dname in names(yaml_dset) ) {
    if (dname %in% accepted.fieldnames) {
      qname = yaml_dset[[dname]]
      return(qname)
    }
  }

  return(qname)
}


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


#' Loads the list of Q folders. RootPath is required where the Qs are located.
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


#' Main part of the YAML debugger. Loops trough the provided Q folders and extracts YAML meta info.
#' If errors occur, corresponding error handling is executed.
#'
#' @param qnames the list with Q names as provided by 'yaml.debugger.get.qnames'
#'
#' @param init.obj as provided by 'yaml.debugger.init'
#'
#' @return the summary data of the YAML debugger process. Possible YAML parser errors are also provided in this data structure
#'
#' @examples
#' d_results = yaml.debugger.run(qnames, d_init)
yaml.debugger.run = function(qnames, init.obj) {
  n = length(qnames)
  # Initialize the lists for results
  Metainfos <- Metainfo_dnames <- SG_probs <- QNames_meta <- Desc_stats <- KeywordsOK <- KeywordsOK_count <- KeywordsToReplace <- KeywordsToReplace_count <- as.list(rep(NA, n))
  yaml_errors_v <- q_id_errors_v <- vector()

  for (i in 1:n) {
    # current name of quantlet
    currentQuantlet = qnames[i]
    print(paste(i, ": ", currentQuantlet, sep = ""))
    # set working directory
    setwd(paste(init.obj$RootPath, currentQuantlet, sep ="/"))

    if(file.exists("Metainfo.txt")){
      # clean file handling
      zz <- file("Metainfo.txt", "r")
      Meta = readChar(zz, file.info("Metainfo.txt")$size)
      close(zz)

      result = try( yaml_meta <- yaml.load(Meta), silent = FALSE )

      if (class(result) == "try-error") {
        print( paste("yaml parser error in: ", currentQuantlet, sep = "") )
        yaml_errors_v = c(yaml_errors_v, result)
        q_id_errors_v = c(q_id_errors_v, i)
        Metainfos[[i]] = "parser error"
      } else {
        Metainfos[[i]] = yaml_meta
        QNames_meta[[i]] = yaml.getQName(yaml_meta)
        Metainfo_dnames[[i]] = paste(names(yaml_meta), collapse = ", ")

        desc_stat = stri_stats_latex(yaml_meta$Description)
        desc_stat_str = paste(desc_stat["Words"], " word(s), ", desc_stat["CharsWord"], " Character(s)", sep = "")
        Desc_stats[[i]] = desc_stat_str

        sg_missingfields = vector()
        if (QNames_meta[[i]] == "") { sg_missingfields = c(sg_missingfields, "qname") }
        sg_fields = c("Published in", "Description", "Keywords", "Author")
        sg_fields_check = sg_fields %in% names(yaml_meta)
        sg_missingfields = c(sg_missingfields, sg_fields[!sg_fields_check])
        SG_probs[[i]] = paste(sg_missingfields, collapse = ", ")

        # KW check
        if ("Keywords" %in% names(yaml_meta)) {
          # get all keywords from the current meta info file as array
          keywords = unlist(strsplit(yaml_meta$Keywords, ","))
          # standardize keywords
          keywords = str_trim(tolower(keywords))
          # which keywords are in the global kw list ?
          keywords_check = keywords %in% init.obj$allKeywords
          # store "good" kw's
          KeywordsOK[[i]] = paste(keywords[keywords_check], collapse = ", ")
          KeywordsOK_count[[i]] = length(keywords[keywords_check])
          # save the array of "bad" keywords for later improvement in KeywordsToReplace
          if(!all(keywords_check)) {
            bad_keywords = keywords[!keywords_check]
            bad_keywords_str = paste(bad_keywords, collapse = ", ")
            print(paste("new/bad keywords: ", bad_keywords_str, sep = ""))
            KeywordsToReplace[[i]] = bad_keywords_str
            KeywordsToReplace_count[[i]] = length(keywords[!keywords_check])
          }
        }
      }
    }
    # delimiter for text output
    print("--------------------------------------------------------------------")
  }

  # release the q-folder-connection
  setwd(init.obj$RootPath)

  res = list()
  res$Metainfos 				= Metainfos
  res$QNames_meta 			= QNames_meta
  res$Metainfo_dnames			= Metainfo_dnames
  res$Desc_stats				= Desc_stats
  res$SG_probs				= SG_probs
  res$KeywordsOK 				= KeywordsOK
  res$KeywordsOK_count 		= KeywordsOK_count
  res$KeywordsToReplace 		= KeywordsToReplace
  res$KeywordsToReplace_count = KeywordsToReplace_count
  res$yaml_errors_v 			= yaml_errors_v
  res$q_id_errors_v 			= q_id_errors_v

  return(res)
}


#' Overview of the parser results. If errors occured, the corresponding Q names and YAML errors are displayed.
#'
#' @param qnames the list with Q names as provided by 'yaml.debugger.get.qnames'
#'
#' @param results as provided by 'yaml.debugger.run'
#'
#' @param showErrors boolean trigger for showing / not showing the parser errors
#'
#' @param showOverView boolean trigger for showing / not showing the total Overview
#'
#' @param summaryType [mini/compact/full] controls the details and extent of the Overview output
#'
#' @return the summary overview in matrix form for further inspection
#'
#' @examples
#' OverView = yaml.debugger.summary(qnames, d_results, summaryType = "mini")
yaml.debugger.summary = function(qnames, results, showErrors = TRUE, showOverView = TRUE, summaryType = "full") {
  if (showErrors && length(results$q_id_errors_v) > 0) {
    for (i in 1:length(results$q_id_errors_v)) {
      print(qnames[results$q_id_errors_v[i]])
      print(results$yaml_errors_v[i])
      print("--------------------------------------------------------------------")
    }
  }

  # additional calculation of statistics
  kw_total  = unlist(results$KeywordsOK_count) + unlist(results$KeywordsToReplace_count)
  kw_stats  = paste(kw_total, ": ", unlist(results$KeywordsOK_count), " (standard), ", unlist(results$KeywordsToReplace_count), " (new)", sep ="")

  # display metainfos and names of quantlets
  Qnames 		= as.matrix(results$QNames_meta)
  Metas 		= as.matrix(results$Metainfo_dnames)
  Desc_stats	      = as.matrix(results$Desc_stats)
  Keywords	        = as.matrix(results$KeywordsOK)
  Keywords_count	  = as.matrix(results$KeywordsOK_count)
  newKeywords		  	= as.matrix(results$KeywordsToReplace)
  newKeywords_count	= as.matrix(results$KeywordsToReplace_count)
  SQ_probs			    = as.matrix(results$SG_probs)

  # create OverView of metainfos and errors parsed by yaml parser
  if (summaryType == "compact") {
    OverView = cbind(Qnames, SQ_probs, Desc_stats, kw_stats, Metas)
    OverViewLabels = c("Q Names", "Missing Style Guide fields", "Descriptions stats", "Keywords stats", "Meta Info data fields")
  } else if (summaryType == "mini") {
    OverView = cbind(Qnames, SQ_probs, Desc_stats, kw_stats)
    OverViewLabels = c("Q Names", "Missing Style Guide fields", "Descriptions stats", "Keywords stats")
  } else {
    OverView = cbind(Qnames, Metas, SQ_probs, Desc_stats, kw_stats,
                     Keywords, Keywords_count, newKeywords, newKeywords_count, kw_total)
    OverViewLabels = c("Q Names", "Meta Info data fields", "Missing Style Guide fields", "Descriptions stats", "Keywords stats",
                       "Keywords", "Nr. of KW's", "new Keywords", "Nr. of new KW's", "total Nr. of KW's")
  }
  colnames(OverView) = OverViewLabels

  if (showOverView) { View(OverView) }

  return(OverView)
}
