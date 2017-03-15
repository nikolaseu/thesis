folders = dir(fullfile(pwd, '2014.*'));
folders = {folders.name};

maxErrorHist = 0.4;
minErrorHist = -maxErrorHist;
nelements = {};
xcenters = {};
stddev = [];

nbins = 64;

data = {};
for i=1:numel(folders),
    errorFile = dir(fullfile(pwd, folders{i}, '*FitErrors.txt'))
    errorFile = fullfile(pwd, folders{i}, errorFile.name);
    fileID = fopen(errorFile);
    if fileID,
        data{i} = fscanf(fileID, '%f\n');
        fclose(fileID);
        
        stddev(i) = std(data{i});
        
        data{i} = max(minErrorHist, min(maxErrorHist, data{i}));
        
        [nelements{i}, xcenters{i}] = hist(data{i}, nbins);
        nelements{i} = 100 * nelements{i}/sum(nelements{i});
        
        hist(data{i}, nbins);
        xlabel('Error [mm]');
        ylabel('Puntos [%]');
        title(sprintf('Distribución del error de fiteo (%d categorías)', nbins))
        
        saveas(gcf, sprintf('%s.plot.eps', errorFile))
        saveas(gcf, sprintf('%s.plot.png', errorFile))
    end
end


% Defaults for this blog post
width = 3;     % Width in inches
height = 2;    % Height in inches
alw = 1.75;    % AxesLineWidth
fsz = 13;      % Fontsize
lw = 2.5;      % LineWidth
msz = 8;       % MarkerSize



locationCylinder = 210 + [0:20:100];

f = figure;
pos = get(gcf, 'Position');
set(gcf, 'Position', [pos(1) pos(2) width*100, height*100]); %<- Set size
set(gca, 'FontSize', fsz, 'LineWidth', alw); %<- Set properties
hold all;
for i=1:numel(folders),
    plot(xcenters{i}, nelements{i}, 'LineWidth' , lw);
end
a = sprintf('%dmm\n', locationCylinder);
l = strsplit(a, '\n');
legend(l(1:end-1));
axis tight
grid on
xlabel('Error [mm]');
ylabel('Puntos [%]');
title(sprintf('Distribución del error de fiteo (%d categorías)', nbins))
print(f, fullfile(pwd, '..', 'plotCylinder'), '-dpng', '-r96');
%print(f, fullfile(pwd, '..', 'plotCylinder'), '-depsc ', '-r96');
%print(f, fullfile(pwd, '..', 'plotCylinder'), '-dpdf', '-r96');

a = sprintf('%d\n', locationCylinder);
l = strsplit(a, '\n');
f2 = figure;
pos = get(gcf, 'Position');
set(gcf, 'Position', [pos(1) pos(2) width*100, height*100]); %<- Set size
set(gca, 'FontSize', fsz, 'LineWidth', alw); %<- Set properties
plot(locationCylinder, stddev*1000, 'LineWidth', lw);
xlabel('Distancia [mm]');
ax = gca;
set(ax, 'XTick', locationCylinder);
set(ax, 'XTickLabel', l(1:end-1));
axis tight
grid on
ylabel('Desvío estándar [um]');
title('Desvío estándar del error VS distancia')
print(f2, fullfile(pwd, '..', 'plotCylinderSD'), '-dpng', '-r96');
%print(f2, fullfile(pwd, '..', 'plotCylinderSD'), '-depsc ', '-r96');
%print(f2, fullfile(pwd, '..', 'plotCylinderSD'), '-dpdf', '-r96');






%%
i = 0;
distance = {};
point = {};
direction = {};
radius = {};
mean_error = {};
std_dev = {};

%
i = i + 1;
distance{i} = 50;
point{i} = [13.4498, -10.9541, 272.831]
direction{i} = [0.923215, 0.0362905, -0.382566]
radius{i} = 41.8258
mean_error{i} = 0.000238092
std_dev{i} = 0.0464905

%
i = i + 1;
distance{i} = 30;
point{i} = [88.4285, -9.92461, 263.345]
direction{i} = -[-0.923301, -0.0362201, 0.382365]
radius{i} = 41.8226
mean_error{i} = 0.000127095
std_dev{i} = 0.0496442

%
i = i + 1;
distance{i} = 10;
point{i} = [78.9296, -12.2114, 288.836]
direction{i} = -[-0.9234, -0.0361707, 0.382132]		
radius{i} = 41.8115
mean_error{i} = -0.000163606	
std_dev{i} = 0.0557518

%
i = i + 1;
distance{i} = -10;
point{i} = [13.3247, -16.699, 337.504]
direction{i} = [0.92351, 0.0362476, -0.381856]
radius{i} = 41.7919
mean_error{i} = -0.000169696
std_dev{i} = 0.065785

%
i = i + 1;
distance{i} = -30;
point{i} = [-5.1075, -19.3351, 366.628]
direction{i} = [0.923584, 0.0361695, -0.381686]
radius{i} = 41.7706
mean_error{i} = -0.000295421
std_dev{i} = 0.0800823

