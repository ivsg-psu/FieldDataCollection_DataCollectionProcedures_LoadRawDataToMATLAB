
%% Introduction to and Purpose of the Code
% This is the explanation of the code that can be found by running
%       script_demo_LoadRawDataToMATLAB.m
% This is a script to demonstrate the functions within the LoadRawDataToMATLAB code
% library. This code repo is typically located at:
%   https://github.com/ivsg-psu/FieldDataCollection_DataCollectionProcedures_LoadRawDataToMATLAB
%
% If you have questions or comments, please contact Sean Brennan at
% sbrennan@psu.edu
%
% The purpose of the code is to load "raw" data - CSV files primarily -
% into formats that MATLAB can digest.


% Revision history:
% 2025_09_19 - Sean Brennan
% -- created this repo by pulling "loading" codes out of DataCleanClass

% TO-DO:
% -- add items here

clear library_name library_folders library_url

ith_library = 1;
library_name{ith_library}    = 'DebugTools_v2025_09_19c';
library_folders{ith_library} = {'Functions','Data'};
library_url{ith_library}     = 'https://github.com/ivsg-psu/Errata_Tutorials_DebugTools/archive/refs/tags/DebugTools_v2025_09_19c.zip';

ith_library = ith_library+1;
library_name{ith_library}    = 'PathClass_v2025_08_03';
library_folders{ith_library} = {'Functions'};
library_url{ith_library}     = 'https://github.com/ivsg-psu/PathPlanning_PathTools_PathClassLibrary/archive/refs/tags/PathClass_v2025_08_03.zip';

ith_library = ith_library+1;
library_name{ith_library}    = 'GetUserInputPath_v2025_04_27';
library_folders{ith_library} = {''};
library_url{ith_library}     = 'https://github.com/ivsg-psu/PathPlanning_PathTools_GetUserInputPath/archive/refs/tags/GetUserInputPath_v2025_04_27.zip';

ith_library = ith_library+1;
library_name{ith_library}    = 'PlotRoad_v2025_07_16';
library_folders{ith_library} = {'Functions','Data'};
library_url{ith_library}     = 'https://github.com/ivsg-psu/FieldDataCollection_VisualizingFieldData_PlotRoad/archive/refs/tags/PlotRoad_v2025_07_16.zip';

ith_library = ith_library+1;
library_name{ith_library}    = 'GeometryClass_v2025_05_31';
library_folders{ith_library} = {'Functions'};
library_url{ith_library}     = 'https://github.com/ivsg-psu/PathPlanning_GeomTools_GeomClassLibrary/archive/refs/tags/GeometryClass_v2025_05_31.zip';

ith_library = ith_library+1;
library_name{ith_library}    = 'GPSClass_v2023_04_21';
library_folders{ith_library} = {''};
library_url{ith_library}     = 'https://github.com/ivsg-psu/FieldDataCollection_GPSRelatedCodes_GPSClass/archive/refs/tags/GPSClass_v2023_04_21.zip';

% ith_library = ith_library+1;
% library_name{ith_library}    = 'AlignCoordinates_2023_03_29';
% library_folders{ith_library} = {'Functions'};
% library_url{ith_library}     = 'https://github.com/ivsg-psu/PathPlanning_GeomTools_AlignCoordinates/blob/main/Releases/AlignCoordinates_2023_03_29.zip?raw=true';


%% Clear paths and folders, if needed
if 1==0
    clear flag_LoadRawDataToMATLAB_Folders_Initialized
    fcn_INTERNAL_clearUtilitiesFromPathAndFolders;

end

%% Do we need to set up the work space?
if ~exist('flag_LoadRawDataToMATLAB_Folders_Initialized','var')
    this_project_folders = {'Functions','Data','LargeData'};
    fcn_INTERNAL_initializeUtilities(library_name,library_folders,library_url,this_project_folders);
    flag_LoadRawDataToMATLAB_Folders_Initialized = 1;
end

%% Set environment flags for input checking in LoadRawDataToMATLAB library
% These are values to set if we want to check inputs or do debugging
setenv('MATLABFLAG_LOADRAWDATATOMATLAB_FLAG_CHECK_INPUTS','1');
setenv('MATLABFLAG_LOADRAWDATATOMATLAB_FLAG_DO_DEBUG','0');

%% Set environment flags that define the ENU origin
% This sets the "center" of the ENU coordinate system for all plotting
% functions
% Location for Test Track base station
setenv('MATLABFLAG_PLOTROAD_REFERENCE_LATITUDE','40.86368573');
setenv('MATLABFLAG_PLOTROAD_REFERENCE_LONGITUDE','-77.83592832');
setenv('MATLABFLAG_PLOTROAD_REFERENCE_ALTITUDE','344.189');


%% Set environment flags for plotting
% These are values to set if we are forcing image alignment via Lat and Lon
% shifting, when doing geoplot. This is added because the geoplot images
% are very, very slightly off at the test track, which is confusing when
% plotting data
setenv('MATLABFLAG_PLOTROAD_ALIGNMATLABLLAPLOTTINGIMAGES_LAT','-0.0000008');
setenv('MATLABFLAG_PLOTROAD_ALIGNMATLABLLAPLOTTINGIMAGES_LON','0.0000054');

%% Start of Demo Code
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   _____ _             _            __   _____                          _____          _
%  / ____| |           | |          / _| |  __ \                        / ____|        | |
% | (___ | |_ __ _ _ __| |_    ___ | |_  | |  | | ___ _ __ ___   ___   | |     ___   __| | ___
%  \___ \| __/ _` | '__| __|  / _ \|  _| | |  | |/ _ \ '_ ` _ \ / _ \  | |    / _ \ / _` |/ _ \
%  ____) | || (_| | |  | |_  | (_) | |   | |__| |  __/ | | | | | (_) | | |___| (_) | (_| |  __/
% |_____/ \__\__,_|_|   \__|  \___/|_|   |_____/ \___|_| |_| |_|\___/   \_____\___/ \__,_|\___|
%
%
% See: http://patorjk.com/software/taag/#p=display&f=Big&t=Start%20of%20Demo%20Code
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf(1,['Welcome to the demo code for the LoadRawDataToMATLAB library! \n' ...
    'The purpose of this library is to read data from the outputs produced \n' ...
    'by the parsing operations on a bag file, and load the data into \n' ...
    'a structured format within a MATLAB variable. Core library functionalities \n' ...
    'include: \n' ...
    '* Loading mapping van data from a file into a rawData structure. \n' ...
    '\t See: fcn_LoadRawDataToMATLAB_loadMappingVanDataFromFile\n' ...
    '* Plotting one or many rawData structures, saving plots to file. \n' ...
    '\t See: fcn_LoadRawDataToMATLAB_plotRawDataPositions\n' ...
    '* Saving rawData structures into mat file format. \n' ...
    '\t See: fcn_LoadRawDataToMATLAB_saveRawDataMatFiles\n' ...
    '* Merging sequences of rawData structures into one rawData structure. \n' ...
    '\t See: fcn_LoadRawDataToMATLAB_mergeRawDataStructures\n' ...
    ''])

%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   _____ _                 _        __  __                       ______                           _
%  / ____(_)               | |      |  \/  |                     |  ____|                         | |
% | (___  _ _ __ ___  _ __ | | ___  | \  / | ___ _ __ __ _  ___  | |__  __  ____ _ _ __ ___  _ __ | | ___  ___
%  \___ \| | '_ ` _ \| '_ \| |/ _ \ | |\/| |/ _ \ '__/ _` |/ _ \ |  __| \ \/ / _` | '_ ` _ \| '_ \| |/ _ \/ __|
%  ____) | | | | | | | |_) | |  __/ | |  | |  __/ | | (_| |  __/ | |____ >  < (_| | | | | | | |_) | |  __/\__ \
% |_____/|_|_| |_| |_| .__/|_|\___| |_|  |_|\___|_|  \__, |\___| |______/_/\_\__,_|_| |_| |_| .__/|_|\___||___/
%                    | |                              __/ |                                 | |
%                    |_|                             |___/                                  |_|
% See: http://patorjk.com/software/taag/#p=display&f=Big&t=Simple%20Merge%20Examples
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    
%% Test 1: Simple merge using data from Site 1 - Pittsburgh 
% Location for Pittsburgh, site 1
setenv('MATLABFLAG_PLOTROAD_REFERENCE_LATITUDE','40.44181017');
setenv('MATLABFLAG_PLOTROAD_REFERENCE_LONGITUDE','-79.76090840');
setenv('MATLABFLAG_PLOTROAD_REFERENCE_ALTITUDE','327.428');

%% Demonstrate data loading from LargeData, many bag files and several directories
% Loads the data across 2 directories

% Choose data folder and bag name, read before running the script
% The parsed the data files are saved on OneDrive
% in \IVSG\GitHubMirror\MappingVanDataCollection\ParsedData. To process the
% bag file, please copy file folder to the LargeData folder.

% List which directory/directories need to be loaded
clear rootdirs
rootdirs{1} = fullfile(cd,'LargeData','2024-07-10'); % There are 5 data here
rootdirs{2} = fullfile(cd,'LargeData','2024-07-11');  % There are 52 data here

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
fid = 1; % 1 --> print to console, 0 --> no printing

% Specify the Flags
Flags = []; % Use defaults

% Call the data loading function
[rawDataCellArray, only_directory_filelist] = fcn_LoadRawDataToMATLAB_loadRawDataFromDirectories(...
    rootdirs, Identifiers, (bagQueryString), (fid), (Flags), (figNum));

% Show that we get a cell array of data with more than 1 entry
assert(iscell(rawDataCellArray));
assert(length(rawDataCellArray)>1);
assert(length(rawDataCellArray)==length(only_directory_filelist));

%% Demonstrate plotting and plot saving of the above data
% NOTE: can save plots by changing flags

% List what will be saved
clear saveFlags
saveFlags.flag_saveImages = 1;
imageDirectory = fullfile(cd,'Data','RawData',rawDataCellArray{1}.Identifiers.ProjectStage,rawDataCellArray{1}.Identifiers.WorkZoneScenario);
saveFlags.flag_saveImages_directory  = imageDirectory;
saveFlags.flag_forceDirectoryCreation = 1;
saveFlags.flag_forceImageOverwrite = 1;

% List what will be plotted, and the figure numbers
clear plotFlags
plotFlags.fig_num_plotAllRawTogether = figNum;
plotFlags.fig_num_plotAllRawIndividually = [];

% Call function to plot data, and save plots into file formats
fcn_LoadRawDataToMATLAB_plotRawDataPositions(rawDataCellArray, (saveFlags), (plotFlags));

%% Save results to a new directory (in Data)

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

%% Demonstrate that can load the MAT files via queries
clear searchIdentifiers
searchIdentifiers.Project = 'PennDOT ADS Workzones'; % This is the project sponsoring the data collection
searchIdentifiers.ProjectStage = 'OnRoad'; % Can be 'Simulation', 'TestTrack', or 'OnRoad'
searchIdentifiers.WorkZoneScenario = 'PA51Aliquippa'; % Can be one of the ~20 scenarios, see key
searchIdentifiers.WorkZoneDescriptor = 'WorkInRightLaneMobileWorkzone'; % Can be one of the 20 descriptors, see key
searchIdentifiers.Treatment = 'BaseMap'; % Can be one of 9 options, see key
searchIdentifiers.DataSource = 'MappingVan'; % Can be 'MappingVan', 'AV', 'CV2X', etc. see key
searchIdentifiers.AggregationType = 'PreRun'; % Can be 'PreCalibration', 'PreRun', 'Run', 'PostRun', or 'PostCalibration'

% Specify the bagQueryString
matQueryString = 'mapping_van_*.mat'; % The more specific, the better to avoid accidental loading of wrong information
%matQueryString = 'mapping_van_*_merged.mat'; % The more specific, the better to avoid accidental loading of wrong information

% Spedify the fid
fid = 1; % 1 --> print to console

% List which directory/directories need to be loaded
clear rootdirs
rootdirs{1} = fullfile(cd,'Data'); % ,'2024-07-10');
% rootdirs{2} = fullfile(cd,'LargeData','2024-07-11');

