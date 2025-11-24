% script_test_fcn_LoadRawDataToMATLAB_plotRawData.m
% tests fcn_LoadRawDataToMATLAB_plotRawData.m

% REVISION HISTORY
% 
% As: script_test_fcn_LoadRawDataToMATLAB_plotRawData
% 
% 2025_09_19 by Sean Brennan, sbrennan@psu.edu
% * In script_test_fcn_LoadRawDataToMATLAB_plotRawData
% - Wrote the code originally
% 
% 2025_11_23 by Sean Brennan, sbrennan@psu.edu
% - Corrected script name
% - Fixed rev history to be Markdown format
% - Added TO+-DO list

% TO-DO:
% 
% 2025_11_23 by Sean Brennan, sbrennan@psu.edu
% - (add items here)


%% Set up the workspace
close all

% Location for Pittsburgh, site 1
setenv('MATLABFLAG_PLOTROAD_REFERENCE_LATITUDE','40.44181017');
setenv('MATLABFLAG_PLOTROAD_REFERENCE_LONGITUDE','-79.76090840');
setenv('MATLABFLAG_PLOTROAD_REFERENCE_ALTITUDE','327.428');

%% Code demos start here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   _____                              ____   __    _____          _
%  |  __ \                            / __ \ / _|  / ____|        | |
%  | |  | | ___ _ __ ___   ___  ___  | |  | | |_  | |     ___   __| | ___
%  | |  | |/ _ \ '_ ` _ \ / _ \/ __| | |  | |  _| | |    / _ \ / _` |/ _ \
%  | |__| |  __/ | | | | | (_) \__ \ | |__| | |   | |___| (_) | (_| |  __/
%  |_____/ \___|_| |_| |_|\___/|___/  \____/|_|    \_____\___/ \__,_|\___|
%
%
% See: https://patorjk.com/software/taag/#p=display&f=Big&t=Demos%20Of%20Code
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Figures start with 1

close all;
fprintf(1,'Figure: 1XXXXXX: DEMO cases\n');

%% DEMO case: Plotting with defaults
figNum = 10001;
titleString = sprintf('DEMO case: Plotting with defaults');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); close(figNum);

fullExampleFilePath = fullfile(cd,'Data','ExampleData_plotRawData.mat');
load(fullExampleFilePath,'dataStructure')
rawData = dataStructure;
bagName = dataStructure.Identifiers.mergedName;

% Plot the data
plotFormat = [];
colorMapToUse = [];
fcn_LoadRawDataToMATLAB_plotRawData(rawData, (bagName), (plotFormat), (colorMapToUse), (figNum))

%% DEMO case: Plotting with formats
figNum = 10002;
titleString = sprintf('DEMO case: Plotting with formats');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); close(figNum);


fullExampleFilePath = fullfile(cd,'Data','ExampleData_plotRawData.mat');
load(fullExampleFilePath,'dataStructure')
rawData = dataStructure;
bagName = dataStructure.Identifiers.mergedName;


% Test the function
clear plotFormat
plotFormat.LineStyle = '-';
plotFormat.LineWidth = 3;
plotFormat.Marker = 'none';
plotFormat.MarkerSize = 5;

colorMapMatrix = colormap('hot');
% Reduce the colormap
Ncolors = 20;
colorMapToUse = fcn_plotRoad_reduceColorMap(colorMapMatrix, Ncolors, -1);

fcn_LoadRawDataToMATLAB_plotRawData(rawData, (bagName), (plotFormat), (colorMapToUse), (figNum))

%% DEMO case: Plotting a color
figNum = 10003;
titleString = sprintf('DEMO case: Plotting a color');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); close(figNum);

fullExampleFilePath = fullfile(cd,'Data','ExampleData_plotRawData.mat');
load(fullExampleFilePath,'dataStructure')
rawData = dataStructure;
bagName = dataStructure.Identifiers.mergedName;

% Test the function
clear plotFormat
plotFormat.LineStyle = '-';
plotFormat.LineWidth = 2;
plotFormat.Marker = 'none';
plotFormat.MarkerSize = 5;
plotFormat.Color = fcn_geometry_fillColorFromNumberOrName(2);

colorMapToUse = plotFormat.Color;
fcn_LoadRawDataToMATLAB_plotRawData(rawData, (bagName), (plotFormat), (colorMapToUse), (figNum))
h_legend = legend(bagName);
set(h_legend,'Interpreter','none')


%% Test cases start here. These are very simple, usually trivial
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  _______ ______  _____ _______ _____
% |__   __|  ____|/ ____|__   __/ ____|
%    | |  | |__  | (___    | | | (___
%    | |  |  __|  \___ \   | |  \___ \
%    | |  | |____ ____) |  | |  ____) |
%    |_|  |______|_____/   |_| |_____/
%
%
%
% See: https://patorjk.com/software/taag/#p=display&f=Big&t=TESTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Figures start with 2

close all;
fprintf(1,'Figure: 2XXXXXX: TEST mode cases\n');

% %% TEST case: Load Encoder_diag diagnostic file
% figNum = 20001;
% titleString = sprintf('DEMO case: Load Encoder_diag diagnostic file');
% fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
% figure(figNum); close(figNum);


