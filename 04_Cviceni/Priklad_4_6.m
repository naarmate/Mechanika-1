clc; clear; close all;

% Zadani
M = 1500;
G = 5000;
h = 4;
a = 2.5;
b = 1.5;

% Vypocet linearni soustavy rovnic
sin_alfa = a/sqrt(a^2+b^2);
cos_alfa = b/sqrt(a^2+b^2);

A = [1 0 -cos_alfa
     0 1 -sin_alfa
     0 0 cos_alfa*a];

F = [0
     G
     M];

R = A\F;

% Reakce
RAx = R(1)
RAy = R(2)
RA = sqrt(RAx^2 + RAy^2)
S1 = R(3)
S2 = 0