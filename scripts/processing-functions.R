library("data.table")
library("reshape2")


###########
#FUNCTIONS#
###########

setwd('/home/shannon/Documents/dHCR/data/test_21.8.18/') 

## @knitr import_data
import_data <- function(folder, search_pattern){
  #function imports every file matching a particular pattern in a search directory. 
  #returns a data.frame, unprocessed. 
  files <- list.files(path = folder, pattern= search_pattern, full.names = TRUE) 
  data <- do.call(rbind, lapply(files, function(x)
    cbind(fread(x), name=strsplit(x,'\\.')[[1]][1]))) #https://stackoverflow.com/questions/41006985/importing-multiple-csv-files-into-r-and-adding-a-new-column-with-file-name
  return(data) 
}

## @knitr relative_expression
calculate_relative_expression <- function(folder, slices, genes){
  #will import all the data in the folder specified, and calculate RNA foci per micron counts 
  #if slices = TRUE, will add z.position column to data. Default is FALSE
  #genes is a list of the genes- 1st gene should be in 1st channel etc. 
  
  #import data 
  data <- import_data(folder, "^Image.*.csv")
  areas <- import_data(folder, "^Areas")
  
  #Give nice channel numbers  
  data$channel <- substr(data$Slice, 3, 3)
  data$relative = 0
  
  areas$name <- gsub("Areas", "", areas$name) #get rid of "Areas" for later 
  
  if (slices == TRUE){
    data$z.position <- regmatches(data$Slice, regexpr("z:[[:digit:]]*", data$Slice))
    data$z.position <- substring(data$z.position, 3)
    data$id <- paste(data$name, data$z.position, sep = ",")
    
    areas$z.position <- regmatches(areas$Label, regexpr("z:[[:digit:]]*", areas$Label))
    areas$z.position <- substring(areas$z.position, 3)
    areas$id <- paste(areas$name, areas$z.position, sep = ",")
    
    for (i in 1:length(areas)-1){
      data$relative[data$id == areas$id[i]] <- data$Count[data$id == areas$id[i]]/areas$Area[i] #death by subscripts
      
      
      
    }
    
  } else {
  for (i in 1:length(areas)-1){
    data$relative[data$name == areas$name[i]] <- data$Count[data$name==areas$name[i]]/areas$Area[i] 
  }
  }
  data$gene <- genes[as.numeric(data$channel)] #uses the channel no. as index for gene name! 
  
  return(data)
  
}





