%% ========================================================================
%  ENGR 2405 - Lab 10: Power Transfer in AC Circuits
%  Generates the two required plots:
%     Figure 1 : P_L vs R_L            (Case 1)  -> lab10_case1.pdf
%     Figure 2 : P_L vs C, three R_L   (Case 2)  -> lab10_case2.pdf
%
%  Filenames match those referenced by the LaTeX report.
%  Run from the same directory as the .tex file.
% =========================================================================
clear; clc; close all;

%% ----------------------- Circuit parameters -----------------------------
Vin = 2.00;             % measured DELIVERED amplitude (V), not the dial setting
Rs  = 100;              % source resistance (ohm)
L   = 33e-3;            % line inductance (H)
f   = 5000;             % frequency (Hz)
w   = 2*pi*f;           % angular frequency (rad/s)
XL  = w*L;              % inductive reactance (ohm)

RLopt = sqrt(Rs^2 + XL^2);            % optimum load resistance  (Case 1)
Copt  = L/(w^2*L^2 + Rs^2);           % optimum shunt capacitance (Case 2)
Cser  = 47e-9*100e-9/(47e-9+100e-9);  % 47 nF in series with 100 nF

fprintf('XL = %.1f ohm   RL,opt = %.1f ohm   C,opt = %.2f nF\n', ...
        XL, RLopt, Copt*1e9);

%% --------------------------- MEASURED DATA ------------------------------
% Case 1: load resistance and measured load AMPLITUDE
RL1 = [10 47 100 330 680 1000 2200 10000];
VL1 = [0.040 0.200 0.280 0.608 1.060 1.320 1.880 2.520];

% Case 2: common capacitance list (ascending) and load amplitudes per RL
C2    = [0 10e-9 22e-9 Cser 47e-9 113e-9];
RL2   = [1000 680 2200];
VL2   = [1.320 1.380 1.440 1.360 1.260 0.696;    % RL = 1000 ohm
         1.046 1.134 1.209 1.225 1.163 0.633;    % RL =  680 ohm
         1.740 2.273 3.154 3.490 2.537 0.723];   % RL = 2200 ohm

%% ------------------------- Power expressions ----------------------------
P1 = @(RL)   (Vin^2/2).*RL ./ ((Rs+RL).^2 + XL^2);
P2 = @(C,RL) (Vin^2/2).*RL ./ ((Rs + RL - w^2.*RL.*L.*C).^2 ...
                             + (w.*(L + RL.*Rs.*C)).^2);

PL1 = VL1.^2 ./ (2*RL1) * 1e3;                   % measured power, mW
PL2 = VL2.^2 ./ (2*RL2(:)) * 1e3;                % measured power, mW (rows = RL)

%% --------------------------- Plot styling -------------------------------
set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultTextInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');

col = [0.00 0.35 0.70;      % blue
       0.00 0.55 0.30;      % green
       0.80 0.15 0.15];     % red
gry = [0.45 0.45 0.45];
FS  = 11;                   % font size
LW  = 1.8;                  % curve line width
MS  = 7;                    % marker size

%% ===================== FIGURE 1: Case 1, P_L vs R_L =====================
fig1 = figure('Units','inches','Position',[1 1 6.5 4.2],'Color','w');
ax1  = axes(fig1); hold(ax1,'on'); box(ax1,'on');

Rsw = logspace(1, 4.3, 800);
semilogx(ax1, Rsw, P1(Rsw)*1e3, '-', 'Color', col(1,:), 'LineWidth', LW, ...
         'DisplayName', sprintf('theory ($V_{in}=%.1f$ V)', Vin));
semilogx(ax1, RL1, PL1, 's', 'MarkerSize', MS, 'LineWidth', 1.4, ...
         'Color', col(3,:), 'MarkerFaceColor', 'w', 'DisplayName', 'measured');

% mark the theoretical optimum
yl = [0 1.05*max([PL1, P1(RLopt)*1e3])];
plot(ax1, [RLopt RLopt], yl, '--', 'Color', gry, 'LineWidth', 1, ...
     'HandleVisibility','off');
