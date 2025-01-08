rho = [ 1 .70 .41 .32 .46 .70 .58 .67 .71 .28 0; % Coca Cola Co.
.70 1 .47 .42 .59 .58 .55 .67 .62 .30 0; % Disney W. Co.
.41 .47 1 .25 .54 .46 .57 .53 .55 .50 0; % Exxon Corp.
.32 .42 .25 1 .45 .36 .35 .28 .22 .25 0; % Goodyear Co.
.46 .59 .54 .45 1 .48 .58 .51 .53 .44 0; % International Paper
.70 .58 .46 .36 .48 1 .50 .65 .62 .22 0; % Merck Co.
.58 .55 .57 .35 .58 .50 1 .51 .59 .29 0; % Morgan J.P. Co.
.67 .67 .53 .28 .51 .65 .51 1 .67 .31 0; % Morris P. Co.
.71 .62 .55 .22 .53 .62 .59 .67 1 .30 0; % Proctor & Gamble
.28 .30 .50 .25 .44 .22 .29 .31 .30 1 0; % Texaco Oil Co.
0 0 0 0 0 0 0 0 0 0 1]; % US Treasury Bond

mu = ...
[2.885  2.426  1.647  1.745  2.056  3.196  1.727  3.364  1.851  1.869  0.407]';

sd = ...
[6.574  9.110  4.939 11.702  8.482  6.606  8.169  7.482  6.500  6.381  0]';


k_values = linspace(0, 0.9999, 1000);
sigmaport = zeros(size(k_values));
returnport = zeros(size(k_values));
y=zeros(11, length(k_values));

