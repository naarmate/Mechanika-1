clc; clear; close all;

%% Zadání
a = 2;      % [m]
P = 10000;  % [N]

%% Řešení
RAy = P/2;
sin_alfa = sqrt(2)/2;
cos_alfa = sqrt(2)/2;

A = [1 sin_alfa   1
     0 -cos_alfa  0
     a 0          0];

b = [0, -RAy, RAy*a]';

x = A\b;

%% Vypsání výsledku
S4 = x(1)
S5 = x(2)
S6 = x(3)