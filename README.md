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
```r
help(yaml.debugger.init)
d_init = yaml.debugger.init("c:/test", show_keywords = TRUE)
```

second real function	
```r
help(yaml.debugger.get.qnames)
qnames = yaml.debugger.get.qnames(d_init$RootPath)
```

### Application example. Make sure you have some Q folders on your lokal disk for validating. Let 'workdir' be the folder where the Q folders are stored.

```r
workdir = "c:/test"
	
d_init = yaml.debugger.init(workdir, show_keywords = TRUE)
	
qnames = yaml.debugger.get.qnames(d_init$RootPath)
	
d_results = yaml.debugger.run(qnames, d_init)
	
OverView = yaml.debugger.summary(qnames, d_results, summaryType = "mini")
```

to be continued...


### History of Qs validated by 'yamldebugger' :

```r
> qnames = yaml.debugger.get.qnames(d_init$RootPath)
[1] "1 Q folder(s) found:"
[1] "ICplots"
> d_results = yaml.debugger.run(qnames, d_init)
[1] "1: ICplots"
[1] "new/bad keywords: information criteria, model selection"
[1] "--------------------------------------------------------------------"
> OverView = yaml.debugger.summary(qnames, d_results, summaryType = "mini")
> OverView
     Q Names   Missing Style Guide fields Descriptions stats            Keywords stats            
[1,] "ICplots" ""                         "13 word(s), 63 Character(s)" "5: 3 (standard), 2 (new)"
```