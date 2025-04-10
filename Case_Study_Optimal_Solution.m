
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

mu = [2.885 2.426 1.647 1.745 2.056 3.196 1.727 3.364 1.851 1.869 0.407]';
sd = [6.574 9.110 4.939 11.702 8.482 6.606 8.169 7.482 6.500 6.381 0]';

[V, D] = eig(rho);
Vinv = inv(V);

n_modifications = 100;
k = 0.7;
obj_funs = cell(1, n_modifications);

for n = 1:n_modifications
    delta = 0.0;
    d = rand(11, 1) * 2 * delta - delta;
    Dmod = diag(d) + D;
    rhomod = V * Dmod * Vinv;

    m = 11;
    for i = 1:m
        for j = 1:m
            rhomod(i, j) = rhomod(i, j) / sqrt(rhomod(i, i) * rhomod(j, j));
        end
    end

    H = (1 - k) * diag(sd) * rhomod * diag(sd);
    H = (H + H') / 2;
    g = -k * mu;

    obj_funs{n} = @(x) 0.5 * x' * H * x + g' * x+4.;
end

p = 20;
obj_fun_max = @(x) (sum(cellfun(@(f) f(x).^p, obj_funs)).^(1/p));

x0 = ones(size(H, 1), 1) / size(H, 1);
Aeq = ones(1,size(H,1));
beq = 1;
lb = zeros(size(H, 1), 1);  
ub = ones(size(H, 1), 1); 
options = optimoptions('fmincon', 'Display', 'iter', 'Algorithm', 'sqp');

[x_opt, fval] = fmincon(obj_fun_max, x0, [], [], Aeq, beq, lb, ub, [], options);

disp('Optimal portfolio allocation:');
disp(x_opt);
disp('Minimum of maximum):');
disp(fval);