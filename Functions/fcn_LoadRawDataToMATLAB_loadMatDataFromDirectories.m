function rawDataCellArray  = fcn_LoadRawDataToMATLAB_loadMatDataFromDirectories(rootdirs, varargin)
% fcn_DataClean_loadMatDataFromDirectories
% imports MATLAB data from files contained in specified root
% directories, including all subdirectories. Stores each result into a cell
% array, one for each mat data file. Produces plots of the data via
% optional plotting flags.
%
% FORMAT:
%
%     rawDataCellArray = fcn_DataClean_loadMatDataFromDirectories(...
%     rootdirs, (searchIdentifiers), (matQueryString), (fid), (plotFlags));
%
% INPUTS:
%
%      rootdirs: either a string containing the folder name where the mat
%      files are located, or a cell array of names of folder locations.
%      NOTE: the folder locations should be complete paths.
%
%      (OPTIONAL INPUTS)
%
%      searchIdentifiers: an optional structure indicating the labels to attach to
%      the files that are being loaded. The structure has the following
%      format:
% 
%             clear searchIdentifiers
%             searchIdentifiers.Project = 'PennDOT ADS Workzones'; % This is the project sponsoring the data collection
%             searchIdentifiers.ProjectStage = 'OnRoad'; % Can be 'Simulation', 'TestTrack', or 'OnRoad'
%             searchIdentifiers.WorkZoneScenario = 'I376ParkwayPitt'; % Can be one of the ~20 scenarios, see key
%             searchIdentifiers.WorkZoneDescriptor = 'WorkInRightLaneOfUndividedHighway'; % Can be one of the 20 descriptors, see key
%             searchIdentifiers.Treatment = 'BaseMap'; % Can be one of 9 options, see key
%             searchIdentifiers.DataSource = 'MappingVan'; % Can be 'MappingVan', 'AV', 'CV2X', etc. see key
%             searchIdentifiers.AggregationType = 'PreRun'; % Can be 'PreCalibration', 'PreRun', 'Run', 'PostRun', or 'PostCalibration'
%             searchIdentifiers.SourceBagFileName =''; % This is filled in automatically for each file
%
%      For a list of allowable Identifiers, see:
%      https://github.com/ivsg-psu/FieldDataCollection_VisualizingFieldData_LoadWorkZone
%      If left empty, all values are accepted.
%
%      matQueryString: the prefix used to perform the query to search for
%      mat file directories. All directories within the rootdirectors, and
%      any subdirectories of these, are processed. The default
%      matQueryString, if left empty, is: 'mapping_van_*.mat'.
%
%      fid: the fileID where to print. Default is 1, to print results to
%      the console.
%
%      plotFlags: a structure of figure numbers to plot results. If set to
%      -1, skips any input checking or debugging, no figures will be
%      generated, and sets up code to maximize speed. The structure has the
%      following format:
%
%         plotFlags.fig_num_plotAllMatTogether = 1111; % This is the figure
%         where all the mat files are plotted together
%
%         plotFlags.fig_num_plotAllMatIndividually = 2222; % This is the
%         number starting the count for all the figures that open,
%         individually, for each mat file after it is loaded.
%
%     the default is to not plot the results
%
% OUTPUTS:
%
%     rawDataCellArray: a cell array of data structures containing data
%      fields filled for each mat file
%
% DEPENDENCIES:
%
%      fcn_DebugTools_checkInputsToFunctions
%      fcn_DataClean_loadMappingVanDataFromFile
%      fcn_DataClean_plotRawData
%
% EXAMPLES:
%
%     See the script: script_test_fcn_DataClean_loadMatDataFromDirectories
%     for a full test suite.
%
% This function was written on 2024_09_13 by S. Brennan
% Questions or comments? sbrennan@psu.edu

% Revision history
% 2024_09_13 - Sean Brennan, sbrennan@psu.edu
% -- wrote the code originally

%% Debugging and Input checks
% Check if flag_max_speed set. This occurs if the figNum variable input
% argument (varargin) is given a number of -1, which is not a valid figure
% number.
MAX_NARGIN = 5; % The largest Number of argument inputs to the function
flag_max_speed = 0;
if (nargin==MAX_NARGIN && isequal(varargin{end},-1))
    flag_do_debug = 0; %     % Flag to plot the results for debugging
    flag_check_inputs = 0; % Flag to perform input checking
    flag_max_speed = 1;
else
    % Check to see if we are externally setting debug mode to be "on"
    flag_do_debug = 0; %     % Flag to plot the results for debugging
    flag_check_inputs = 1; % Flag to perform input checking
    MATLABFLAG_LOADRAWDATATOMATLAB_FLAG_CHECK_INPUTS = getenv("MATLABFLAG_LOADRAWDATATOMATLAB_FLAG_CHECK_INPUTS");
    MATLABFLAG_LOADRAWDATATOMATLAB_FLAG_DO_DEBUG = getenv("MATLABFLAG_LOADRAWDATATOMATLAB_FLAG_DO_DEBUG");
    if ~isempty(MATLABFLAG_LOADRAWDATATOMATLAB_FLAG_CHECK_INPUTS) && ~isempty(MATLABFLAG_LOADRAWDATATOMATLAB_FLAG_DO_DEBUG)
        flag_do_debug = str2double(MATLABFLAG_LOADRAWDATATOMATLAB_FLAG_DO_DEBUG);
        flag_check_inputs  = str2double(MATLABFLAG_LOADRAWDATATOMATLAB_FLAG_CHECK_INPUTS);
    end
end

% flag_do_debug = 1;

if flag_do_debug
    st = dbstack; %#ok<*UNRCH>
    fprintf(1,'STARTING function: %s, in file: %s\n',st(1).name,st(1).file);
    debug_figNum = 3445467; %#ok<NASGU>
