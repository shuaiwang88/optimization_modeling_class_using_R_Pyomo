# Sudoku problem
library(dplyr)
library(ROI)
library(ROI.plugin.glpk)
library(ompr)
library(ompr.roi)

n <- 9
model <- MIPModel() %>%
  
  # The number k stored in position i,j
  add_variable(x[i, j, k], i = 1:n, j = 1:n, k = 1:9, type = "binary") %>%
  
  # no objective
  set_objective(0) %>%
  
  # only one number can be assigned per cell
  add_constraint(sum_expr(x[i, j, k], k = 1:9) == 1, i = 1:n, j = 1:n) %>%
  
  # each number is exactly once in a row
  add_constraint(sum_expr(x[i, j, k], j = 1:n) == 1, i = 1:n, k = 1:9) %>%
  
  # each number is exactly once in a column
  add_constraint(sum_expr(x[i, j, k], i = 1:n) == 1, j = 1:n, k = 1:9) %>%
  
  # each 3x3 square must have all numbers
  add_constraint(sum_expr(x[i, j, k], i = 1:3 + sx, j = 1:3 + sy) == 1,
                 sx = seq(0, n - 3, 3), sy = seq(0, n - 3, 3), k = 1:9)
model


model_fixed <- model %>%
    add_constraint(x[1, 1, 5] == 1) %>%
    add_constraint(x[1, 2, 3] == 1) %>%
    add_constraint(x[1, 5, 7] == 1) %>%
    add_constraint(x[2, 1, 6] == 1) %>%
    add_constraint(x[2, 4, 1] == 1) %>%
    add_constraint(x[2, 5, 9] == 1) %>%
    add_constraint(x[2, 6, 5] == 1) %>%
    add_constraint(x[3, 2, 9] == 1) %>%
    add_constraint(x[3, 3, 8] == 1) %>%
    add_constraint(x[3, 8, 6] == 1) %>%
    add_constraint(x[4, 1, 8] == 1) %>%
    add_constraint(x[4, 5, 6] == 1) %>%
    add_constraint(x[4, 9, 3] == 1) %>%
    add_constraint(x[5, 1, 4] == 1) %>%
    add_constraint(x[5, 4, 8] == 1) %>%
    add_constraint(x[5, 6, 3] == 1) %>%
    add_constraint(x[5, 9, 1] == 1)  %>%
    add_constraint(x[6, 1, 7] == 1) %>%                 
    add_constraint(x[6, 5, 2] == 1) %>%           
    add_constraint(x[6, 9, 6] == 1) %>%
    add_constraint(x[7, 2, 6] == 1) %>%
    add_constraint(x[7, 7, 2] == 1) %>%
    add_constraint(x[7, 8, 8] == 1) %>%
    add_constraint(x[8, 4, 4] == 1) %>%
    add_constraint(x[8, 5, 1] == 1) %>%
    add_constraint(x[8, 6, 9] == 1) %>%
    add_constraint(x[8, 9, 5] == 1) %>%
    add_constraint(x[9, 5, 8] == 1) %>%
    add_constraint(x[9, 8, 7] == 1) %>%
    add_constraint(x[9, 9, 9] == 1)

result <- solve_model(model_fixed, with_ROI(solver = "glpk", verbose = TRUE))

result %>%
  get_solution(x[i,j,k]) %>%
  filter(value > 0) %>%
  select(i, j, k) %>%
  tidyr::spread(j, k) %>%
  select(-i)

