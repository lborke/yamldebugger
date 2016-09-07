# yamldebugger - test package

### Quickie for installation and first tests
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

### Application example. Make sure you have some Q folders on your lokal disk for validating. Let 'workdir' be the folder where the Q folders are stored.

```r
workdir = "c:/test"
	
d_init = yaml.debugger.init(workdir, show_keywords = TRUE)
	
qnames = yaml.debugger.get.qnames(d_init$RootPath)
	
d_results = yaml.debugger.run(qnames, d_init)
	
OverView = yaml.debugger.summary(qnames, d_results, summaryType = "mini")
```

to be continued...


# History of Qs validated by 'yamldebugger' (Version 0.5.0) :

## [IC](https://github.com/QuantLet/IC)
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

## [Stochastic_processes](https://github.com/b2net/Stochastic_processes)
```r
> qnames = yaml.debugger.get.qnames(d_init$RootPath)
[1] "3 Q folder(s) found:"
[1] "ar1_process"    "random_walk"    "randomwalk_ar1"
> d_results = yaml.debugger.run(qnames, d_init)
[1] "1: ar1_process"
[1] "--------------------------------------------------------------------"
[1] "2: random_walk"
[1] "--------------------------------------------------------------------"
[1] "3: randomwalk_ar1"
[1] "--------------------------------------------------------------------"
> 
> OverView = yaml.debugger.summary(qnames, d_results, summaryType = "mini")
> OverView 
     Q Names          Missing Style Guide fields Descriptions stats             Keywords stats               
[1,] "ar1_process"    ""                         "32 word(s), 157 Character(s)" "NA: 9 (standard), NA (new)" 
[2,] "random_walk"    ""                         "17 word(s), 93 Character(s)"  "NA: 9 (standard), NA (new)" 
[3,] "randomwalk_ar1" ""                         "58 word(s), 273 Character(s)" "NA: 12 (standard), NA (new)"
```

## [DYTEC](https://github.com/QuantLet/DYTEC)
```r
> qnames = yaml.debugger.get.qnames(d_init$RootPath)
[1] "4 Q folder(s) found:"
[1] "chp_test"             "data_load_hurricanes" "P_beta_est"           "tau_variance"        
> 
> d_results = yaml.debugger.run(qnames, d_init)
[1] "1: chp_test"
[1] "--------------------------------------------------------------------"
[1] "2: data_load_hurricanes"
[1] "new/bad keywords: dytec"
[1] "--------------------------------------------------------------------"
[1] "3: P_beta_est"
[1] "new/bad keywords: dytec"
[1] "--------------------------------------------------------------------"
[1] "4: tau_variance"
[1] "new/bad keywords: norm, tau"
[1] "--------------------------------------------------------------------"
> OverView = yaml.debugger.summary(qnames, d_results, summaryType = "mini")
> OverView 
     Q Names                Missing Style Guide fields Descriptions stats             Keywords stats              
[1,] "chp_test"             ""                         "17 word(s), 91 Character(s)"  "NA: 6 (standard), NA (new)"
[2,] "data_load_hurricanes" ""                         "17 word(s), 100 Character(s)" "6: 5 (standard), 1 (new)"  
[3,] "P_beta_est"           ""                         "36 word(s), 200 Character(s)" "8: 7 (standard), 1 (new)"  
[4,] "tau_variance"         ""                         "21 word(s), 110 Character(s)" "7: 5 (standard), 2 (new)"
```

