clear;
close all;
clc;

% 3 vrste irisa
% 4 obelezja
% - sepal length [cm]
% - sepal width [cm]
% - petal length [cm]
% - petal width [cm]
% klase
% - 3 irisa

load('Iris_podaci.mat');
X1 = X(Y == 1, :);
X2 = X(Y == 2, :);
X3 = X(Y == 3, :);

% podela na trening i test (70% train 30% test)
X1_train = X1(1:round(0.7*50), :);
X2_train = X2(1:round(0.7*50), :);
X3_train = X3(1:round(0.7*50), :);

X1_test = X1(round(0.7*50) + 1:50, :);
X2_test = X2(round(0.7*50) + 1:50, :);
X3_test = X3(round(0.7*50) + 1:50, :);

% LDA
S1 = cov(X1_train);
S2 = cov(X2_train);
S3 = cov(X3_train);
M1 = mean(X1_train)';
M2 = mean(X2_train)';
M3 = mean(X3_train)';

SW = 1/3*S1 + 1/3*S2 + 1/3*S3;
M0 = 1/3*M1 + 1/3*M2 + 1/3*M3;
SB = 1/3*(M1 - M0)*(M1 - M0)' ...
    + 1/3*(M2 - M0)*(M2 - M0)' ...
    + 1/3*(M3 - M0)*(M3 - M0)';
T = SW^-1*SB;
[P, L] = eig(T); 
P = P; % smer nebitan za separabilnost al su promenili smer u novoj verziji

A = P(:, 1:2); % jedine dve nenulte sopstvene vrednosti
Y1_train = A'*X1_train';
Y2_train = A'*X2_train';
Y3_train = A'*X3_train';
Y1_test = A'*X1_test';
Y2_test = A'*X2_test';
Y3_test = A'*X3_test';

figure();
hold all;
scatter(Y1_train(1, :), Y1_train(2, :), 'filled');
scatter(Y2_train(1, :), Y2_train(2, :), 'filled');
scatter(Y3_train(1, :), Y3_train(2, :), 'filled');
legend('Iris Setosa', 'Iris Vesticolour', 'Iris Virginica');

% KNN klasifikator
k = 5;
Y_test = [Y1_test, Y2_test, Y3_test];
Y_train = [Y1_train, Y2_train, Y3_train];
Y_train_c = [ones(1, 35), 2*ones(1, 35), 3*ones(1, 35)];
Y_true = [ones(1, 15), 2*ones(1, 15), 3*ones(1, 15)];
Y_pred = zeros(size(Y_true));

for i = 1:length(Y_true)
    Y_cur = Y_test(:, i);
    euklidske = sqrt((Y_train(1, :) - Y_cur(1)).^2 ...
        + (Y_train(2, :) - Y_cur(2)).^2);
    [euklidske, index] = sort(euklidske, 'ascend');
    Y_train_c = Y_train_c(index);
    Y_train = Y_train(:, index);
    Y_pred(i) = mode(Y_train_c(1:k)); % koja klasa se najcesce javlja
end

C = confusionmat(Y_true, Y_pred);