% Call the function
searchIdentifiers = [];
rawDataCellArray2 = fcn_LoadRawDataToMATLAB_loadMatDataFromDirectories(...
    rootdirs, (searchIdentifiers), (matQueryString), (fid), (figNum));
assert(length(rawDataCellArray2) == length(rawDataCellArray));


%% Demonstrate merging of the above data
% Prepare for merging

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


%% Test 2: Simple merge using data from Site 2 - Falling Water

% Location for Site 2, Falling water
setenv('MATLABFLAG_PLOTROAD_REFERENCE_LATITUDE','39.995339');
setenv('MATLABFLAG_PLOTROAD_REFERENCE_LONGITUDE','-79.445472');
setenv('MATLABFLAG_PLOTROAD_REFERENCE_ALTITUDE','344.189');

%%%%
% Load the data

% Choose data folder and bag name, read before running the script
% The parsed the data files are saved on OneDrive
% in \IVSG\GitHubMirror\MappingVanDataCollection\ParsedData. To process the
% bag file, please copy file folder to the LargeData folder.

% For details on identifiers, see https://github.com/ivsg-psu/FieldDataCollection_VisualizingFieldData_LoadWorkZone
clear Identifiers
Identifiers.Project = 'PennDOT ADS Workzones'; % This is the project sponsoring the data collection
Identifiers.ProjectStage = 'OnRoad'; % Can be 'Simulation', 'TestTrack', or 'OnRoad'
Identifiers.WorkZoneScenario = 'PA653Normalville'; % Can be one of the ~20 scenarios, see key
Identifiers.WorkZoneDescriptor = 'SingleLaneApproachWithTemporarySignals'; % Can be one of the 20 descriptors, see key
Identifiers.Treatment = 'BaseMap'; % Can be one of 9 options, see key
Identifiers.DataSource = 'MappingVan'; % Can be 'MappingVan', 'AV', 'CV2X', etc. see key
Identifiers.AggregationType = 'PreRun'; % Can be 'PreCalibration', 'PreRun', 'Run', 'PostRun', or 'PostCalibration'
Identifiers.SourceBagFileName =''; % This is filled in automatically for each file

% Specify the bagQueryString
bagQueryString = 'mapping_van_2024-08-22*'; % The more specific, the better to avoid accidental loading of wrong information

% Spedify the fid
fid = 1; % 1 --> print to console

% Specify the Flags
Flags = []; 

% List which directory/directories need to be loaded
clear rootdirs
rootdirs{1} = fullfile(cd,'LargeData','ParsedBags_PoseOnly', 'OnRoad', 'PA653Normalville', '2024-08-22'); % Pre

% List what will be saved
saveFlags.flag_saveMatFile = 1;
saveFlags.flag_saveMatFile_directory = fullfile(cd,'Data','RawData',Identifiers.ProjectStage,Identifiers.WorkZoneScenario);
saveFlags.flag_saveImages = 1;
saveFlags.flag_saveImages_directory  = fullfile(cd,'Data','RawData',Identifiers.ProjectStage,Identifiers.WorkZoneScenario);
saveFlags.flag_forceDirectoryCreation = 1;
saveFlags.flag_forceImageOverwrite = 1;
saveFlags.flag_forceMATfileOverwrite = 1;

% List what will be plotted, and the figure numbers
plotFlags.fig_num_plotAllRawTogether = 3333; % [];
plotFlags.fig_num_plotAllRawIndividually = 4444; %[];

% Call the data loading function
rawDataCellArray = fcn_LoadRawDataToMATLAB_loadRawDataFromDirectories(rootdirs, Identifiers, (bagQueryString), (fid), (Flags), (saveFlags), (plotFlags));

%%%%%%%%%%%%%%
% Prepare for merging
% Specify the nearby time
thresholdTimeNearby = 10;

% Spedify the fid
% fid = 1; % 1 --> print to console
readmeFilename = fullfile(cd,'Data','RawDataMerged',Identifiers.ProjectStage,Identifiers.WorkZoneScenario,'MergeProcessingMessages.txt');
fid = fopen(readmeFilename,'w');

% List what will be saved
saveFlags.flag_saveMatFile = 1;
saveFlags.flag_saveMatFile_directory = fullfile(cd,'Data','RawDataMerged',Identifiers.ProjectStage,Identifiers.WorkZoneScenario);
saveFlags.flag_saveImages = 1;
saveFlags.flag_saveImages_directory  = fullfile(cd,'Data','RawDataMerged',Identifiers.ProjectStage,Identifiers.WorkZoneScenario);
saveFlags.flag_saveImages_name = cat(2,Identifiers.WorkZoneScenario,'_merged');
saveFlags.flag_forceDirectoryCreation = 1;
saveFlags.flag_forceImageOverwrite = 1;
saveFlags.flag_forceMATfileOverwrite = 1;

% List what will be plotted, and the figure numbers
plotFlags.fig_num_plotAllMergedTogether = 1111; %[];
plotFlags.fig_num_plotAllMergedIndividually = 2222; %[];
    
plotFlags.mergedplotFormat.LineStyle = '-';
plotFlags.mergedplotFormat.LineWidth = 2;
plotFlags.mergedplotFormat.Marker = 'none';
plotFlags.mergedplotFormat.MarkerSize = 5;


% Call the function
[mergedRawDataCellArray, uncommonFieldsCellArray] = fcn_LoadRawDataToMATLAB_mergeRawDataStructures(rawDataCellArray, (thresholdTimeNearby), (fid), (saveFlags), (plotFlags));

