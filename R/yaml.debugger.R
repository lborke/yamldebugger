
#' Standard Quantlet keywords inherited from the older PHP based QuantNet.
#'
#' A character vector containing 594 standard Quantlet keywords.
#' Please use as many as possible of them to enable good text mining results for the D3 Visualization.
#'
#' @format A character vector with 594 keywords
#'
#' @source \url{http://quantlet.de/}
"allKeywords"


### STEP 1: initialize

#' YAML initialization function.
#'
#' @param RootPath current working directory with Qs for debugging
#'
#' @param show_keywords boolean trigger for showing / not showing the standard keywords
#'
#' @return The list with data needed in the further process.
#'
#' @examples
#' \dontrun{
#' d_init = yaml.debugger.init("c:/test", show_keywords = TRUE)
#' }
yaml.debugger.init = function(RootPath = "C:/r/test", show_keywords = FALSE) {
	# specify the path where your quantlets are stored
	allKeywords = tolower(allKeywords)
	if (show_keywords) { print(allKeywords) }

	res = list()
	res$RootPath = RootPath
	res$allKeywords = allKeywords

	return(res)
}


### STEP 2: load list of Q folders

#' Loads the list of Q folders. RootPath is required where the Qs are located.
#'
#' @param RootPath current working directory with Qs for debugging
#'
#' @param show_qnames boolean trigger for showing / not showing the found Q folder names in the folder RootPath
#'
#' @return The list with Q folder names needed in the further process.
#'
#' @examples
#' \dontrun{
#' qnames = yaml.debugger.get.qnames(d_init$RootPath)
#' }
yaml.debugger.get.qnames = function(RootPath, show_qnames = TRUE) {
	# define a pattern for the folder names containing quantlets
	# pattern_qfolders = "[:alpha:]+"
	# pattern_qfolders = "[^[:blank:]]" # no blank characters, i.e. space and tab.
	pattern_qfolders = "[^\b|\\.git]" # no empty strings

	listofQl = list.dirs(RootPath, full.names = FALSE, recursive = FALSE)
	# no empty strings and no .git folder
	listofQl = listofQl[grepl(pattern_qfolders, listofQl, ignore.case = TRUE)]

	# no blanks in folder names
	listofQl_ok = listofQl[!grepl("[[:blank:]]+", listofQl, ignore.case = TRUE)]
	# bad folders
	listofQl_bad = listofQl[grepl("[[:blank:]]+", listofQl, ignore.case = TRUE)]

	if (show_qnames) {
		print( paste(length(listofQl_ok), "Q folder(s) found:") )
		print(listofQl_ok)
	}

	if (length(listofQl_bad) > 0) {
		print( paste(length(listofQl_bad), "skipped Q folder(s) with blanks:") )
		print(listofQl_bad)
		print("The skipped Q folders need to be renamed! Otherwise no debugging is possible and no Style guide compliance!")
	}

	return(listofQl_ok)
}


### STEP 3: loop trough Q folders and extract YAML meta info

