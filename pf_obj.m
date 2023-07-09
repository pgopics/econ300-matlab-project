function [f, g, H] = pf_obj(s, er)

% objective function: expected returns
f = -er*s;

% first order derivative
g = -er;

% second order derivative of the Lagrangian function (also called Hessian)
H = zeros(length(s), length(s));

