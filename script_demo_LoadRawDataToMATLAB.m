
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


% REVISION HISTORY:
%
% 2025_09_19 - Sean Brennan
% - created this repo by pulling "loading" codes out of DataCleanClass
% 
% 2025_09_27 - Sean Brennan
% - updated DebugTools_v2025_09_26
% 
% 2025_11_22 by Sean Brennan, sbrennan@psu.edu
% - Started modifying rev lists to Markdown format
% - Added auto-installer
%
% 2025_11_24 by Sean Brennan, sbrennan@psu.edu
% - Complete review of allscripts and functions
% (new release)
%
% 2025_11_26 by Sean Brennan, sbrennan@psu.edu
% - in fcn_LoadRawDataToMATLAB_pullDataFromFieldAcrossAll
%   % * Improved header docstrings to better explain expected outputs
%   % * Especially for empty sensor type, was not clear what to expect
%
% 2025_11_27 by Sean Brennan, sbrennan@psu.edu
% - worked on README.md (barely started)
% - made this main script more clear by adding sections (not done)
% - updated script_test_all_functions
% - fixed minor bug where data file was missing in test script
% (new release)

% TO-DO:
% 2025_11_22 by Sean Brennan, sbrennan@psu.edu
% - Need to update README

%% Prep the workspace
close all

%% Make sure we are running out of root directory
st = dbstack; 
thisFile = which(st(1).file);
[filepath,name,ext] = fileparts(thisFile);
cd(filepath);

%% Clear paths and folders, if needed
if 1==1
    clear flag_LoadRawDataToMATLAB_Folders_Initialized
end
if 1==0
    fcn_INTERNAL_clearUtilitiesFromPathAndFolders;
end
if 1==0
    % Resets all paths to factory default
    restoredefaultpath;
end

%% Install dependencies
% Define a universal resource locator (URL) pointing to the repos of
% dependencies to install. Note that DebugTools is always installed
% automatically, first, even if not listed:
clear dependencyURLs dependencySubfolders
ith_repo = 0;

ith_repo = ith_repo+1;
dependencyURLs{ith_repo} = 'https://github.com/ivsg-psu/PathPlanning_PathTools_PathClassLibrary';
dependencySubfolders{ith_repo} = {'Functions'};

ith_repo = ith_repo+1;
dependencyURLs{ith_repo} = 'https://github.com/ivsg-psu/PathPlanning_PathTools_GetUserInputPath';
dependencySubfolders{ith_repo} = {''};

ith_repo = ith_repo+1;
dependencyURLs{ith_repo} = 'https://github.com/ivsg-psu/FieldDataCollection_VisualizingFieldData_PlotRoad';
dependencySubfolders{ith_repo} = {'Functions','Data'};

ith_repo = ith_repo+1;
dependencyURLs{ith_repo} = 'https://github.com/ivsg-psu/PathPlanning_GeomTools_GeomClassLibrary';
dependencySubfolders{ith_repo} = {'Functions','Data'};

ith_repo = ith_repo+1;
dependencyURLs{ith_repo} = 'https://github.com/ivsg-psu/FieldDataCollection_GPSRelatedCodes_GPSClass';
dependencySubfolders{ith_repo} = {'Functions'};


%% Do we need to set up the work space?
if ~exist('flag_LoadRawDataToMATLAB_Folders_Initialized','var')

    % Clear prior global variable flags
    clear global FLAG_*

    % Navigate to the Installer directory
    currentFolder = pwd;
    cd('Installer');
    % Create a function handle
    func_handle = @fcn_DebugTools_autoInstallRepos;

    % Return to the original directory
    cd(currentFolder);

    % Call the function to do the install
    func_handle(dependencyURLs, dependencySubfolders, (0), (-1));

    % Add this function's folders to the path
    this_project_folders = {...
        'Functions','Data'};
    fcn_DebugTools_addSubdirectoriesToPath(pwd,this_project_folders)

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

