% script_test_fcn_LoadRawDataToMATLAB_saveRawDataMatFiles.m
% tests fcn_LoadRawDataToMATLAB_saveRawDataMatFiles.m

% Revision history
% 2025_09_20 - Sean Brennan, sbrennan@psu.edu
% -- wrote the code originally, using 
%    script_test_fcn_DataClean_loadMappingVanDataFromFile as starter

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


%% Test 1: Load MANY bag file with defaults (no LIDARs) and save each mat file to new folder
% Original data was collected from LargeData
% New data is pushed into Data

% Load test data
exampleDatafile = fullfile(cd,'Data','ExampleData_fromLoadRawDataFromDirectories.mat');
load(exampleDatafile,'rawDataCellArray','only_directory_filelist');

% Create a cell array list of directory names
clear originalDirectoryList
Ndirectories = length(only_directory_filelist);
originalDirectoryList = cell(Ndirectories,1);
for ith_directory = 1:Ndirectories
    directoryPath = only_directory_filelist(ith_directory).folder;
    directoryName = only_directory_filelist(ith_directory).name;    
    originalDirectoryList{ith_directory,1} = fullfile(directoryPath,directoryName);
end

% The original list contains locations in LargeData. Shift to Data
newDirectoryList = replace(originalDirectoryList,'LargeData','Data');

% List what will be saved
clear saveFlags
saveFlags.flag_forceDirectoryCreation = 1;
saveFlags.flag_forceMATfileOverwrite = 1;

% Call function
fcn_LoadRawDataToMATLAB_saveRawDataMatFiles(rawDataCellArray, newDirectoryList, (saveFlags))

%% Test 2: Load MANY bag file with defaults (no LIDARs) and plot first 5

% Load test data
exampleDatafile = fullfile(cd,'Data','ExampleData_fromLoadRawDataFromDirectories.mat');
load(exampleDatafile,'rawDataCellArray','only_directory_filelist');

% Create a list of directory names
clear originalDirectoryList
Ndirectories = length(only_directory_filelist);
originalDirectoryList = cell(Ndirectories,1);
for ith_directory = 1:Ndirectories
    directoryPath = only_directory_filelist(ith_directory).folder;
    directoryName = only_directory_filelist(ith_directory).name;    
    originalDirectoryList{ith_directory,1} = fullfile(directoryPath,directoryName);
end

% The original list contains locations in LargeData. Shift to Data
newDirectoryList = replace(originalDirectoryList,'LargeData','Data');

% List what will be saved
clear saveFlags
saveFlags.flag_forceDirectoryCreation = 1;
saveFlags.flag_forceMATfileOverwrite = 1;

% Make small versions
smallCellArray = cell(5,1);
smallNewDirectoryList = cell(5,1);
for ith_array = 1:5
    smallCellArray{ith_array,1} = rawDataCellArray{ith_array,1};
    smallNewDirectoryList{ith_array,1} = newDirectoryList{ith_array,1};
end

% Call function
fcn_LoadRawDataToMATLAB_saveRawDataMatFiles(smallCellArray, smallNewDirectoryList, (saveFlags))

%% Test 3: Load one bag file with defaults (no LIDARs)

exampleDatafile = fullfile(cd,'Data','ExampleData_fromLoadMappingVanDataFromFile.mat');
load(exampleDatafile,'rawData');

% List what will be saved
rawDataCellArray = {rawData};
newDirectoryList = {fullfile(cd,'Data','output_of_saveRawDataMatFiles')};
clear saveFlags
saveFlags.flag_forceDirectoryCreation = 1;
saveFlags.flag_forceMATfileOverwrite = 1;

% Call function
fcn_LoadRawDataToMATLAB_saveRawDataMatFiles(rawDataCellArray, newDirectoryList, (saveFlags))

%% Fail conditions
if 1==0
    %% ERROR because folders do not exist
    % Need to delete the folders before starting this

    % Load test data
    exampleDatafile = fullfile(cd,'Data','ExampleData_fromLoadRawDataFromDirectories.mat');
    load(exampleDatafile,'rawDataCellArray','only_directory_filelist');

    % Create a list of directory names
    clear originalDirectoryList
    Ndirectories = length(only_directory_filelist);
    originalDirectoryList = cell(Ndirectories,1);
    for ith_directory = 1:Ndirectories
        directoryPath = only_directory_filelist(ith_directory).folder;
        directoryName = only_directory_filelist(ith_directory).name;
        originalDirectoryList{ith_directory,1} = fullfile(directoryPath,directoryName);
    end

    % The original list contains locations in LargeData. Shift to Data
    newDirectoryList = replace(originalDirectoryList,'LargeData','Data');

    % List what will be saved
    clear saveFlags
    saveFlags.flag_forceDirectoryCreation = 0;
    saveFlags.flag_forceMATfileOverwrite = 1;

    % Call function
    fcn_LoadRawDataToMATLAB_saveRawDataMatFiles(rawDataCellArray, newDirectoryList, (saveFlags))

    %% ERROR because NOT allowed to force overwrite, but files exist
    % Need to run above Example 1 before testing

    % Load test data
    exampleDatafile = fullfile(cd,'Data','ExampleData_fromLoadRawDataFromDirectories.mat');
    load(exampleDatafile,'rawDataCellArray','only_directory_filelist');

    % Create a list of directory names
    clear originalDirectoryList
    Ndirectories = length(only_directory_filelist);
    originalDirectoryList = cell(Ndirectories,1);
    for ith_directory = 1:Ndirectories
        directoryPath = only_directory_filelist(ith_directory).folder;
        directoryName = only_directory_filelist(ith_directory).name;
        originalDirectoryList{ith_directory,1} = fullfile(directoryPath,directoryName);
    end

    % The original list contains locations in LargeData. Shift to Data
    newDirectoryList = replace(originalDirectoryList,'LargeData','Data');

    % List what will be saved
    clear saveFlags
    saveFlags.flag_forceDirectoryCreation = 1;
    saveFlags.flag_forceMATfileOverwrite = 0;

    % Call function
    fcn_LoadRawDataToMATLAB_saveRawDataMatFiles(rawDataCellArray, newDirectoryList, (saveFlags))

end
