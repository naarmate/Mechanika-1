clc; clear; close all;

%% Zadané parametry
r = 0.036;           % [m] délka ramene kliky
l = 0.133;           % [m] délka ojnice
phi = 30 * (pi/180); % [rad] úhel natočení kliky (30 stupňů)
P = 800;             % [N] zatěžující síla na píst

%% Geometrie
psi = asin( (r/l)*sin(phi) );

%% Soustava lineárních rovnic
% Matice soustavy (7 rovnic, 7 neznámých)
% Pořadí vektoru neznámých: [ROx, ROy, RA, RB, N, N*n, M2]'
A = [   1, 0, cos(psi), 0, 0, 0, 0;
        0, 1, -sin(psi), 0, 0, 0, 0;
        0, 0, -r*sin(phi+psi), 0, 0, 0, -1;
        0, 0, 1, -1, 0, 0, 0;
        0, 0, 0, -cos(psi), 0, 0, 0;
        0, 0, 0, sin(psi), 1, 0, 0;
        0, 0, 0, 0, 0, 1, 0    ];

% Vektor pravých stran
b = [0; 0; 0; 0; P; 0; 0];

% Řešení soustavy
x = A \ b; 

ROx = x(1) 
ROy = x(2)
RA  = x(3)
RB  = x(4)
N   = x(5)
Nn  = x(6)
M2  = x(7)

n = Nn / N % Výpočet ramene normálové reakce