#' Main part of the YAML debugger. Loops trough the provided Q folders and extracts YAML meta info.
#' If errors occur, corresponding error handling is executed.
#'
#' @param qnames the list with Q folder names as provided by \code{yaml.debugger.get.qnames}
#'
#' @param init.obj as provided by \code{yaml.debugger.init}
#'
#' @return The summary data of the YAML debugger process. Possible YAML parser errors are also provided in this data structure
#'
#' @examples
#' \dontrun{
#' d_results = yaml.debugger.run(qnames, d_init)
#' }
yaml.debugger.run = function(qnames, init.obj) {
	n = length(qnames)
	# Initialize the lists for results
	Metainfos <- QCodes <- QNames_meta <- Desc_stats <- KeywordsOK <- KeywordsToReplace <- as.list(rep(NA, n))
	KeywordsOK_count <- KeywordsToReplace_count <- possible_pictures <- QDescription_words <- rep(0, n)
	q_code_exist <- rep(TRUE, n)
	wrong_quote_signs <- rep(FALSE, n)

	Qbadnames <- SG_probs <- Metainfo_dnames <- Q_found_software <- rep("", n)

	yaml_errors_v <- q_id_errors_v <- vector()

	wrong_quote_signs_regex_pattern = "^‚|^‘"

	sw_md_match = list("r" = "r", "m" = "matlab", "py" = "python", "sas" = "sas", "sh" = "shell")
	accepted_sw = names(sw_md_match)
	accepted_pict = c("png", "jpg")
	possible_pict = c("pdf")

	for (i in 1:n) {
		# current name of quantlet folder
		currentQfolder = qnames[i]
		print(paste(i, ": ", currentQfolder, sep = ""))

		qfolder = paste(init.obj$RootPath, currentQfolder, sep ="/")
		q_files = list.files(qfolder, recursive = FALSE)

		q_files_badnames = q_files[grepl("[[:blank:]]+", q_files, ignore.case = TRUE)]

		if (length(q_files_badnames) > 0) {
			print("This Q folder has at least one bad file name with blanks! All listed files must be renamed according to the Style guide.")
			print(q_files_badnames)
			#print("This Q will be excluded from the debugging process until all listed files are renamed according to the Style guide.")
			Qbadnames[i] = paste("bad Q file names!:", paste(q_files_badnames, collapse = ", "))
			#print("--------------------------------------------------------------------")
			#next
		}

		t_vec = vector()
		pic_vec = vector()
		poss_pic_vec = vector()
		found_software = vector()

		for (qlet in q_files) {

			f_ext = tolower(file_ext(qlet))
			if (f_ext %in% accepted_sw) {

				# clean file handling
				q_full_path = paste(qfolder, qlet, sep ="/")
				zz <- file(q_full_path, "r")
				q_str = readChar(zz, file.info(q_full_path)$size)
				close(zz)

				# add code file text to the vector
				t_vec[qlet] = q_str
				# count this appearance of R/Matlab/etc. code
				found_software = c(found_software, sw_md_match[[f_ext]])
			}
			if (f_ext %in% accepted_pict) {
				pic_vec = c(pic_vec, qlet)
			}
			if (f_ext %in% possible_pict) {
				poss_pic_vec = c(poss_pic_vec, qlet)
			}

			if( tolower(qlet) == "metainfo.txt" ){
				q_full_path = paste(qfolder, qlet, sep ="/")

				result = try( yaml_meta <- yaml.load_file(q_full_path), silent = FALSE )

				if (class(result) == "try-error") {
					print( paste("yaml parser error in: ", currentQfolder, sep = "") )
					yaml_errors_v = c(yaml_errors_v, result)
					q_id_errors_v = c(q_id_errors_v, i)
					Metainfos[[i]] = "parser error"
					QNames_meta[[i]] = "YAML error!"
				} else {
					# handle some trivial cases
					if (is.null(yaml_meta)) {yaml_meta = ""}
					Metainfos[[i]] = yaml_meta
					QNames_meta[[i]] = yaml.getQField(yaml_meta, "q")
					#Metainfo_dnames[i] = paste(names(yaml_meta), collapse = ", ")
					Metainfo_dnames[i] = paste(yaml.Qdfields.from.meta(yaml_meta)$found_dnames, collapse = ", ")

					sg_missingfields = vector()
					# check Qname I
					if (QNames_meta[[i]] == "") { sg_missingfields = c(sg_missingfields, "Name of Quantlet") }
					# check Published II
					if (yaml.getQField(yaml_meta, "p") == "") { sg_missingfields = c(sg_missingfields, "Published in") }
					# check Author III
					if (yaml.getQField(yaml_meta, "a") == "") { sg_missingfields = c(sg_missingfields, "Author") }

					# check Desc IV + stats
					QDescription = yaml.getQField(yaml_meta, "d")
					print(QDescription)
					if (QDescription == "") { sg_missingfields = c(sg_missingfields, "Description") }
					# replace "%" making sure that words after "%" are counted
					QDescription	= gsub("%", " ", QDescription)
					# replace "new lines" making sure that stri_stats_latex works
					QDescription	= gsub("\n", " ", QDescription)
					desc_stat		= stri_stats_latex(QDescription)
					Desc_stats[[i]]			= paste(desc_stat["Words"], " word(s), ", desc_stat["CharsWord"], " Character(s)", sep = "")
					QDescription_words[i]	= desc_stat["Words"]

					# check Keywords V
					QKeywords = yaml.getQField(yaml_meta, "k")
					if (QKeywords == "") { sg_missingfields = c(sg_missingfields, "Keywords") } else {
						# get all keywords from the current meta info file as array
						keywords = unlist(strsplit(QKeywords, ","))
						# standardize keywords
						keywords = str_trim(tolower(keywords))
						# which keywords are in the global kw list ?
						keywords_check = keywords %in% init.obj$allKeywords
						# store "good" kw's
						# KeywordsOK[[i]] = keywords[keywords_check]
						KeywordsOK[[i]] = paste(keywords[keywords_check], collapse = ", ")
						KeywordsOK_count[i] = length(keywords[keywords_check])
						# save the array of "bad" keywords for later improvement in KeywordsToReplace
						if(!all(keywords_check)) {
							bad_keywords = keywords[!keywords_check]
							bad_keywords_str = paste(bad_keywords, collapse = ", ")
							print(paste("new/unknown keywords: ", bad_keywords_str, sep = ""))
							KeywordsToReplace[[i]] = bad_keywords_str
							KeywordsToReplace_count[i] = length(keywords[!keywords_check])
						}
					}

					meta_df_text_v = c(QNames_meta[[i]], yaml.getQField(yaml_meta, "p"), yaml.getQField(yaml_meta, "a"), QDescription, QKeywords,
									   yaml.getQField(yaml_meta, "df"), yaml.getQField(yaml_meta, "e"), yaml.getQField(yaml_meta, "i"),
									   yaml.getQField(yaml_meta, "o"), yaml.getQField(yaml_meta, "s"), yaml.getQField(yaml_meta, "sa"))
					wrong_quote_signs[i] = any(grepl(wrong_quote_signs_regex_pattern, meta_df_text_v))
					if (wrong_quote_signs[i]) { print(paste("Wrong quote signs:", wrong_quote_signs[i])) }

					SG_probs[i] = paste(sg_missingfields, collapse = ", ")
				}
			}
		}

		found_software = unique(found_software)
		print(paste("Found_software: ", paste(found_software, collapse = ", ")))
		print(paste("Number of code files: ", length(t_vec), " - ", paste(names(t_vec), collapse = ", ")) )
		print(paste("Number of pictures: ", length(pic_vec), " - ", paste(pic_vec, collapse = ", ")) )
		if ( length(poss_pic_vec) > 0 ) {
			print(paste("Number of possible pictures: ", length(poss_pic_vec), " - ", paste(poss_pic_vec, collapse = ", ")) )
			possible_pictures[i] = length(poss_pic_vec)
		}

		Q_found_software[i] = paste(found_software, collapse = ", ")

		codename = tolower(QNames_meta[[i]])
		fnames = tolower(file_path_sans_ext(names(t_vec)))
		code_Q = t_vec[which(fnames == codename)]
		if (length(code_Q) == 0) {
			q_code_exist[i] = FALSE
			print("No Quantlet CODE found !!!")
		} else { QCodes[[i]] = code_Q }
		# delimiter for text output
		print("--------------------------------------------------------------------")
	}

	meta_names  = unlist(sapply( Metainfos, function(y){ names(y) } ))
	meta_names_distribution = sort(table(meta_names), decreasing = T)

	res = list()
	res$Metainfos 				= Metainfos
	res$meta_names_distribution	= meta_names_distribution
	res$QNames_meta 			= QNames_meta
	res$QCodes 					= QCodes
	res$Metainfo_dnames			= Metainfo_dnames
	res$Desc_stats				= Desc_stats
	res$SG_probs				= SG_probs
	res$KeywordsOK 				= KeywordsOK
	res$KeywordsOK_count 		= KeywordsOK_count
	res$KeywordsToReplace 		= KeywordsToReplace
	res$KeywordsToReplace_count = KeywordsToReplace_count
	res$yaml_errors_v 			= yaml_errors_v
	res$q_id_errors_v 			= q_id_errors_v
	res$q_code_exist 			= q_code_exist
	res$wrong_quote_signs 		= wrong_quote_signs
	res$possible_pictures 		= possible_pictures
	res$Qbadnames 				= Qbadnames
	res$QDescription_words		= QDescription_words
	res$Q_found_software		= Q_found_software

	return(res)
}