% Check the results
assert(iscell(mergedRawDataCellArray));
assert(iscell(uncommonFieldsCellArray));

%% Test 3: Simple merge using data from Site 3 - Line Painting - PRE
% Location for Aliquippa, site 3
setenv('MATLABFLAG_PLOTROAD_REFERENCE_LATITUDE','40.694871');
setenv('MATLABFLAG_PLOTROAD_REFERENCE_LONGITUDE','-80.263755');
setenv('MATLABFLAG_PLOTROAD_REFERENCE_ALTITUDE','223.294');

%%%%
% Load the data for the "PRE" portion

% Choose data folder and bag name, read before running the script
% The parsed the data files are saved on OneDrive
% in \IVSG\GitHubMirror\MappingVanDataCollection\ParsedData. To process the
% bag file, please copy file folder to the LargeData folder.

% For details on identifiers, see https://github.com/ivsg-psu/FieldDataCollection_VisualizingFieldData_LoadWorkZone
clear Identifiers
Identifiers.Project = 'PennDOT ADS Workzones'; % This is the project sponsoring the data collection
Identifiers.ProjectStage = 'OnRoad'; % Can be 'Simulation', 'TestTrack', or 'OnRoad'
Identifiers.WorkZoneScenario = 'PA51Aliquippa'; % Can be one of the ~20 scenarios, see key
Identifiers.WorkZoneDescriptor = 'WorkInRightLaneMobileWorkzone'; % Can be one of the 20 descriptors, see key
Identifiers.Treatment = 'BaseMap'; % Can be one of 9 options, see key
Identifiers.DataSource = 'MappingVan'; % Can be 'MappingVan', 'AV', 'CV2X', etc. see key
Identifiers.AggregationType = 'PreRun'; % Can be 'PreCalibration', 'PreRun', 'Run', 'PostRun', or 'PostCalibration'
Identifiers.SourceBagFileName =''; % This is filled in automatically for each file

% Specify the bagQueryString
bagQueryString = 'mapping_van_2024-09-19*'; % The more specific, the better to avoid accidental loading of wrong information
% bagQueryString = 'mapping_van_2024-09-19-13-04-*'; % The more specific, the better to avoid accidental loading of wrong information


% Spedify the fid
fid = 1; % 1 --> print to console

% Specify the Flags
Flags = []; 

% List which directory/directories need to be loaded
clear rootdirs
rootdirs{1} = fullfile(cd,'LargeData','ParsedBags_PoseOnly', 'OnRoad', 'PA51Aliquippa', '2024-09-19'); % Pre
% rootdirs{1} = fullfile(cd,'LargeData','2024-09-20'); % Post

% List what will be saved
saveFlags.flag_saveMatFile = 1;
saveFlags.flag_saveMatFile_directory = fullfile(cd,'Data','RawData',Identifiers.ProjectStage,Identifiers.WorkZoneScenario);
saveFlags.flag_saveImages = 1;
saveFlags.flag_saveImages_directory  = fullfile(cd,'Data','RawData',Identifiers.ProjectStage,Identifiers.WorkZoneScenario);
saveFlags.flag_forceDirectoryCreation = 1;
saveFlags.flag_forceImageOverwrite = 1;
saveFlags.flag_forceMATfileOverwrite = 1;

% List what will be plotted, and the figure numbers
plotFlags.fig_num_plotAllRawTogether = 1111; %[];
plotFlags.fig_num_plotAllRawIndividually = 2222; %[];

% Call the data loading function
rawDataCellArray = fcn_LoadRawDataToMATLAB_loadRawDataFromDirectories(rootdirs, Identifiers, (bagQueryString), (fid), (Flags), (saveFlags), (plotFlags));

%%%%
% Prepare for merging
% Specify the nearby time
thresholdTimeNearby = 10;

% Spedify the fid
% fid = 1; % 1 --> print to console
readmeFilename = fullfile(cd,'Data','RawDataMerged',Identifiers.ProjectStage,Identifiers.WorkZoneScenario,'MergeProcessingMessages.txt');
fid = fopen(readmeFilename,'w');

% List what will be saved
saveFlags.flag_saveMatFile = 1;
saveFlags.flag_saveMatFile_directory = fullfile(cd,'Data','RawDataMerged',Identifiers.ProjectStage,Identifiers.WorkZoneScenario);
saveFlags.flag_saveImages = 1;
saveFlags.flag_saveImages_directory  = fullfile(cd,'Data','RawDataMerged',Identifiers.ProjectStage,Identifiers.WorkZoneScenario);
saveFlags.flag_saveImages_name = cat(2,Identifiers.WorkZoneScenario,'_merged');
saveFlags.flag_forceDirectoryCreation = 1;
saveFlags.flag_forceImageOverwrite = 1;
saveFlags.flag_forceMATfileOverwrite = 1;

% List what will be plotted, and the figure numbers
plotFlags.fig_num_plotAllMergedTogether = 3333; %[];
plotFlags.fig_num_plotAllMergedIndividually = 4444; %[];
    
plotFlags.mergedplotFormat.LineStyle = '-';
plotFlags.mergedplotFormat.LineWidth = 2;
plotFlags.mergedplotFormat.Marker = 'none';
plotFlags.mergedplotFormat.MarkerSize = 5;


% Call the function
[mergedRawDataCellArray, uncommonFieldsCellArray] = fcn_LoadRawDataToMATLAB_mergeRawDataStructures(rawDataCellArray, (thresholdTimeNearby), (fid), (saveFlags), (plotFlags));

% Check the results
assert(iscell(mergedRawDataCellArray));
assert(iscell(uncommonFieldsCellArray));

%% Test 3: Simple merge using data from Site 3 - Line Painting - POST
% Location for Aliquippa, site 3
setenv('MATLABFLAG_PLOTROAD_REFERENCE_LATITUDE','40.694871');
setenv('MATLABFLAG_PLOTROAD_REFERENCE_LONGITUDE','-80.263755');
setenv('MATLABFLAG_PLOTROAD_REFERENCE_ALTITUDE','223.294');

%%%%
% Load the data for the "PRE" portion

% Choose data folder and bag name, read before running the script
% The parsed the data files are saved on OneDrive
% in \IVSG\GitHubMirror\MappingVanDataCollection\ParsedData. To process the
% bag file, please copy file folder to the LargeData folder.

% For details on identifiers, see https://github.com/ivsg-psu/FieldDataCollection_VisualizingFieldData_LoadWorkZone
clear Identifiers
Identifiers.Project = 'PennDOT ADS Workzones'; % This is the project sponsoring the data collection
Identifiers.ProjectStage = 'OnRoad'; % Can be 'Simulation', 'TestTrack', or 'OnRoad'
Identifiers.WorkZoneScenario = 'PA51Aliquippa'; % Can be one of the ~20 scenarios, see key
Identifiers.WorkZoneDescriptor = 'WorkInRightLaneMobileWorkzone'; % Can be one of the 20 descriptors, see key
Identifiers.Treatment = 'BaseMap'; % Can be one of 9 options, see key
Identifiers.DataSource = 'MappingVan'; % Can be 'MappingVan', 'AV', 'CV2X', etc. see key
Identifiers.AggregationType = 'PostRun'; % Can be 'PreCalibration', 'PreRun', 'Run', 'PostRun', or 'PostCalibration'
Identifiers.SourceBagFileName =''; % This is filled in automatically for each file

% Specify the bagQueryString
bagQueryString = 'mapping_van_2024-09-20*'; % The more specific, the better to avoid accidental loading of wrong information

% Spedify the fid
fid = 1; % 1 --> print to console

% Specify the Flags
Flags = []; 

% List which directory/directories need to be loaded
clear rootdirs
% rootdirs{1} = fullfile(cd,'LargeData','ParsedBags_PoseOnly', 'OnRoad', 'PA51Aliquippa', '2024-09-19'); % Pre
rootdirs{1} = fullfile(cd,'LargeData','ParsedBags_PoseOnly', 'OnRoad', 'PA51Aliquippa', '2024-09-20'); % Post

% List what will be saved
saveFlags.flag_saveMatFile = 1;
saveFlags.flag_saveMatFile_directory = fullfile(cd,'Data','RawData',Identifiers.ProjectStage,Identifiers.WorkZoneScenario);
saveFlags.flag_saveImages = 1;
saveFlags.flag_saveImages_directory  = fullfile(cd,'Data','RawData',Identifiers.ProjectStage,Identifiers.WorkZoneScenario);
saveFlags.flag_forceDirectoryCreation = 1;
saveFlags.flag_forceImageOverwrite = 1;
saveFlags.flag_forceMATfileOverwrite = 1;

% List what will be plotted, and the figure numbers
plotFlags.fig_num_plotAllRawTogether = 111; %[];
plotFlags.fig_num_plotAllRawIndividually = 2222; %[];

% Call the data loading function
rawDataCellArray = fcn_LoadRawDataToMATLAB_loadRawDataFromDirectories(rootdirs, Identifiers, (bagQueryString), (fid), (Flags), (saveFlags), (plotFlags));