text(ax1, RLopt*1.15, 0.10*yl(2), ...
     sprintf('$R_{L,opt} = %.0f\\,\\Omega$', RLopt), ...
     'Color', gry, 'FontSize', FS-2);

set(ax1, 'XScale','log', 'FontSize', FS-1, 'XLim', [10 2e4], 'YLim', yl, ...
         'XTick', [10 100 1000 1e4], 'XMinorTick','on', 'YMinorTick','on', ...
         'TickDir','out', 'LineWidth', 0.8, 'Layer','top');
grid(ax1,'on'); ax1.GridAlpha = 0.15;
xlabel(ax1, '$R_L$ \, (\,$\Omega$\,)', 'FontSize', FS);
ylabel(ax1, '$P_L$ \, (mW)', 'FontSize', FS);
title(ax1, 'Case 1: load power vs.\ load resistance', 'FontSize', FS);
legend(ax1, 'Location','northwest', 'FontSize', FS-2, 'Box','off');

%% =================== FIGURE 2: Case 2, P_L vs C ========================
fig2 = figure('Units','inches','Position',[1 1 6.5 4.4],'Color','w');
ax2  = axes(fig2); hold(ax2,'on'); box(ax2,'on');

Csw = linspace(0, 120e-9, 800);
for k = 1:numel(RL2)
    plot(ax2, Csw*1e9, P2(Csw, RL2(k))*1e3, '-', 'Color', col(k,:), ...
         'LineWidth', LW, ...
         'DisplayName', sprintf('$R_L = %g\\,\\Omega$ theory', RL2(k)));
    plot(ax2, C2*1e9, PL2(k,:), 'o', 'MarkerSize', MS, 'LineWidth', 1.4, ...
         'Color', col(k,:), 'MarkerFaceColor','w', ...
         'DisplayName', sprintf('$R_L = %g\\,\\Omega$ meas.', RL2(k)));
end

yl2 = [0 1.08*max(PL2(:))];
plot(ax2, [Copt Copt]*1e9, yl2, '--', 'Color', gry, 'LineWidth', 1, ...
     'HandleVisibility','off');
text(ax2, Copt*1e9 + 2.5, 0.06*yl2(2), ...
     sprintf('$C_{opt} = %.1f$ nF', Copt*1e9), ...
     'Color', gry, 'FontSize', FS-2);

set(ax2, 'FontSize', FS-1, 'XLim', [0 120], 'YLim', yl2, ...
         'XTick', 0:20:120, 'XMinorTick','on', 'YMinorTick','on', ...
         'TickDir','out', 'LineWidth', 0.8, 'Layer','top');
grid(ax2,'on'); ax2.GridAlpha = 0.15;
xlabel(ax2, '$C$ \, (nF)', 'FontSize', FS);
ylabel(ax2, '$P_L$ \, (mW)', 'FontSize', FS);
title(ax2, 'Case 2: load power vs.\ shunt capacitance', 'FontSize', FS);
legend(ax2, 'Location','northeast', 'FontSize', FS-2, 'Box','off', ...
       'NumColumns', 2);

%% -------------------------- Vector PDF export ---------------------------
savepdf(fig1, 'lab10_case1.pdf');
savepdf(fig2, 'lab10_case2.pdf');
fprintf('Wrote lab10_case1.pdf and lab10_case2.pdf\n');

%% ------------------------------ helper ----------------------------------
function savepdf(fh, fname)
% Vector PDF, cropped to the axes. exportgraphics needs R2020a+;
% older releases fall back to a manually sized print().
    if exist('exportgraphics','file')
        exportgraphics(fh, fname, 'ContentType','vector', ...
                       'BackgroundColor','none');
    else
        set(fh, 'PaperPositionMode','auto');
        pp = get(fh, 'PaperPosition');
        set(fh, 'PaperSize', [pp(3) pp(4)]);
        print(fh, '-dpdf', '-painters', fname);
    end
end