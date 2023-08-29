clear;
close all;
clc;

% kvadratni klasifikator metodom zeljenog izlaza
% generisemo nelinearno separabilne klase

N = 500;

phi1 = 2*pi*rand(1, N); % podjednaka ver za svaki ugao
rho1 = rand(1, N); % poluprecnik je 1
X = zeros(2, N);
X(1, :) = rho1.*cos(phi1);
X(2, :) = rho1.*sin(phi1);

phi2 = 2*pi*rand(1, N);
rho2 = rand(1, N) + 2; % prsten
Y = zeros(2, N);
Y(1, :) = rho2.*cos(phi2);
Y(2, :) = rho2.*sin(phi2);

figure();
hold on;
scatter(X(1, :), X(2, :), 'bo');
scatter(Y(1, :), Y(2, :), 'ro');

Gamma = ones(2*N, 1);

U = [-1*ones(1, N), ones(1, N); ...
    -1*X, Y; ...
    -1*X(1, :).^2, Y(1, :).^2; ...
    -1*X(2, :).^2, Y(2, :).^2; ...
    -2*X(1, :).*X(2, :), 2*Y(1, :).*Y(2, :)];
W = (U*U')^(-1)*U*Gamma;
v0 = W(1);
V1 = W(2);
V2 = W(3);
Q11 = W(4);
Q22 = W(5);
Q12 = W(6);

x1 = -3:0.1:3;
x2 = -3:0.1:3;
h = zeros(length(x1), length(x2));
for i = 1:length(x1)
    for j = 1:length(x2)
        h(i, j) = v0 + V1*x1(i) + V2*x2(j) + ...
            Q11*(x1(i)).^2 + Q22*(x2(j)).^2 +...
            Q12*x1(i)*x2(j);
    end
end

contour(x1, x2, h, [0, 0]);