%%%%
% Prepare for merging
% Specify the nearby time
thresholdTimeNearby = 10;

% Spedify the fid
% fid = 1; % 1 --> print to console
readmeFilename = fullfile(cd,'Data','RawDataMerged',Identifiers.ProjectStage,Identifiers.WorkZoneScenario,'MergeProcessingMessages.txt');
fid = fopen(readmeFilename,'w');

% List what will be saved
saveFlags.flag_saveMatFile = 1;
saveFlags.flag_saveMatFile_directory = fullfile(cd,'Data','RawDataMerged',Identifiers.ProjectStage,Identifiers.WorkZoneScenario);
saveFlags.flag_saveImages = 1;
saveFlags.flag_saveImages_directory  = fullfile(cd,'Data','RawDataMerged',Identifiers.ProjectStage,Identifiers.WorkZoneScenario);
saveFlags.flag_saveImages_name = cat(2,Identifiers.WorkZoneScenario,'_merged');
saveFlags.flag_forceDirectoryCreation = 1;
saveFlags.flag_forceImageOverwrite = 1;
saveFlags.flag_forceMATfileOverwrite = 1;

% List what will be plotted, and the figure numbers
plotFlags.fig_num_plotAllMergedTogether = 333; % [];
plotFlags.fig_num_plotAllMergedIndividually = 4444; %[];
    
plotFlags.mergedplotFormat.LineStyle = '-';
plotFlags.mergedplotFormat.LineWidth = 2;
plotFlags.mergedplotFormat.Marker = 'none';
plotFlags.mergedplotFormat.MarkerSize = 5;


% Call the function
[mergedRawDataCellArray, uncommonFieldsCellArray] = fcn_LoadRawDataToMATLAB_mergeRawDataStructures(rawDataCellArray, (thresholdTimeNearby), (fid), (saveFlags), (plotFlags));

% Check the results
assert(iscell(mergedRawDataCellArray));
assert(iscell(uncommonFieldsCellArray));

%% Test 3: Simple merge using data from Site 3 - Line Painting - ALL
% Location for Aliquippa, site 3
setenv('MATLABFLAG_PLOTROAD_REFERENCE_LATITUDE','40.694871');
setenv('MATLABFLAG_PLOTROAD_REFERENCE_LONGITUDE','-80.263755');
setenv('MATLABFLAG_PLOTROAD_REFERENCE_ALTITUDE','223.294');

%%%%
% Load the data for the "PRE" portion

% Choose data folder and bag name, read before running the script
% The parsed the data files are saved on OneDrive
% in \IVSG\GitHubMirror\MappingVanDataCollection\ParsedData. To process the
% bag file, please copy file folder to the LargeData folder.

% For details on identifiers, see https://github.com/ivsg-psu/FieldDataCollection_VisualizingFieldData_LoadWorkZone
clear Identifiers
Identifiers.Project = 'PennDOT ADS Workzones'; % This is the project sponsoring the data collection
Identifiers.ProjectStage = 'OnRoad'; % Can be 'Simulation', 'TestTrack', or 'OnRoad'
Identifiers.WorkZoneScenario = 'PA51Aliquippa'; % Can be one of the ~20 scenarios, see key
Identifiers.WorkZoneDescriptor = 'WorkInRightLaneMobileWorkzone'; % Can be one of the 20 descriptors, see key
Identifiers.Treatment = 'BaseMap'; % Can be one of 9 options, see key
Identifiers.DataSource = 'MappingVan'; % Can be 'MappingVan', 'AV', 'CV2X', etc. see key
Identifiers.AggregationType = 'PostRun'; % Can be 'PreCalibration', 'PreRun', 'Run', 'PostRun', or 'PostCalibration'
Identifiers.SourceBagFileName =''; % This is filled in automatically for each file

% Specify the bagQueryString
bagQueryString = 'mapping_van_2024-09-*'; % The more specific, the better to avoid accidental loading of wrong information

% Spedify the fid
fid = 1; % 1 --> print to console

% Specify the Flags
Flags = []; 

% List which directory/directories need to be loaded
clear rootdirs
rootdirs{1} = fullfile(cd,'LargeData','ParsedBags_PoseOnly', 'OnRoad', 'PA51Aliquippa', '2024-09-19'); % Pre
rootdirs{2} = fullfile(cd,'LargeData','ParsedBags_PoseOnly', 'OnRoad', 'PA51Aliquippa', '2024-09-20'); % Post

% List what will be saved
saveFlags.flag_saveMatFile = 0;
saveFlags.flag_saveMatFile_directory = fullfile(cd,'Data','RawData',Identifiers.ProjectStage,Identifiers.WorkZoneScenario);
saveFlags.flag_saveImages = 0;
saveFlags.flag_saveImages_directory  = fullfile(cd,'Data','RawData',Identifiers.ProjectStage,Identifiers.WorkZoneScenario);
saveFlags.flag_forceDirectoryCreation = 1;
saveFlags.flag_forceImageOverwrite = 1;
saveFlags.flag_forceMATfileOverwrite = 1;

% List what will be plotted, and the figure numbers
plotFlags.fig_num_plotAllRawTogether = []; % 3333;
plotFlags.fig_num_plotAllRawIndividually = []; %4444;

% Call the data loading function
rawDataCellArray = fcn_LoadRawDataToMATLAB_loadRawDataFromDirectories(rootdirs, Identifiers, (bagQueryString), (fid), (Flags), (saveFlags), (plotFlags));

%%%%
% Prepare for merging
% Specify the nearby time
thresholdTimeNearby = 10;

% Spedify the fid
fid = 1; % 1 --> print to console
% consoleFname = fullfile(cd,'Data','RawDataMerged',Identifiers.ProjectStage,Identifiers.WorkZoneScenario,'MergeProcessingMessages.txt');
% fid = fopen(consoleFname,'w');

% List what will be saved
saveFlags.flag_saveMatFile = 0;
saveFlags.flag_saveMatFile_directory = fullfile(cd,'Data','RawDataMerged',Identifiers.ProjectStage,Identifiers.WorkZoneScenario);
saveFlags.flag_saveImages = 0;
saveFlags.flag_saveImages_directory  = fullfile(cd,'Data','RawDataMerged',Identifiers.ProjectStage,Identifiers.WorkZoneScenario);
saveFlags.flag_saveImages_name = cat(2,Identifiers.WorkZoneScenario,'_merged');
saveFlags.flag_forceDirectoryCreation = 1;
saveFlags.flag_forceImageOverwrite = 1;
saveFlags.flag_forceMATfileOverwrite = 1;

% List what will be plotted, and the figure numbers
plotFlags.fig_num_plotAllMergedTogether = [];
plotFlags.fig_num_plotAllMergedIndividually = []; %2222;
    
plotFlags.mergedplotFormat.LineStyle = '-';
plotFlags.mergedplotFormat.LineWidth = 2;
plotFlags.mergedplotFormat.Marker = 'none';
plotFlags.mergedplotFormat.MarkerSize = 5;


% Call the function
[mergedRawDataCellArray, uncommonFieldsCellArray] = fcn_LoadRawDataToMATLAB_mergeRawDataStructures(rawDataCellArray, (thresholdTimeNearby), (fid), (saveFlags), (plotFlags));

% Check the results
assert(iscell(mergedRawDataCellArray));
assert(iscell(uncommonFieldsCellArray));

%% Test 10016: Test track scenario 1.6
% Location for Test Track base station
setenv('MATLABFLAG_PLOTROAD_REFERENCE_LATITUDE','40.86368573');
setenv('MATLABFLAG_PLOTROAD_REFERENCE_LONGITUDE','-77.83592832');
setenv('MATLABFLAG_PLOTROAD_REFERENCE_ALTITUDE','344.189');


%%%%
% Load the data

% Choose data folder and bag name, read before running the script
% The parsed the data files are saved on OneDrive
% in \IVSG\GitHubMirror\MappingVanDataCollection\ParsedData. To process the
% bag file, please copy file folder to the LargeData folder.

% For details on identifiers, see https://github.com/ivsg-psu/FieldDataCollection_VisualizingFieldData_LoadWorkZone
clear Identifiers
Identifiers.Project = 'PennDOT ADS Workzones'; % This is the project sponsoring the data collection
Identifiers.ProjectStage = 'TestTrack'; % Can be 'Simulation', 'TestTrack', or 'OnRoad'
Identifiers.WorkZoneScenario = '1.6'; % Can be one of the ~20 scenarios, see key
Identifiers.WorkZoneDescriptor = 'WorkInRightLaneOfUndividedHighway'; % Can be one of the 20 descriptors, see key
Identifiers.Treatment = 'BaseMap'; % Can be one of 9 options, see key
Identifiers.DataSource = 'MappingVan'; % Can be 'MappingVan', 'AV', 'CV2X', etc. see key
Identifiers.AggregationType = 'PostRun'; % Can be 'PreCalibration', 'PreRun', 'Run', 'PostRun', or 'PostCalibration'
Identifiers.SourceBagFileName =''; % This is filled in automatically for each file

