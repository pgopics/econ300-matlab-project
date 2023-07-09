function [c_ineq, c_eq, gc_ineq, gc_eq] = pf_constr(s, V, min_var)

% specify the constraint

c_ineq = s'*V*s - min_var; % the algorithm will try to make sure to choose s such that c_ineq<=0

c_eq = []; % 

% specify the derivative of the constraint
gc_ineq = 2*V*s;

gc_eq = [];