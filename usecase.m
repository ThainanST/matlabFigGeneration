clc; clear; close all

%% Signal
f = 60;          d = 50e-6;
t1 = 0:d:2/f;    t2 = 0:d*2:2/f;
y1 = sin(2*pi*f*t1);
y2 = cos(2*pi*f*t2);

%% Config
config = struct;
config.x = {t1, t2};
config.y = {y1, y2};
config.ylimvet        = [-1.5 1.5]; % optional
config.labels         = {'Sine', 'Cosine'};
config.lineSpec       = {'-', '-'};
config.xlabel         = 'Time, s';
config.ylabel         = 'Voltage, V';
config.fontName       = 'Times New Roman';
config.fontSize       = 14;
config.axisFontSize   = 14;
config.lineWidths     = [1.5, 1.5];
config.legendLocation = 'NorthEast';
config.currentFolder  = pwd;
config.nameFig        = 'fig1';
config.width          = 12;
config.height         = 4;

%% Execução
pg = PlotGenerator(config);
pg.execute();