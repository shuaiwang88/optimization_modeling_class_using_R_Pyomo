
library(dplyr)
library(ROI)
library(ROI.plugin.glpk)
library(ompr)
library(ompr.roi)

# General example ----
result <- MIPModel() %>%
  add_variable(x, type = "integer") %>%
  add_variable(y, type = "continuous", lb = 0) %>%
  set_bounds(x, lb = 0) %>%
  set_objective(x + y, "max") %>%
  add_constraint(x + y <= 11.25) %>%
  solve_model(with_ROI(solver = "glpk"))
get_solution(result, x)
get_solution(result, y)

# Knapsack problem
max_capacity <- 5
n <- 10
weights <- runif(n, max = max_capacity)
MIPModel() %>%
  add_variable(x[i], i = 1:n, type = "binary") %>%
  set_objective(sum_expr(weights[i] * x[i], i = 1:n), "max") %>%
  add_constraint(sum_expr(weights[i] * x[i], i = 1:n) <= max_capacity) %>%
  solve_model(with_ROI(solver = "glpk")) %>%
  get_solution(x[i]) %>%
  filter(value > 0)

# Sudoku problem
library(ompr)
library(dplyr)
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

library(ompr.roi)
library(ROI.plugin.glpk)
result <- solve_model(model, with_ROI(solver = "glpk", verbose = TRUE))


result %>%
  get_solution(x[i,j,k]) %>%
  filter(value > 0) %>%
  select(i, j, k) %>%
  tidyr::spread(j, k) %>%
  select(-i)

model_fixed <- model %>%
  add_constraint(x[1, 1, 1] == 1) %>%
  add_constraint(x[1, 2, 2] == 1) %>%
  add_constraint(x[1, 3, 3] == 1) %>%
  add_constraint(x[2, 1, 4] == 1) %>%
  add_constraint(x[2, 2, 5] == 1) %>%
  add_constraint(x[2, 3, 6] == 1) %>%
  add_constraint(x[3, 1, 7] == 1) %>%
  add_constraint(x[3, 2, 8] == 1) %>%
  add_constraint(x[3, 3, 9] == 1)
result <- solve_model(model_fixed, with_ROI(solver = "glpk", verbose = TRUE))

result %>%
  get_solution(x[i,j,k]) %>%
  filter(value > 0) %>%
  select(i, j, k) %>%
  tidyr::spread(j, k) %>%
  select(-i)

# Traveling Salesman problem

# number of cities
n <- 10

# Boundary of our Euclidean space:
# from 0 to ...
max_x <- 500
max_y <- 500

et.seed(1)
cities <- data.frame(id = 1:n, x = runif(n, max = max_x), y = runif(n, max = max_y))

ggplot(cities, aes(x, y)) +
  geom_point()

# distance matrix
distance <- as.matrix(dist(select(cities, x, y), diag = TRUE, upper = TRUE))


model <- MIPModel() %>%

  # we create a variable that is 1 iff we travel from city i to j
  add_variable(x[i, j], i = 1:n, j = 1:n,
               type = "integer", lb = 0, ub = 1) %>%

  # a helper variable for the MTZ formulation of the tsp
  add_variable(u[i], i = 1:n, lb = 1, ub = n) %>%

  # minimize travel distance
  set_objective(sum_expr(distance[i, j] * x[i, j], i = 1:n, j = 1:n), "min") %>%

  # you cannot go to the same city
  set_bounds(x[i, i], ub = 0, i = 1:n) %>%

  # leave each city
  add_constraint(sum_expr(x[i, j], j = 1:n) == 1, i = 1:n) %>%

  # visit each city
  add_constraint(sum_expr(x[i, j], i = 1:n) == 1, j = 1:n) %>%

  # ensure no subtours (arc constraints)
  add_constraint(u[i] >= 2, i = 2:n) %>%
  add_constraint(u[i] - u[j] + 1 <= (n - 1) * (1 - x[i, j]), i = 2:n, j = 2:n)
model

result <- solve_model(model, with_ROI(solver = "glpk", verbose = TRUE))

solution <- get_solution(result, x[i, j]) %>%
  filter(value > 0)
kable(head(solution, 3))

paths <- select(solution, i, j) %>%
  rename(from = i, to = j) %>%
  mutate(trip_id = row_number()) %>%
  tidyr::gather(property, idx_val, from:to) %>%
  mutate(idx_val = as.integer(idx_val)) %>%
  inner_join(cities, by = c("idx_val" = "id"))


ggplot(cities, aes(x, y)) +
    geom_point() +
    geom_line(data = paths, aes(group = trip_id)) +
    ggtitle(paste0("Optimal route with cost: ", round(objective_value(result), 2)))
