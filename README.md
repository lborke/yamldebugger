# yamldebugger - test package

### Quickie

	library(devtools)

	devtools::install_github("lborke/yamldebugger")
	
	library(yamldebugger)
	
	allKeywords
	
	
first real function

	help(yaml.debugger.init)
	
	d_init = yaml.debugger.init("c:/test", show_keywords = TRUE)

second real function	

	help(yaml.debugger.get.qnames)
	
	qnames = yaml.debugger.get.qnames(d_init$RootPath)
	

to be continued...
