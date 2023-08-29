clear; 
close all; 
clc;

slova = load('mixoutALL_shifted.mat');
S = slova.mixout(1014:1076);
lenS = 1076-1014;
V = slova.mixout(1145:1217);   
lenV = 1217-1145;
O = slova.mixout(749:815);
lenO = 815-749;

% podaci su brzine kretanja markera na tabli
% identifikujemo pisana slova
% radimo sumu da bismo nasli pozicije

% iscrtavanje slova i brzina

% izdvajamo po jedno slovo
% slova su strukture pa idu viticaste
S1 = S{4};
V1 = V{5};
O1 = O{4};

% brzine po x i y osi
Sx = S1(1, :);
Vx = V1(1, :);
Ox = O1(1, :);
Sy = S1(2, :);
Vy = V1(2, :);
Oy = O1(2, :);

% pozicije
Sxp = cumsum(Sx);
Vxp = cumsum(Vx);
Oxp = cumsum(Ox);
Syp = cumsum(Sy);
Vyp = cumsum(Vy);
Oyp = cumsum(Oy);
Oy = O1(2, :);

figure(1)
subplot(2, 2, [1, 3]);
scatter(Sxp, Syp);
subplot(2, 2, 2);
plot(Sx);
subplot(2, 2, 4);
plot(Sy);

figure(2)
subplot(2, 2, [1, 3]);
scatter(Vxp, Vyp);
subplot(2, 2, 2);
plot(Vx);
subplot(2, 2, 4);
plot(Vy);

figure(3)
subplot(2, 2, [1, 3]);
scatter(Oxp, Oyp);
subplot(2, 2, 2);
plot(Ox);
subplot(2, 2, 4);
plot(Oy);

% obelezja
% prolazak brzine kroz nulu - ali lose zato sto je diskretno
% visina maksimuma
% najbolja su obelezja na kontinualnim vrednostima

% obelezje1 = maxVx - maxVx
% obelezje2 = maxVy - minVy

% izdvajanje obelezja
S_ob = zeros(2, lenS);

V_ob = zeros(2, lenV);

O_ob = zeros(2, lenO);

for i = 1:lenS
    S_cur = S{i};
    S_ob(1, i) = obelezje1(S_cur(1, :), S_cur(2, :));
    S_ob(2, i) = obelezje2(S_cur(1, :), S_cur(2, :));
end

for i = 1:lenV
    V_cur = V{i};
    V_ob(1, i) = obelezje1(V_cur(1, :), V_cur(2, :));
    V_ob(2, i) = obelezje2(V_cur(1, :), V_cur(2, :));
end

for i = 1:lenS
    O_cur = O{i};
    O_ob(1, i) = obelezje1(O_cur(1, :), O_cur(2, :));
    O_ob(2, i) = obelezje2(O_cur(1, :), O_cur(2, :));
end

% crtanje klasa i podela na trening skup
X1 = V_ob(:, 1:50);
X2 = S_ob(:, 1:50);
X3 = O_ob(:, 1:50);

X1_test = V_ob(:, 50:62);
X2_test = S_ob(:, 50:62);
X3_test = O_ob(:, 50:62);

figure();
hold all;
plot(X1(1, :), X1(2, :), 'rx');
plot(X2(1, :), X2(2, :), 'gx');
plot(X3(1, :), X3(2, :), 'bx');
legend('V', 'S', 'O');

% klasifikator distance
% na osnovu euklidske distance do matematickog ocekivanje 
% odredjujemo kojoj klasi pripada

X_test = [X1_test, X2_test, X3_test];
X_true = [ones(1, 13), 2*ones(1, 13), 3*ones(1, 13)];
X_pred = zeros(size(X_true));

M1 = mean(X1, 2); 
M2 = mean(X2, 2); 
M3 = mean(X3, 2); 

for i = 1:length(X_true)
    X_cur = X_test(:, i);
    % euklidske distance
    e1 = sqrt(sum((X_cur - M1).^2));
    e2 = sqrt(sum((X_cur - M2).^2));
    e3 = sqrt(sum((X_cur - M3).^2));
    e = [e1, e2, e3];
    [~, X_pred(i)] = min(e);
end

C = confusionmat(X_true, X_pred)

% klasifikaciona linija klasifikatora distance je normala na duz