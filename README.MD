# PlotGenerator - MATLAB Plotting Utility

A flexible MATLAB class for creating, customizing, and saving professional-quality plots with minimal code.

## Installation
Simply add the `PlotGenerator.m` class file to your MATLAB path.

## Basic Usage

```matlab
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
```

## Line Specification Options
Combine these characters to specify line style, marker, and color:

| Specifier | Line Style | Example |
| --- | --- | --- |
| '-' | Solid | config.lineSpec = {'-'} |
| '--' | Dashed | config.lineSpec = {'--'} |
| ':' | Dotted | config.lineSpec = {':'} |
| '-.' | Dash-dotted | config.lineSpec = {'-.'} |
| 'o' | Circle markers | config.lineSpec = {'o'} |
| '+' | Plus markers | config.lineSpec = {'+'} |
| '*' | Asterisk markers | config.lineSpec = {'*'} |

## Legend Location Options
Location String | Position
| --- | --- |
'North' | Top center
'South' | Bottom center
'East' | Right side
'West' | Left side
'NorthEast' | Top-right (default)
'NorthWest' | Top-left
'SouthEast' | Bottom-right
'SouthWest' | Bottom-left
'NorthOutside' | Above plot
'SouthOutside' | Below plot
'EastOutside' | Right of plot
'WestOutside' | Left of plot
'Best' | MATLAB chooses
'BestOutside' | Outside best