# installing/loading the package:
if(!require(installr)) { install.packages("installr"); require(installr)} #load / install+load installr

# Installing pandoc
install.pandoc(use_regex = FALSE)  # The use of use_regex here is due to a change in pandoc download page.  This parameter will not be needed in installr versions after 0.9

#more infomration on using pandoc
#http://rprogramming.net/create-html-or-pdf-files-with-r-knitr-miktex-and-pandoc/