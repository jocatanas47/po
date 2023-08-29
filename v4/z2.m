clear;
close all;
clc;

N = 500;
rng(100);

M1 = [1; 1];
S1 = [1, 0; 0, 1];
M2 = [5; 8];
S2 = [1.2, 0.4; 0.4, 1.2];

X1 = mvnrnd(M1, S1, N)';
X2 = mvnrnd(M2, S2, N)';

figure();
hold all;
scatter(X1(1, :), X1(2, :), 'bo');
scatter(X2(1, :), X2(2, :), 'ro');

% linearni klasifikator metodom zeljenih izlaza
U = [-ones(1, N), ones(1, N); ... % redjamo [z1, ..., z(N1 + N2)]
    -1*X1, X2];
% nepoznati vektor W = [v0 V']';
Gamma = [2*ones(N, 1); 6*ones(N, 1)]; % uspravni vektor
% bitnija nam je dobra druga klasa dobro klasifikovana pa linija ide kroz
% prvu klasu
W = (U*U')^(-1)*U*Gamma;
v0 = W(1);
V1 = W(2);
V2 = W(3);

x1 = -2:0.1:10;
x2 = -(v0 + V1*x1)/V2;
figure(1);
plot(x1, x2, 'r--', 'LineWidth', 1.4);

% kvadratni klasifikator metodom zeljenog izlaza