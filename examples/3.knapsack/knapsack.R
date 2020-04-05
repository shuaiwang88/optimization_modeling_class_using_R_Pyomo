library(dplyr)
library(ROI)
library(ROI.plugin.glpk)
library(ompr)
library(ompr.roi)

# Knapsack problem
max_capacity <- 400
n <- 5
# weights <- runif(n, max = max_capacity)
weights <- c(300, 1, 200, 100,10)
value <- c(4000,5000,5000,2000,1000)

MIPModel() %>%
  add_variable(x[i], i = 1:n, type = "binary") %>%
  set_objective(sum_expr(value[i] * x[i], i = 1:n), "max") %>%
  add_constraint(sum_expr(weights[i] * x[i], i = 1:n) <= max_capacity) %>%
  solve_model(with_ROI(solver = "glpk")) %>%
  get_solution(x[i]) %>%
  filter(value > 0)

demand_df <- data.frame(
  zone = rep(c('zone1', 'zone2', 'zone3'), 24*2*2),
  job = rep(c("full", 'part'), 24*3*2),
  rule = rep(c('rule1', 'rule2'), 24*3*2 ),
  demand = sample.int(80:120, size = 24*3*2*2, replace =  T),
)

demand_df