for i = 1:length(k_values)
    k = k_values(i);
    H = (1-k)*diag(sd)*rho*diag(sd);
    H = (H+H')/2;
    
    f = -k*mu;
    Aeq = ones(1,size(H,1));
    beq = 1;
    lb = zeros(size(H,1),1);
    ub = ones(size(H,1),1);

    x = quadprog(H,f,[],[],Aeq,beq,lb,ub);
    sigmaport(i) = sqrt(x' * H * x / (1 - k));
    returnport(i) = mu' * x;
    y(:,i)=x;

end

% Line Graph
figure;
yyaxis left
plot(k_values, sigmaport, 'b-', 'DisplayName', 'Portfolio Risk');
ylabel('Portfolio Risk');
xlabel('k');

yyaxis right
plot(k_values, returnport, 'r-', 'DisplayName', 'Portfolio Return');
ylabel('Portfolio Return');

title('Portfolio Risk and Return as a Function of k');
legend('show');
grid on;


% Number of bars
selected_k_values = linspace(0, 0.9999, 100);
selected_weights = zeros(size(mu, 1), length(selected_k_values));

for j = 1:length(selected_k_values)
    k = selected_k_values(j);
    H = (1 - k) * diag(sd) * rho * diag(sd);
    H = (H + H') / 2;

    f = -k * mu;
    Aeq = ones(1, size(H, 1));
    beq = 1;
    lb = zeros(size(H, 1), 1);
    ub = ones(size(H, 1), 1);

    x = quadprog(H, f, [], [], Aeq, beq, lb, ub);
    selected_weights(:, j) = x;
end


colours = [0.6350, 0.0780, 0.1840; % Coca Cola Co. - dark red
          0.5000, 0.5000, 0.5000; % Disney W. Co. - grey
          0.8700, 0.4900, 0.0000; % Exxon Corp. - brown
          0.4660, 0.6740, 0.1880; % Goodyear Co. - green
          0.9290, 0.6940, 0.1250; % International Paper - yellow
          0.4940, 0.1840, 0.5560; % Merck Co. - purple
          0.0000, 0.4470, 0.7410; % JP Morgan Co. - blue
          0.3010, 0.7450, 0.9330; % Morris P. Co. - light blue
          0.8500, 0.7250, 0.4980; % Procter & Gamble - beige
          0.3000, 0.7500, 0.3000; % Texaco Oil Co. - greenish
          0.8500, 0.3250, 0.0980]; % US Treasury Bond - orange


% Bar Chart
figure;
b = bar(selected_k_values, selected_weights', 'stacked');

for i = 1:length(b)
    b(i).FaceColor = colours(i, :);
end

xlabel('k');
ylabel('Portfolio Weights');
title('Portfolio Composition as a Function of k');
legend({'Coca Cola', 'Disney', 'Exxon', 'Goodyear', 'Intl Paper', 'Merck', 'JP Morgan', 'Philip Morris', 'Procter & Gamble', 'Texaco Oil', 'US Treasury Bond'}, 'Location', 'bestoutside');
grid on;

% Joint Graph
figure;

% Line Graph
subplot(2, 1, 1);
yyaxis left;
plot(k_values, sigmaport, 'b-', 'LineWidth', 1.5, 'DisplayName', 'Portfolio Risk');
ylabel('Portfolio Risk');
hold on;

yyaxis right;
plot(k_values, returnport, 'r-', 'LineWidth', 1.5, 'DisplayName', 'Portfolio Return');
ylabel('Portfolio Return');
xlabel('k');
title('Portfolio Risk and Return as a Function of k');
legend({'Portfolio Risk', 'Portfolio Return'}, 'Location', 'best');
grid on;

xline(0.2993, '--k', 'LineWidth', 1.5, 'HandleVisibility', 'off');
xline(0.5995, '--k', 'LineWidth', 1.5, 'HandleVisibility', 'off');
xline(0.8998, '--k', 'LineWidth', 1.5, 'HandleVisibility', 'off');
xline(0.9188, '--k', 'LineWidth', 1.5, 'HandleVisibility', 'off');
xline(0.9288, '--k', 'LineWidth', 1.5, 'HandleVisibility', 'off');
xline(0.9589, '--k', 'LineWidth', 1.5, 'HandleVisibility', 'off');

% Area Graph
subplot(2, 1, 2);
b = area(selected_k_values, selected_weights');
for i = 1:length(b)
    b(i).FaceColor = colours(i, :);
end
ylabel('Portfolio Weights');
xlabel('k');
title('Portfolio Composition as a Function of k');
legend({'Coca Cola', 'Disney', 'Exxon', 'Goodyear', 'Intl Paper', 'Merck', 'JP Morgan', 'Philip Morris', 'Procter & Gamble', 'Texaco Oil', 'US Treasury Bond'}, 'Location', 'best');
grid on;

xline(0.2993, '--k', 'LineWidth', 1.5, 'HandleVisibility', 'off');
xline(0.5995, '--k', 'LineWidth', 1.5, 'HandleVisibility', 'off');
xline(0.8998, '--k', 'LineWidth', 1.5, 'HandleVisibility', 'off');
xline(0.9188, '--k', 'LineWidth', 1.5, 'HandleVisibility', 'off');
xline(0.9288, '--k', 'LineWidth', 1.5, 'HandleVisibility', 'off');
xline(0.9589, '--k', 'LineWidth', 1.5, 'HandleVisibility', 'off');


% Pie Chart
indices = [1, 300, 600, 900, 919, 929, 959, 1000];

% Joint Graph
figure;

for i = 1:length(indices)
    subplot(2, 4, i);
    h = pie(y(:, indices(i))); 

    pieHandles = findobj(h, 'Type', 'Patch');
    for j = 1:length(colours)
        set(pieHandles(j), 'FaceColor', colours(j, :));
    end

    title(sprintf('Portfolio Composition at k = %.4f', k_values(indices(i))));
end

legend({'Coca Cola', 'Disney', 'Exxon', 'Goodyear', 'Intl Paper', 'Merck', 'JP Morgan', 'Philip Morris', 'Procter & Gamble', 'Texaco Oil', 'US Treasury Bond'}, 'Location', 'best', 'Direction', 'reverse');
grid on;



figure;
b = area(selected_k_values, selected_weights');
for i = 1:length(b)
    b(i).FaceColor = colours(i, :);
end
ylabel('Portfolio Weights');
xlabel('k');
title('Portfolio Composition as a Function of k');
legend({'Coca Cola', 'Disney', 'Exxon', 'Goodyear', 'Intl Paper', 'Merck', 'JP Morgan', 'Philip Morris', 'Procter & Gamble', 'Texaco Oil', 'US Treasury Bond'}, 'Location', 'best');
grid on;