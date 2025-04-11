% Define the exponent used in the p-norm approximation
n = 25;

% Define 6 quadratic functions
f1 = @(x) (3.6*x.^2 - 3.6*x + 1.25);
f2 = @(x) (1.75*x.^2 - 1*x + 0.25);
f3 = @(x) (1.6*x.^2 - 1.6*x + 0.5);
f4 = @(x) (1*x.^2 - 2*x + 1.25);
f5 = @(x) (2*x.^2 - 2*x + 0.5);
f6 = @(x) (3*x.^2 - 1.75*x + 0.25);

% Define h(x) as the p-norm approximation of the maximum of the functions f1 to f6
h = @(x) (f1(x).^n + f2(x).^n + f3(x).^n + f4(x).^n + f5(x).^n + f6(x).^n).^(1/n);
% This is smooth and can be minimized using fmincon

% Define range of x values
x_vals = linspace(0, 1, 100);

% Create figure and hold on to overlay multiple plots
figure; hold on;

% Plot each function in a different color
plot(x_vals, f1(x_vals), 'r', 'LineWidth', 2);
plot(x_vals, f2(x_vals), 'g', 'LineWidth', 2);
plot(x_vals, f3(x_vals), 'y', 'LineWidth', 2);
plot(x_vals, f4(x_vals), 'b', 'LineWidth', 2);
plot(x_vals, f5(x_vals), 'm', 'LineWidth', 2);
plot(x_vals, f6(x_vals), 'k', 'LineWidth', 2);
plot(x_vals, h(x_vals), 'c--', 'LineWidth', 2);

% Add legend for all functions
legend('f_1(x)', 'f_2(x)', 'f_3(x)', 'f_4(x)', 'f_5(x)', 'f_6(x)', 'obj fun max f_n(x)', 'FontSize', 18);
% Add grid to the plot
grid on;  

% Initial guess for optimization
x0 = 0;

% Set options
options = optimoptions('fmincon', 'Algorithm', 'sqp');

% Minimize h(x) over the interval [0, 1]
[x_min, h_min] = fmincon(h, x0, [], [], [], [], 0, 1, [], options);

% Plot the minimum point on the graph
plot(x_min, h_min, 'go', 'MarkerSize', 9, 'MarkerFaceColor', 'g', ...
     'DisplayName', 'Min (obj fun max f_n(x))');

% Add title and axis labels
title('Quadratic Functions and Optimized max f_n(x)', 'FontSize', 20);
xlabel('x', 'FontSize', 18);
ylabel('y', 'FontSize', 18);

% Set font size for axes
ax = gca;
