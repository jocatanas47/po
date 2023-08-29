clear;
close all;
clc;

N = 1000;
K0 = randn(2, N);

M1 = [1; 3];
S1 = [1.2, 0.9; 0.9, 1.2];
M2 = [5; 1];
S2 = [1, -0.2; -0.2, 1];

[F1, L1] = eig(S1);
[F2, L2] = eig(S2);

K1 = F1*(L1^0.5)*K0 + M1; % transformacija bojenja
K2 = F2*(L2^0.5)*K0 + M2;

figure();
hold all;
scatter(K1(1, :), K1(2, :), 'ro');
scatter(K2(1, :), K2(2, :), 'bo');
legend('Klasa 1', 'Klasa 2');

% transformacija beljenja
[F, L] = eig(S1);
K1_izbeljeno = (F*L^(-0.5))'*(K1 - M1*ones(1, N));

figure();
hold all;
scatter(K1(1, :), K1(2, :), 'ro');
scatter(K1_izbeljeno(1, :), K1_izbeljeno(2, :), 'bo');
legend('Klasa 1', 'Klasa 1 nakon izbeljivanja');


% Neyman-Pearson-ov test - nije dobro uwu
x = -5:0.1:10;
y = -5:0.1:10;
f1 = zeros(length(x), length(y));
f2 = zeros(length(x), length(y));

for i = 1:length(x)
    for j = 1:length(y)
        X = [x(i); y(j)];
        f1(i, j) = 1/(2*pi*det(S1)^0.5) * ...
            exp(-0.5*(X - M1)'*inv(S1)*(X - M1));
        f2(i, j) = 1/(2*pi*det(S2)^0.5) * ...
            exp(-0.5*(X - M2)'*inv(S2)*(X - M2));
    end
end
h = -log(f1./f2);

br = 0;
for mu = 0.01:0.01:10
    br = br + 1;
    eps2(br) = 0;
    for i = 1:(length(x) - 1)
        for j = 1:(length(y) - 1)
            if (h(i, j) < -log(mu))
                eps2(br) = eps2(br) + ...
                    0.1*0.1*(f2(i, j) + f2(i + 1, j) + ... 
                    f2(i, j + 1) + f2(i + 1, j + 1))/4;
            end
        end
    end
end

figure();
plot(0.01:0.01:10, eps2);