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
require("grid")
require("gridExtra")
require("R.matlab")
require("car")
require("lmtest")
require("plyr")

rm(list=ls());
gc();
gc();


## load the data ------------------------------------------ 
df = read.dta("tradedata.dta")
writeMat('tradedata_original.mat',dataset = df)
dff = df;
df = subset(df,trade>0);
dff = subset(dff,trade>0);
# take a log
dff[-c(1,2)] = log(dff[-c(1,2)]);


df = ddply(df, c("origin"), transform, x_jj = gdp_destination - sum(trade))
# drop the observations
df = subset(df,x_jj>0);
# take the log
df[-c(1,2)] = log(df[-c(1,2)]);

# log ratio
df$ratio = df$trade-df$x_jj;


## dummy for (b)
df_b = df;
for(level in unique(df_b$origin)){
        df_b[paste("origin_dummy", level, sep = "_")] <- ifelse(df_b$origin == level, 1, 0)
}

for(level in unique(df_b$destination)){
        df_b[paste("destination_dummy", level, sep = "_")] <- ifelse(df_b$destination == level, 1, 0)
}

# names
a = df$origin;
b = df$destination;
c = rbind(a,b);
c = c[1,];
total_name = unique(c);

# dummy for (c)
df_c = df;
for(level in unique(total_name)){
        a = as.numeric(df_c$origin     ==level);
        b = as.numeric(df_c$destination==level);
        c = a-b;
        df_c[paste("dummy", level, sep = "_")] <- c
}

# dummy for (d)
df_d = df;
for(level in unique(total_name)){
        a = as.numeric(df_d$origin     ==level);
        b = as.numeric(df_d$destination==level);
        c = a+b;
        df_d[paste("dummy", level, sep = "_")] <- c
}

# dummy for 2 (c)
df_2 = df_d;
for(level in unique(total_name)){
        df_2[paste("additional_destination_dummy", level, sep = "_")] <- ifelse(df_2$destination == level, 1, 0)
}


# data set for matlab
attach(df)
N_country = dim(as.matrix(total_name));
GDP = as.matrix(gdp_destination[1:N_country])
df_matlab = df[c(1,2,6,7,8,10)];
writeMat('data_Q3.mat',dataset = df_matlab)




df_import_export = data.frame(export = tapply(dff$trade,dff$destination,mean), import = tapply(dff$trade,dff$origin,mean))

df_b = df_b[-c(1,2,4,5,6,7,9,10)]; # 3 = distance , 8 = trade flow
df_c = df_c[-c(1,2,4,5,6,7,8,9)];
df_d = df_d[-c(1,2,4,5,6,7,9,10)];
df_2 = df_2[-c(1,2,4,5,6,7,9,10)];


save.image("trade_data_set_cleaned")




#export =  tapply(df$trade,df$destination,mean)
#export = data.frame(names(export),export)
#names(export)[1]= c("destination")
#merge(df$destination,export,by = c("destination"))
#import =  tapply(df$trade,df$destination,mean)

#df_sub= ddply(df, c("origin"), transform, x_jj = gdp_destination - sum(trade))
#df_sub = subset(df_sub,x_jj>0);
#df_sub = subset(df_sub,trade>0);
#df_sub[-c(1,2)] = log(df_sub[-c(1,2)]);
#df=ddply(df, c("destination"),  transform, trade_sum_destination = sum(trade))
#df_sub$ratio = df_sub$trade-df_sub$x_jj;
#write.csv(file = 'tradedata.csv',x = df)
# drop the observations
#df = subset(df,trade>0);
#df=ddply(df, c("origin"),  transform, trade_sum_origin = sum(trade))


