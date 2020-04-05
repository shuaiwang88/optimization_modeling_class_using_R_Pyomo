# Set covering problem
# 6 doctors 6 procedures
num_doctor   = 6
num_procedure = 6

availability = matrix(
  c(
    1,0,0,1,0,0,
    1,0,0,0,1,0,
    0,1,1,0,0,0,
    1,0,0,0,0,1,
    0,1,1,0,0,1,
    0,1,0,0,0,0),
  ncol = num_doctor
)

# cost of doctors
cost = c(2500, 2800, 1800, 1200, 1100, 900)



# Model 
MIPModel() %>% 
  #if assign doctor to a procedure
  add_variable(x[d], d=1:num_doctor, type = "binary") %>% 
  set_objective(sum_expr(cost[d] * x[d], d=1:num_doctor), 
                "min") %>% 
  add_constraint(sum_expr(x[d]* availability[d,p], d=1:num_doctor) >=1,
                 p=1:num_procedure) %>% 
  solve_model(with_ROI(solver="glpk")) %>%
  get_solution(x[d]) %>% 
  filter(value > 0)