% Specify the bagQueryString
mappingDate = '2024-09-17';
bagQueryString = cat(2,'mapping_van_',mappingDate,'*'); % The more specific, the better to avoid accidental loading of wrong information

% Spedify the fid
fid = 1; % 1 --> print to console

% Specify the Flags
Flags = []; 

% List which directory/directories need to be loaded
clear rootdirs
rootdirs{1} = fullfile(cd,'LargeData','ParsedBags_PoseOnly',Identifiers.ProjectStage,cat(2,'Scenario ',Identifiers.WorkZoneScenario),mappingDate); 

% List what will be saved
saveFlags.flag_saveMatFile = 1;
saveFlags.flag_saveMatFile_directory = fullfile(cd,'Data','RawData',Identifiers.ProjectStage,cat(2,'Scenario ',Identifiers.WorkZoneScenario));
saveFlags.flag_saveImages = 1;
saveFlags.flag_saveImages_directory  = fullfile(cd,'Data','RawData',Identifiers.ProjectStage,cat(2,'Scenario ',Identifiers.WorkZoneScenario));
saveFlags.flag_forceDirectoryCreation = 1;
saveFlags.flag_forceImageOverwrite = 1;
saveFlags.flag_forceMATfileOverwrite = 1;

% List what will be plotted, and the figure numbers
plotFlags.fig_num_plotAllRawTogether = 10016;
plotFlags.fig_num_plotAllRawIndividually = 11016;

% Call the data loading function
rawDataCellArray = fcn_LoadRawDataToMATLAB_loadRawDataFromDirectories(rootdirs, Identifiers, (bagQueryString), (fid), (Flags), (saveFlags), (plotFlags));

%%%%%
% Prepare for merging
% Specify the nearby time
thresholdTimeNearby = 10;

% Spedify the fid
fid = 1; % 1 --> print to console
% consoleFname = fullfile(cd,'Data','RawDataMerged',Identifiers.ProjectStage,Identifiers.WorkZoneScenario,'MergeProcessingMessages.txt');
% fid = fopen(consoleFname,'w');

% List what will be saved
saveFlags.flag_saveMatFile = 1;
saveFlags.flag_saveMatFile_directory = fullfile(cd,'Data','RawDataMerged',Identifiers.ProjectStage,cat(2,'Scenario ',Identifiers.WorkZoneScenario));
saveFlags.flag_saveImages = 1;
saveFlags.flag_saveImages_directory  = fullfile(cd,'Data','RawDataMerged',Identifiers.ProjectStage,cat(2,'Scenario ',Identifiers.WorkZoneScenario));
saveFlags.flag_saveImages_name = cat(2,Identifiers.WorkZoneScenario,'_merged');
saveFlags.flag_forceDirectoryCreation = 1;
saveFlags.flag_forceImageOverwrite = 1;
saveFlags.flag_forceMATfileOverwrite = 1;

% List what will be plotted, and the figure numbers
plotFlags.fig_num_plotAllMergedTogether = 1111;
plotFlags.fig_num_plotAllMergedIndividually = 2222;
    
plotFlags.mergedplotFormat.LineStyle = '-';
plotFlags.mergedplotFormat.LineWidth = 2;
plotFlags.mergedplotFormat.Marker = 'none';
plotFlags.mergedplotFormat.MarkerSize = 5;
plotFlags.mergedplotFormat.Color = [1 1 0];


% Call the function
[mergedRawDataCellArray, uncommonFieldsCellArray] = fcn_LoadRawDataToMATLAB_mergeRawDataStructures(rawDataCellArray, (thresholdTimeNearby), (fid), (saveFlags), (plotFlags));

% Check the results
assert(iscell(mergedRawDataCellArray));
assert(iscell(uncommonFieldsCellArray));



