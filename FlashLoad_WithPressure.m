clear all

%Ask user to select files to analyze
[FileName,PathName]=uigetfile('*.csv','Select the density INPUT DATA FILE(s)','MultiSelect','on');
[FileName2,PathName2]=uigetfile('*.csv','Select the time array','MultiSelect','off');
[FileName3,PathName3]=uigetfile('*.csv','Select the pressure INPUT DATA FILE(s)','MultiSelect','on');

%Goes through the filenames and reads the number, to record the valid files
%in the dataset.
for i=1:length(FileName)
    str = regexprep(char(FileName(i)),'.csv','');
    str = regexprep(str,'File','');
    FileNumber(i) = str2num(str);
end

file=[char(PathName) char(FileName(1))]
Test = readtable(file);
Test = table2array(Test);
Array3D = zeros( size(Test,1), size(Test,2), length(FileNumber));
Array3D(:,:,1) = Test;

file=[char(PathName) char(FileName3(1))]
Test2 = readtable(file);
Test2 = table2array(Test2);
Pressure = zeros( size(Test2,1), size(Test2,2), length(FileNumber));
Pressure(:,:,1) = Test2;

for FileIndex=FileNumber(2:end)
         
file=[char(PathName) char(FileName(FileIndex))]

Test = readtable(file);
Test = table2array(Test);
Array3D(:,:,FileNumber(FileIndex+1)) = Test;

file=[char(PathName) char(FileName3(FileIndex))]

Test2 = readtable(file);
Test2 = table2array(Test2);
Pressure(:,:,FileNumber(FileIndex+1)) = Test2;
end

Array3D(Array3D==0)=0.0001;
Array3D(Array3D<0)=0.0001;
Pressure(Pressure==0)=0.0001;
Pressure(Pressure<0)=0.0001;

TimeLength = length(FileNumber);

x = [0:560/499:560]-280;
xarray = repmat(x,500,1);
y = [0:560/499:560]-100;
yarray = repmat(y,500,1).';

% Time = [0:0.01:((TimeLength-1)/100)]; %Time in ns
% Timearray = repmat(Time,500,1);

% Setup the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 1);
% Specify range and delimiter
opts.DataLines = [1, Inf];
opts.Delimiter = ",";
% Specify column names and types
opts.VariableNames = "VarName1";
opts.VariableTypes = "double";
% Specify file level properties
opts.ImportErrorRule = "omitrow";
opts.MissingRule = "omitrow";
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
% Import the data
timearray = readtable([PathName2 FileName2], opts);
% Clear temporary variables
clear opts
Timearray = table2array(timearray).*10^9;

figure
surf( xarray, yarray, Array3D(:,:,1))
colormap('parula');
xlabel('Horizontal Position (\mu m)');
ylabel('Vertical Position (\mu m)')
zlabel('Mass Density (g/cm^3)');
shading interp
view(2)
%caxis([0 20]);
grid off
box on
h = colorbar;
ylabel(h, 'Density (g/cm^3)')
set(gca,'colorscale','log')
fig=gcf;
fig.Units               = 'centimeters';
fig.Position(3)         = 8.6;
fig.Position(4)         = 7;
set(fig.Children, ...
    'FontName',     'Times', ...
    'FontSize',     8);
set(h, 'YTickLabel', cellstr(num2str(reshape(get(h, 'YTick'),[],1),'%.2g')) )
box on
xline(125);
xlim([0 560])
ylim([-10 150])
% set(gca,'LooseInset', max(get(gca,'TightInset'), 0.02))

