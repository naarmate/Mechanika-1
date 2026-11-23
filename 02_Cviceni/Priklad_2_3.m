% 2.cviceni Mechanika I. - Priklad 2.3 - Rovnovazna poloha objimky
clc; clear; close all; 

% Zadano
G = 300;            %[N] tiha objimky
r = 0.2;            %[m] polomer kladky
l = 1;              %[m] vzdalenost vedeni zavazi a trajektorie protizavazi
Z = 400;            % [N] tiha zavazi

% Uhel beta
cos_beta = G/Z;         % [1] cosinus uhlu mezi lanem a vedenim                
beta = acos(cos_beta);  % [Rad]

% Rovnovazna poloha
y_rov = (l-r)/tan(beta)-r/sin(beta)     % [m] rovnovazna poloha