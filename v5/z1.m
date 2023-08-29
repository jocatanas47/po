clear;
close all;
clc;

rng(100)

% Kreiranje klasa
M1 = [-2; -2; -2];
S1 = [1, 0.5, 0.5; 0.5, 1, 0.5; 0.5, 0.5, 1];
M2 = [2; 2; 2];
S2 = eye(3);
M3 = [-2; 5; 0];
S3 = 2*eye(3);

N = 1000;
K1 = mvnrnd(M1, S1, N);
K2 = mvnrnd(M2, S2, N);
K3 = mvnrnd(M3, S3, N);
X = [K1; K2; K3];

figure()
hold all;
scatter3(K1(:, 1), K1(:, 2), K1(:, 3), 'ro');
scatter3(K2(:, 1), K2(:, 2), K2(:, 3), 'bo');
scatter3(K3(:, 1), K3(:, 2), K3(:, 3), 'go');

% standarsizacija podataka
mean1 = mean(X(:, 1));
mean2 = mean(X(:, 2));
mean3 = mean(X(:, 3));
std1 = std(X(:, 1));
std2 = std(X(:, 2));
std3 = std(X(:, 3));

K1(:, 1) = (K1(:, 1) - mean1)/std1;
K2(:, 1) = (K2(:, 1) - mean1)/std1;
K3(:, 1) = (K3(:, 1) - mean1)/std1;
K1(:, 2) = (K1(:, 2) - mean2)/std2;
K2(:, 2) = (K2(:, 2) - mean2)/std2;
K3(:, 2) = (K3(:, 2) - mean2)/std2;
K1(:, 3) = (K1(:, 3) - mean3)/std3;
K2(:, 3) = (K2(:, 3) - mean3)/std3;
K3(:, 3) = (K3(:, 3) - mean3)/std3;

X = [K1; K2; K3];

% PCA (KL ekspanzija)

% 1. standardizacija dataset-a
% 2. procena kovariacione matrice
% 3. sopstveni vektori i vrednosti te matrice
% -> kovariaciona matrica simetricna => sopstveni vektori ortagonalni
% 4. sortiramo sopstvene vektora po lambda
% 5. Y = A'*X; A = [Phi1, Phi2, ... , Phim];

% mane PCA:
% - ne odrzaa separabilnost
% - obelezja nemaju fizicko znacenje

Sigma = cov(X);
[P, L] = eig(Sigma);
Lambdas = [L(1, 1), L(2, 2), L(3, 3)];
[Lambdas, index] = sort(Lambdas, 'descend');
P = P(:, index);
A = P(:, 1:2);
Y1 = K1*A;
Y2 = K2*A;
Y3 = K3*A;
Y = X*A;

figure();
hold all;
scatter(Y1(:, 1), Y1(:, 2), 'ro');
scatter(Y2(:, 1), Y2(:, 2), 'bo');
scatter(Y3(:, 1), Y3(:, 2), 'go');

% ugradjeni PCA
% vraca sopstvene vektore sortirane
coeff = pca(X); 

% LDA - zasnovan na matricama rasejanja

% uzima u ozir separabilnost klasa
% matrice rasejanja (scatter matrix)
% within-class scatter matrix
% between-class scatter matrix

SW = 1/3*S1 + 1/3*S2 + 1/3*S3;
M0 = 1/3*M1 + 1/3*M2 + 1/3*M3;
SB = 1/3*(M1 - M0)*(M1 - M0)' ...
    + 1/3*(M2 - M0)*(M2 - M0)' ...
    + 1/3*(M3 - M0)*(M3 - M0)';
% SM = SQ + SB - miksovana matrica rasejanja
T = SW^-1*SB;
[P, L] = eig(T);
A = P(:, 2:3);
Y1 = K1*A;
Y2 = K2*A;
Y3 = K3*A;
Y = X*A;

figure();
hold all;
scatter(Y1(:, 1), Y1(:, 2), 'ro');
scatter(Y2(:, 1), Y2(:, 2), 'bo');
scatter(Y3(:, 1), Y3(:, 2), 'go');