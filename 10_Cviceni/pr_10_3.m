clear; clc; close all;

% 1. Zadání vstupních parametrů
G   = 5600;     % Tíha výložníku [N]
Z   = 1500;     % Tíha břemene [N]
l   = 6;        % Délka výložníku [m]
r   = 1.2;      % Poloměr kruhového oblouku pro lano [m]
r1  = 0.2;      % Poloměr bubnu navijáku [m]
rc  = 0.040;    % Poloměr čepu B [m] (40 mm)
muc = 0.05;     % Součinitel čepového tření [-]

% 2. Diskretizace úhlu natočení výložníku
phi_deg = linspace(0, 90, 181);   % Úhel natočení [deg]
phi     = deg2rad(phi_deg);       % Úhel natočení [rad]

% 3. Výpočet síly v laně a hnacího momentu S pasivními účinky
F_pas = ( Z*(l*cos(phi) + rc*muc) + rc*muc*G ) / (r - rc*muc);
M_pas = F_pas*r1;

% 4. Výpočet síly v laně a hnacího momentu BEZ pasivních účinků
F_id = (Z*l*cos(phi)) / r;
M_id = F_id * r1;

% 5. Rozdíl momentů vlivem pasivních odporů
dM = M_pas - M_id;

% 6. Vykreslení výsledků
fig1 = figure('Name', 'Prubeh momentu M(phi)', 'Color', 'w', 'Position', [100, 120, 820, 620]);