## [big_data_analysis](https://github.com/b2net/big_data_analysis)
```r
> qnames = yaml.debugger.get.qnames(d_init$RootPath)
[1] "4 Q folder(s) found:"
[1] "GoogleCorrelateWords_and_FRMcomparison" "TreeModel"                              "Unemployment_Google_vs_Official"       
[4] "Unemploymentrate_jobagency_comparison" 
> 
> d_results = yaml.debugger.run(qnames, d_init)
[1] "1: GoogleCorrelateWords_and_FRMcomparison"
[1] "new/bad keywords: google, google trends"
[1] "--------------------------------------------------------------------"
[1] "2: TreeModel"
[1] "--------------------------------------------------------------------"
[1] "3: Unemployment_Google_vs_Official"
[1] "--------------------------------------------------------------------"
[1] "4: Unemploymentrate_jobagency_comparison"
[1] "--------------------------------------------------------------------"
> 
> OverView = yaml.debugger.summary(qnames, d_results, summaryType = "mini")
> OverView
     Q Names                                  Missing Style Guide fields Descriptions stats             Keywords stats              
[1,] "GoogleCorrelateWords_and_FRMcomparison" ""                         "85 word(s), 441 Character(s)" "15: 13 (standard), 2 (new)"
[2,] "TreeModel"                              ""                         "57 word(s), 264 Character(s)" "NA: 9 (standard), NA (new)"
[3,] "Unemployment_Google_vs_Official"        ""                         "64 word(s), 311 Character(s)" "NA: 6 (standard), NA (new)"
[4,] "Unemploymentrate_jobagency_comparison"  ""                         "36 word(s), 170 Character(s)" "NA: 9 (standard), NA (new)"
```

## [MVA-ToDo](https://github.com/QuantLet/MVA-ToDo)
```r
> qnames = yaml.debugger.get.qnames(d_init$RootPath)
[1] "1 Q folder(s) found:"
[1] "QID-1225-MVApcasimu"
> d_results = yaml.debugger.run(qnames, d_init)
[1] "1: QID-1225-MVApcasimu"
[1] "--------------------------------------------------------------------"
> 
> OverView = yaml.debugger.summary(qnames, d_results, summaryType = "mini")
> OverView 
     Q Names      Missing Style Guide fields Descriptions stats            Keywords stats              
[1,] "MVApcasimu" ""                         "16 word(s), 87 Character(s)" "NA: 9 (standard), NA (new)"
```

