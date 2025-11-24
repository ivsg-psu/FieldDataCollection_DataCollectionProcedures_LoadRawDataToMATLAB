% script_test_fcn_LoadRawDataToMATLAB_loadRawFromFile_LidarSICK
% Tests: fcn_LoadRawDataToMATLAB_loadRawFromFile_LidarSICK

% script_test_fcn_LoadRawDataToMATLAB_loadMappingVanDataFromFile.m
% tests fcn_LoadRawDataToMATLAB_loadMappingVanDataFromFile.m

% REVISION HISTORY
% 
% As: script_test_fcn_LoadRawDataToMATLAB_loadRawFromFile_LidarSICK
% 
% 2025_11_23 by Sean Brennan, sbrennan@psu.edu
% - Created first draft of the script

% TO-DO:
% 
% 2025_11_23 by Sean Brennan, sbrennan@psu.edu
% - Need to add test cases


%% Set up the workspace
close all

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

%% DEMO case: Load one bag file with defaults (no LIDARs)
figNum = 10001;
titleString = sprintf('DEMO case: Load one bag file with defaults (no LIDARs)');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;
% 
% clear rawData
% 
% % Location for Pittsburgh, site 1
% setenv('MATLABFLAG_PLOTROAD_REFERENCE_LATITUDE','40.44181017');
% setenv('MATLABFLAG_PLOTROAD_REFERENCE_LONGITUDE','-79.76090840');
% setenv('MATLABFLAG_PLOTROAD_REFERENCE_ALTITUDE','327.428');
% 
% 
% % Add Identifiers to the data that will be loaded
% clear Identifiers
% Identifiers.Project = 'PennDOT ADS Workzones'; % This is the project sponsoring the data collection
% Identifiers.ProjectStage = 'OnRoad'; % Can be 'Simulation', 'TestTrack', or 'OnRoad'
% Identifiers.WorkZoneScenario = 'I376ParkwayPitt'; % Can be one of the ~20 scenarios, see key
% Identifiers.WorkZoneDescriptor = 'WorkInRightLaneOfUndividedHighway'; % Can be one of the 20 descriptors, see key
% Identifiers.Treatment = 'BaseMap'; % Can be one of 9 options, see key
% Identifiers.DataSource = 'MappingVan'; % Can be 'MappingVan', 'AV', 'CV2X', etc. see key
% Identifiers.AggregationType = 'PreRun'; % Can be 'PreCalibration', 'PreRun', 'Run', 'PostRun', or 'PostCalibration'
% Identifiers.SourceBagFileName =''; % This is filled in automatically for each file
% 
% fid = 1;
% dataFolderString = "LargeData";
% dateString = '2024-07-10';
% bagName = "mapping_van_2024-07-10-19-41-49_0";
% bagPath = fullfile(pwd, dataFolderString,dateString, bagName);
% Flags = [];
% rawData = fcn_LoadRawDataToMATLAB_loadMappingVanDataFromFile(bagPath, Identifiers, (bagName), (fid), (Flags), (figNum));
% 
% % Check the data
% assert(isstruct(rawData))
% 
% exampleDatafile = fullfile(cd,'Data','ExampleData_fromLoadMappingVanDataFromFile.mat');
% save(exampleDatafile,'rawData','-mat','-v7.3');


%% DEMO case: Load part of the bag file
figNum = 10002;
titleString = sprintf('DEMO case: Load part of the bag file');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;

% Commented out because very slow

% figNum = 2;
% figure(figNum);
% clf;
% 
% clear rawData
% 
% 
% fid = 1;
% dataFolderString = "LargeData";
% dateString = '2024-06-20';
% bagName = "mapping_van_2024-06-20-15-21-04_0";
% bagPath = fullfile(pwd, dataFolderString, dateString, bagName);
% Flags = struct;
% Flags.flag_do_load_sick = 0;
% Flags.flag_do_load_velodyne = 1;
% Flags.flag_do_load_cameras = 0;
% rawData = fcn_LoadRawDataToMATLAB_loadMappingVanDataFromFile(bagPath, (bagName), (fid), (Flags), (figNum));
% 
% % Check the data
% assert(isstruct(rawData))
% 


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

