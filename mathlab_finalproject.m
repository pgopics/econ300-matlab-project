amzn = readall(datastore('AMZN.csv'));
biib = readall(datastore('BIIB.csv'));
ew = readall(datastore('EW.csv'));

% before calculating the returns, check the data to make sure the time matches

% get the prices
p = [amzn.AdjClose, biib.AdjClose, ew.AdjClose];

%% 1. calculate the returns
r = p(2:end, :)./p(1:end-1, :) - 1;

% in contrast, p(2:end), p(1:end-1) would only use the first column, instead of all
% columns of p.

%% 1. calculate the returns
r = p(2:end, :)./p(1:end-1, :) - 1;

% in contrast, p(2:end), p(1:end-1) would only use the first column, instead of all
% columns of p.


%% 2. calculate the expected returns and variance covariance matrix
er = mean(r); % expected returns

V = cov(r); 

%% 3. find the allocation
% 3.1 we first find the lowest variance (therefore the lowest standard
% deviation) of the stocks chosen here
min_var = min(diag(V));

% 3.2 setup the maximization problem
% the unknown shares are assumed to be a column vector 

% 3.2.1 define the objective function: fmincon only minimizes function
% values; to find a maximizer, negate the objective function
% see the function pf_obj

% 3.2.2 define the constraints c(s)<=0
% see the function pf_constr

% in a large scale optimization, you would also need to specify the
% derivatives of the constraint function; our optimization problem is not
% that complicated and omitted here

% 3.2.3 apply fmincon to find the optimal shares subject to the constraints
s0 = ones(length(er), 1)/length(er); % set an initial value such that if there are n stocks, the allocation is 1/n, 1/n, ...

% there is one more step before invoking fmincon: the objective function
% and the constraints must have one input (s); therefore we convert pf_obj
% and pf_constr into function handles that use only one input
pf_obj_handle = @(s) pf_obj(s, er);

pf_constr_handle = @(s) pf_constr(s, V, min_var);

hessianfcn_handle = @(s, lambda) hessianfcn(s, lambda, V); % second order derivative of the Lagrangian

options = optimoptions('fmincon','Algorithm','interior-point',...
    'SpecifyObjectiveGradient',true,'SpecifyConstraintGradient',true,...
    'HessianFcn', hessianfcn_handle, 'CheckGradients', true);

% below, I use ... to break one long line of command into multiple rows
s1 = fmincon(pf_obj_handle,...objective function
    s0,...initial value
    ones(1, length(er)), 1,... inequality constaints: [1 1 1]*s<=1 
    [], [], ... omit equality constraints
    zeros(length(er), 1), ...lower bound [0; 0; 0]
    ones(length(er), 1),...upper bound [1; 1; 1] 
    pf_constr_handle,... the constraints
    options); 

%%
% As a side note, you can use the setup above to signficantly scale up the
% number of stocks 


% 1)
disp("1. er =");
disp(er);

% 2/3)
disp("2&3. V = ");
disp(V);

% 4) 
disp("4. s1 = ")
disp(s1);

resval = s1'*V*s1;
disp("Resulting variance:");
disp(resval);



