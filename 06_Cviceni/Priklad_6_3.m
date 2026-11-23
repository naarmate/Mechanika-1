clc; clear; close all;

%% Zadané parametry
r = 0.036;           % [m] délka ramene kliky
l = 0.133;           % [m] délka ojnice
phi = 30 * (pi/180); % [rad] úhel natočení kliky (30 stupňů)
P = 800;             % [N] zatěžující síla na píst

%% Geometrie
psi = asin( (r/l)*sin(phi) );

%% Soustava lineárních rovnic
% Matice soustavy (9 rovnic, 9 neznámých)
% Pořadí vektoru neznámých: [ROx, ROy, RAx, RAy, RBx, RBy, N, N*n, M2]'
A = [   1, 0, 1, 0, 0, 0, 0, 0, 0;
        0, 1, 0, 1, 0, 0, 0, 0, 0;
        0, 0, -r*sin(phi), r*cos(phi), 0, 0, 0, 0, -1;
        0, 0, -1, 0, 1, 0, 0, 0, 0;
        0, 0, 0, -1, 0, 1, 0, 0, 0;
        0, 0, 0, 0, l*sin(psi), l*cos(psi), 0, 0, 0;
        0, 0, 0, 0, -1, 0, 0, 0, 0;
        0, 0, 0, 0, 0, -1, 1, 0, 0;
        0, 0, 0, 0, 0, 0, 0, 1, 0   ];

% Vektor pravých stran
b = [0; 0; 0; 0; 0; 0; P; 0; 0];

% Řešení soustavy
x = A \ b; 

ROx = x(1) 
ROy = x(2)
RAx = x(3)
RAy = x(4)
RBx = x(5)
RBy = x(6)
N   = x(7)
Nn  = x(8)
M2  = x(9)

n = Nn / N % Výpočet ramene normálové reakce