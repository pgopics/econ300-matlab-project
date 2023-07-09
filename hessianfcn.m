function H = hessianfcn(s, lambda, V)

% second order derivative of the lagrangian function
H = zeros(length(s), length(s)) + lambda.ineqnonlin*V*2;