%% Data Loading Functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  _____        _
% |  __ \      | |
% | |  | | __ _| |_ __ _
% | |  | |/ _` | __/ _` |
% | |__| | (_| | || (_| |
% |_____/ \__,_|\__\__,_|
%
%
%  _                     _ _
% | |                   | (_)
% | |     ___   __ _  __| |_ _ __   __ _
% | |    / _ \ / _` |/ _` | | '_ \ / _` |
% | |___| (_) | (_| | (_| | | | | | (_| |
% |______\___/ \__,_|\__,_|_|_| |_|\__, |
%                                   __/ |
%                                  |___/
%  ______                _   _
% |  ____|              | | (_)
% | |__ _   _ _ __   ___| |_ _  ___  _ __  ___
% |  __| | | | '_ \ / __| __| |/ _ \| '_ \/ __|
% | |  | |_| | | | | (__| |_| | (_) | | | \__ \
% |_|   \__,_|_| |_|\___|\__|_|\___/|_| |_|___/
% See: http://patorjk.com/software/taag/#p=display&f=Big&t=Data%0ALoading%0AFunctions&x=none&v=0&h=4&w=80&we=false
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% DATA LOADING figures start with 1

close all;
fprintf(1,'Figure: 1XXXXXX: DATA LOADING functions\n');


%% DEMO case: fcn_LoadRawDataToMATLAB_plotRawDataPositions

figNum = 10001;
titleString = sprintf('fcn_LoadRawDataToMATLAB_loadRawDataFromDirectories');
% Demonstrates plotting and plot saving of data
% NOTE: can save plots by changing flags

% Demonstrates data loading from LargeData, many bag files and several directories
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

title('');
sgtitle(titleString, 'Interpreter','none');

% Show that we get a cell array of data with more than 1 entry
assert(iscell(rawDataCellArray));
assert(length(rawDataCellArray)>1);
assert(length(rawDataCellArray)==length(only_directory_filelist));

% Save results
fullPathFileName = fullfile(pwd,'Images',cat(2,titleString,'.png'));
saveas(gcf, fullPathFileName);
fullPathFileName = fullfile(pwd,'Images',cat(2,titleString,'.fig'));
saveas(gcf, fullPathFileName);

%% DEMO case: fcn_LoadRawDataToMATLAB_loadMatDataFromDirectories

figNum = 10002;
titleString = sprintf('fcn_LoadRawDataToMATLAB_loadMatDataFromDirectories');
% Demonstrates plotting and plot saving of data
% NOTE: can save plots by changing flags

% Demonstrate that can load the MAT files via queries


% FORMAT:
%
%     rawDataCellArray = fcn_DataClean_loadMatDataFromDirectories(...
%     rootdirs, (searchIdentifiers), (matQueryString), (fid), (plotFlags));


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
rawDataCellArray = fcn_LoadRawDataToMATLAB_loadMatDataFromDirectories(...
    rootdirs, (searchIdentifiers), (matQueryString), (fid), (figNum));


title('');
sgtitle(titleString, 'Interpreter','none');

assert(iscell(rawDataCellArray));
% assert(length(rawDataCellArray2) == length(rawDataCellArray));


% Save results
fullPathFileName = fullfile(pwd,'Images',cat(2,titleString,'.png'));
saveas(gcf, fullPathFileName);
fullPathFileName = fullfile(pwd,'Images',cat(2,titleString,'.fig'));
saveas(gcf, fullPathFileName);



%% Plotting Functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  _____  _       _   _   _
% |  __ \| |     | | | | (_)
% | |__) | | ___ | |_| |_ _ _ __   __ _
% |  ___/| |/ _ \| __| __| | '_ \ / _` |
% | |    | | (_) | |_| |_| | | | | (_| |
% |_|    |_|\___/ \__|\__|_|_| |_|\__, |
%                                  __/ |
%                                 |___/
%  ______                _   _
% |  ____|              | | (_)
% | |__ _   _ _ __   ___| |_ _  ___  _ __  ___
% |  __| | | | '_ \ / __| __| |/ _ \| '_ \/ __|
% | |  | |_| | | | | (__| |_| | (_) | | | \__ \
% |_|   \__,_|_| |_|\___|\__|_|\___/|_| |_|___/
% See: http://patorjk.com/software/taag/#p=display&f=Big&t=Plotting%0AFunctions&x=none&v=0&h=4&w=80&we=false
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% DATA PLOTTING figures start with 2

close all;
fprintf(1,'Figure: 2XXXXXX: DATA PLOTTING functions\n');

%% DEMO case: fcn_LoadRawDataToMATLAB_plotRawDataPositions

figNum = 20001;
titleString = sprintf('fcn_LoadRawDataToMATLAB_plotRawDataPositions');
% Demonstrates plotting and plot saving of data
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
plotFlags.figNum_plotAllRawTogether = figNum;
plotFlags.figNum_plotAllRawIndividually = [];

% Call function to plot data, and save plots into file formats
fcn_LoadRawDataToMATLAB_plotRawDataPositions({rawDataCellArray{1}}, (saveFlags), (plotFlags));

title('');
sgtitle(titleString, 'Interpreter','none');


% Save results
fullPathFileName = fullfile(pwd,'Images',cat(2,titleString,'.png'));
saveas(gcf, fullPathFileName);
fullPathFileName = fullfile(pwd,'Images',cat(2,titleString,'.fig'));
saveas(gcf, fullPathFileName);

%% DATA SAVING Functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  _____        _
% |  __ \      | |
% | |  | | __ _| |_ __ _
% | |  | |/ _` | __/ _` |
% | |__| | (_| | || (_| |
% |_____/ \__,_|\__\__,_|
%
%
%   _____             _
%  / ____|           (_)
% | (___   __ ___   ___ _ __   __ _
%  \___ \ / _` \ \ / / | '_ \ / _` |
%  ____) | (_| |\ V /| | | | | (_| |
% |_____/ \__,_| \_/ |_|_| |_|\__, |
%                              __/ |
%                             |___/
%  ______                _   _
% |  ____|              | | (_)
% | |__ _   _ _ __   ___| |_ _  ___  _ __  ___
% |  __| | | | '_ \ / __| __| |/ _ \| '_ \/ __|
% | |  | |_| | | | | (__| |_| | (_) | | | \__ \
% |_|   \__,_|_| |_|\___|\__|_|\___/|_| |_|___/
% See: http://patorjk.com/software/taag/#p=display&f=Big&t=Data%0ASaving%0AFunctions&x=none&v=0&h=4&w=80&we=false
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% DATA SAVING figures start with 3

close all;
fprintf(1,'Figure: 3XXXXXX: DATA SAVING functions\n');



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

%% DATA MERGING Functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  _____        _
% |  __ \      | |
% | |  | | __ _| |_ __ _
% | |  | |/ _` | __/ _` |
% | |__| | (_| | || (_| |
% |_____/ \__,_|\__\__,_|
%
%
%  __  __                _
% |  \/  |              (_)
% | \  / | ___ _ __ __ _ _ _ __   __ _
% | |\/| |/ _ \ '__/ _` | | '_ \ / _` |
% | |  | |  __/ | | (_| | | | | | (_| |
% |_|  |_|\___|_|  \__, |_|_| |_|\__, |
%                   __/ |         __/ |
%                  |___/         |___/
%  ______                _   _
% |  ____|              | | (_)
% | |__ _   _ _ __   ___| |_ _  ___  _ __  ___
% |  __| | | | '_ \ / __| __| |/ _ \| '_ \/ __|
% | |  | |_| | | | | (__| |_| | (_) | | | \__ \
% |_|   \__,_|_| |_|\___|\__|_|\___/|_| |_|___/
% See: http://patorjk.com/software/taag/#p=display&f=Big&t=Data%0AMerging%0AFunctions&x=none&v=0&h=4&w=80&we=false
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% DATA MERGING figures start with 4

close all;
fprintf(1,'Figure: 4XXXXXX: DATA MERGING functions\n');



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

%%%%
% Load the data

clear searchIdentifiers
% searchIdentifiers.Project = 'PennDOT ADS Workzones'; % This is the project sponsoring the data collection
% searchIdentifiers.ProjectStage = 'OnRoad'; % Can be 'Simulation', 'TestTrack', or 'OnRoad'
% searchIdentifiers.WorkZoneScenario = 'PA51Aliquippa'; % Can be one of the ~20 scenarios, see key
% searchIdentifiers.WorkZoneDescriptor = 'WorkInRightLaneMobileWorkzone'; % Can be one of the 20 descriptors, see key
% searchIdentifiers.Treatment = 'BaseMap'; % Can be one of 9 options, see key
% searchIdentifiers.DataSource = 'MappingVan'; % Can be 'MappingVan', 'AV', 'CV2X', etc. see key
% searchIdentifiers.AggregationType = 'PreRun'; % Can be 'PreCalibration', 'PreRun', 'Run', 'PostRun', or 'PostCalibration'

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

% assert(length(rawDataCellArray2) == length(rawDataCellArray));


%%%%% Demonstrate merging of the above data
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

% % List what will be saved
% saveFlags.flag_saveMatFile = 1;
% saveFlags.flag_saveMatFile_directory = fullfile(cd,'Data','RawData',Identifiers.ProjectStage,Identifiers.WorkZoneScenario);
% saveFlags.flag_saveImages = 1;
% saveFlags.flag_saveImages_directory  = fullfile(cd,'Data','RawData',Identifiers.ProjectStage,Identifiers.WorkZoneScenario);
% saveFlags.flag_forceDirectoryCreation = 1;
% saveFlags.flag_forceImageOverwrite = 1;
% saveFlags.flag_forceMATfileOverwrite = 1;

% % List what will be plotted, and the figure numbers
% plotFlags.figNum_plotAllRawTogether = 3333; % [];
% plotFlags.figNum_plotAllRawIndividually = 4444; %[];

% Call the data loading function
rawDataCellArray = fcn_LoadRawDataToMATLAB_loadRawDataFromDirectories(rootdirs, Identifiers, (bagQueryString), (fid), (Flags), (figNum));

%%%%%%%%%%%%%%
% Prepare for merging
% Specify the nearby time
thresholdTimeNearby = 10;

% Spedify the fid
% fid = 1; % 1 --> print to console
readmeFilename = fullfile(cd,'Data','RawDataMerged',Identifiers.ProjectStage,Identifiers.WorkZoneScenario,'MergeProcessingMessages.txt');
fid = fopen(readmeFilename,'w');

% % List what will be saved
% saveFlags.flag_saveMatFile = 1;
% saveFlags.flag_saveMatFile_directory = fullfile(cd,'Data','RawDataMerged',Identifiers.ProjectStage,Identifiers.WorkZoneScenario);
% saveFlags.flag_saveImages = 1;
% saveFlags.flag_saveImages_directory  = fullfile(cd,'Data','RawDataMerged',Identifiers.ProjectStage,Identifiers.WorkZoneScenario);
% saveFlags.flag_saveImages_name = cat(2,Identifiers.WorkZoneScenario,'_merged');
% saveFlags.flag_forceDirectoryCreation = 1;
% saveFlags.flag_forceImageOverwrite = 1;
% saveFlags.flag_forceMATfileOverwrite = 1;
% 
% % List what will be plotted, and the figure numbers
% plotFlags.figNum_plotAllMergedTogether = 1111; %[];
% plotFlags.figNum_plotAllMergedIndividually = 2222; %[];
% 
% plotFlags.mergedplotFormat.LineStyle = '-';
% plotFlags.mergedplotFormat.LineWidth = 2;
% plotFlags.mergedplotFormat.Marker = 'none';
% plotFlags.mergedplotFormat.MarkerSize = 5;


% Call the function
[mergedRawDataCellArray, uncommonFieldsCellArray] = fcn_LoadRawDataToMATLAB_mergeRawDataStructures(rawDataCellArray, (thresholdTimeNearby), (fid), (Flags), (figNum));

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
plotFlags.figNum_plotAllRawTogether = 1111; %[];
plotFlags.figNum_plotAllRawIndividually = 2222; %[];

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
plotFlags.figNum_plotAllMergedTogether = 3333; %[];
plotFlags.figNum_plotAllMergedIndividually = 4444; %[];
    
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
plotFlags.figNum_plotAllRawTogether = 111; %[];
plotFlags.figNum_plotAllRawIndividually = 2222; %[];

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
plotFlags.figNum_plotAllMergedTogether = 333; % [];
plotFlags.figNum_plotAllMergedIndividually = 4444; %[];
    
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
plotFlags.figNum_plotAllRawTogether = []; % 3333;
plotFlags.figNum_plotAllRawIndividually = []; %4444;

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
plotFlags.figNum_plotAllMergedTogether = [];
plotFlags.figNum_plotAllMergedIndividually = []; %2222;
    
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
plotFlags.figNum_plotAllRawTogether = 10016;
plotFlags.figNum_plotAllRawIndividually = 11016;

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
plotFlags.figNum_plotAllMergedTogether = 1111;
plotFlags.figNum_plotAllMergedIndividually = 2222;
    
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
plotFlags.figNum_plotAllRawTogether = []; %10016;
plotFlags.figNum_plotAllRawIndividually = []; %11016;


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
plotFlags.figNum_plotAllMergedTogether = 1111;
plotFlags.figNum_plotAllMergedIndividually = 2222;
    
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
% figNum = 1;
% figure(figNum);
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
plotFlags.figNum_plotAllRawTogether = [];
plotFlags.figNum_plotAllRawIndividually = [];

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
plotFlags.figNum_plotAllMergedTogether = [];
plotFlags.figNum_plotAllMergedIndividually = [];
    
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
