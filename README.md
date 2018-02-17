# yamldebugger R package

### Quickie for the installation and first tests
```r
# needed only for package installation or update
library(devtools)
devtools::install_github("lborke/yamldebugger")

# load the package every time you want to use 'yamldebugger'
library(yamldebugger)

allKeywords
"plot" %in% allKeywords
```
	
first real function :
```r
help(yaml.debugger.init)
d_init = yaml.debugger.init("c:/test", show_keywords = TRUE)
```

second real function :
```r
help(yaml.debugger.get.qnames)
qnames = yaml.debugger.get.qnames(d_init$RootPath)
```

### Application example. Make sure you have some Q folders on your local disk for validating. Let 'workdir' be the folder where the Q folders are stored, e.g. the local version of the git repository containing Qs.

```r
workdir = "c:/test"
	
d_init = yaml.debugger.init(workdir, show_keywords = TRUE)
	
qnames = yaml.debugger.get.qnames(d_init$RootPath)
	
d_results = yaml.debugger.run(qnames, d_init)
	
OverView = yaml.debugger.summary(qnames, d_results, summaryType = "mini")
```

## Citing yamldebugger

If you use yamldebugger in your research or wish to refer to the [Quantlets](https://github.com/QuantLet) validated by this R package, please use the following BibTeX entry.

```
@Manual{yamldebugger,
    title = {yamldebugger: YAML parser debugger according to the QuantNet style guide},
    author = {Lukas Borke},
    year = {2017},
    note = {R package version 1.0},
    url = {https://github.com/lborke/yamldebugger}
}
```

A more sophisticated overview and background information is provided by:

```
@phdthesis{Borke2017Thesis,
	author = {Borke, Lukas},
	title = {Dynamic Clustering and Visualization of Smart Data via D3-3D-LSA},
	school = {Humboldt-Universität zu Berlin, Wirtschaftswissenschaftliche Fakultät},
	year = {2017},
	doi = {http://dx.doi.org/10.18452/18307}
}
```
