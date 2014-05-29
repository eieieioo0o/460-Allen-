## test


# this is a code for Treb Allen's trade course.
a = getwd();
setwd(a)
require('foreign')
require('plm')
require('mFilter')
require('ggplot2')
require("vars")
require("stats")
require("xlsx")
require("reshape2")
require("stargazer")
require("plyr")
require("grid")
require("gridExtra")
require("R.matlab")
require("car")
require("lmtest")

rm(list=ls());
gc();
gc();

y = c(4,4,5,5);
x = 1:4;
z = data.frame(x,y)

A = aggregate(z$x,list(by=z$y),FUN = mean)
names(A)[1] = c('y')
M = merge(z,A,  by = "y")
result = z$x-M[,3]

mydf <- data.frame(x=rnorm(10, mean=-10),y = rnorm(10, mean=10), sex=sample(c("M","F"), 10, rep=T))#, group=gl(5, 20, labels=LETTERS[1:5]))  
mydf = ddply(mydf, c("sex"), transform, x.mean=mean(y))

mydf <- data.frame(x=-4:4,y = -4:4)
sweep(mydf, 2, apply(mydf,2,mean)) 

#Generate example dataframe with character column
#Generate example dataframe with character column
#example <- as.data.frame(c("A", "A", "B", "F", "C", "G", "C", "D", "E", "F"))
#names(example) <- "strcol"

#For every unique value in the string column, create a new 1/0 column
#This is what Factors do "under-the-hood" automatically when passed to function requiring numeric data
for(level in unique(mydf$sex)){
        mydf[paste("dummy", level, sep = "_")] <- ifelse(mydf$sex == level, 1, 0)
}









