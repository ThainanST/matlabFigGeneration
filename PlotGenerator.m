classdef PlotGenerator
    properties
        xList       % Cell array of x vectors
        yList       % Cell array of y vectors
        config
        figHandle
        plotHandles
    end

    methods
        function obj = PlotGenerator(config)
            if nargin < 1
                error('Provide a config struct.');
            end
            
            % Verifica se x e y existem no config
            if ~isfield(config, 'x') || ~isfield(config, 'y')
                error('Config must contain x and y fields.');
            end
            
            obj.config = obj.applyDefaults(config);
            obj.xList = obj.config.x;
            obj.yList = obj.config.y;

            if ~iscell(obj.xList), obj.xList = {obj.xList}; end
            if ~iscell(obj.yList), obj.yList = {obj.yList}; end

            if length(obj.xList) ~= length(obj.yList)
                error('x and y must have the same number of elements.');
            end
        end

        function config = applyDefaults(~, config)
            defaultColors = {
                [0.0000 0.4470 0.7410];
                [0.8500 0.3250 0.0980];
                [0.9290 0.6940 0.1250];
                [0.4940 0.1840 0.5560];
                [0.4660 0.6740 0.1880];
                [0.3010 0.7450 0.9330];
                [0.6350 0.0780 0.1840];
            };

            if ~isfield(config, 'labels'),         config.labels = {}; end
            if ~isfield(config, 'lineSpec'),       config.lineSpec = {}; end
            if ~isfield(config, 'xlabel'),        config.xlabel = 'Time, s'; end
            if ~isfield(config, 'ylabel'),        config.ylabel = 'Amplitude, adm'; end
            if ~isfield(config, 'fontName'),      config.fontName = 'Times New Roman'; end
            if ~isfield(config, 'fontSize'),      config.fontSize = 14; end
            if ~isfield(config, 'fontAngle'),     config.fontAngle = 'italic'; end
            if ~isfield(config, 'colors'),        config.colors = defaultColors; end
            if ~isfield(config, 'axisFontSize'),  config.axisFontSize = 14; end
            if ~isfield(config, 'lineWidths'),    config.lineWidths = ones(1, length(config.labels)); end
            if ~isfield(config, 'legendLocation'), config.legendLocation = 'NorthEast'; end
            if ~isfield(config, 'currentFolder'),    config.currentFolder = pwd; end
            if ~isfield(config, 'nameFig'),       config.nameFig = 'figure'; end
            if ~isfield(config, 'width'),        config.width = 12; end
            if ~isfield(config, 'height'),       config.height = 4; end
        end

        function obj = plot(obj)
            obj.figHandle = figure;
            hold on; grid on; box on;

            nCurves = length(obj.xList);
            obj.plotHandles = gobjects(1, nCurves);

            xmin = inf;
            xmax = -inf;
            
            % If lineSpec not provided, create default cell array
            if isempty(obj.config.lineSpec)
                obj.config.lineSpec = repmat({'-'}, 1, nCurves);
            end
            
            for k = 1:nCurves
                x = obj.xList{k};
                y = obj.yList{k};
                
                % Get line specification (default to '-' if not provided)
                if length(obj.config.lineSpec) >= k
                    lineSpec = obj.config.lineSpec{k};
                else
                    lineSpec = '-';
                end
                
                c = obj.config.colors{mod(k-1, length(obj.config.colors)) + 1};
                lw = obj.config.lineWidths(min(k, length(obj.config.lineWidths)));
                obj.plotHandles(k) = plot(x, y, lineSpec, 'Color', c, 'LineWidth', lw);
                
                xmin = min(xmin, min(x));
                xmax = max(xmax, max(x));
            end
            
            
            xlim([xmin, xmax])
            
            if (isfield(obj.config, 'ylimvet'))
                ylimvet = obj.config.ylimvet;
                ylim(ylimvet)
            end
            

            if ~isempty(obj.config.labels)
                leg = legend(obj.plotHandles, obj.config.labels, 'Location', obj.config.legendLocation);
                set(leg, 'FontSize', obj.config.fontSize, ...
                         'FontAngle', obj.config.fontAngle, ...
                         'FontName', obj.config.fontName);
            end

            labelFont = sprintf('\\fontname{%s}\\fontsize{%d}\\bf', ...
                                 obj.config.fontName, obj.config.fontSize);
            xlabel([labelFont, obj.config.xlabel]);
            ylabel([labelFont, obj.config.ylabel]);
            set(gca, 'FontSize', obj.config.axisFontSize, 'FontName', obj.config.fontName);
        end

        function saveFigure(obj, figName, width, height)
            set(obj.figHandle, 'PaperPosition', [0 0 width height]);
            set(obj.figHandle, 'PaperSize', [width height]);
            fullpath = fullfile(obj.config.currentFolder, [figName, '.pdf']);
            set(gca, 'box', 'on');
            saveas(obj.figHandle, fullpath, 'pdf');
        end

        function closeFigure(obj)
            close(obj.figHandle);
        end
        
        function execute(obj)
            % Executa todo o fluxo de plotagem e salvamento
            obj = obj.plot();
            obj.saveFigure(obj.config.nameFig, obj.config.width, obj.config.height);
            obj.closeFigure();
            fprintf('Figure "%s" saved successfully!\n\n', ...
                    obj.config.nameFig);
        end
    end
end