### STEP 4: Overview of parser results

#' Overview of the parser results. If errors occured, the corresponding Q folder names and YAML errors are displayed.
#'
#' @param qfolders the list with Q folder names as provided by \code{yaml.debugger.get.qnames}
#'
#' @param results as provided by \code{yaml.debugger.run}
#'
#' @param showErrors boolean trigger for showing / not showing the parser errors
#'
#' @param showOverView boolean trigger for showing / not showing the total \code{Overview}
#'
#' @param summaryType [mini/compact/full] controls the details and extent of the \code{Overview} output
#'
#' @return The summary overview as data frame for further inspection
#'
#' @examples
#' \dontrun{
#' OverView = yaml.debugger.summary(qfolders, d_results, summaryType = "mini")
#' }
yaml.debugger.summary = function(qfolders, results, showErrors = TRUE, showOverView = TRUE, summaryType = "full") {
	if (showErrors && length(results$q_id_errors_v) > 0) {
		for (i in 1:length(results$q_id_errors_v)) {
			print(qfolders[results$q_id_errors_v[i]])
			print(results$yaml_errors_v[i])
			print("--------------------------------------------------------------------")
		}
	}

	n = length(qfolders)
	#Qfolders 	 = as.vector(qfolders)
	YAML_Ranking = rep("A", n)

	Keywords_count		= results$KeywordsOK_count
	newKeywords_count	= results$KeywordsToReplace_count
	# additional calculation of statistics
	kw_total  = Keywords_count + newKeywords_count
	kw_stats  = paste(kw_total, ": ", Keywords_count, " (standard), ", newKeywords_count, " (new)", sep ="")

	YAML_Ranking[kw_total < 5] = "B"
	YAML_Ranking[results$QDescription_words < 10] = "B"

	PossPicts					= results$possible_pictures
	YAML_Ranking[PossPicts > 0]	= "B"
	PossPicts[PossPicts == 0]	= ""
	PossPicts[PossPicts > 0]	= "If PDF is a picture PNG or JPG required!"

	QExist 							= results$q_code_exist
	YAML_Ranking[QExist == FALSE]	= "C"
	QExist[QExist == TRUE]			= "ok"
	QExist[QExist == FALSE]			= "NOT FOUND"

	WrongSigns						= results$wrong_quote_signs
	YAML_Ranking[WrongSigns == TRUE]= "C"
	WrongSigns[WrongSigns == TRUE]	= "Wrong quotes!"
	WrongSigns[WrongSigns == FALSE]	= ""

	Q_Bad_names	= results$Qbadnames
	YAML_Ranking[Q_Bad_names != ""]	= "C"

	SG_probs					= results$SG_probs
	YAML_Ranking[SG_probs != ""]= "C"

	Qnames 						= as.vector(results$QNames_meta)
	YAML_Ranking[is.na(Qnames)]				= "N"
	YAML_Ranking[Qnames == "YAML error!"]	= "D"
	Qnames[is.na(Qnames)]		= "No metainfo found!"
	Qnames						= as.character(Qnames)

	Meta_DNames		 = results$Metainfo_dnames
	Q_found_software = results$Q_found_software

	Desc_stats	= as.character(as.vector(results$Desc_stats))
	Keywords	= as.character(as.vector(results$KeywordsOK))
	newKeywords	= as.character(as.vector(results$KeywordsToReplace))

	# create OverView of metainfos and errors retrieved by the yaml parser
	if (summaryType == "mini") {
		OverView = data.frame(YAML_Ranking, qfolders, Qnames, Desc_stats, kw_stats)
		OverViewLabels = c("Q-Quali", "Q folders", "Q Names", "Descriptions stats", "Keywords stats")
	} else if (summaryType == "compact") {
		OverView = data.frame(YAML_Ranking, qfolders, Qnames, Desc_stats, kw_stats, Q_found_software, Meta_DNames)
		OverViewLabels = c("Q-Quali", "Q folders", "Q Names", "Descriptions stats", "Keywords stats", "Found SW", "Meta Info data fields")
	} else {
		OverView = data.frame(YAML_Ranking, qfolders, Qnames, Desc_stats, kw_stats, Meta_DNames, Keywords, newKeywords)
		OverViewLabels = c("Q-Quali", "Q folders", "Q Names", "Descriptions stats", "Keywords stats", "Meta Info data fields", "Keywords", "new Keywords")
	}

	if (length(QExist[QExist == "NOT FOUND"]) > 0) {
		OverView = cbind(OverView, QExist)
		OverViewLabels = c(OverViewLabels, "Q Code")
	}
	if (length(SG_probs[SG_probs != ""]) > 0) {
		OverView = cbind(OverView, SG_probs)
		OverViewLabels = c(OverViewLabels, "Missing Style Guide fields")
	}
	if (length(WrongSigns[WrongSigns != ""]) > 0) {
		OverView = cbind(OverView, WrongSigns)
		OverViewLabels = c(OverViewLabels, "Quote signs")
	}
	if (length(Q_Bad_names[Q_Bad_names != ""]) > 0) {
		OverView = cbind(OverView, Q_Bad_names)
		OverViewLabels = c(OverViewLabels, "Bad file names")
	}
	if (length(PossPicts[PossPicts != ""]) > 0) {
		OverView = cbind(OverView, PossPicts)
		OverViewLabels = c(OverViewLabels, "PDF files")
	}

	names(OverView) = OverViewLabels

	if (showOverView) { View(OverView) }

	return(OverView)
}
