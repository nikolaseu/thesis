% Defaults for this blog post
width = 3;     % Width in inches
height = 2;    % Height in inches
alw = 1.75;    % AxesLineWidth
fsz = 13;      % Fontsize
lw = 2.5;      % LineWidth
msz = 8;       % MarkerSize


stddevPlane = [77.5, 55.3, 51.2, 57.4, 65.2 87.4];
locationPlane = 10*[18 20 22 24 26 29];
a = sprintf('%d\n', locationPlane);
l = strsplit(a, '\n');


f3 = figure;
pos = get(gcf, 'Position');
set(gcf, 'Position', [pos(1) pos(2) width*100, height*100]); %<- Set size
set(gca, 'FontSize', fsz, 'LineWidth', alw); %<- Set properties
plot(locationPlane, stddevPlane, 'LineWidth', lw);
xlabel('Distancia [mm]');
ax = gca;
set(ax, 'XTick', locationPlane);
set(ax, 'XTickLabel', l(1:end-1));
axis tight
grid on
ylabel('Desvío estándar [um]');
title('Desvío estándar del error VS distancia')
print(f3, fullfile(pwd, '..', 'plotPlaneSD'), '-dpng', '-r96');
%print(f3, fullfile(pwd, '..', 'plotPlaneSD'), '-depsc ', '-r96');
%print(f3, fullfile(pwd, '..', 'plotPlaneSD'), '-dpdf', '-r96');









