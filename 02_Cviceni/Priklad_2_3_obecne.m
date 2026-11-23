% 2.cviceni Mechanika I. - Priklad 2.3 - Rovnovazna poloha objimky
clc; clear; close all;

% Zadano
G = 300;            % [N] tiha zavazi
r = 0.2;            % [m] polomer kladky
l = 1;              % [m] vzdalenost vedeni zavazi a trajektorie protizavazi
Z = 320:1:820;      % [N] sit hodnot tihy protizavazi ulozena do vektoru
                    % [N] sila v lane je rovna tizi protizavazi Z (Vychazi z momentove rovnovahy na kladce.)
                    % ./ .* .^ jsou operace provadene zaroven na jednotlivych prvcich vektoru
                    % ( v Matlabu tzv. "array operations")
% Uhel beta
cos_beta = G./Z; 
beta = acos(cos_beta);  % [Rad]

% Rovnovazna poloha objimky
y_rov = (l-r)./tan(beta)-r./sin(beta);    % [m] 
   
% Vykreslení
figure(1);
hold on;
grid on;
plot(Z, y_rov, 'r', 'Linewidth', 2);
title('Rovnovážná poloha y_{rov}');
legend('Z = 320:1:820');
xlabel('Zatížení Z [N]');
ylabel('Rovnovážná poloha y_{rov} [m]');

figure(2);
hold on;
grid on;
plot(Z, beta, 'b', 'Linewidth', 2);
title('Rovnovážná poloha');
legend('Z = 320:1:820');
xlabel('Zatížení Z [N]');
ylabel('Úhel beta [rad]');