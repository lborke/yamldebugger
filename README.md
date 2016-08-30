# yamldebugger - test package

### Quickie for installation and first tests

	# needed only for package installation or update
	library(devtools)
	devtools::install_github("lborke/yamldebugger")
	
	# load the package every time you want to use 'yamldebugger'
	library(yamldebugger)
	
	allKeywords
	"plot" %in% allKeywords
	
	
first real function

	help(yaml.debugger.init)
	
	d_init = yaml.debugger.init("c:/test", show_keywords = TRUE)

second real function	

	help(yaml.debugger.get.qnames)
	
	qnames = yaml.debugger.get.qnames(d_init$RootPath)
	

### Application example. Make sure you have some Q folders on your lokal disk for validating. Let 'workdir' be the folder where the Q folders are stored.

	workdir = "c:/test"
	
	d_init = yaml.debugger.init(workdir, show_keywords = TRUE)
	
	qnames = yaml.debugger.get.qnames(d_init$RootPath)
	
	d_results = yaml.debugger.run(qnames, d_init)
	
	OverView = yaml.debugger.summary(qnames, d_results, summaryType = "mini")
	

to be continued...