else
    debug_figNum = []; %#ok<NASGU>
end

%% check input arguments?
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
if 0==flag_max_speed
    if flag_check_inputs
        % Are there the right number of inputs?
        narginchk(2,MAX_NARGIN);

        % Check if rootdirs is a string. If so, convert it to a cell array
        if ~iscell(rootdirs) && (isstring(rootdirs) || ischar(rootdirs))
            rootdirs{1} = rootdirs;
        end

        % Loop through all the directories and make sure they are there
        for ith_directory = 1:length(rootdirs)
            folderName = rootdirs{ith_directory};
            try
                fcn_DebugTools_checkInputsToFunctions(folderName, 'DoesDirectoryExist');
            catch ME
                warning('on','backtrace');
                warning(['It appears that data was not pushed into a folder, for example: ' ...
                    '\\DataCleanClassLibrary\LargeData ' ...
                    'which is the folder where large data is imported for processing. ' ...
                    'Note that this folder is too large to include in the code repository, ' ...
                    'so it must be copied over from a data storage location. Within IVSG, ' ...
                    'this storage location is the OndeDrive folder called GitHubMirror.']);
                warning('The missing folder is: %s',folderName);
                rethrow(ME)
            end
        end

    end
end

% Does user specify?
clear searchIdentifiers
searchIdentifiers.Project = ''; % This is the project sponsoring the data collection
searchIdentifiers.ProjectStage = ''; % Can be 'Simulation', 'TestTrack', or 'OnRoad'
searchIdentifiers.WorkZoneScenario = ''; % Can be one of the ~20 scenarios, see key
searchIdentifiers.WorkZoneDescriptor = ''; % Can be one of the 20 descriptors, see key
searchIdentifiers.Treatment = ''; % Can be one of 9 options, see key
searchIdentifiers.DataSource = ''; % Can be 'MappingVan', 'AV', 'CV2X', etc. see key
searchIdentifiers.AggregationType = ''; % Can be 'PreCalibration', 'PreRun', 'Run', 'PostRun', or 'PostCalibration'
searchIdentifiers.SourceBagFileName = ''; % This is filled in automatically for each file
if 2 <= nargin
    temp = varargin{1};
    if ~isempty(temp)
        searchIdentifiers = temp;
    end
end


% Does user want to specify matQueryString?
matQueryString = 'mapping_van_*.mat';
if 3 <= nargin
    temp = varargin{2};
    if ~isempty(temp)
        matQueryString = temp;
    end
end

% Does user want to specify fid?
fid = 1;
if 4 <= nargin
    temp = varargin{3};
    if ~isempty(temp)
        fid = temp;
    end
end

% Does user want to show the plots?
flag_do_plots = 0; % Default is to NOT show plots
if (0==flag_max_speed) && (MAX_NARGIN == nargin) 
    temp = varargin{end};
    if ~isempty(temp) % Did the user NOT give an empty figure number?
        figNum = temp;
        flag_do_plots = 1;
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

%% Find all the files that will be queried
only_directory_filelist = fcn_DebugTools_listDirectoryContents(rootdirs, (matQueryString), (0), (fid));


%% Loop through all the directories
% Initialize key storage variables
NdataSets = length(only_directory_filelist);
rawDataCellArray = cell(1,1);

% Loop through all the Bag folders in each directory
NgoodDataSets = 0;
for ith_folder = 1:NdataSets

    % Load the mat data
    matName = only_directory_filelist(ith_folder).name;
    dataFolderString = only_directory_filelist(ith_folder).folder;
    matPath = fullfile(dataFolderString, matName);

    % Check that the fields all match
    tempLoad = load(matPath);
    tempFieldNames = fieldnames(tempLoad);
    assert(length(tempFieldNames)==1,'No main field detected. Unsure what field to plot.'); %#ok<ISCL>
    mainField = tempFieldNames{1};
    tempDataStructure = tempLoad.(mainField);

    searchFields = fieldnames(searchIdentifiers);
    flag_thisIsGoodMatFile = 1;
    for ith_searchfield = 1:length(searchFields)
        searchFieldName = searchFields{ith_searchfield};
        if ~isempty(searchIdentifiers.(searchFieldName))
            if ~strcmp(searchIdentifiers.(searchFieldName),tempDataStructure.Identifiers.(searchFieldName))
                flag_thisIsGoodMatFile = 0;
            end
        end
    end

    if 1==flag_thisIsGoodMatFile
        if fid
            fprintf(fid,'Loading file %.0d of %.0d: %s\n', ith_folder, NdataSets, matName);
        end
        NgoodDataSets = NgoodDataSets + 1;
        if isstruct(tempLoad) && isfield(tempLoad,'rawData')
            rawDataCellArray{NgoodDataSets,1} = tempLoad.rawData;
        else
            rawDataCellArray{NgoodDataSets,1} = tempLoad;
        end
    end

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
if (1==flag_do_plots)
    % List what will be saved (nothing)
    clear saveFlags
    saveFlags.flag_saveImages = 0;
    saveFlags.flag_saveImages_directory  = [];
    saveFlags.flag_forceDirectoryCreation = 0;
    saveFlags.flag_forceImageOverwrite = 0;

    % List what will be plotted, and the figure numbers
    clear plotFlags
    plotFlags.fig_num_plotAllRawTogether = figNum;
    plotFlags.fig_num_plotAllRawIndividually = [];

    % Call function
    fcn_LoadRawDataToMATLAB_plotRawDataPositions(rawDataCellArray, (saveFlags), (plotFlags))



end

if flag_do_debug
    fprintf(1,'ENDING function: %s, in file: %s\n\n',st(1).name,st(1).file);
end

end % Ends main function




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

