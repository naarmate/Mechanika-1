clc; clear; close all;

%% ========================================================================
%  PŘÍKLAD 8.6 - PRUTOVÁ SOUSTAVA (Styčníková metoda a vizualizace)
% =========================================================================
%% 1. ZADÁNÍ A GEOMETRIE
a = 2;          % Rozměrový parametr [m]
P = 10000;      % Zatěžující síla [N]

s = 8;          % Počet styčníků
p = 13;         % Počet prutů
m = 3;          % Počet složek vnějších reakcí 

% Souřadnice styčníků: 1:A, 2:D, 3:E, 4:F, 5:B (dolní), 6:C, 7:G, 8:H (horní)
uzly = [0,   0; a,   0; 2*a, 0; 3*a, 0; 4*a, 0; a,   a; 2*a, a; 3*a, a];
nazvy_uzlu = {'A','D','E','F','B','C','G','H'};

% Topologie: propojení prutů [od_uzlu, do_uzlu]
pruty = [1, 2; 1, 6; 2, 6; 2, 3; 6, 3; 6, 7; 7, 3; 
         7, 8; 3, 8; 3, 4; 4, 8; 4, 5; 8, 5];

%% 2. GLOBÁLNÍ MATICOVÉ ŘEŠENÍ (Sestavení a výpočet)
% Globální matice A_glob (16x16) a vektor pravé strany b_glob
A_glob = zeros(2*s, p + m);
b_glob = zeros(2*s, 1);

% Příspěvky jednotlivých prutů
for k = 1:p
    u1 = pruty(k, 1);
    u2 = pruty(k, 2);
    dx = uzly(u2, 1) - uzly(u1, 1);
    dy = uzly(u2, 2) - uzly(u1, 2);
    L  = hypot(dx, dy);
    
    A_glob(2*u1-1, k) =  dx / L;
    A_glob(2*u1,   k) =  dy / L;
    A_glob(2*u2-1, k) = -dx / L;
    A_glob(2*u2,   k) = -dy / L;
end

% Příspěvky vazbových reakcí (RAx, RAy, RBy)
A_glob(1,  p+1) = 1; % RAx uzel 1
A_glob(2,  p+2) = 1; % RAy uzel 1
A_glob(10, p+3) = 1; % RBy uzel 5

% Vnější zatížení (-P ve směru y v uzlu 3 převádíme na pravou stranu)
b_glob(2*3) = P; 

% Řešení soustavy
x_glob = A_glob \ b_glob;
S_all  = x_glob(1:p);
reakce = x_glob(p+1:end);
RAy = reakce(2);
RBy = reakce(3);

%% 3. VIZUALIZACE VÝSLEDKŮ
fig = figure('Name', 'Rozložení sil v prutové soustavě', 'Color', 'w', ...
             'Position', [100, 100, 1200, 600]);
hold on; axis equal; grid on; box on;
title('Rozložení osových sil (Modrá = TAH, Červená = TLAK, Šedá = NULOVÉ)', ...
      'FontSize', 14, 'FontWeight', 'bold');
xlabel('x [m]'); ylabel('y [m]');
xlim([-1, 4*a+1]); ylim([-1.2, a+1]);

max_S = max(abs(S_all)); % Hledání absolutně největší síly pro detekci kritických prutů

for k = 1:p
    u1 = pruty(k, 1); u2 = pruty(k, 2);
    X = [uzly(u1,1), uzly(u2,1)]; Y = [uzly(u1,2), uzly(u2,2)];
    
    is_critical = abs(abs(S_all(k)) - max_S) < 1e-6; % Je tento prut kritický?
    
    if abs(S_all(k)) < 1e-6
        plot(X, Y, '--', 'Color', [0.6 0.6 0.6], 'LineWidth', 2);
        txt_str = sprintf('S_{%d}=0', k);
        txt_col = [0.4 0.4 0.4];
    elseif S_all(k) > 0
        lw = 2 + 4 * (abs(S_all(k)) / max_S);
        if is_critical, lw = lw + 3; end
        plot(X, Y, '-', 'Color', [0.1 0.45 0.85], 'LineWidth', lw);
        txt_str = sprintf('S_{%d}=%.0f N', k, S_all(k));
        txt_col = [0.05 0.3 0.65];
    else
        lw = 2 + 4 * (abs(S_all(k)) / max_S);
        if is_critical, lw = lw + 3; end
        plot(X, Y, '-', 'Color', [0.85 0.2 0.2], 'LineWidth', lw);
        txt_str = sprintf('S_{%d}=%.0f N', k, S_all(k));
        txt_col = [0.7 0.1 0.1];
    end
    
    % Zvýraznění popisku pro kritické pruty
    if is_critical
        txt_str = [txt_str, ' [MAX]']; %#ok<AGROW> 
        font_weight = 'bold'; font_size = 12;
        bg_col = [1 0.95 0.8]; % Jemně žluté pozadí pro kritické popisky
    else
        font_weight = 'normal'; font_size = 11;
        bg_col = [1 1 1 0.85];
    end
    
    text(mean(X), mean(Y) + 0.18, txt_str, 'HorizontalAlignment', 'center', ...
         'FontSize', font_size, 'FontWeight', font_weight, 'Color', txt_col, ...
         'BackgroundColor', bg_col, 'Margin', 1.5);
end

% Vykreslení styčníků a reakcí
plot(uzly(:,1), uzly(:,2), 'ko', 'MarkerFaceColor', 'w', 'MarkerSize', 8, 'LineWidth', 1.5);
for i = 1:s
    text(uzly(i,1)-0.15, uzly(i,2)-0.28, nazvy_uzlu{i}, 'FontWeight', 'bold', 'FontSize', 12);
end
quiver(2*a, 0, 0, -0.9, 0, 'Color', [0.8 0.3 0], 'LineWidth', 2.5, 'MaxHeadSize', 0.6);
text(2*a+0.15, -0.6, sprintf('P = %d N', P), 'Color', [0.8 0.3 0], 'FontWeight', 'bold', 'FontSize', 12);
quiver(0, -0.8, 0, 0.75, 0, 'Color', [0 0.6 0.2], 'LineWidth', 2, 'MaxHeadSize', 0.6);
text(-0.8, -0.5, sprintf('R_{Ay}=%.0f N', RAy), 'Color', [0 0.6 0.2], 'FontWeight', 'bold', 'FontSize', 12);
quiver(4*a, -0.8, 0, 0.75, 0, 'Color', [0 0.6 0.2], 'LineWidth', 2, 'MaxHeadSize', 0.6);
text(4*a+0.15, -0.5, sprintf('R_{By}=%.0f N', RBy), 'Color', [0 0.6 0.2], 'FontWeight', 'bold', 'FontSize', 12);