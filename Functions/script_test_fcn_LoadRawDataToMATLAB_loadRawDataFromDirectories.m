% script_test_fcn_LoadRawDataToMATLAB_loadRawDataFromDirectories.m
% tests fcn_LoadRawDataToMATLAB_loadRawDataFromDirectories.m

% Revision history
% 2025_09_19 - sbrennan@psu.edu
% * In script_test_fcn_LoadRawDataToMATLAB_loadRawDataFromDirectories
% -- wrote the code originally, using 
%    script_test_fcn_DataClean_loadRawDataFromDirectories as starter

%% Set up the workspace
close all

%% Choose data folder and bag name, read before running the script
% The parsed the data files are saved on OneDrive
% in \IVSG\GitHubMirror\MappingVanDataCollection\ParsedData. To process the
% bag file, please copy file folder to the LargeData folder.


%% Test 1: Load all bag files from one given directory and all subdirectories
figNum = 1;
figure(figNum);
clf;

% Location for Pittsburgh, site 1
setenv('MATLABFLAG_PLOTROAD_REFERENCE_LATITUDE','40.44181017');
setenv('MATLABFLAG_PLOTROAD_REFERENCE_LONGITUDE','-79.76090840');
setenv('MATLABFLAG_PLOTROAD_REFERENCE_ALTITUDE','327.428');


clear Identifiers
Identifiers.Project = 'PennDOT ADS Workzones'; % This is the project sponsoring the data collection
Identifiers.ProjectStage = 'OnRoad'; % Can be 'Simulation', 'TestTrack', or 'OnRoad'
Identifiers.WorkZoneScenario = 'I376ParkwayPitt'; % Can be one of the ~20 scenarios, see key
Identifiers.WorkZoneDescriptor = 'WorkInRightLaneOfUndividedHighway'; % Can be one of the 20 descriptors, see key
Identifiers.Treatment = 'BaseMap'; % Can be one of 9 options, see key
Identifiers.DataSource = 'MappingVan'; % Can be 'MappingVan', 'AV', 'CV2X', etc. see key
Identifiers.AggregationType = 'PreRun'; % Can be 'PreCalibration', 'PreRun', 'Run', 'PostRun', or 'PostCalibration'
Identifiers.SourceBagFileName =''; % This is filled in automatically for each file

% Specify the bagQueryString
bagQueryString = 'mapping_van_2024-07-1*'; % The more specific, the better to avoid accidental loading of wrong information

% Spedify the fid
fid = 1; % 1 --> print to console

% Specify the Flags
Flags = []; 

% List which directory/directories need to be loaded
clear rootdirs
rootdirs{1} = fullfile(cd,'LargeData','2024-07-10');
% rootdirs{2} = fullfile(cd,'LargeData','2024-07-11');

% Call the function
rawDataCellArray = fcn_LoadRawDataToMATLAB_loadRawDataFromDirectories(...
    rootdirs, Identifiers, (bagQueryString), (fid), (Flags), (figNum));

% Check the results
assert(iscell(rawDataCellArray));


%% Test 2: Load all bag files from several given directories and all subdirectories
figNum = 2;
figure(figNum);
clf;

if 1==0  % Change to 1==1 to see it work (slow)

    % Location for Pittsburgh, site 1
    setenv('MATLABFLAG_PLOTROAD_REFERENCE_LATITUDE','40.44181017');
    setenv('MATLABFLAG_PLOTROAD_REFERENCE_LONGITUDE','-79.76090840');
    setenv('MATLABFLAG_PLOTROAD_REFERENCE_ALTITUDE','327.428');

    clear Identifiers
    Identifiers.Project = 'PennDOT ADS Workzones'; % This is the project sponsoring the data collection
    Identifiers.ProjectStage = 'OnRoad'; % Can be 'Simulation', 'TestTrack', or 'OnRoad'
    Identifiers.WorkZoneScenario = 'I376ParkwayPitt'; % Can be one of the ~20 scenarios, see key
    Identifiers.WorkZoneDescriptor = 'WorkInRightLaneOfUndividedHighway'; % Can be one of the 20 descriptors, see key
    Identifiers.Treatment = 'BaseMap'; % Can be one of 9 options, see key
    Identifiers.DataSource = 'MappingVan'; % Can be 'MappingVan', 'AV', 'CV2X', etc. see key
    Identifiers.AggregationType = 'PreRun'; % Can be 'PreCalibration', 'PreRun', 'Run', 'PostRun', or 'PostCalibration'
    Identifiers.SourceBagFileName =''; % This is filled in automatically for each file

    % Specify the bagQueryString
    bagQueryString = 'mapping_van_2024-07-1*'; % The more specific, the better to avoid accidental loading of wrong information

    % Spedify the fid
    fid = 1; % 1 --> print to console

    % Specify the Flags
    Flags = [];

    % List which directory/directories need to be loaded
    clear rootdirs
    rootdirs{1} = fullfile(cd,'LargeData','2024-07-10');
    rootdirs{2} = fullfile(cd,'LargeData','2024-07-11');

    % Call the function
    rawDataCellArray = fcn_LoadRawDataToMATLAB_loadRawDataFromDirectories(...
        rootdirs, Identifiers, (bagQueryString), (fid), (Flags), (figNum));

    % Check the results
    assert(iscell(rawDataCellArray));
