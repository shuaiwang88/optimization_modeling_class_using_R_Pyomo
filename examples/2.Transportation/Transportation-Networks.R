library(tidyverse)
library(ROI)
library(ROI.plugin.glpk)
library(ompr)
library(ompr.roi)

Customer= c( 'Lon', 'Ber', 'Maa', 'Ams', 'Utr', 'Hag' )
Source = c('Arn', 'Gou')

Demand <- c(125,175,225,250,225,200)

Supply <- c(600, 650)

Cost <- matrix(
  c(1000, 2.5, 2.5, 1000, 1.6, 2.0, 1.4, 1.0, 0.8, 1.0, 1.4, 0.8),
  ncol = 2)

m <- MIPModel() %>% 
  add_variable(x[i,j], i=1: length(Customer), j = 1:length(Source),
               type = "continuous", lb = 0) %>% 
  set_objective(sum_expr(x[i,j] * Cost[i,j],
                         i=1: length(Customer),
                         j = 1:length(Source)),
                sense = 'min') %>% 
  add_constraint(sum_expr(x[i,j], i = 1:length(Customer)) <= Supply[j],
                 j = 1:length(Source)) %>% 
  add_constraint(sum_expr(x[i,j], j = 1:length(Source)) == Demand[i], 
                 i = 1:length(Customer)) %>% 
  solve_model(with_ROI(solver = "glpk"))

m$solution
