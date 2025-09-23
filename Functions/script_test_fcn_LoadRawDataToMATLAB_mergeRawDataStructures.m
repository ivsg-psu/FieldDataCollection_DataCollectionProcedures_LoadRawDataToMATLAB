% script_test_fcn_LoadRawDataToMATLAB_mergeRawDataStructures.m
% tests fcn_DataClean_mergeRawDataStructures.m

% Revision history
% 2024_09_15 - sbrennan@psu.edu
% -- wrote the code originally, using Laps_checkZoneType as starter

%% Set up the workspace
close all



%% Test 1: Simple merge using data from Site 1 - Pittsburgh 
figNum = 1;
figure(figNum);
clf;

% Location for Pittsburgh, site 1
setenv('MATLABFLAG_PLOTROAD_REFERENCE_LATITUDE','40.44181017');
setenv('MATLABFLAG_PLOTROAD_REFERENCE_LONGITUDE','-79.76090840');
setenv('MATLABFLAG_PLOTROAD_REFERENCE_ALTITUDE','327.428');

%%%%
% Load test data
load('ExampleData_fromLoadRawDataFromDirectories.mat','rawDataCellArray');
% 
% 
% % Choose data folder and bag name, read before running the script
% % The parsed the data files are saved on OneDrive
% % in \IVSG\GitHubMirror\MappingVanDataCollection\ParsedData. To process the
% % bag file, please copy file folder to the LargeData folder.
% 
% % For details on identifiers, see https://github.com/ivsg-psu/FieldDataCollection_VisualizingFieldData_LoadWorkZone
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
% % Specify the bagQueryString
% bagQueryString = 'mapping_van_2024-07-1*'; % The more specific, the better to avoid accidental loading of wrong information
% 
% % Spedify the fid
% fid = 0; % 1 --> print to console
% 
% % Specify the Flags
% Flags = []; 
% 
% % List which directory/directories need to be loaded
% clear rootdirs
% rootdirs{1} = fullfile(cd,'LargeData','2024-07-10'); % There are 5 data here
% rootdirs{2} = fullfile(cd,'LargeData','2024-07-11');  % There are 52 data here
% 
% % List what will be saved
% saveFlags.flag_saveMatFile = 0;
% saveFlags.flag_saveMatFile_directory = fullfile(cd,'Data','RawData',Identifiers.ProjectStage,Identifiers.WorkZoneScenario);
% saveFlags.flag_saveImages = 0;
% saveFlags.flag_saveImages_directory  = fullfile(cd,'Data','RawData',Identifiers.ProjectStage,Identifiers.WorkZoneScenario);
% saveFlags.flag_forceDirectoryCreation = 1;
% saveFlags.flag_forceImageOverwrite = 1;
% saveFlags.flag_forceMATfileOverwrite = 1;
% 
% % List what will be plotted, and the figure numbers
% plotFlags.fig_num_plotAllRawTogether = [];
% plotFlags.fig_num_plotAllRawIndividually = [];
% 
% % Call the data loading function
% rawDataCellArray = fcn_LoadRawDataToMATLAB_loadRawDataFromDirectories(rootdirs, Identifiers, (bagQueryString), (fid), (Flags), (saveFlags), (plotFlags));

%%%%
% Prepare for merging
% Specify the nearby time
thresholdTimeNearby = 10;

% Spedify the fid
fid = 1; % 1 --> print to console
% consoleFname = fullfile(cd,'Data','RawDataMerged',Identifiers.ProjectStage,Identifiers.WorkZoneScenario,'MergeProcessingMessages.txt');
% fid = fopen(consoleFname,'w');

% Call the function
[mergedRawDataCellArray, uncommonFieldsCellArray] = ...
    fcn_LoadRawDataToMATLAB_mergeRawDataStructures(rawDataCellArray, ...
    (thresholdTimeNearby), (fid), (figNum));

% Check the results
assert(iscell(mergedRawDataCellArray));
assert(iscell(uncommonFieldsCellArray));




%% Fail conditions
if 1==0
    %% ERROR for bad data folder
    bagName = "badData";
    rawdata = fcn_LoadRawDataToMATLAB_loadMappingVanDataFromFile(bagName, bagName);
end