## [First 10 Qs from XFG-ToDo](https://github.com/QuantLet/XFG-ToDo)
```r
> qnames = yaml.debugger.get.qnames(d_init$RootPath)
[1] "10 Q folder(s) found:"
 [1] "cdf2quant"           "DGdecompS"           "Eulerscheme"         "gFourierInversion"   "kernel"             
 [6] "nw"                  "optionprice"         "regxest"             "StandardNormalCharf" "VaRcdfDG"           
> d_results = yaml.debugger.run(qnames, d_init)
[1] "1: cdf2quant"
Error in yaml.load(Meta) : 
  Scanner error: while scanning a simple key at line 12, column 1could not find expected ':' at line 14, column 1

[1] "yaml parser error in: cdf2quant"
[1] "--------------------------------------------------------------------"
[1] "2: DGdecompS"
Error in yaml.load(Meta) : 
  Scanner error: while scanning a simple key at line 17, column 1could not find expected ':' at line 19, column 1

[1] "yaml parser error in: DGdecompS"
[1] "--------------------------------------------------------------------"
[1] "3: Eulerscheme"
[1] "new/bad keywords: numerical approximation"
[1] "--------------------------------------------------------------------"
[1] "4: gFourierInversion"
Error in yaml.load(Meta) : 
  Scanner error: while scanning a simple key at line 15, column 1could not find expected ':' at line 17, column 1

[1] "yaml parser error in: gFourierInversion"
[1] "--------------------------------------------------------------------"
[1] "5: kernel"
Error in yaml.load(Meta) : 
  Scanner error: while scanning a simple key at line 9, column 1could not find expected ':' at line 11, column 1

[1] "yaml parser error in: kernel"
[1] "--------------------------------------------------------------------"
[1] "6: nw"
[1] "--------------------------------------------------------------------"
[1] "7: optionprice"
[1] "--------------------------------------------------------------------"
[1] "8: regxest"
[1] "--------------------------------------------------------------------"
[1] "9: StandardNormalCharf"
Error in yaml.load(Meta) : 
  Scanner error: while scanning a simple key at line 16, column 1could not find expected ':' at line 17, column 1

[1] "yaml parser error in: StandardNormalCharf"
[1] "--------------------------------------------------------------------"
[1] "10: VaRcdfDG"
Error in yaml.load(Meta) : 
  Scanner error: while scanning a simple key at line 18, column 2could not find expected ':' at line 19, column 2

[1] "yaml parser error in: VaRcdfDG"
[1] "--------------------------------------------------------------------"
> OverView = yaml.debugger.summary(qnames, d_results, summaryType = "mini")
[1] "cdf2quant"
[1] "Error in yaml.load(Meta) : \n  Scanner error: while scanning a simple key at line 12, column 1could not find expected ':' at line 14, column 1\n\n"
[1] "--------------------------------------------------------------------"
[1] "DGdecompS"
[1] "Error in yaml.load(Meta) : \n  Scanner error: while scanning a simple key at line 17, column 1could not find expected ':' at line 19, column 1\n\n"
[1] "--------------------------------------------------------------------"
[1] "gFourierInversion"
[1] "Error in yaml.load(Meta) : \n  Scanner error: while scanning a simple key at line 15, column 1could not find expected ':' at line 17, column 1\n\n"
[1] "--------------------------------------------------------------------"
[1] "kernel"
[1] "Error in yaml.load(Meta) : \n  Scanner error: while scanning a simple key at line 9, column 1could not find expected ':' at line 11, column 1\n\n"
[1] "--------------------------------------------------------------------"
[1] "StandardNormalCharf"
[1] "Error in yaml.load(Meta) : \n  Scanner error: while scanning a simple key at line 16, column 1could not find expected ':' at line 17, column 1\n\n"
[1] "--------------------------------------------------------------------"
[1] "VaRcdfDG"
[1] "Error in yaml.load(Meta) : \n  Scanner error: while scanning a simple key at line 18, column 2could not find expected ':' at line 19, column 2\n\n"
[1] "--------------------------------------------------------------------"
> OverView
      Q Names       Missing Style Guide fields Descriptions stats            Keywords stats               
 [1,] NA            NA                         NA                            "NA: NA (standard), NA (new)"
 [2,] NA            NA                         NA                            "NA: NA (standard), NA (new)"
 [3,] "Eulerscheme" "Author"                   "4 word(s), 19 Character(s)"  "2: 1 (standard), 1 (new)"   
 [4,] NA            NA                         NA                            "NA: NA (standard), NA (new)"
 [5,] NA            NA                         NA                            "NA: NA (standard), NA (new)"
 [6,] ""            "qname, Author"            "6 word(s), 36 Character(s)"  "NA: 1 (standard), NA (new)" 
 [7,] ""            "qname, Keywords, Author"  "4 word(s), 19 Character(s)"  "NA: NA (standard), NA (new)"
 [8,] ""            "qname, Keywords, Author"  "15 word(s), 88 Character(s)" "NA: NA (standard), NA (new)"
 [9,] NA            NA                         NA                            "NA: NA (standard), NA (new)"
[10,] NA            NA                         NA                            "NA: NA (standard), NA (new)"
```

## [PCA-in-an-Asymmetric-Norm](https://github.com/QuantLet/PCA-in-an-Asymmetric-Norm)
```r
> qnames = yaml.debugger.get.qnames(d_init$RootPath)
[1] "4 Q folder(s) found:"
[1] "PEC_algorithm_princdir" "PEC_algorithm_topdown"  "PEC_fMRI"               "PEC_temperature"       
> d_results = yaml.debugger.run(qnames, d_init)
[1] "1: PEC_algorithm_princdir"
[1] "--------------------------------------------------------------------"
[1] "2: PEC_algorithm_topdown"
[1] "--------------------------------------------------------------------"
[1] "3: PEC_fMRI"
[1] "--------------------------------------------------------------------"
[1] "4: PEC_temperature"
[1] "--------------------------------------------------------------------"
> OverView = yaml.debugger.summary(qnames, d_results, summaryType = "mini")
> OverView
     Q Names         Missing Style Guide fields Descriptions stats            Keywords stats               
[1,] NA              NA                         NA                            "NA: NA (standard), NA (new)"
[2,] "China_example" ""                         "15 word(s), 91 Character(s)" "NA: 4 (standard), NA (new)" 
[3,] "China_example" ""                         "15 word(s), 91 Character(s)" "NA: 4 (standard), NA (new)" 
[4,] "China_example" ""                         "15 word(s), 91 Character(s)" "NA: 4 (standard), NA (new)"
```


