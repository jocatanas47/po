clear;
close all;
clc;

fullpath = 'C:\Users\tj190054d\Faks\matlabkod\po\vezbe\v1\Baza_A';
x = dir('Baza_A');

% dir ucita nesto glupo u prva dva mesta pa citamo od 3
for i = 3:max(size(x))
    filename = fullfile(fullpath, x(i).name);
    X = imread(filename);
    Y = isecanje(X);
    imshow(Y);
    pause;
end

% ideje za obelezja
% crni pikseli u sredini -> A
% odnos piksela gore i dole, simetricno -> O

% fullpath = 'C:\Users\tj190054d\Faks\matlabkod\po\vezbe\v1\Baza_O';
% x = dir('Baza_O');
% 
% % dir ucita nesto glupo u prva dva mesta pa citamo od 3
% for i = 3:max(size(x))
%     filename = fullfile(fullpath, x(i).name);
%     X = imread(filename);
%     % imshow(X);
%     % pause;
% end