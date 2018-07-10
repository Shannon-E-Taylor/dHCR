#! /usr/bin/env R

library("ggplot2")
library("data.table")

setwd('../data/test_10.07.18/')

files <- list.files(pattern="Image.*.csv") #I is important to ignore the Q/W/A files! 
data <- do.call(rbind, lapply(files, function(x)
	cbind(fread(x), name=strsplit(x,'\\.')[[1]][1]))) #https://stackoverflow.com/questions/41006985/importing-multiple-csv-files-into-r-and-adding-a-new-column-with-file-name

#add some sensible colnames to data 
data$channel <- substr(data$Slice, 3, 3)

#Grab and wrangle Queens, (IW, AW) data 
Queens <- fread('Queen.csv')
Queens$name <- substr(Queens$Label, 1, 9) 

Workers <- fread('Workers.csv')
Workers$name <- substr(Workers$Label, 1, 9) 

#make and wrangle table 
#counts <- table(data$channel, data$name)
#c <- data.table(counts) #subsets not needed anymore? 
data$relative <- 0
data$class <- ''
#get no. dots per um^2
for (i in 1:length(Queens)-1){
	data$relative[data$name==Queens$name[i]] <- data$Count[data$name==Queens$name[i]]/Queens$Area[i]
	data$class[data$name==Queens$name[i]] <- "Queen"
}


for (i in 1:length(Workers)){
	data$relative[data$name==Workers$name[i]] <- data$Count[data$name==Workers$name[i]]/Workers$Area[i]
	data$class[data$name==Workers$name[i]] <- "InactiveWorker"
}



areas <- ggplot(data, aes(x=Label, y = Area)) + geom_violin(scale = "count") #see area dist
expressions <- ggplot(c, aes(x=V1, y=N)) + geom_boxplot() + geom_jitter() #see dist of values 
rel_expression <- ggplot(rel_exp, aes(x=V1, y = N)) + geom_boxplot() + geom_jitter() #expression per um^2

#no difference between actives and inactives. 
#upon looking at the output images, I think this is a thresholding issue- lots of small 1px speckles in inactives
#that would be picked up by particle counter. 
#need to fix this! 
#todo- print this out for lab book. 
#todo- fix thresholding issue! either change lower bound for particle counter, or change thresholding itself. 
OUTPUT <- ggplot(data, aes(x=channel, y = relative)) + geom_boxplot() + geom_jitter(aes(colour = class))