end

%% Test 3: Load all bag files from several given directories and all subdirectories, no plotting
figNum = 3;
figure(figNum);
clf;

if 1==1  % Change to 1==1 to see it work (slow)
    % Location for Pittsburgh, site 1
    setenv('MATLABFLAG_PLOTROAD_REFERENCE_LATITUDE','40.44181017');
    setenv('MATLABFLAG_PLOTROAD_REFERENCE_LONGITUDE','-79.76090840');
    setenv('MATLABFLAG_PLOTROAD_REFERENCE_ALTITUDE','327.428');

    clear Identifiers
    Identifiers.Project = 'PennDOT ADS Workzones'; % This is the project sponsoring the data collection
    Identifiers.ProjectStage = 'OnRoad'; % Can be 'Simulation', 'TestTrack', or 'OnRoad'
    Identifiers.WorkZoneScenario = 'I376ParkwayPitt'; % Can be one of the ~20 scenarios, see key
    Identifiers.WorkZoneDescriptor = 'WorkInRightLaneOfUndividedHighway'; % Can be one of the 20 descriptors, see key
    Identifiers.Treatment = 'BaseMap'; % Can be one of 9 options, see key
    Identifiers.DataSource = 'MappingVan'; % Can be 'MappingVan', 'AV', 'CV2X', etc. see key
    Identifiers.AggregationType = 'PreRun'; % Can be 'PreCalibration', 'PreRun', 'Run', 'PostRun', or 'PostCalibration'
    Identifiers.SourceBagFileName =''; % This is filled in automatically for each file

    % Specify the bagQueryString
    bagQueryString = 'mapping_van_2024-07-1*'; % The more specific, the better to avoid accidental loading of wrong information

    % Spedify the fid
    fid = 0; % 1 --> print to console

    % Specify the Flags
    Flags = [];

    % List which directory/directories need to be loaded
    clear rootdirs
    rootdirs{1} = fullfile(cd,'LargeData','2024-07-10');
    rootdirs{2} = fullfile(cd,'LargeData','2024-07-11');
    
    % Call the function
    rawDataCellArray = fcn_LoadRawDataToMATLAB_loadRawDataFromDirectories(...
        rootdirs, Identifiers, (bagQueryString), (fid), (Flags), ([]));

    % Check the results
    assert(iscell(rawDataCellArray));
end

%% Test 4: Demonstrate data loading across many bag files and several directories
figNum = 4;
figure(figNum);
clf;

% Load the data across 2 different directories
% Save results into the "Data" directory
% Verbose

% Choose data folder and bag name, read before running the script
% The parsed the data files are saved on OneDrive
% in \IVSG\GitHubMirror\MappingVanDataCollection\ParsedData. To process the
% bag file, please copy file folder to the LargeData folder.

% For details on identifiers, see https://github.com/ivsg-psu/FieldDataCollection_VisualizingFieldData_LoadWorkZone
clear Identifiers
Identifiers.Project = 'PennDOT ADS Workzones'; % This is the project sponsoring the data collection
Identifiers.ProjectStage = 'OnRoad'; % Can be 'Simulation', 'TestTrack', or 'OnRoad'
Identifiers.WorkZoneScenario = 'I376ParkwayPitt'; % Can be one of the ~20 scenarios, see key
Identifiers.WorkZoneDescriptor = 'WorkInRightLaneOfUndividedHighway'; % Can be one of the 20 descriptors, see key
Identifiers.Treatment = 'BaseMap'; % Can be one of 9 options, see key
Identifiers.DataSource = 'MappingVan'; % Can be 'MappingVan', 'AV', 'CV2X', etc. see key
Identifiers.AggregationType = 'PreRun'; % Can be 'PreCalibration', 'PreRun', 'Run', 'PostRun', or 'PostCalibration'
Identifiers.SourceBagFileName =''; % This is filled in automatically for each file

% Specify the bagQueryString
bagQueryString = 'mapping_van_2024-07-1*'; % The more specific, the better to avoid accidental loading of wrong information

% Spedify the fid
fid = 1; % 1 --> print to console, 0--> no printing

% Specify the Flags
Flags = []; 

% List which directory/directories need to be loaded
clear rootdirs
rootdirs{1} = fullfile(cd,'LargeData','2024-07-10'); % There are 5 data here
rootdirs{2} = fullfile(cd,'LargeData','2024-07-11');  % There are 52 data here

% Call the data loading function
% Call the function
[rawDataCellArray, only_directory_filelist] = fcn_LoadRawDataToMATLAB_loadRawDataFromDirectories(...
    rootdirs, Identifiers, (bagQueryString), (fid), (Flags), (figNum));

% Show that we get a cell array of data with more than 1 entry
assert(iscell(rawDataCellArray));
assert(length(rawDataCellArray)>1);
assert(length(rawDataCellArray)==length(only_directory_filelist));

exampleDatafile = fullfile(cd,'Data','ExampleData_fromLoadRawDataFromDirectories.mat');
save(exampleDatafile,'rawDataCellArray','only_directory_filelist','-mat','-v7.3');

%% Fail conditions
if 1==0
    %% ERROR for bad data folder
    bagName = "badData";
    rawdata = fcn_LoadRawDataToMATLAB_loadRawDataFromDirectories(bagName, bagName);
end
