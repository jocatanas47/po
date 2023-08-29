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
scatter(X1(1, :), X1(2, :), 'ro');
scatter(X2(1, :), X2(2, :), 'bo');

% linearni klasifikator - druga numericka metoda
N1 = length(X1(1, :));
N2 = length(X2(1, :));
M1_est = mean(X1, 2);
M2_est = mean(X2, 2);
S1_est = cov(X1');
S2_est = cov(X2');

s = 0:1e-3:1;
v0_opt_s = []; % optimalno v0 za fiksno s
Neps_s = []; % greska klasifikacije za fiksno s
for i = 1:length(s)
    % pronalazimo V
    V = ((s(i)*S1_est + (1 - s(i))*S2_est)^(-1))*(M2_est - M1_est);
    % projektujemo odbirke obe klase na V
    Y1 = V'*X1;
    Y2 = V'*X2;
    Y = [Y1, Y2];
    Y = sort(Y);
    % petlja po v0 + brojanje gresaka
    v0 = [];
    Neps = []; % za jedno s i svako v0 pamtimo gresku
    for j = 1:(length(Y) - 1)
        v0(j) = -(Y(j) + Y(j + 1))/2; % tacno izmedju dve susedne projekcije
        Neps(j) = 0;
        for k = 1:N1
            if (Y1(k) > -v0(j))
                Neps(j) = Neps(j) + 1;
            end
        end
        for k = 1:N2
            if (Y2(k) < -v0(j))
                Neps(j) = Neps(j) + 1;
            end
        end
    end
    [Neps_s(i), indx] = min(Neps);
    v0_opt_s(i) = v0(indx);
end

[Neps_opt, indx] = min(Neps_s);
v0_opt = v0_opt_s(indx);
s_opt = s(indx);

% iscrtavanje klasifikacione linije
V = ((s_opt*S1_est + (1 - s_opt)*S2_est)^-1)*(M2_est - M1_est);

x1 = -2:0.1:10;
x2 = -(v0_opt + V(1)*x1)/V(2);
figure(1);
plot(x1, x2, 'k');


% iscrtavanje [rpjekcija odbiraka na V
Y1 = V'*X1;
Y2 = V'*X2;
figure(2);
hold all;
plot(Y1, zeros(1, N), 'r*');
plot(Y2, zeros(1, N), 'b*');
plot([-v0_opt -v0_opt], [-1 1], 'k', 'LineWidth', 1.5);