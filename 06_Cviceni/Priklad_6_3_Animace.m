clc; clear; close all;

%% Zadané parametry
r = 0.036;           % [m] délka ramene kliky
l = 0.133;           % [m] délka ojnice
phi = 30 * (pi/180); % [rad] úhel natočení kliky (30 stupňů)
P = 800;             % [N] zatěžující síla na píst

kroky = 120;
phi_vec = linspace(0, 2*pi, kroky);

%% 1. Výpočet pro celou otáčku
% Příprava matice pro uložení všech 9 neznámých:
% 1:ROx, 2:ROy, 3:RAx, 4:RAy, 5:RBx, 6:RBy, 7:N, 8:Nn, 9:M2
X_mat = zeros(9, kroky);

for i = 1:kroky
    phi = phi_vec(i);
    psi = asin( (r/l)*sin(phi) );
    
    A = [   1, 0, 1, 0, 0, 0, 0, 0, 0;
            0, 1, 0, 1, 0, 0, 0, 0, 0;
            0, 0, -r*sin(phi), r*cos(phi), 0, 0, 0, 0, -1;
            0, 0, -1, 0, 1, 0, 0, 0, 0;
            0, 0, 0, -1, 0, 1, 0, 0, 0;
            0, 0, 0, 0, l*sin(psi), l*cos(psi), 0, 0, 0;
            0, 0, 0, 0, -1, 0, 0, 0, 0;
            0, 0, 0, 0, 0, -1, 1, 0, 0;
            0, 0, 0, 0, 0, 0, 0, 1, 0   ];

    b = [0; 0; 0; 0; 0; 0; P; 0; 0];
    
    X_mat(:, i) = A \ b;
end

% Dopočet ramene n = Nn / N [m]
% V bodech, kde N přechází nulou, vynecháme singularitu dělení
n_vec = X_mat(8, :) ./ X_mat(7, :);
n_vec(abs(X_mat(7, :)) < 1e-4) = NaN; 

phi_deg = rad2deg(phi_vec);

%% 2. Vykreslení všech neznámých
figure(1); clf;
set(gcf, 'Color', 'w');
tl = tiledlayout(3, 2, 'TileSpacing', 'compact', 'Padding', 'compact');
title(tl, 'Průběhy všech neznámých', 'FontWeight', 'bold');

% 1. Čep O (rám - klika)
nexttile;
plot(phi_deg, X_mat(1,:), 'b-', 'LineWidth', 1.8); hold on;
plot(phi_deg, X_mat(2,:), 'b--', 'LineWidth', 1.8);
grid on; xlim([0 360]);
ylabel('Síla [N]');
legend('R_{Ox}', 'R_{Oy}', 'Location', 'best');
title('Reakce v rámu (čep O)');

% 2. Čep A (klika - ojnice)
nexttile;
plot(phi_deg, X_mat(3,:), 'Color', '#D95319', 'LineStyle', '-', 'LineWidth', 1.8); hold on;
plot(phi_deg, X_mat(4,:), 'Color', '#D95319', 'LineStyle', '--', 'LineWidth', 1.8);
grid on; xlim([0 360]);
ylabel('Síla [N]');
legend('R_{Ax}', 'R_{Ay}', 'Location', 'best');
title('Reakce v čepu A');

% 3. Čep B (ojnice - píst)
nexttile;
plot(phi_deg, X_mat(5,:), 'Color', '#EDB120', 'LineStyle', '-', 'LineWidth', 1.8); hold on;
plot(phi_deg, X_mat(6,:), 'Color', '#EDB120', 'LineStyle', '--', 'LineWidth', 1.8);
grid on; xlim([0 360]);
ylabel('Síla [N]');
legend('R_{Bx}', 'R_{By}', 'Location', 'best');
title('Reakce v čepu B');

% 4. Normálová reakce vedení pístu N
nexttile;
plot(phi_deg, X_mat(7,:), 'Color', '#77AC30', 'LineWidth', 1.8);
grid on; xlim([0 360]);
ylabel('N [N]');
legend('N', 'Location', 'best');
title('Normálová reakce');

% 5. Hnací moment M2
nexttile;
plot(phi_deg, X_mat(9,:), 'r-', 'LineWidth', 2);
grid on; xlim([0 360]);
xlabel('$\varphi \ [^\circ]$', 'Interpreter', 'latex');
ylabel('M_2 [Nm]');
legend('M_2', 'Location', 'best');
title('Hnací moment M_2');

% 6. Excentricita působiště n (případně pomocná neznámá N*n)
nexttile;
plot(phi_deg, n_vec * 1e3, 'k-', 'LineWidth', 1.8);
grid on; xlim([0 360]);
xlabel('$\varphi \ [^\circ]$', 'Interpreter', 'latex');
ylabel('n [mm]');
legend('n', 'Location', 'best');
title('Působiště reakce pístu (rameno n)');

%% 3. Animace mechanismu
figure(2); clf;
fig = gcf;
set(fig, 'Color', 'w'); % Bílé pozadí okna