%% Fast Mode Tests
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  ______        _     __  __           _        _______        _
% |  ____|      | |   |  \/  |         | |      |__   __|      | |
% | |__ __ _ ___| |_  | \  / | ___   __| | ___     | | ___  ___| |_ ___
% |  __/ _` / __| __| | |\/| |/ _ \ / _` |/ _ \    | |/ _ \/ __| __/ __|
% | | | (_| \__ \ |_  | |  | | (_) | (_| |  __/    | |  __/\__ \ |_\__ \
% |_|  \__,_|___/\__| |_|  |_|\___/ \__,_|\___|    |_|\___||___/\__|___/
%
%
% See: http://patorjk.com/software/taag/#p=display&f=Big&t=Fast%20Mode%20Tests
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Figures start with 8

close all;
fprintf(1,'Figure: 8XXXXXX: FAST mode cases\n');

% %% Basic example - NO FIGURE
% figNum = 80001;
% fprintf(1,'Figure: %.0f: FAST mode, empty figNum\n',figNum);
% figure(figNum); close(figNum);
% 
% filePath = fullfile(pwd,'Data','TestLoadData','_slash_parseTrigger.csv');
% datatype = 'trigger';
% 
% % Call the function
% structureEncoder = fcn_LoadRawDataToMATLAB_loadRawFromFile_Trigger(filePath, datatype, ([]));
% 
% % sgtitle(titleString, 'Interpreter','none');
% 
% % Check variable types
% assert(isstruct(structureEncoder))
% 
% % Check variable sizes
% assert(size(structureEncoder,1)==1); 
% assert(size(structureEncoder,1)==1); 
% 
% % Make sure plot did NOT open up
% figHandles = get(groot, 'Children');
% assert(~any(figHandles==figNum));
% 
% 
% %% Basic fast mode - NO FIGURE, FAST MODE
% figNum = 80002;
% fprintf(1,'Figure: %.0f: FAST mode, figNum=-1\n',figNum);
% figure(figNum); close(figNum);
% 
% filePath = fullfile(pwd,'Data','TestLoadData','_slash_parseTrigger.csv');
% datatype = 'trigger';
% 
% % Call the function
% structureEncoder = fcn_LoadRawDataToMATLAB_loadRawFromFile_Trigger(filePath, datatype, (-1));
% 
% % sgtitle(titleString, 'Interpreter','none');
% 
% % Check variable types
% assert(isstruct(structureEncoder))
% 
% % Check variable sizes
% assert(size(structureEncoder,1)==1); 
% assert(size(structureEncoder,1)==1); 
% 
% 
% % Make sure plot did NOT open up
% figHandles = get(groot, 'Children');
% assert(~any(figHandles==figNum));
% 
% 
% %% Compare speeds of pre-calculation versus post-calculation versus a fast variant
% figNum = 80003;
% fprintf(1,'Figure: %.0f: FAST mode comparisons\n',figNum);
% figure(figNum);
% close(figNum);
% 
% filePath = fullfile(pwd,'Data','TestLoadData','_slash_parseTrigger.csv');
% datatype = 'trigger';
% 
% Niterations = 10;
% 
% % Do calculation without pre-calculation
% tic;
% for ith_test = 1:Niterations
%     % Call the function
%     structureEncoder = fcn_LoadRawDataToMATLAB_loadRawFromFile_Trigger(filePath, datatype, ([]));
% end
% slow_method = toc;
% 
% % Do calculation with pre-calculation, FAST_MODE on
% tic;
% for ith_test = 1:Niterations
%     % Call the function
%     structureEncoder = fcn_LoadRawDataToMATLAB_loadRawFromFile_Trigger(filePath, datatype, (-1));
% end
% fast_method = toc;
% 
% % Make sure plot did NOT open up
% figHandles = get(groot, 'Children');
% assert(~any(figHandles==figNum));
% 
% % Plot results as bar chart
% figure(373737);
% clf;
% hold on;
% 
% X = categorical({'Normal mode','Fast mode'});
% X = reordercats(X,{'Normal mode','Fast mode'}); % Forces bars to appear in this exact order, not alphabetized
% Y = [slow_method fast_method ]*1000/Niterations;
% bar(X,Y)
% ylabel('Execution time (Milliseconds)')
% 
% % Make sure plot did NOT open up
% figHandles = get(groot, 'Children');
% assert(~any(figHandles==figNum));


%% BUG cases
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  ____  _    _  _____
% |  _ \| |  | |/ ____|
% | |_) | |  | | |  __    ___ __ _ ___  ___  ___
% |  _ <| |  | | | |_ |  / __/ _` / __|/ _ \/ __|
% | |_) | |__| | |__| | | (_| (_| \__ \  __/\__ \
% |____/ \____/ \_____|  \___\__,_|___/\___||___/
%
% See: http://patorjk.com/software/taag/#p=display&v=0&f=Big&t=BUG%20cases
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% All bug case figures start with the number 9

% close all;

%% BUG 

%% Fail conditions
if 1==0
    %% ERROR for bad data folder
    bagName = "badData";
    rawdata = fcn_LoadRawDataToMATLAB_plotRawData(bagName, bagName);
end



%% Functions follow
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   ______                _   _
%  |  ____|              | | (_)
%  | |__ _   _ _ __   ___| |_ _  ___  _ __  ___
%  |  __| | | | '_ \ / __| __| |/ _ \| '_ \/ __|
%  | |  | |_| | | | | (__| |_| | (_) | | | \__ \
%  |_|   \__,_|_| |_|\___|\__|_|\___/|_| |_|___/
%
% See: https://patorjk.com/software/taag/#p=display&f=Big&t=Functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%§
