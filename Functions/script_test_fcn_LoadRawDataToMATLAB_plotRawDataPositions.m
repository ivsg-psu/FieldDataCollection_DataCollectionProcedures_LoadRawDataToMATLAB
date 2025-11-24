% script_test_fcn_LoadRawDataToMATLAB_plotRawDataPositions.m
% tests fcn_LoadRawDataToMATLAB_plotRawDataPositions.m

% REVISION HISTORY
% 
% 2023_06_19 by Sean Brennan, sbrennan@psu.edu
% - Wrote the code originally, using 
%    script_test_fcn_Data+Clean_loadMappingVanDataFromFile as starter
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


%% Check assertions for basic path operations and function testing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                              _   _                 
%      /\                     | | (_)                
%     /  \   ___ ___  ___ _ __| |_ _  ___  _ __  ___ 
%    / /\ \ / __/ __|/ _ \ '__| __| |/ _ \| '_ \/ __|
%   / ____ \\__ \__ \  __/ |  | |_| | (_) | | | \__ \
%  /_/    \_\___/___/\___|_|   \__|_|\___/|_| |_|___/
%                                                    
%                                                    
% See: https://patorjk.com/software/taag/#p=display&f=Big&t=Assertions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Choose data folder and bag name, read before running the script
% 2023_06_19
% Data from "mapping_van_2023-06-05-1Lap.bag" is set as the default value
% used in this test script.
% All files are saved on OneDrive, in
% \\IVSG\GitHubMirror\MappingVanDataCollection\ParsedData, to use data from other files,
% change the data_folder variable and bagname variable to corresponding path and bag
% name.

% 2023_06_24
% Data from "mapping_van_2023-06-22-1Lap_0.bag" and "mapping_van_2023-06-22-1Lap_1.bag"
% will be used as the default data used in this test script. 
% The parsed the data files are saved on OneDrive
% in \IVSG\GitHubMirror\MappingVanDataCollection\ParsedData. To process the
% bag file, please copy mapping_van_2023-06-22-1Lap_0 and
% mapping_van_2023-06-22-1Lap_1 folder to the LargeData folder.

% 2023_06_26
% New test data 'mapping_van_2023-06-26-Parking5s.bag',
% 'mapping_van_2023-06-26-Parking10s.bag',
% 'mapping_van_2023-06-26-Parking20s.bag', and
% 'mapping_van_2023-06-26-Parking30s.bag' will be used as the default data
% in this script.
% The parsed the data files are saved on OneDrive
% in \IVSG\GitHubMirror\MappingVanDataCollection\ParsedData. To process the
% bag file, please copy file folder to the LargeData folder.
% mapping_van_2023-06-26-Parking5s folder will also be placed in the Data
% folder and will be pushed to GitHub repo.


%% Test 1: Load MANY bag file with defaults (no LIDARs) and plot only summary
figNum = 1;
figure(figNum);
clf;


% Load test data
exampleDatafile = fullfile(pwd,'Data','ExampleData_fromLoadRawDataFromDirectories.mat');
load(exampleDatafile,'rawDataCellArray');

% List what will be saved
clear saveFlags
saveFlags.flag_saveImages = 1;
imageDirectory = fullfile(cd,'Data','RawData',rawDataCellArray{1}.Identifiers.ProjectStage,rawDataCellArray{1}.Identifiers.WorkZoneScenario);
saveFlags.flag_saveImages_directory  = imageDirectory;
saveFlags.flag_forceDirectoryCreation = 1;
saveFlags.flag_forceImageOverwrite = 1;

% List what will be plotted, and the figure numbers
clear plotFlags
plotFlags.figNum_plotAllRawTogether = figNum;
plotFlags.figNum_plotAllRawIndividually = [];

% Call function
fcn_LoadRawDataToMATLAB_plotRawDataPositions(rawDataCellArray, (saveFlags), (plotFlags))

%% Test 2: Load MANY bag file with defaults (no LIDARs) and plot first 5
figNum = 2;
figure(figNum);
clf;


% Load test data
exampleDatafile = fullfile(cd,'Data','ExampleData_fromLoadRawDataFromDirectories.mat');
load(exampleDatafile,'rawDataCellArray');

% List what will be saved
clear saveFlags
saveFlags.flag_saveImages = 1;
imageDirectory = fullfile(cd,'Data','RawData',rawDataCellArray{1}.Identifiers.ProjectStage,rawDataCellArray{1}.Identifiers.WorkZoneScenario);
saveFlags.flag_saveImages_directory  = imageDirectory;
saveFlags.flag_forceDirectoryCreation = 1;
saveFlags.flag_forceImageOverwrite = 1;

% List what will be plotted, and the figure numbers
clear plotFlags
plotFlags.figNum_plotAllRawTogether = [];
plotFlags.figNum_plotAllRawIndividually = figNum;

% Call function
smallCellArray = cell(5,1);
for ith_array = 1:5
    smallCellArray{ith_array,1} = rawDataCellArray{ith_array,1};
end
fcn_LoadRawDataToMATLAB_plotRawDataPositions(smallCellArray, (saveFlags), (plotFlags))

%% Test 3: Load one bag file with defaults (no LIDARs)
figNum = 3;
figure(figNum);
clf;

exampleDatafile = fullfile(cd,'Data','ExampleData_fromLoadMappingVanDataFromFile.mat');
load(exampleDatafile,'rawData');


% List what will be saved
clear saveFlags
saveFlags.flag_saveImages = 1;
imageDirectory = fullfile(cd,'Data','RawData',rawData.Identifiers.ProjectStage,rawData.Identifiers.WorkZoneScenario);
saveFlags.flag_saveImages_directory  = imageDirectory;
saveFlags.flag_forceDirectoryCreation = 1;
saveFlags.flag_forceImageOverwrite = 1;

% List what will be plotted, and the figure numbers
clear plotFlags
plotFlags.figNum_plotAllRawTogether = figNum;
plotFlags.figNum_plotAllRawIndividually = [];

% Call function
fcn_LoadRawDataToMATLAB_plotRawDataPositions({rawData}, (saveFlags), (plotFlags))



%% Fail conditions
if 1==0
    %% ERROR for bad data folder
    bagName = "badData";
    rawdata = fcn_LoadRawDataToMATLAB_plotRawDataPositions(bagName, bagName);
end

%% Functions
function lastPart = fcn_INTERNAL_findSequenceNumber(nameString) %#ok<DEFNU>
% Finds the last part of a string, the part after the very last underscore
% and returns this as a number
if ~contains(nameString,'_')
    lastPart = nan;
else
    stringLeft = nameString;
    while contains(stringLeft,'_')
        stringLeft = extractAfter(stringLeft,'_');
    end
    lastPart = str2double(stringLeft);
end
end