% Nastavení fixních os a mřížky
axis equal; 
xlim([-0.1 0.25]);
ylim([-0.1 0.1]);
grid on; 
hold on;
xlabel('x [m]');
ylabel('y [m]');

% 1. INICIALIZACE GRAFICKÝCH OBJEKTŮ
h_klika  = plot([0 0], [0 0], 'k-', 'LineWidth', 4);
h_ojnice = plot([0 0], [0 0], 'k-', 'LineWidth', 3);
h_pist   = plot(0, 0, 'ks', 'MarkerSize', 16, 'MarkerFaceColor', [0.8 0.8 0.8], 'LineWidth', 1.5);
h_cepy   = plot([0 0 0], [0 0 0], 'ko', 'MarkerSize', 7, 'MarkerFaceColor', 'w', 'LineWidth', 1.5);

% Inicializace silových vektorů
h_RO = quiver(0, 0, 0, 0, 0, 'Color', '#0072BD', 'LineWidth', 2, 'MaxHeadSize', 0.5); % Modrá
h_RA = quiver(0, 0, 0, 0, 0, 'Color', '#D95319', 'LineWidth', 2, 'MaxHeadSize', 0.5); % Oranžová
h_RB = quiver(0, 0, 0, 0, 0, 'Color', '#EDB120', 'LineWidth', 2, 'MaxHeadSize', 0.5); % Žlutá/Zlatá (Reakce B)
h_N  = quiver(0, 0, 0, 0, 0, 'Color', '#77AC30', 'LineWidth', 2, 'MaxHeadSize', 0.5); % Zelená
h_P  = quiver(0, 0, 0, 0, 0, 'Color', 'r',       'LineWidth', 2, 'MaxHeadSize', 0.5); % Červená (Hnací síla P)

% --- Inicializace zástupných čar pro legendu (neviditelné na grafu) ---
d_RO = plot(NaN, NaN, 'Color', '#0072BD', 'LineWidth', 2, 'DisplayName', 'Reakce R_O');
d_RA = plot(NaN, NaN, 'Color', '#D95319', 'LineWidth', 2, 'DisplayName', 'Reakce R_A');
d_RB = plot(NaN, NaN, 'Color', '#EDB120', 'LineWidth', 2, 'DisplayName', 'Reakce R_B');
d_N  = plot(NaN, NaN, 'Color', '#77AC30', 'LineWidth', 2, 'DisplayName', 'Normálová reakce N');
d_P  = plot(NaN, NaN, 'Color', 'r',       'LineWidth', 2, 'DisplayName', 'Síla P');

% Vytvoření legendy před animační smyčkou
legend([d_RO, d_RA, d_RB, d_N, d_P], 'Location', 'southeast', 'AutoUpdate', 'off');

h_title = title('');
scale = 5e-5; % Vizuální měřítko sil

% 2. NEKONEČNÁ SMYČKA (běží, dokud existuje okno fig)
% pause_time = 1e-3;
pause_time = 0;
while ishandle(fig)
    for i = 1:kroky
        if ~ishandle(fig), break; end
        
        phi = phi_vec(i);
        sin_psi = (r / l) * sin(phi);
        cos_psi = sqrt(1 - sin_psi^2);
        
        % Kinematika bodů
        Ox = 0; 
        Oy = 0;
        Ax = r * cos(phi);     
        Ay = r * sin(phi);
        Bx = Ax + l * cos_psi; 
        By = 0;
        
        % Přepočet matice a sil
        A(3,3:4) = [-r*sin(phi), r*cos(phi)];
        A(6,5:6) = [l*sin_psi, l*cos_psi];
        x = A \ b;
        
        % Aktualizace geometrie
        set(h_klika,  'XData', [Ox Ax], 'YData', [Oy Ay]);
        set(h_ojnice, 'XData', [Ax Bx], 'YData', [Ay By]);
        set(h_pist,   'XData', Bx,      'YData', By);
        set(h_cepy,   'XData', [Ox Ax Bx], 'YData', [Oy Ay By]);
        
        % Aktualizace silových vektorů
        set(h_RO, 'XData', Ox, 'YData', Oy, 'UData', x(1)*scale, 'VData', x(2)*scale);
        set(h_RA, 'XData', Ax, 'YData', Ay, 'UData', x(3)*scale, 'VData', x(4)*scale);
        set(h_RB, 'XData', Bx, 'YData', By, 'UData', x(5)*scale, 'VData', x(6)*scale);
        set(h_N,  'XData', Bx, 'YData', By, 'UData', 0,          'VData', x(7)*scale);
        
        % Síla P: začíná na pravé hraně pístu a směřuje doleva (-P)
        set(h_P,  'XData', Bx + 0.045, 'YData', By, 'UData', -P*scale, 'VData', 0);
        
        % Aktualizace nadpisu
        set(h_title, 'String', sprintf('Poloha mechanismu: $\\varphi = %d^\\circ$', round(rad2deg(phi))), 'Interpreter', 'latex');
        
        drawnow;
        % pause(pause_time)
    end
end