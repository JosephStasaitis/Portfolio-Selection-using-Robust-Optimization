
% Correlation matrix for 11 investments
rho = [ 1 .70 .41 .32 .46 .70 .58 .67 .71 .28 0;
        .70 1 .47 .42 .59 .58 .55 .67 .62 .30 0;
        .41 .47 1 .25 .54 .46 .57 .53 .55 .50 0;
        .32 .42 .25 1 .45 .36 .35 .28 .22 .25 0;
        .46 .59 .54 .45 1 .48 .58 .51 .53 .44 0;
        .70 .58 .46 .36 .48 1 .50 .65 .62 .22 0;
        .58 .55 .57 .35 .58 .50 1 .51 .59 .29 0;
        .67 .67 .53 .28 .51 .65 .51 1 .67 .31 0;
        .71 .62 .55 .22 .53 .62 .59 .67 1 .30 0;
        .28 .30 .50 .25 .44 .22 .29 .31 .30 1 0;
        0 0 0 0 0 0 0 0 0 0 1];

% Expected returns for the 11 investments
mu = [2.885 2.426 1.647 1.745 2.056 3.196 1.727 3.364 1.851 1.869 0.407]';

% Expected risk for the 11 investments
sd = [6.574 9.110 4.939 11.702 8.482 6.606 8.169 7.482 6.500 6.381 0]';

% Eigenvalues of the correlation matrix
[V, D] = eig(rho);
% Inverse of eigenvector matrix
Vinv = inv(V);  

% Number of random perturbations to correlation matrix
n_modifications = 100;  
% Risk-Return value
k = 0.7;
obj_funs = cell(1, n_modifications); 

for n = 1:n_modifications
    delta = 0.0;  % Level of Uncertainty
    d = rand(11, 1) * 2 * delta - delta;  % Vector of changes due to uncertainty
    Dmod = diag(d) + D;  % Modifying the eigenvalues
    rhomod = V * Dmod * Vinv;  % Reconstruct modified correlation matrix

    % Normalize so rhomod is a valid correlation matrix
    m = 11;
    for i = 1:m
        for j = 1:m
            rhomod(i, j) = rhomod(i, j) / sqrt(rhomod(i, i) * rhomod(j, j));
        end
    end

    % Construct the covariance matrix H using the modified correlation matrix
    H = (1 - k) * diag(sd) * rhomod * diag(sd);
    H = (H + H') / 2;  % Ensure symmetry
    g = -k * mu;  % Linear term from mean-variance objective

    % Define quadratic objective function with modified H and g
    obj_funs{n} = @(x) 0.5 * x' * H * x + g' * x + 4.;  % Constant added to avoid negatives
end

% Define p-norm approximation to max function
p = 20;
obj_fun_max = @(x) (sum(cellfun(@(f) f(x).^p, obj_funs)).^(1/p));

% Initial guess
x0 = ones(size(H, 1), 1) / size(H, 1);

% Weights must sum to 1 
Aeq = ones(1, size(H, 1));
beq = 1;

% Each weight must be between 0 and 1
lb = zeros(size(H, 1), 1);  
ub = ones(size(H, 1), 1); 

% Optimization options
options = optimoptions('fmincon', 'Display', 'iter', 'Algorithm', 'sqp');

% Minimize worst-case objective function
[x_opt, fval] = fmincon(obj_fun_max, x0, [], [], Aeq, beq, lb, ub, [], options);

% Display results
disp('Optimal portfolio allocation:');
disp(x_opt);
disp('Minimum of maximum (robust objective):');
disp(fval);
