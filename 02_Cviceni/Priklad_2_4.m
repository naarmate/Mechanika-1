% 2.cviceni Mechanika I. - Priklad 2.4 - Rovnovazna bodu v prostoru
clc; clear; close all; 

% Zadano
G = 600;  % [N]    
xA = 1;     yA = -1;    zA = 0; 
xB = -2;    yB = -2;    zB = 0;
xC = 0;     yC = 2;     zC = 0;
xD = 0;     yD = 0;     zD = -2;
     
% Jednotkove vektory
fA = [xA-xD; yA-yD; zA-zD]/sqrt((xD-xA)^2+(yD-yA)^2+(zD-zA)^2);
fB = [xB-xD; yB-yD; zB-zD]/sqrt((xD-xB)^2+(yD-yB)^2+(zD-zB)^2); 
fC = [xC-xD; yC-yD; zC-zD]/sqrt((xD-xC)^2+(yD-yC)^2+(zD-zC)^2);

% Vypocet soustavy linearnich rovnic
A = [fA fB fC]     %[1] matice koeficientu pro vypocet sil v lanech.
b = [ 0; 0; G];     %[N] vektor pravych stran pro rovnice rovnovahy
x = A\b;            % Vypocet sil v prutech (x = A\b dava reseni soustavy linearnich rovnic "A*x = b")

F_A = x(1)
F_B = x(2)
F_C = x(3)