% Horní graf: Celkový průběh M
subplot(2, 1, 1);
plot(phi_deg, M_pas, 'b-',  'LineWidth', 2.2); 
hold on; grid on;
plot(phi_deg, M_id,  'r--', 'LineWidth', 1.8);
xlabel('$\varphi$ [$^\circ$]', 'Interpreter', 'latex');
ylabel('$M$ [$\mathrm{N\cdot m}$]', 'Interpreter', 'latex');
title('Porovn\''an\''i hnac\''iho momentu $M(\varphi)$ s pasivn\''imi \''u\v{c}inky a bez nich', 'Interpreter', 'latex');
legend({'S pasivn\''imi \''u\v{c}inky $M(\varphi)$', 'Bez pasivn\''ich \''u\v{c}ink\r{u} $M_0(\varphi)$'}, ...
       'Interpreter', 'latex', 'Location', 'northeast');
xlim([0, 90]);

% Spodní graf: Detailní rozdíl
subplot(2, 1, 2);
plot(phi_deg, dM, 'Color', 'g', 'LineWidth', 2.2);
grid on;
xlabel('$\varphi$ [$^\circ$]', 'Interpreter', 'latex');
ylabel('P\v{r}\''ir\r{u}stek momentu $\Delta M$ [$\mathrm{N\cdot m}$]', 'Interpreter', 'latex');
title('Vliv pasivn\''ich odpor\r{u}: rozd\''il $\Delta M(\varphi) = M(\varphi) - M_0(\varphi)$', 'Interpreter', 'latex');
xlim([0, 90]);
ylim([0, max(dM) * 1.25]);


%% ========================================================================
%  ANIMACE MECHANISMU A VEKTORŮ SIL

% Reakce ve vazbách a třecí moment
R_By_pas = F_pas + G + Z;
R_Ay_pas = -F_pas;
M_c      = rc*muc * abs(R_By_pas);

figAnim = figure('Name', 'Animace mechanismu a vektoru sil', ...
                 'Color', 'w', 'Position', [80, 60, 1260, 700]);

% --- Levá část: Geometrie mechanismu ---
axMech = subplot(1, 5, 1:3);
hold(axMech, 'on'); grid(axMech, 'on'); axis(axMech, 'equal');
xlim(axMech, [-2.8, 7.6]);
ylim(axMech, [-0.6, 10.4]);
xlabel(axMech, '$x$ [$\mathrm{m}$]', 'Interpreter', 'latex');
ylabel(axMech, '$y$ [$\mathrm{m}$]', 'Interpreter', 'latex');
title(axMech, 'Animace a pr\r{u}b\v{e}hy sil a momentu', 'Interpreter', 'latex');

% Rozměry stojanu a jednotné měřítko vektorů sil
H_B     = 3.6;                     % Výška čepu B nad zemí [m]
y_A     = 1.6;                     % Výška osy navijáku A [m]
x_A     = -r + r1;                 % Vodorovná poloha osy bubnu A [m]
scale_F = 2.6 / max(R_By_pas);     % Jednotné měřítko sil [m / N]

% Zobrazení rámu a stojanu
plot(axMech, [-2.6, 7.2], [0, 0], 'k-', 'LineWidth', 2.2);
for xh = -2.5:0.35:7.0
    plot(axMech, [xh, xh-0.2], [0, -0.25], 'k-', 'LineWidth', 0.8);
end
patch(axMech, [-0.14, 0.14, 0.14, -0.14], [0, 0, H_B, H_B], [0.82, 0.82, 0.82], ...
      'EdgeColor', [0.45, 0.45, 0.45], 'LineWidth', 1.2);
plot(axMech, [x_A, 0], [y_A, y_A], 'Color', [0.55, 0.55, 0.55], 'LineWidth', 4.5);

% Buben navijáku A a svislá část lana
th_drum = linspace(0, 2*pi, 60);
patch(axMech, x_A + r1*cos(th_drum), y_A + r1*sin(th_drum), [0.90, 0.90, 0.90], ...
      'EdgeColor', [0.2, 0.2, 0.2], 'LineWidth', 1.6);
hDrumSpoke = plot(axMech, [x_A, x_A + r1], [y_A, y_A], 'k-', 'LineWidth', 1.8);
plot(axMech, [-r, -r], [y_A, H_B], 'Color', [0.15, 0.15, 0.15], 'LineWidth', 2.2);

% Pohyblivé části: výložník, lano na oblouku, úhel \varphi
hBoomPatch = patch(axMech, NaN, NaN, [0.80, 0.90, 0.98], ...
                   'EdgeColor', [0.05, 0.25, 0.55], 'LineWidth', 2.0, 'FaceAlpha', 0.82);
hCableArc  = plot(axMech, NaN, NaN, 'Color', [0.15, 0.15, 0.15], 'LineWidth', 2.8);
plot(axMech, [0, l*0.4], [H_B, H_B], 'k:', 'LineWidth', 1.0);
hAngleArc  = plot(axMech, NaN, NaN, 'k-', 'LineWidth', 1.2);
hAngleTxt  = text(axMech, 1.4, H_B + 0.2, '', 'Interpreter', 'latex', 'FontSize', 11);

% Klouby A a B
plot(axMech, 0,   H_B, 'ko', 'MarkerFaceColor', 'w', 'MarkerSize', 8, 'LineWidth', 1.8);
plot(axMech, x_A, y_A, 'ko', 'MarkerFaceColor', 'w', 'MarkerSize', 6, 'LineWidth', 1.5);
text(axMech, 0.22, H_B - 0.18, '$B$', 'Interpreter', 'latex', 'FontSize', 11);
text(axMech, x_A + 0.26, y_A + 0.14, '$A$', 'Interpreter', 'latex', 'FontSize', 11);

% Vektory sil
col_G = [0.93, 0.45, 0.00];
hVec_RBy = quiver(axMech, 0,  H_B, 0, 0, 'AutoScale', 'off', 'Color', [0.00, 0.45, 0.74], ...
                  'LineWidth', 2.6, 'MaxHeadSize', 0.35);
hVec_G   = quiver(axMech, 0,  H_B, 0, -G*scale_F, 'AutoScale', 'off', 'Color', col_G, ...
                  'LineWidth', 2.8, 'MaxHeadSize', 0.45);
hVec_F   = quiver(axMech, -r, H_B, 0, 0, 'AutoScale', 'off', 'Color', [0.85, 0.15, 0.15], ...
                  'LineWidth', 2.6, 'MaxHeadSize', 0.45);
hVec_Z   = quiver(axMech, l,  H_B, 0, -Z*scale_F, 'AutoScale', 'off', 'Color', [0.65, 0.10, 0.65], ...
                  'LineWidth', 2.5, 'MaxHeadSize', 0.80);
hVec_RAy = quiver(axMech, x_A, y_A, 0, 0, 'AutoScale', 'off', 'Color', [0.10, 0.60, 0.25], ...
                  'LineWidth', 2.6, 'MaxHeadSize', 0.45);

% Popisky vektorů sil
hLbl_RBy = text(axMech, 0.22, H_B, '', 'Interpreter', 'latex', 'Color', [0.00, 0.45, 0.74], 'FontSize', 10);
hLbl_G   = text(axMech, 0.22, H_B - G*scale_F, sprintf('$G = %.0f\\,\\mathrm{N}$', G), ...
                'Interpreter', 'latex', 'Color', col_G, 'FontSize', 10);
hLbl_F   = text(axMech, -r - 0.18, H_B, '', 'Interpreter', 'latex', 'Color', [0.85, 0.15, 0.15], ...
                'FontSize', 10, 'HorizontalAlignment', 'right');
hLbl_Z   = text(axMech, l, H_B, '', 'Interpreter', 'latex', 'Color', [0.65, 0.10, 0.65], 'FontSize', 10);
hLbl_RAy = text(axMech, x_A - 0.22, y_A, '', 'Interpreter', 'latex', 'Color', [0.10, 0.60, 0.25], ...
                'FontSize', 10, 'HorizontalAlignment', 'right');

% Informační panel
hInfoBox = text(axMech, 3.2, 10.1, '', 'Interpreter', 'latex', 'VerticalAlignment', 'top', ...
                'FontSize', 10, 'BackgroundColor', [0.97, 0.97, 0.97], 'EdgeColor', [0.6, 0.6, 0.6]);

% --- Pravá část: Grafy momentu a sil ---
axLiveM = subplot(2, 5, 4:5);
hold(axLiveM, 'on'); grid(axLiveM, 'on');
plot(axLiveM, phi_deg, M_pas, 'b-',  'LineWidth', 2.0);
plot(axLiveM, phi_deg, M_id,  'r--', 'LineWidth', 1.4);
hDotM = plot(axLiveM, phi_deg(1), M_pas(1), 'bo', 'MarkerFaceColor', 'y', 'MarkerSize', 8);
xlabel(axLiveM, '$\varphi$ [$^\circ$]', 'Interpreter', 'latex');
ylabel(axLiveM, '$M$ [$\mathrm{N\cdot m}$]', 'Interpreter', 'latex');
title(axLiveM, 'Moment na navij\''aku $M(\varphi)$', 'Interpreter', 'latex');
legend(axLiveM, {'$M$ (s t\v{r}en\''im)', '$M_0$ (bez t\v{r}en\''i)'}, ...
       'Interpreter', 'latex', 'Location', 'northeast');
xlim(axLiveM, [0, 90]);
ylim(axLiveM, [0, max(M_pas)*1.12]);

axLiveF = subplot(2, 5, 9:10);
hold(axLiveF, 'on'); grid(axLiveF, 'on');
plot(axLiveF, phi_deg, R_By_pas/1e3, 'Color', [0.00, 0.45, 0.74], 'LineWidth', 1.8);
plot(axLiveF, phi_deg, F_pas/1e3,    'Color', [0.85, 0.15, 0.15], 'LineWidth', 1.8);
hDotRBy = plot(axLiveF, phi_deg(1), R_By_pas(1)/1e3, 'o', 'Color', [0.00, 0.45, 0.74], ...
               'MarkerFaceColor', 'y', 'MarkerSize', 7);
hDotF   = plot(axLiveF, phi_deg(1), F_pas(1)/1e3,    'o', 'Color', [0.85, 0.15, 0.15], ...
               'MarkerFaceColor', 'y', 'MarkerSize', 7);
xlabel(axLiveF, '$\varphi$ [$^\circ$]', 'Interpreter', 'latex');
ylabel(axLiveF, 'S\''ila [$\mathrm{kN}$]', 'Interpreter', 'latex');
title(axLiveF, 'Pr\r{u}b\v{e}h sil $R_{By}$ a $F$', 'Interpreter', 'latex');
legend(axLiveF, {'$R_{By}$', '$F = |R_{Ay}|$'}, 'Interpreter', 'latex', 'Location', 'northeast');
xlim(axLiveF, [0, 90]);
ylim(axLiveF, [0, max(R_By_pas)/1e3 * 1.12]);

% --- Nekonečná animační smyčka while až do zavření okna ---
N_pts  = numel(phi);
idxSeq = [1:2:N_pts, N_pts:-2:1];
step_i = 1;

while isvalid(figAnim)
    k  = idxSeq(step_i);
    ph = phi(k);

    % 1) Natočení výložníku kolem B
    th_arc = linspace(pi + ph, pi/2 + ph, 30);
    x_tip  = l * cos(ph);
    y_tip  = H_B + l * sin(ph);
    set(hBoomPatch, 'XData', [0, r*cos(th_arc), x_tip, 0], ...
                    'YData', [H_B, H_B + r*sin(th_arc), y_tip, H_B]);

    % 2) Navinutá část lana na oblouku a natočení bubnu A
    th_cable = linspace(pi, pi/2 + ph, 25);
    set(hCableArc, 'XData', r * cos(th_cable), 'YData', H_B + r * sin(th_cable));

    psi = (r / r1) * ph;
    set(hDrumSpoke, 'XData', [x_A, x_A + r1*cos(psi)], ...
                    'YData', [y_A, y_A + r1*sin(psi)]);

    % 3) Úhel \varphi
    th_ang = linspace(0, ph, 20);
    set(hAngleArc, 'XData', 1.45 * cos(th_ang), 'YData', H_B + 1.45 * sin(th_ang));
    set(hAngleTxt, 'Position', [1.75*cos(ph/2), H_B + 1.75*sin(ph/2), 0], ...
                   'String', sprintf('$\\varphi = %.0f^\\circ$', phi_deg(k)));

    % 4) Aktualizace délek a poloh vektorů sil
    L_RBy = R_By_pas(k) * scale_F;
    L_F   = F_pas(k)    * scale_F;
    L_RAy = abs(R_Ay_pas(k)) * scale_F;
    L_Z   = Z * scale_F;

    set(hVec_RBy, 'VData',  L_RBy);
    set(hVec_F,   'VData', -L_F);
    set(hVec_Z,   'XData', x_tip, 'YData', y_tip, 'VData', -L_Z);
    set(hVec_RAy, 'VData', -L_RAy);

    % 5) Aktualizace popisků sil
    set(hLbl_RBy, 'Position', [0.22, H_B + L_RBy, 0], ...
                  'String', sprintf('$R_{By} = %.0f\\,\\mathrm{N}$', R_By_pas(k)));
    set(hLbl_F,   'Position', [-r - 0.18, H_B - L_F, 0], ...
                  'String', sprintf('$F = %.0f\\,\\mathrm{N}$', F_pas(k)));
    set(hLbl_Z,   'Position', [x_tip + 0.16, y_tip - L_Z, 0], ...
                  'String', sprintf('$Z = %.0f\\,\\mathrm{N}$', Z));
    set(hLbl_RAy, 'Position', [x_A - 0.20, y_A - L_RAy, 0], ...
                  'String', sprintf('$|R_{Ay}| = %.0f\\,\\mathrm{N}$', abs(R_Ay_pas(k))));

    % 6) Aktualizace textového panelu a bodů v grafech
    infoStr = sprintf(['$\\varphi = %.1f^\\circ$\n' ...
                       '$M = %.2f\\,\\mathrm{N\\cdot m}$ ($M_0 = %.2f\\,\\mathrm{N\\cdot m}$)\n' ...
                       '$\\Delta M = %.2f\\,\\mathrm{N\\cdot m}$ \\quad $M_{\\mathrm{\\check{c}}} = %.2f\\,\\mathrm{N\\cdot m}$\n' ...
                       '$F = %.1f\\,\\mathrm{N}$ \\quad $R_{By} = %.1f\\,\\mathrm{N}$'], ...
                       phi_deg(k), M_pas(k), M_id(k), dM(k), M_c(k), F_pas(k), R_By_pas(k));
    set(hInfoBox, 'String', infoStr);

    set(hDotM,   'XData', phi_deg(k), 'YData', M_pas(k));
    set(hDotRBy, 'XData', phi_deg(k), 'YData', R_By_pas(k)/1e3);
    set(hDotF,   'XData', phi_deg(k), 'YData', F_pas(k)/1e3);

    drawnow;
    pause(0.03);

    % Posun na další snímek v cyklu
    step_i = step_i + 1;
    if step_i > numel(idxSeq)
        step_i = 1;
    end
end