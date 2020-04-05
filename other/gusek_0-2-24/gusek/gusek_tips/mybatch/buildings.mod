# Problem posed by Nicolas, original model by Xypron, adapted by Luiz Bettoni
#
# Suppose we have a squared-grid (size=n) with n2 cells with a 4-connexity
# neighborhood. Each cell must contains exactly one building. We have several
# building colors (blue, red and green, etc) with an increasing amount of points.
#
# The game rules are the following:
# * No constraints on blue buildings.
# * Red buildings must have at least one blue building in its neighborhood.
# * Green buildings must have at least one red building and at least one blue
#    building in its neighborhood.
# * etc...
#
# The goal is to maximize the number of points by having the biggest buildings
# (blue < red < green < ...).


# size of problem
param n, >0, default 4;

# number of buildings colors
param b, >1, <=5, default 3;

# set of buildings colors
set   B := 1..b;

# buildings colors points
param p{k in B}, default k;

# set of cells
set   C := 1..n cross 1..n;

# binaries indicating buildings colors for each cell
var bld{C, B}, binary;

# objective
maximize obj :
	sum{(i,j) in C, k in B} bld[i,j,k] * p[k];

# max one color per cell
subj to sumCell{(i,j) in C}:
	sum{k in B} bld[i,j,k] = 1;

# buildings must have at least one from each smaller building in their neighborhood
subj to nbhood{(i,j) in C, k in B, l in B: k > 1 and l < k}:
	bld[i,j,k] <=
		+ (if j>1 then bld[i,j-1,l])
		+ (if i>1 then bld[i-1,j,l])
		+ (if i<n then bld[i+1,j,l])
		+ (if j<n then bld[i,j+1,l]);

solve;

# output
printf '\n';
for{i in 1..n}{
	for{j in 1..n}
		printf '%2d', sum{k in B} k * bld[i,j,k];
	printf '\n';
}
printf '\nColor|Cells\n';
printf{k in B} ' %2d  |%4d\n', k, sum{(i,j) in C} bld[i,j,k];
printf '\n';

data;

param n := 5;
param b := 3;
param p := 1 2, 2 5, 3 10;

end;