figure
% surf(Timearray, repmat(y,700,1).', squeeze(Array3D(:,130,:)))
surf(Timearray, repmat(y,TimeLength,1).', squeeze(Array3D(:,130,:)))
colorbar;
colormap('parula');
xlabel('Time (ns)');
ylabel('Position (\mu m)')
zlabel('Mass Density (g/cm^3)');
shading interp
view(2)
%caxis([0 20]);
grid off
box on
h = colorbar;
% ylabel(h, 'Density (g/cm^3)')
set(gca,'colorscale','log')
fig=gcf;
fig.Units               = 'centimeters';
fig.Position(3)         = 8.6;
fig.Position(4)         = 7;
set(fig.Children, ...
    'FontName',     'Times', ...
    'FontSize',     8);
set(h, 'YTickLabel', cellstr(num2str(reshape(get(h, 'YTick'),[],1),'%.2g')) )
box on
ylim([0 150])
xlim([0 5])
set(gca,'LooseInset', max(get(gca,'TightInset'), 0.02))
dimDensity = [0.822715326277611,0,0.163672483788904,0.125];
strDensity = {'Density', '(g/cm^3)'}
annotation('textbox',dimDensity,'String',strDensity,'FitBoxToText','on',  'FontSize',     8, 'FontName',     'Times','LineStyle', 'none', 'HorizontalAlignment', 'center');

% InverseDensityScaleLength = abs( diff(log(squeeze(Pressure(:,130,:)))./diff(Radius(1:end-1:end, :)));
InverseDensityScaleLength = abs( diff(log(Pressure(:,130,:))));
InverseDensityScaleLength(isnan(InverseDensityScaleLength)) = 0.001;
InverseDensityScaleLength((InverseDensityScaleLength==0)) = 0.001;
InverseDensityScaleLength(isinf(InverseDensityScaleLength)) = 0.001; 
% Zones = repmat([1:size(Radius,1)-2].', 1, length(Time));

figure
% surf(Timearray, repmat(y,700,1).', squeeze(Array3D(:,130,:)))
surf(Timearray, repmat(y,TimeLength,1).', squeeze(Pressure(:,130,:)))
colorbar;
colormap('parula');
xlabel('Time (ns)');
ylabel('Position (\mu m)')
zlabel('Mass Density (g/cm^3)');
shading interp
view(2)
%caxis([0 20]);
grid off
box on
h = colorbar;
% ylabel(h, 'Density (g/cm^3)')
set(gca,'colorscale','log')
fig=gcf;
fig.Units               = 'centimeters';
fig.Position(3)         = 8.6;
fig.Position(4)         = 7;
set(fig.Children, ...
    'FontName',     'Times', ...
    'FontSize',     8);
set(h, 'YTickLabel', cellstr(num2str(reshape(get(h, 'YTick'),[],1),'%.2g')) )
box on
ylim([0 150])
xlim([0 5])
set(gca,'LooseInset', max(get(gca,'TightInset'), 0.02))
dimDensity = [0.822715326277611,0,0.163672483788904,0.125];
strDensity = {'Density', '(g/cm^3)'}
annotation('textbox',dimDensity,'String',strDensity,'FitBoxToText','on',  'FontSize',     8, 'FontName',     'Times','LineStyle', 'none', 'HorizontalAlignment', 'center');


figure
% surf(Timearray, repmat(y,700,1).', squeeze(Array3D(:,130,:)))
surf(Timearray, repmat(y(1:end-1),TimeLength,1).', squeeze(InverseDensityScaleLength))
colormap('parula');
xlabel('Time (ns)');
ylabel('Position (\mu m)')
zlabel('Mass Density (g/cm^3)');
shading interp
view(2)
caxis([0.1 2]);
grid off
box on
% ylabel(h, 'Density (g/cm^3)')
set(gca,'colorscale','log')
fig=gcf;
fig.Units               = 'centimeters';
fig.Position(3)         = 8.6;
fig.Position(4)         = 7;
set(fig.Children, ...
    'FontName',     'Times', ...
    'FontSize',     8);
box on
ylim([40 85])
xlim([1.2 3.1])
set(gca,'LooseInset', max(get(gca,'TightInset'), 0.02))


figure
surf(Timearray, repmat([1:length(y(1:end-1))],TimeLength,1).', squeeze(InverseDensityScaleLength))
        set(gca,'ColorScale','log');
        colormap(jet);
        xlabel('Time (ns)');
        ylabel('Cell number');
         colormap('parula');
        zlabel('Mass Density (g/cm^3)');
        shading interp
        colorbar
                view(2)
                caxis([0.01 1]);


% set(gca,'LooseInset', max(get(gca,'TightInset'), 0.02))

figure
subplot(2,2,1)
surf(Array3D(:,:,1))
colormap('parula');
% xlabel('Time (ns)');
ylabel('Position (\mu m)')
zlabel('Mass Density (g/cm^3)');
shading interp
view(2)
%caxis([0 20]);
grid off
box on
set(gca,'colorscale','log')
fig=gcf;
set(fig.Children, ...
    'FontName',     'Times', ...
    'FontSize',     8);
box on
xline(125);
xlim([25 475])
ylim([175 500])
subplot(2,2,2)
surf(Array3D(:,:,250))
colormap('parula');
% xlabel('Time (ns)');
ylabel('Position (\mu m)')
zlabel('Mass Density (g/cm^3)');
shading interp
view(2)
%caxis([0 20]);
grid off
box on
set(gca,'colorscale','log')
fig=gcf;
set(fig.Children, ...
    'FontName',     'Times', ...
    'FontSize',     8);
box on
xline(125);
xlim([25 475])
ylim([175 500])
subplot(2,2,3)
surf(Array3D(:,:,360))
colormap('parula');
xlabel('Time (ns)');
ylabel('Position (\mu m)')
zlabel('Mass Density (g/cm^3)');
shading interp
view(2)
%caxis([0 20]);
grid off
box on
set(gca,'colorscale','log')
fig=gcf;
set(fig.Children, ...
    'FontName',     'Times', ...
    'FontSize',     8);
box on
xline(125);
xlim([25 475])
ylim([175 500])
subplot(2,2,4)
surf(Array3D(:,:,400))
colormap('parula');
xlabel('Time (ns)');
% ylabel('Position (\mu m)')
zlabel('Mass Density (g/cm^3)');
shading interp
view(2)
%caxis([0 20]);
grid off
box on
set(gca,'colorscale','log')
fig=gcf;
set(fig.Children, ...
    'FontName',     'Times', ...
    'FontSize',     8);
box on
xline(125);
xlim([25 475])
ylim([175 500])
fig.Units               = 'centimeters';
fig.Position(3)         = 8.6;
fig.Position(4)         = 7;
% set(gca,'LooseInset', max(get(gca,'TightInset'), 0.02))