%
i = i + 1;
distance{i} = -50;
point{i} = [47.0758, -19.213, 366.578]
direction{i} = -[-0.923612, -0.0364446, 0.381592]
radius{i} = 41.7483
mean_error{i} = 0.00429754
std_dev{i} = 0.0922858


%%
f = figure;
hold all;
pPlano = point{1};
nPlano = direction{1};
pPoint = {};
for i=1:numel(point),
    cPoint = point{i};
    plot3(cPoint(1), cPoint(2), cPoint(3), '*');
    cDirection = direction{i};
    plot3([cPoint(1) cPoint(1)+cDirection(1)*100], ...
        [cPoint(2) cPoint(2)+cDirection(2)*100], ...
        [cPoint(3) cPoint(3)+cDirection(3)*100], '-');
    
    lambda = (cDirection * (pPlano - cPoint)') / ...
        (nPlano * cDirection');
    pPoint{i} = cPoint + lambda * cDirection;
    plot3(pPoint{i}(1), pPoint{i}(2), pPoint{i}(3), 'o');
end


diffV = {};
cylDistance(1) = 0;
for i=2:numel(point),
    diffV{i} = point{1} - pPoint{i};
    cylDistance(i) = norm(diffV{i});
end

realDistance = 0:20:100;

a = sprintf('%d\n', locationCylinder);
l = strsplit(a, '\n');
f5 = figure;
pos = get(gcf, 'Position');
set(gcf, 'Position', [pos(1) pos(2) width*100, height*100]); %<- Set size
set(gca, 'FontSize', fsz, 'LineWidth', alw); %<- Set properties
plot(locationCylinder, cylDistance-realDistance, 'LineWidth', lw);
xlabel('Distancia [mm]');
ax = gca;
set(ax, 'XTick', locationCylinder);
set(ax, 'XTickLabel', l(1:end-1));
axis tight
grid on
ylabel('Error [mm]');
title('Error en la ubicación del cilindro VS distancia')
print(f5, fullfile(pwd, '..', 'plotCylinderLocationError'), '-dpng', '-r96');
%print(f5, fullfile(pwd, '..', 'plotCylinderLocationError'), '-depsc ', '-r96');
%print(f5, fullfile(pwd, '..', 'plotCylinderLocationError'), '-dpdf', '-r96');



%%
nPlano = direction{1};
cylDirError(1) = 0;
for i=2:numel(point),
    cDirection = direction{i};
    ppunto = nPlano * cDirection';
    cosAngle = ppunto / (norm(nPlano) * norm(cDirection));
    cylDirError(i) = acosd(cosAngle);
    
    % esto debe dar 0...
    %diffff = cosd(cylDirError(i)) * (norm(nPlano) * norm(cDirection)) - ppunto
end




a = sprintf('%d\n', locationCylinder);
l = strsplit(a, '\n');
f5 = figure;
pos = get(gcf, 'Position');
set(gcf, 'Position', [pos(1) pos(2) width*100, height*100]); %<- Set size
set(gca, 'FontSize', fsz, 'LineWidth', alw); %<- Set properties
plot(locationCylinder, cylDirError, 'LineWidth', lw);
xlabel('Distancia [mm]');
ax = gca;
set(ax, 'XTick', locationCylinder);
set(ax, 'XTickLabel', l(1:end-1));
axis tight
grid on
ylabel('Error [°]');
title('Error en la dirección del cilindro VS distancia')
print(f5, fullfile(pwd, '..', 'plotCylinderDirectionError'), '-dpng', '-r96');
%print(f5, fullfile(pwd, '..', 'plotCylinderDirectionError'), '-depsc ', '-r96');
%print(f5, fullfile(pwd, '..', 'plotCylinderDirectionError'), '-dpdf', '-r96');






realRadius = 82.55 / 2;
radiusError = []
for i=1:numel(radius),
    cRadius = radius{i};
    radiusError(i) = cRadius - realRadius;
end

a = sprintf('%d\n', locationCylinder);
l = strsplit(a, '\n');
f5 = figure;
pos = get(gcf, 'Position');
set(gcf, 'Position', [pos(1) pos(2) width*100, height*100]); %<- Set size
set(gca, 'FontSize', fsz, 'LineWidth', alw); %<- Set properties
plot(locationCylinder, radiusError, 'LineWidth', lw);
xlabel('Distancia [mm]');
ax = gca;
set(ax, 'XTick', locationCylinder);
set(ax, 'XTickLabel', l(1:end-1));
axis tight
grid on
ylabel('Error [mm]');
title('Error en la estimación del radio del cilindro VS distancia')
print(f5, fullfile(pwd, '..', 'plotCylinderRadiusError'), '-dpng', '-r96');
%print(f5, fullfile(pwd, '..', 'plotCylinderRadiusError'), '-depsc ', '-r96');
%print(f5, fullfile(pwd, '..', 'plotCylinderRadiusError'), '-dpdf', '-r96');
