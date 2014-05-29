# load the R-file to set up the data.



## plot --------

qplot(df$distance,df$trade) + xlab("log of distance") + ylab("log (Xij) : tradeflows") + ggtitle("Correlation") + geom_smooth();
ggsave("dist_tradeflow.eps",width = 10, height = 10)


qplot(df$distance,df$trade-df$gdp_origin -df$gdp_destination) + xlab("log of distance") + ylab("log (Xij) - log(Yi) - log(Yj)") + ggtitle("Correlation") + geom_smooth();
ggsave("dist_tradeflow_adjusted.eps",width = 10, height = 10)


## traditional gravity equation ----
# (a-i)

qplot(df$distance,df$trade-df$gdp_origin -df$gdp_destination) + xlab("log of distance") + ylab("log (Xij) - log(Yi) - log(Yj)") + ggtitle("Correlation") + geom_smooth();
ggsave("dist_tradeflow_adjusted.eps",width = 10, height = 10)

result_a_i = lm(df$trade-df$gdp_origin -df$gdp_destination ~ 0 +  df$distance);
summary(result_a_i)

## with a twist ----
# (a-ii) 
result_a_ii = lm(df$trade~ 0 + df$distance + df$gdp_origin + df$gdp_destination);
summary(result_a_ii)


## fixed effects ----
# (b)
result_b = lm(df_b$trade ~ 0 + . ,data = df_b);
coefficient = coef(result_b);
coefficient = coefficient[-1];
origin_effect = coefficient[1:180];
destination_effect = coefficient[-c(1:181)]
destination_effect = destination_effect[1:180]
fixed_effects = data.frame(origin_fixed_effects = origin_effect, destination_fixed_effects = destination_effect )
fixed_effects = na.omit(fixed_effects);
fixed_effects = sweep(fixed_effects, 2, apply(fixed_effects,2,mean)); 
qplot(fixed_effects$origin_fixed_effects,fixed_effects$destination_fixed_effects) + xlab("Origin effect") + ylab("Destination effect") + ggtitle("Fixed effects") + geom_smooth()
ggsave("Fixed_effects.eps",width = 10, height = 10)


summary(result_b)


## Ratio gravity estimator ---
# (c)
result_c = lm(df_c$ratio ~ 0 + . , data = df_c);
summary(result_c)


## General gravity estimator ---
# (d)
result_d = lm(df_d$trade ~ 0 +. ,data = df_d);
summary(result_d)

## balance trade ---
balance = lm(df_import_export$import ~ 0 + df_import_export$export)
rhs = 1;
hm  = 1;
linearHypothesis(balance,hm,rhs)
summary(balance)
summary(df_import_export)

## 2 (c)
result_2 = lm(df_2$trade ~ 0 + . , data  = df_2)
summary(result_2)