%% TEST case: Two polytopes with clear space right down middle, edge 5 to 8 on polytope
figNum = 20001;
titleString = sprintf('TEST case: Two polytopes with clear space right down middle, edge 5 to 8 on polytope');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;


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
% % Load some test data 
% dataSetNumber = 1; % Two polytopes with clear space right down middle
% 
% [pointsWithData, start, finish, vGraph, polytopes, goodAxis] = fcn_INTERNAL_loadExampleData(dataSetNumber);
% mode = '2d';
% 
% plottingOptions.axis = goodAxis;
% plottingOptions.selectedFromToToPlot = [1 6];
% plottingOptions.filename = 'dilationAnimation.gif'; % Specify the output file name
% 
% % Call the function
% dilation_robustness_matrix = ...
%     fcn_VGraph_generateDilationRobustnessMatrix(...
%     pointsWithData, start, finish, vGraph, mode, polytopes,...
%     (plottingOptions), ([]));
% 
% % Check variable types
% assert(isnumeric(dilation_robustness_matrix));
% 
% % Check variable sizes
% Npoints = size(vGraph,1);
% assert(size(dilation_robustness_matrix,1)==Npoints); 
% assert(size(dilation_robustness_matrix,1)==Npoints); 
% 
% % Check variable values
% % 1 is left, 2 is right
% valueToTest = dilation_robustness_matrix(plottingOptions.selectedFromToToPlot(1), plottingOptions.selectedFromToToPlot(2),1);
% roundedValueToTest = round(valueToTest,2);
% assert(isequal(roundedValueToTest,0.97));
% valueToTest = dilation_robustness_matrix(plottingOptions.selectedFromToToPlot(1), plottingOptions.selectedFromToToPlot(2),2);
% roundedValueToTest = round(valueToTest,2);
% assert(isequal(roundedValueToTest,0.97));
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
% % Load some test data 
% dataSetNumber = 1; % Two polytopes with clear space right down middle
% 
% [pointsWithData, start, finish, vGraph, polytopes, goodAxis] = fcn_INTERNAL_loadExampleData(dataSetNumber);
% mode = '2d';
% plottingOptions.axis = goodAxis;
% plottingOptions.selectedFromToToPlot = [1 6];
% plottingOptions.filename = 'dilationAnimation.gif'; % Specify the output file name
% 
% % Call the function
% dilation_robustness_matrix = ...
%     fcn_VGraph_generateDilationRobustnessMatrix(...
%     pointsWithData, start, finish, vGraph, mode, polytopes,...
%     (plottingOptions), (-1));
% 
% % Check variable types
% assert(isnumeric(dilation_robustness_matrix));
% 
% % Check variable sizes
% Npoints = size(vGraph,1);
% assert(size(dilation_robustness_matrix,1)==Npoints); 
% assert(size(dilation_robustness_matrix,1)==Npoints); 
% 
% % Check variable values
% % 1 is left, 2 is right
% valueToTest = dilation_robustness_matrix(plottingOptions.selectedFromToToPlot(1), plottingOptions.selectedFromToToPlot(2),1);
% roundedValueToTest = round(valueToTest,2);
% assert(isequal(roundedValueToTest,0.97));
% valueToTest = dilation_robustness_matrix(plottingOptions.selectedFromToToPlot(1), plottingOptions.selectedFromToToPlot(2),2);
% roundedValueToTest = round(valueToTest,2);
% assert(isequal(roundedValueToTest,0.97));
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
% % Load some test data 
% dataSetNumber = 1; % Two polytopes with clear space right down middle
% 
% [pointsWithData, start, finish, vGraph, polytopes, goodAxis] = fcn_INTERNAL_loadExampleData(dataSetNumber);
% mode = '2d';
% 
% plottingOptions.axis = goodAxis;
% plottingOptions.selectedFromToToPlot = [1 6];
% plottingOptions.filename = 'dilationAnimation.gif'; % Specify the output file name
% 
% 
% Niterations = 1;
% 
% % Do calculation without pre-calculation
% tic;
% for ith_test = 1:Niterations
%     % Call the function
%     dilation_robustness_matrix = ...
%         fcn_VGraph_generateDilationRobustnessMatrix(...
%         pointsWithData, start, finish, vGraph, mode, polytopes,...
%         (plottingOptions), ([]));
% end
% slow_method = toc;
% 
% % Do calculation with pre-calculation, FAST_MODE on
% tic;
% for ith_test = 1:Niterations
%     % Call the function
%     dilation_robustness_matrix = ...
%         fcn_VGraph_generateDilationRobustnessMatrix(...
%         pointsWithData, start, finish, vGraph, mode, polytopes,...
%         (plottingOptions), (-1));
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
    rawdata = fcn_LoadRawDataToMATLAB_loadMappingVanDataFromFile(bagName, bagName);
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


% 
% %% Functions
% function lastPart = fcn_INTERNAL_findSequenceNumber(nameString) 
% % Finds the last part of a string, the part after the very last underscore
% % and returns this as a number
% if ~contains(nameString,'_')
%     lastPart = nan;
% else
%     stringLeft = nameString;
%     while contains(stringLeft,'_')
%         stringLeft = extractAfter(stringLeft,'_');
%     end
%     lastPart = str2double(stringLeft);
% end
% end
