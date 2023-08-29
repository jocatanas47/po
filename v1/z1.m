clear;
close all;
clc;

% polimodalna gausova raspodela
% npr f(x) = 0.5f1(x) + 0.5f2(x)

% M i S su paremetri gausove raspode;a
% d^2 kriva - kriva gde je fgv konstantna
% - secemo fgv ravni

M0 = [-2, -2]';
S0 = [1, 0.5; 0.5, 1];
M1 = [4, 4]';
S1 = [2, -0.5; -0.5, 2];
M2 = [4, 8]';
S2 = [0.9, 0.7; 0.7, 0.9];
M3 = [-4, 6]';
S3 = [1.5, 0.5; 0.5, 1.5];

x = -10:0.1:10;
y = -10:0.1:10;

f0 = zeros(length(x), length(y));
f1 = zeros(length(x), length(y));
f2 = zeros(length(x), length(y));
f3 = zeros(length(x), length(y));
f = f3;

for i = 1:length(x)
    for j = 1:length(y)
        X = [x(i); y(j)];
        f0(i, j) = 1/(2*pi*det(S0)^0.5) * ...
            exp(-0.5*(X - M0)'*inv(S0)*(X - M0));
        f1(i, j) = 1/(2*pi*det(S1)^0.5) * ...
            exp(-0.5*(X - M1)'*inv(S1)*(X - M1));
        f2(i, j) = 1/(2*pi*det(S2)^0.5) * ...
            exp(-0.5*(X - M2)'*inv(S2)*(X - M2));
        f3(i, j) = 1/(2*pi*det(S3)^0.5) * ...
            exp(-0.5*(X - M3)'*inv(S3)*(X - M3));
        f(i, j) = 0.4*f1(i, j) + 0.3*f2(i, j) + 0.3*f3(i, j);
    end
end

figure(1)
mesh(x, y, f');

% D2 krive
% (X - M0)'*inv(S0)*(X - M0) - statisticko odstojanje, 
% ono je jednako ovom vektoru d2

d2 = [1, 4, 9];

figure(2);
contour(x, y, f0);

% prag - const_ispred_raspodele * exp(-0.5*d2)
prag = max(max(f0))*exp(-0.5*d2);
figure(3);
hold all;
contour(x, y, f0, prag);

prag = max(max(f))*exp(-0.5*d2);
contour(x, y, f, prag);