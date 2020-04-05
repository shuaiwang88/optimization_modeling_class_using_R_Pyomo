library(tidyverse)
library(ROI)
library(ROI.plugin.glpk)
library(ompr)
library(ompr.roi)

Nmin = c(2000, 350, 55, 100, 100, 100, 100) 
Nmax = c(NA, 350, NA, NA, NA, NA, NA) %>% replace_na(Inf)

Cost = c(1.84, 2.19, 1.84, 1.44, 2.29, 0.77, 1.29, 0.60, 0.72)
Volumn = c(4, 7.5, 3.5, 5, 7.3, 2.6, 4.1, 8, 12)

max_volumn = 75

nutrient_df <- read_csv(file = "nutrient.csv")
food_set <- nutrient_df$Food
nutrient_set = names(nutrient_df)[-1]

nutrient_matrix <- select(nutrient_df, -Food) %>% 
  as.matrix(ncol=length(nutrient_set))

MIPModel() %>% 
  add_variable(x[i], i= 1:length(food_set), type = "integer",  lb =0) %>% 
  set_objective(sum_expr(Cost[i] * x[i], i = 1:length(food_set)), "min") %>% 
  add_constraint(sum_expr(x[i] * nutrient_matrix[i,j],
                 i = 1:length(food_set)) >= Nmin[j],
                 j = 1:length(nutrient_set))%>% 
  add_constraint(sum_expr(x[i] * nutrient_matrix[i,j],
                          i = 1:length(food_set)) <= Nmax[j],
                 j = 1:length(nutrient_set)) %>% 
  add_constraint(sum_expr(x[i] * Volumn[i], i = 1:length(food_set)) <= max_volumn) %>% 
  solve_model(with_ROI(solver="glpk")) %>%
  get_solution(x[i]) 

