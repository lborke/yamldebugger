
#' YAML data field matching list. Used by \code{yaml.getQField}, \code{yaml.not.Qdfields}, \code{yaml.Qdfields.from.meta} and \code{yaml.Qdfields.nchar.from.meta}.
Q_dfield_list = list(
	# Style guide data fields : required
	"q" = c("quantletname", "qname", "nameofquantlet", "name_of_quantlet"),
	"p" = c("publishedin", "published"),
	"a" = c("author", "authors", "author[new]", "author[r]", "author[matlab]", "author[m]", "author[sas]"),
	"d" = c("description", "descriptions"),
	"k" = c("keywords", "keyword", "keywords[new]", "keyword[new]"),
	# Style guide data fields : optional
	"df"= c("datafile", "datafiles", "datafile[matlab]", "datafiles[matlab]", "datafile[r]", "datafile[m]", "datafile[example]"),
	"e" = c("example", "examples", "example[matlab]"),
	"i" = c("input", "inputs", "input[matlab]"),
	"o" = c("output", "outputs", "output[matlab]"),
	"s" = c("submitted", "submittedby", "submitted[r]", "submitted[matlab]", "submitted[sas]", "submitted[python]"),
	"sa"= c("seealso", "see", "seealso[matlab]"),
	# free data fields
	"ce" = c("codeeditor", "codeeditors"),
	"cp" = c("codeproblem", "codeproblems", "codeproblems[r]", "codeproblems[matlab]"),
	"cw" = c("codewarning", "codewarnings"),
	"od" = c("outdated"),
	"sf" = c("subfunction", "subfunctions"),
	"u"  = c("usage")
)

#' Extracts the desired data field from the parsed YAML object.
#'
#' \code{Q_dfield_list} is the list defining the data field shortcuts and the corresponding full name variations.
#'
#' @param yaml_dset parsed YAML object as a structured list
#'
#' @param field_name shortcut for the desired data field for extraction as defined in \code{Q_dfield_list}
#'
#' @return A collapsed character vector containing all text values of the corresponding full name variations of
#' the given data field shortcut.
#'
#' @examples
#' \dontrun{
#' yaml.getQField(yaml_meta, "q")
#' }
yaml.getQField = function(yaml_dset, field_name) {
	accepted.fieldnames = Q_dfield_list[[field_name]]

	names(yaml_dset) = tolower(str_replace_all(names(yaml_dset), "[[:space:]]", ""))
	aname = vector()

	for (dname in names(yaml_dset)) {
		if (dname %in% accepted.fieldnames) {
			aname = c(aname, yaml_dset[[dname]])
		}
	}

	return(paste(aname, collapse = ", "))
}


#' Shows the YAML data fields (of a parsed repository with Quantlet folders) which are not captured by \code{Q_dfield_list} so far.
#'
#' \code{Q_dfield_list} is the list defining the data field shortcuts and the corresponding full name variations.
#'
#' @param meta_names_distribution table of disjoint YAML data fields which were extracted by \code{yaml.debugger.run} from the
#' given repository with Quantlet folders
#'
#' @return A character vector with YAML data fields which are not captured by \code{Q_dfield_list} so far.
#'
#' @examples
#' \dontrun{
#' d_results = yaml.debugger.run(qnames, d_init)
#' yaml.not.Qdfields(d_results$meta_names_distribution)
#' }
yaml.not.Qdfields = function(meta_names_distribution) {
	dfield_dist_repo = as.vector(names(meta_names_distribution))
	dfield_dist_repo_clean = tolower(str_replace_all(dfield_dist_repo, "[[:space:]]", ""))
	res = dfield_dist_repo_clean[!(dfield_dist_repo_clean %in% unlist(Q_dfield_list))]
	return(res)
}


#' Extracts unique and disjoint YAML data field shortcuts as defined in \code{Q_dfield_list} for a given parsed YAML object.
#'
#' \code{Q_dfield_list} is the list defining the data field shortcuts and the corresponding full name variations.
#' Additionally, \code{yaml.Qdfields.from.meta} returns a vector of all YAML data fields for the given \code{yaml_meta} which
#' are not captured by \code{Q_dfield_list} so far.
#'
#' @param yaml_meta parsed YAML object as a structured list
#'
#' @return A list containing \code{found_dnames}, disjoint YAML data field shortcuts found in \code{yaml_meta},
#' and \code{new_dnames}, a vector of all YAML data fields for the given \code{yaml_meta} which
#' are not captured by \code{Q_dfield_list} so far.
#'
#' @examples
#' \dontrun{
#' d_results = yaml.debugger.run(qnames, d_init)
#' d_names  = unlist(sapply( d_results$Metainfos, function(yaml){ yaml.Qdfields.from.meta(yaml)$found_dnames } ))
#' ( d_names_distr = sort(table(d_names), decreasing = T) )
#' }
yaml.Qdfields.from.meta = function(yaml_meta) {
	meta_names_clean = tolower(str_replace_all(names(yaml_meta), "[[:space:]]", ""))
	found_dnames = vector()
	new_dnames = vector()

	for (dname in names(Q_dfield_list)) {
		#print(dname)
		#print(Q_dfield_list[[dname]])
		if (any(meta_names_clean %in% Q_dfield_list[[dname]])) {
			found_dnames = c(found_dnames, dname)
		}
	}
	new_dnames = meta_names_clean[!(meta_names_clean %in% unlist(Q_dfield_list))]

	res = list()
	res$found_dnames = found_dnames
	res$new_dnames   = new_dnames

	return(res)
}


#' Counts the number of characters in the YAML data field shortcuts as defined in \code{Q_dfield_list} for a given parsed YAML object.
#'
#' \code{Q_dfield_list} is the list defining the data field shortcuts and the corresponding full name variations.
#'
#' @param yaml_meta parsed YAML object as a structured list
#'
#' @return A named vector with the total number of characters in each found data field shortcut for a given parsed YAML object.
#'
#' @examples
#' \dontrun{
#' d_results = yaml.debugger.run(qnames, d_init)
#' rowSums(sapply( d_results$Metainfos, function(yaml){ yaml.Qdfields.nchar.from.meta(yaml) } ))
#' }
yaml.Qdfields.nchar.from.meta = function(yaml_meta) {
	meta_names_clean = tolower(str_replace_all(names(yaml_meta), "[[:space:]]", ""))
	names(yaml_meta) = meta_names_clean

	n = length(Q_dfield_list)
	dfields_char = rep(0, n)
	names(dfields_char) = names(Q_dfield_list)

	for (dname in names(Q_dfield_list)) {
		#print(dname)
		for ( yaml_dname in meta_names_clean[(meta_names_clean %in% Q_dfield_list[[dname]])] ) {
			#print(yaml_dname)
			if ( is.null(yaml_meta[[yaml_dname]]) ) {
				nchar_res = 0
			} else {
				cur_dfield = yaml_meta[[yaml_dname]]
				# unlist possible structured data fields
				nchar_res = sum(nchar(unlist(cur_dfield)))
			}
			dfields_char[dname] = dfields_char[dname] + nchar_res
		}
	}

	return(dfields_char)
}