%% Load all raw data and convert to MAT files
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  _                     _            _ _   _____                  _____        _          _       _          __  __       _______    __ _ _
% | |                   | |     /\   | | | |  __ \                |  __ \      | |        (_)     | |        |  \/  |   /\|__   __|  / _(_) |
% | |     ___   __ _  __| |    /  \  | | | | |__) |__ ___      __ | |  | | __ _| |_ __ _   _ _ __ | |_ ___   | \  / |  /  \  | |    | |_ _| | ___  ___
% | |    / _ \ / _` |/ _` |   / /\ \ | | | |  _  // _` \ \ /\ / / | |  | |/ _` | __/ _` | | | '_ \| __/ _ \  | |\/| | / /\ \ | |    |  _| | |/ _ \/ __|
% | |___| (_) | (_| | (_| |  / ____ \| | | | | \ \ (_| |\ V  V /  | |__| | (_| | || (_| | | | | | | || (_) | | |  | |/ ____ \| |    | | | | |  __/\__ \
% |______\___/ \__,_|\__,_| /_/    \_\_|_| |_|  \_\__,_| \_/\_/   |_____/ \__,_|\__\__,_| |_|_| |_|\__\___/  |_|  |_/_/    \_\_|    |_| |_|_|\___||___/
%
%
% See: http://patorjk.com/software/taag/#p=display&f=Big&t=Load%20All%20Raw%20Data%20into%20MAT%20files
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% List which directory/directories need to be loaded
DriveRoot = 'F:\Adrive';
% rawBagRoot                  = cat(2,DriveRoot,'\MappingVanData\RawBags');
poseOnlyParsedBagRoot       = cat(2,DriveRoot,'\MappingVanData\ParsedBags_PoseOnly');
% fullParsedBagRoot           = cat(2,DriveRoot,'\MappingVanData\ParsedBags');
parsedMATLAB_PoseOnly       = cat(2,DriveRoot,'\MappingVanData\ParsedMATLAB_PoseOnly\RawData');
% parsedMATLAB_PoseOnlyMerged = cat(2,DriveRoot,'\MappingVanData\ParsedMATLAB_PoseOnly\RawDataMerged');
% mergedTimeCleaned           = cat(2,DriveRoot,'\MappingVanData\ParsedMATLAB_PoseOnly\Merged_01_TimeCleaned');
% mergedDataCleaned           = cat(2,DriveRoot,'\MappingVanData\ParsedMATLAB_PoseOnly\Merged_02_DataCleaned');
% mergedKalmanFiltered        = cat(2,DriveRoot,'\MappingVanData\ParsedMATLAB_PoseOnly\Merged_03_KalmanFiltered');

% Make sure folders exist!
% fcn_INTERNAL_confirmDirectoryExists(rawBagSearchDirectory);
fcn_INTERNAL_confirmDirectoryExists(poseOnlyParsedBagRoot);
% fcn_INTERNAL_confirmDirectoryExists(fullParsedBagRootDirectory);
fcn_INTERNAL_confirmDirectoryExists(parsedMATLAB_PoseOnly);
% fcn_INTERNAL_confirmDirectoryExists(parsedMATLAB_PoseOnlyMergedDirectory);
% fcn_INTERNAL_confirmDirectoryExists(mergedTimeCleanedDirectory);
% fcn_INTERNAL_confirmDirectoryExists(mergedDataCleanedDirectory);
% fcn_INTERNAL_confirmDirectoryExists(mergedKalmanFilteredDirectory);


% Below were run on 11/07/2024
testingConditions = {
    % '2024-02-01','4.2'; % NOT parsed - bad data
    '2024-02-06','4.3';             % Done - confirmed on 2024-11-07
    % '2024-04-19','2.3'; % NOT parsed
    '2024-06-24','I376ParkwayPitt'; % Done - confirmed on 2024-11-07
    % '2024-06-28','4.1b'; % NOT parsed
    '2024-07-10','I376ParkwayPitt'; % Done - confirmed on 2024-11-07
    '2024-07-11','I376ParkwayPitt'; % Done - confirmed on 2024-11-07
    '2024-08-05','BaseMap';         % Done - confirmed on 2024-11-07
    '2024-08-12','BaseMap';         % Done - confirmed on 2024-11-07
    '2024-08-13','BaseMap';         % Done - confirmed on 2024-11-07
    '2024-08-14','4.1a';            % Done - confirmed on 2024-11-07
    '2024-08-15','4.1a';            % Done - confirmed on 2024-11-07
    '2024-08-15','4.3';             % Done - confirmed on 2024-11-07
    '2024-08-22','PA653Normalville';% Done - confirmed on 2024-11-07
    '2024-09-04','5.1a';            % Done - confirmed on 2024-11-07
    '2024-09-13','5.2';             % Done - confirmed on 2024-11-07
    '2024-09-17','1.6';             % Done - confirmed on 2024-11-07
    '2024-09-19','PA51Aliquippa';   % Done - confirmed on 2024-11-07
    '2024-09-20','PA51Aliquippa';   % Done - confirmed on 2024-11-07
    '2024-10-16','I376ParkwayPitt'; % Done - confirmed on 2024-11-07
    '2024-10-24','4.1b'; 
    '2024-10-31','6.1'; 
    };

% List what will be saved
saveFlags.flag_saveMatFile = 0;
saveFlags.flag_saveImages = 0;
saveFlags.flag_forceDirectoryCreation = 1;
saveFlags.flag_forceImageOverwrite = 1;
saveFlags.flag_forceMATfileOverwrite = 1;

% List what will be plotted, and the figure numbers
plotFlags.fig_num_plotAllRawTogether = []; %10016;
plotFlags.fig_num_plotAllRawIndividually = []; %11016;


sizeConditions = size(testingConditions);
allData = cell(sizeConditions(1),1);
for ith_scenarioTest = 18:sizeConditions(1)
    mappingDate = testingConditions{ith_scenarioTest,1};
    scenarioString = testingConditions{ith_scenarioTest,2};

    
    % Grab the identifiers. NOTE: this also sets the reference location for
    % plotting.
    Identifiers = fcn_LoadRawDataToMATLAB_identifyDataByScenarioDate(scenarioString, mappingDate, 1,-1);


    % Specify the bagQueryString
    bagQueryString = cat(2,'mapping_van_',mappingDate,'*'); % The more specific, the better to avoid accidental loading of wrong information

    % Spedify the fid
    fid = 1; % 1 --> print to console

    % Specify the Flags
    Flags = [];

    % List which directory/directories need to be loaded
    clear rootdirs
    if ~isnan(str2double(scenarioString(1)))
        fullScenarioString = cat(2,'Scenario ',Identifiers.WorkZoneScenario);
    else
        fullScenarioString = scenarioString;
    end
    rootdirs{1} = fullfile(poseOnlyParsedBagRoot,Identifiers.ProjectStage,fullScenarioString,mappingDate);

    % List what will be saved
    saveFlags.flag_saveMatFile_directory = fullfile(parsedMATLAB_PoseOnly,Identifiers.ProjectStage,fullScenarioString);
    saveFlags.flag_saveImages_directory  = fullfile(parsedMATLAB_PoseOnly,Identifiers.ProjectStage,fullScenarioString);

    % Call the data loading function
    close all;
    allData{ith_scenarioTest}.rawDataCellArray = fcn_LoadRawDataToMATLAB_loadRawDataFromDirectories(rootdirs, Identifiers, (bagQueryString), (fid), (Flags), (saveFlags), (plotFlags));

    format long
    index_to_check = 1;
    allData{ith_scenarioTest}.rawDataCellArray{index_to_check}.Identifiers
    temp1 = allData{ith_scenarioTest}.rawDataCellArray{index_to_check}.GPS_SparkFun_RightRear_GGA.GPS_Time(1:20,:) - allData{ith_scenarioTest}.rawDataCellArray{1}.GPS_SparkFun_RightRear_GGA.GPS_Time(1,1);
    disp(temp1)

end

%%
% % For debugging
format long
index_to_check = 22;
allData{ith_scenarioTest}.rawDataCellArray{index_to_check}.Identifiers
temp1 = allData{ith_scenarioTest}.rawDataCellArray{index_to_check}.GPS_SparkFun_RightRear_GGA.GPS_Time(1:20,:) - allData{ith_scenarioTest}.rawDataCellArray{1}.GPS_SparkFun_RightRear_GGA.GPS_Time(1,1);
temp2 = allData{ith_scenarioTest}.rawDataCellArray{index_to_check}.GPS_SparkFun_LeftRear_GGA.GPS_Time(1:20,:)  - allData{ith_scenarioTest}.rawDataCellArray{1}.GPS_SparkFun_LeftRear_GGA.GPS_Time(1,1);
temp3 = allData{ith_scenarioTest}.rawDataCellArray{index_to_check}.GPS_SparkFun_Front_GGA.GPS_Time(1:20,:) - allData{ith_scenarioTest}.rawDataCellArray{1}.GPS_SparkFun_Front_GGA.GPS_Time(1,1);
fprintf(1,'GPS_SparkFun_RightRear_GGA   GPS_SparkFun_LeftRear_GGA    GPS_SparkFun_Front_GGA\n')
disp([temp1 temp2 temp3])

%% Merge all MAT files
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  __  __                                _ _   __  __       _______   ______ _ _
% |  \/  |                         /\   | | | |  \/  |   /\|__   __| |  ____(_) |
% | \  / | ___ _ __ __ _  ___     /  \  | | | | \  / |  /  \  | |    | |__   _| | ___  ___
% | |\/| |/ _ \ '__/ _` |/ _ \   / /\ \ | | | | |\/| | / /\ \ | |    |  __| | | |/ _ \/ __|
% | |  | |  __/ | | (_| |  __/  / ____ \| | | | |  | |/ ____ \| |    | |    | | |  __/\__ \
% |_|  |_|\___|_|  \__, |\___| /_/    \_\_|_| |_|  |_/_/    \_\_|    |_|    |_|_|\___||___/
%                   __/ |
%                  |___/
% See: http://patorjk.com/software/taag/#p=display&f=Big&t=Merge%20All%20MAT%20Files
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

URHERE

poseOnlyParsedMATLABRootMerged_PoseOnly   = 'F:\MappingVanData\ParsedMATLAB_PoseOnly\RawDataMerged';

% Prepare for merging
% Specify the nearby time
thresholdTimeNearby = 10;

% Spedify the fid
fid = 1; % 1 --> print to console
% consoleFname = fullfile(cd,'Data','RawDataMerged',Identifiers.ProjectStage,Identifiers.WorkZoneScenario,'MergeProcessingMessages.txt');
% fid = fopen(consoleFname,'w');

% List what will be saved
saveFlags.flag_saveMatFile = 1;
saveFlags.flag_saveImages = 1;
saveFlags.flag_forceDirectoryCreation = 1;
saveFlags.flag_forceImageOverwrite = 1;
saveFlags.flag_forceMATfileOverwrite = 1;

% List what will be plotted, and the figure numbers
plotFlags.fig_num_plotAllMergedTogether = 1111;
plotFlags.fig_num_plotAllMergedIndividually = 2222;
    
plotFlags.mergedplotFormat.LineStyle = '-';
plotFlags.mergedplotFormat.LineWidth = 2;
plotFlags.mergedplotFormat.Marker = 'none';
plotFlags.mergedplotFormat.MarkerSize = 5;
plotFlags.mergedplotFormat.Color = [1 1 0];


for ith_scenarioTest = 3:length(allData)
    mappingDate = testingConditions{ith_scenarioTest,1};
    scenarioString = testingConditions{ith_scenarioTest,2};

    
    % Grab the identifiers. NOTE: this also sets the reference location for
    % plotting.
    Identifiers = fcn_LoadRawDataToMATLAB_identifyDataByScenarioDate(scenarioString, mappingDate, 1,-1);

    if ~isnan(str2double(scenarioString(1)))
        fullScenarioString = cat(2,'Scenario ',Identifiers.WorkZoneScenario);
    else
        fullScenarioString = scenarioString;
    end

    saveFlags.flag_saveMatFile_directory = fullfile(poseOnlyParsedMATLABRootMerged_PoseOnly,Identifiers.ProjectStage,fullScenarioString);
    saveFlags.flag_saveImages_directory  = fullfile(poseOnlyParsedMATLABRootMerged_PoseOnly,Identifiers.ProjectStage,fullScenarioString);
    saveFlags.flag_saveImages_name = cat(2,fullScenarioString,'_merged');


    % Call the function
    fcn_LoadRawDataToMATLAB_mergeRawDataStructures(allData{ith_scenarioTest}.rawDataCellArray, (thresholdTimeNearby), (fid), (saveFlags), (plotFlags));
end



%% Test 999: Simple merge, not verbose
% fig_num = 1;
% figure(fig_num);
% clf;

%%%%
% Load the data

% Choose data folder and bag name, read before running the script
% The parsed the data files are saved on OneDrive
% in \IVSG\GitHubMirror\MappingVanDataCollection\ParsedData. To process the
% bag file, please copy file folder to the LargeData folder.

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

% List what will be saved
saveFlags.flag_saveMatFile = 0;
saveFlags.flag_saveMatFile_directory = fullfile(cd,'Data','RawData',Identifiers.ProjectStage,Identifiers.WorkZoneScenario);
saveFlags.flag_saveImages = 0;
saveFlags.flag_saveImages_directory  = fullfile(cd,'Data','RawData',Identifiers.ProjectStage,Identifiers.WorkZoneScenario);
saveFlags.flag_forceDirectoryCreation = 0;
saveFlags.flag_forceImageOverwrite = 0;
saveFlags.flag_forceMATfileOverwrite = 0;

% List what will be plotted, and the figure numbers
plotFlags.fig_num_plotAllRawTogether = [];
plotFlags.fig_num_plotAllRawIndividually = [];

% Call the data loading function
rawDataCellArray = fcn_LoadRawDataToMATLAB_loadRawDataFromDirectories(rootdirs, Identifiers, (bagQueryString), (fid), (Flags), (saveFlags), (plotFlags));


%%
% Prepare for merging
% Specify the nearby time
thresholdTimeNearby = 10;

% Spedify the fid
fid = []; % 1 --> print to console

% List what will be saved
saveFlags.flag_saveMatFile = 0;
saveFlags.flag_saveMatFile_directory = fullfile(cd,'Data','RawDataMerged',Identifiers.ProjectStage,Identifiers.WorkZoneScenario);
saveFlags.flag_saveImages = 0;
saveFlags.flag_saveImages_directory  = fullfile(cd,'Data','RawDataMerged',Identifiers.ProjectStage,Identifiers.WorkZoneScenario);
saveFlags.flag_saveImages_name = cat(2,Identifiers.WorkZoneScenario,'_merged');
saveFlags.flag_forceDirectoryCreation = 1;
saveFlags.flag_forceImageOverwrite = 1;
saveFlags.flag_forceMATfileOverwrite = 1;

% List what will be plotted, and the figure numbers
plotFlags.fig_num_plotAllMergedTogether = [];
plotFlags.fig_num_plotAllMergedIndividually = [];
    
plotFlags.mergedplotFormat.LineStyle = '-';
plotFlags.mergedplotFormat.LineWidth = 2;
plotFlags.mergedplotFormat.Marker = 'none';
plotFlags.mergedplotFormat.MarkerSize = 5;


% Call the function
[mergedRawDataCellArray, uncommonFieldsCellArray] = fcn_LoadRawDataToMATLAB_mergeRawDataStructures(rawDataCellArray, (thresholdTimeNearby), (fid), (saveFlags), (plotFlags));

% Check the results
assert(iscell(mergedRawDataCellArray));
assert(iscell(uncommonFieldsCellArray));


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
%% fcn_INTERNAL_confirmDirectoryExists
function fcn_INTERNAL_confirmDirectoryExists(directoryName)
if 7~=exist(directoryName,'dir')
    warning('on','backtrace');
    warning('Unable to find folder: \n\t%s',directoryName);
    error('Desired directory: %s does not exist!',directoryName);
end
end % Ends fcn_INTERNAL_confirmDirectoryExists

%% function fcn_INTERNAL_clearUtilitiesFromPathAndFolders
function fcn_INTERNAL_clearUtilitiesFromPathAndFolders
% Clear out the variables
clear global flag* FLAG*
clear flag*
clear path

% Clear out any path directories under Utilities
path_dirs = regexp(path,'[;]','split');
utilities_dir = fullfile(pwd,filesep,'Utilities');
for ith_dir = 1:length(path_dirs)
    utility_flag = strfind(path_dirs{ith_dir},utilities_dir);
    if ~isempty(utility_flag)
        rmpath(path_dirs{ith_dir});
    end
end

% Delete the Utilities folder, to be extra clean!
if  exist(utilities_dir,'dir')
    [status,message,message_ID] = rmdir(utilities_dir,'s');
    if 0==status
        error('Unable remove directory: %s \nReason message: %s \nand message_ID: %s\n',utilities_dir, message,message_ID);
    end
end

end % Ends fcn_INTERNAL_clearUtilitiesFromPathAndFolders

%% fcn_INTERNAL_initializeUtilities
function  fcn_INTERNAL_initializeUtilities(library_name,library_folders,library_url,this_project_folders)
% Reset all flags for installs to empty
clear global FLAG*

fprintf(1,'Installing utilities necessary for code ...\n');

% Dependencies and Setup of the Code
% This code depends on several other libraries of codes that contain
% commonly used functions. We check to see if these libraries are installed
% into our "Utilities" folder, and if not, we install them and then set a
% flag to not install them again.

% Set up libraries
for ith_library = 1:length(library_name)
    dependency_name = library_name{ith_library};
    dependency_subfolders = library_folders{ith_library};
    dependency_url = library_url{ith_library};

    fprintf(1,'\tAdding library: %s ...',dependency_name);
    fcn_INTERNAL_DebugTools_installDependencies(dependency_name, dependency_subfolders, dependency_url);
    clear dependency_name dependency_subfolders dependency_url
    fprintf(1,'Done.\n');
end

% Set dependencies for this project specifically
fcn_DebugTools_addSubdirectoriesToPath(pwd,this_project_folders);

disp('Done setting up libraries, adding each to MATLAB path, and adding current repo folders to path.');
end % Ends fcn_INTERNAL_initializeUtilities


function fcn_INTERNAL_DebugTools_installDependencies(dependency_name, dependency_subfolders, dependency_url, varargin)
%% FCN_DEBUGTOOLS_INSTALLDEPENDENCIES - MATLAB package installer from URL
%
% FCN_DEBUGTOOLS_INSTALLDEPENDENCIES installs code packages that are
% specified by a URL pointing to a zip file into a default local subfolder,
% "Utilities", under the root folder. It also adds either the package
% subfoder or any specified sub-subfolders to the MATLAB path.
%
% If the Utilities folder does not exist, it is created.
%
% If the specified code package folder and all subfolders already exist,
% the package is not installed. Otherwise, the folders are created as
% needed, and the package is installed.
%
% If one does not wish to put these codes in different directories, the
% function can be easily modified with strings specifying the
% desired install location.
%
% For path creation, if the "DebugTools" package is being installed, the
% code installs the package, then shifts temporarily into the package to
% complete the path definitions for MATLAB. If the DebugTools is not
% already installed, an error is thrown as these tools are needed for the
% path creation.
%
% Finally, the code sets a global flag to indicate that the folders are
% initialized so that, in this session, if the code is called again the
% folders will not be installed. This global flag can be overwritten by an
% optional flag input.
%
% FORMAT:
%
%      fcn_DebugTools_installDependencies(...
%           dependency_name, ...
%           dependency_subfolders, ...
%           dependency_url)
%
% INPUTS:
%
%      dependency_name: the name given to the subfolder in the Utilities
%      directory for the package install
%
%      dependency_subfolders: in addition to the package subfoder, a list
%      of any specified sub-subfolders to the MATLAB path. Leave blank to
%      add only the package subfolder to the path. See the example below.
%
%      dependency_url: the URL pointing to the code package.
%
%      (OPTIONAL INPUTS)
%      flag_force_creation: if any value other than zero, forces the
%      install to occur even if the global flag is set.
%
% OUTPUTS:
%
%      (none)
%
% DEPENDENCIES:
%
%      This code will automatically get dependent files from the internet,
%      but of course this requires an internet connection. If the
%      DebugTools are being installed, it does not require any other
%      functions. But for other packages, it uses the following from the
%      DebugTools library: fcn_DebugTools_addSubdirectoriesToPath
%
% EXAMPLES:
%
% % Define the name of subfolder to be created in "Utilities" subfolder
% dependency_name = 'DebugTools_v2023_01_18';
%
% % Define sub-subfolders that are in the code package that also need to be
% % added to the MATLAB path after install; the package install subfolder
% % is NOT added to path. OR: Leave empty ({}) to only add
% % the subfolder path without any sub-subfolder path additions.
% dependency_subfolders = {'Functions','Data'};
%
% % Define a universal resource locator (URL) pointing to the zip file to
% % install. For example, here is the zip file location to the Debugtools
% % package on GitHub:
% dependency_url = 'https://github.com/ivsg-psu/Errata_Tutorials_DebugTools/blob/main/Releases/DebugTools_v2023_01_18.zip?raw=true';
%
% % Call the function to do the install
% fcn_DebugTools_installDependencies(dependency_name, dependency_subfolders, dependency_url)
%
% This function was written on 2023_01_23 by S. Brennan
% Questions or comments? sbrennan@psu.edu

% Revision history:
% 2023_01_23:
% -- wrote the code originally
% 2023_04_20:
% -- improved error handling
% -- fixes nested installs automatically

% TO DO
% -- Add input argument checking

flag_do_debug = 0; % Flag to show the results for debugging
flag_do_plots = 0; % % Flag to plot the final results
flag_check_inputs = 1; % Flag to perform input checking

if flag_do_debug
    st = dbstack; %#ok<*UNRCH>
    fprintf(1,'STARTING function: %s, in file: %s\n',st(1).name,st(1).file);
end


%% check input arguments
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   _____                   _
%  |_   _|                 | |
%    | |  _ __  _ __  _   _| |_ ___
%    | | | '_ \| '_ \| | | | __/ __|
%   _| |_| | | | |_) | |_| | |_\__ \
%  |_____|_| |_| .__/ \__,_|\__|___/
%              | |
%              |_|
% See: http://patorjk.com/software/taag/#p=display&f=Big&t=Inputs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if flag_check_inputs
    % Are there the right number of inputs?
    narginchk(3,4);
end

%% Set the global variable - need this for input checking
% Create a variable name for our flag. Stylistically, global variables are
% usually all caps.
flag_varname = upper(cat(2,'flag_',dependency_name,'_Folders_Initialized'));

% Make the variable global
eval(sprintf('global %s',flag_varname));

if nargin==4
    if varargin{1}
        eval(sprintf('clear global %s',flag_varname));
    end
end

%% Main code starts here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   __  __       _
%  |  \/  |     (_)
%  | \  / | __ _ _ _ __
%  | |\/| |/ _` | | '_ \
%  | |  | | (_| | | | | |
%  |_|  |_|\__,_|_|_| |_|
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



if ~exist(flag_varname,'var') || isempty(eval(flag_varname))
    % Save the root directory, so we can get back to it after some of the
    % operations below. We use the Print Working Directory command (pwd) to
    % do this. Note: this command is from Unix/Linux world, but is so
    % useful that MATLAB made their own!
    root_directory_name = pwd;

    % Does the directory "Utilities" exist?
    utilities_folder_name = fullfile(root_directory_name,'Utilities');
    if ~exist(utilities_folder_name,'dir')
        % If we are in here, the directory does not exist. So create it
        % using mkdir
        [success_flag,error_message,message_ID] = mkdir(root_directory_name,'Utilities');

        % Did it work?
        if ~success_flag
            error('Unable to make the Utilities directory. Reason: %s with message ID: %s\n',error_message,message_ID);
        elseif ~isempty(error_message)
            warning('The Utilities directory was created, but with a warning: %s\n and message ID: %s\n(continuing)\n',error_message, message_ID);
        end

    end

    % Does the directory for the dependency folder exist?
    dependency_folder_name = fullfile(root_directory_name,'Utilities',dependency_name);
    if ~exist(dependency_folder_name,'dir')
        % If we are in here, the directory does not exist. So create it
        % using mkdir
        [success_flag,error_message,message_ID] = mkdir(utilities_folder_name,dependency_name);

        % Did it work?
        if ~success_flag
            error('Unable to make the dependency directory: %s. Reason: %s with message ID: %s\n',dependency_name, error_message,message_ID);
        elseif ~isempty(error_message)
            warning('The %s directory was created, but with a warning: %s\n and message ID: %s\n(continuing)\n',dependency_name, error_message, message_ID);
        end

    end

    % Do the subfolders exist?
    flag_allFoldersThere = 1;
    if isempty(dependency_subfolders{1})
        flag_allFoldersThere = 0;
    else
        for ith_folder = 1:length(dependency_subfolders)
            subfolder_name = dependency_subfolders{ith_folder};

            % Create the entire path
            subfunction_folder = fullfile(root_directory_name, 'Utilities', dependency_name,subfolder_name);

            % Check if the folder and file exists that is typically created when
            % unzipping.
            if ~exist(subfunction_folder,'dir')
                flag_allFoldersThere = 0;
            end
        end
    end

    % Do we need to unzip the files?
    if flag_allFoldersThere==0
        % Files do not exist yet - try unzipping them.
        save_file_name = tempname(root_directory_name);
        zip_file_name = websave(save_file_name,dependency_url);
        % CANT GET THIS TO WORK --> unzip(zip_file_url, debugTools_folder_name);

        % Is the file there?
        if ~exist(zip_file_name,'file')
            error(['The zip file: %s for dependency: %s did not download correctly.\n' ...
                'This is usually because permissions are restricted on ' ...
                'the current directory. Check the code install ' ...
                '(see README.md) and try again.\n'],zip_file_name, dependency_name);
        end

        % Try unzipping
        unzip(zip_file_name, dependency_folder_name);

        % Did this work? If so, directory should not be empty
        directory_contents = dir(dependency_folder_name);
        if isempty(directory_contents)
            error(['The necessary dependency: %s has an error in install ' ...
                'where the zip file downloaded correctly, ' ...
                'but the unzip operation did not put any content ' ...
                'into the correct folder. ' ...
                'This suggests a bad zip file or permissions error ' ...
                'on the local computer.\n'],dependency_name);
        end

        % Check if is a nested install (for example, installing a folder
        % "Toolsets" under a folder called "Toolsets"). This can be found
        % if there's a folder whose name contains the dependency_name
        flag_is_nested_install = 0;
        for ith_entry = 1:length(directory_contents)
            if contains(directory_contents(ith_entry).name,dependency_name)
                if directory_contents(ith_entry).isdir
                    flag_is_nested_install = 1;
                    install_directory_from = fullfile(directory_contents(ith_entry).folder,directory_contents(ith_entry).name);
                    install_files_from = fullfile(directory_contents(ith_entry).folder,directory_contents(ith_entry).name,'*.*');
                    install_location_to = fullfile(directory_contents(ith_entry).folder);
                end
            end
        end

        if flag_is_nested_install
            [status,message,message_ID] = movefile(install_files_from,install_location_to);
            if 0==status
                error(['Unable to move files from directory: %s\n ' ...
                    'To: %s \n' ...
                    'Reason message: %s\n' ...
                    'And message_ID: %s\n'],install_files_from,install_location_to, message,message_ID);
            end
            [status,message,message_ID] = rmdir(install_directory_from);
            if 0==status
                error(['Unable remove directory: %s \n' ...
                    'Reason message: %s \n' ...
                    'And message_ID: %s\n'],install_directory_from,message,message_ID);
            end
        end

        % Make sure the subfolders were created
        flag_allFoldersThere = 1;
        if ~isempty(dependency_subfolders{1})
            for ith_folder = 1:length(dependency_subfolders)
                subfolder_name = dependency_subfolders{ith_folder};

                % Create the entire path
                subfunction_folder = fullfile(root_directory_name, 'Utilities', dependency_name,subfolder_name);

                % Check if the folder and file exists that is typically created when
                % unzipping.
                if ~exist(subfunction_folder,'dir')
                    flag_allFoldersThere = 0;
                end
            end
        end
        % If any are not there, then throw an error
        if flag_allFoldersThere==0
            error(['The necessary dependency: %s has an error in install, ' ...
                'or error performing an unzip operation. The subfolders ' ...
                'requested by the code were not found after the unzip ' ...
                'operation. This suggests a bad zip file, or a permissions ' ...
                'error on the local computer, or that folders are ' ...
                'specified that are not present on the remote code ' ...
                'repository.\n'],dependency_name);
        else
            % Clean up the zip file
            delete(zip_file_name);
        end

    end


    % For path creation, if the "DebugTools" package is being installed, the
    % code installs the package, then shifts temporarily into the package to
    % complete the path definitions for MATLAB. If the DebugTools is not
    % already installed, an error is thrown as these tools are needed for the
    % path creation.
    %
    % In other words: DebugTools is a special case because folders not
    % added yet, and we use DebugTools for adding the other directories
    if strcmp(dependency_name(1:10),'DebugTools')
        debugTools_function_folder = fullfile(root_directory_name, 'Utilities', dependency_name,'Functions');

        % Move into the folder, run the function, and move back
        cd(debugTools_function_folder);
        fcn_DebugTools_addSubdirectoriesToPath(dependency_folder_name,dependency_subfolders);
        cd(root_directory_name);
    else
        try
            fcn_DebugTools_addSubdirectoriesToPath(dependency_folder_name,dependency_subfolders);
        catch
            error(['Package installer requires DebugTools package to be ' ...
                'installed first. Please install that before ' ...
                'installing this package']);
        end
    end


    % Finally, the code sets a global flag to indicate that the folders are
    % initialized.  Check this using a command "exist", which takes a
    % character string (the name inside the '' marks, and a type string -
    % in this case 'var') and checks if a variable ('var') exists in matlab
    % that has the same name as the string. The ~ in front of exist says to
    % do the opposite. So the following command basically means: if the
    % variable named 'flag_CodeX_Folders_Initialized' does NOT exist in the
    % workspace, run the code in the if statement. If we look at the bottom
    % of the if statement, we fill in that variable. That way, the next
    % time the code is run - assuming the if statement ran to the end -
    % this section of code will NOT be run twice.

    eval(sprintf('%s = 1;',flag_varname));
end

%% Plot the results (for debugging)?
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   _____       _
%  |  __ \     | |
%  | |  | | ___| |__  _   _  __ _
%  | |  | |/ _ \ '_ \| | | |/ _` |
%  | |__| |  __/ |_) | |_| | (_| |
%  |_____/ \___|_.__/ \__,_|\__, |
%                            __/ |
%                           |___/
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if flag_do_plots

    % Nothing to do!



end

if flag_do_debug
    fprintf(1,'ENDING function: %s, in file: %s\n\n',st(1).name,st(1).file);
end

end % Ends function fcn_DebugTools_installDependencies
