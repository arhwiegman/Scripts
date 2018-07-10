ask.4.destpath.popbox <- function(npaths=1){
	destpath <- vector(mode="character", length=npaths) # initialize destination paths
	
	#loop to ask user to enter destination folders
	for (i in seq_len(npaths)){
		. <- "Enter destination path (use '/' to denote child directories):"
		. <- svDialogs::dlgInput(.)$res
		destpath[i] <- .
		while (!dir.exists(destpath[i])){
			. <- paste(destpath[i],"does not exist, please enter a valid destination path:")
			. <- svDialogs::dlgInput(.)$res
			destpath[i] <- .
		}#end while loop
		return(destpath)
	}#end for loop
}#end function definition
ask.4.destpath.popbox()