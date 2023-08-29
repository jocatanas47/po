clear;
close all;
clc;

% generisemo unimodalnu i polimodalnu gausovu
N = 1000;
M1 = [0 0]';
S1 = [1 0.5; 0.5 1];
M2 = [5 0]';
S2 = [1.5 -0.7; -0.7 1.5];
M3 = [6 6]';
S3 = [1 0.6; 0.6 1];

K1 = mvnrnd(M1, S1, N); %klasa jedan - unimodalna

% pomocne promenjive
pom = rand(N, 1);
K21 = mvnrnd(M2, S2, N);
K22 = mvnrnd(M3, S3, N);
K2 = (pom < 0.6).*K21 + (pom >= 0.6).*K22;

figure(1);
hold all;
scatter(K1(:, 1), K1(:, 2), 'ro');
scatter(K2(:, 1), K2(:, 2), 'bo');
grid on;

% Bayes-ov klasifikator minimalne greske

x = -5:0.1:12;
y = -5:0.1:12;
f1 = zeros(length(x), length(y));
f2 = zeros(length(x), length(y));
const1 = 1/(2*pi*det(S1)^0.5);
const2 = 1/(2*pi*det(S2)^0.5);
const3 = 1/(2*pi*det(S3)^0.5);
for i = 1:length(x)
    for j = 1:length(y)
        X = [x(i) y(j)]';
        f1(i, j) = const1*exp(-0.5*(X - M1)'*inv(S1)*(X - M1));
        f21 = const2*exp(-0.5*(X - M2)'*inv(S2)*(X - M2));
        f22 = const3*exp(-0.5*(X - M3)'*inv(S3)*(X - M3));
        f2(i, j) = 0.6*f21 + 0.4*f22;
    end
end

figure(1);
h = -log(f1./f2); % f-ja h u svakoj tacki prostora
contour(x, y, h', [0 0], 'g', 'Linewidth', 1.5);

% formula
% f1/f2 > (c12 - c22)/(c21 - c11) -> w1
% < -> w2
% cij - cena smestanja j-te klase u i-tu
% c11 = c22 = 0

% Bayes-ov klasifikator minimalne cene

c11 = 0;
c22 = 0;
c12 = 1;
c21 = 5; % vise penalizujemo pogresnu klasifikaciju odbirka iz klase 1

t = (c12 - c22)/(c21 - c11);
k = f1./f2;

figure(1);
contour(x, y, k', [t t], 'm', 'Linewidth', 1.5);

% procena greske klasifikacije - konfuziona matrica

% spajamo sve odbirke u jedan vektor, stvarne klase znamo, a klasifikator
% daje predikciju

Xs = [K1' K2'];
X_true = [ones(1, N), 2*ones(1, N)];
X_pred = zeros(size(X_true));
for i = 1:length(Xs)
    X = Xs(:, i);
    f1 = const1*exp(-0.5*(X - M1)'*inv(S1)*(X - M1));
    f21 = const2*exp(-0.5*(X - M2)'*inv(S2)*(X - M2));
    f22 = const3*exp(-0.5*(X - M3)'*inv(S3)*(X - M3));
    f2 = 0.6*f21 + 0.4*f22;
    if (f1 > f2)
        X_pred(i) = 1;
    else
        X_pred(i) = 2;
    end
end

C = confusionmat(X_true, X_pred);
figure(2);
confusionchart(C);

err1 = C(1, 2)/sum(C(1, :));
err2 = C(2, 1)/sum(C(2, :));
disp(err1);
disp(err2);

% procena greske klasifikacije - teorijski pristup
% ne radi ne znam zasto - sad radi

x = -5:0.1:12;
y = -5:0.1:12;
f1 = zeros(length(x), length(y));
f2 = zeros(length(x), length(y));
const1 = 1/(2*pi*det(S1)^0.5);
const2 = 1/(2*pi*det(S2)^0.5);
const3 = 1/(2*pi*det(S3)^0.5);
e1 = 0;
e2 = 0;

for i = 1:length(x)
    for j = 1:length(y)
        X = [x(i) y(j)]';
        f1(i, j) = const1*exp(-0.5*(X - M1)'*inv(S1)*(X - M1));
        f21 = const2*exp(-0.5*(X - M2)'*inv(S2)*(X - M2));
        f22 = const3*exp(-0.5*(X - M3)'*inv(S3)*(X - M3));
        f2(i, j) = 0.6*f21 + 0.4*f22;
        h = -log(f1(i, j)/f2(i, j));
        if (h < 0) % u oblasti L1
            e2 = e2 + 0.1*0.1*f2(i, j);
        else % u oblasti L2
            e1 = e1 + 0.1*0.1*f1(i, j);
        end
    end
end

disp(e1);
disp(e2);

% sa realnim podacima - podatke je ona sredila sa proslog casa

load('Slova_obelezja.mat');
figure(3);
hold all;
scatter(P1(1, :), P1(2, :), 'ro');
scatter(P2(1, :), P2(2, :), 'bo');
hold off;

figure(4);
hold all;
hist3(P1');
hist3(P2');

% vidi se da nije gaus