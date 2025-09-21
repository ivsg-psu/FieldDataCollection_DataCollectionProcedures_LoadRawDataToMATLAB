function fcn_LoadRawDataToMATLAB_saveRawDataMatFiles(rawDataCellArray, directoryList, varargin)
% fcn_LoadRawDataToMATLAB_saveRawDataMatFiles
% Produces plots of the data and, via optional saveFlag inputs, 
% can save images (PNG and FIG files) to user-chosen directories.
%
% FORMAT:
%
%      fcn_LoadRawDataToMATLAB_saveRawDataMatFiles(rawDataCellArray, directoryList, (saveFlags))
%
% INPUTS:
%
%      rawDataCellArray: a cell array of data structures containing data
%      fields filled for each ROS topic
%
%      directoryList: a structure array of directory locations where the
%      mat files will be saved.
%
%      (OPTIONAL INPUTS)
%
%      saveFlags: a structure of flags to determine how/where/if the
%      results are saved. The defaults are below
%
%         saveFlags.flag_forceDirectoryCreation = 1; % Set to 1 to force
%         directory to be created if it does not exist
%
%         saveFlags.flag_forceMATfileOverwrite = 1; % Set to 1 to overwrite
%         existing files. If set to 0, and file exists, file will not be
%         created.
%
% OUTPUTS:
%
%      (none)
%
% DEPENDENCIES:
%
%      fcn_DebugTools_checkInputsToFunctions
%
% EXAMPLES:
%
%     See the script: script_test_fcn_LoadRawDataToMATLAB_saveRawDataMatFiles
%     for a full test suite.
%
% This function was written on 2025_09_20 by S. Brennan
% Questions or comments? sbrennan@psu.edu

% Revision history
% 2025_09_20 - Sean Brennan, sbrennan@psu.edu
% -- wrote the code originally using 
%    script_test_fcn_DataClean_loadRawDataFromDirectories as a starter

%% Debugging and Input checks

% Check if flag_max_speed set. This occurs if the fig_num variable input
% argument (varargin) is given a number of -1, which is not a valid figure
% number.
flag_max_speed = 0;
if (nargin==3 && isequal(varargin{end},-1))
    flag_do_debug = 0; % % % % Flag to plot the results for debugging
    flag_check_inputs = 0; % Flag to perform input checking
    flag_max_speed = 1;
else
    % Check to see if we are externally setting debug mode to be "on"
    flag_do_debug = 0; % % % % Flag to plot the results for debugging
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
    debug_fig_num = 999978; %#ok<NASGU>
else
    debug_fig_num = []; %#ok<NASGU>
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

if 0 == flag_max_speed
    if flag_check_inputs == 1
        % Are there the right number of inputs?
        narginchk(2,3);

    end
end

% Does user specify saveFlags?
% Set defaults
saveFlags.flag_forceDirectoryCreation = 1;
saveFlags.flag_forceMATfileOverwrite = 1;
if 2 <= nargin
    temp = varargin{1};
    if ~isempty(temp)
        saveFlags = temp;
    end
end

% Does user want to specify plotFlags?
% Set defaults
flag_do_plots = 0;

% if (0==flag_max_speed) &&  (3<=nargin)
%     temp = varargin{end};
%     if ~isempty(temp)
%         plotFlags = temp;
%         flag_do_plots = 1;
%     end
% end

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

%% Make sure the MAT save directories are there if MAT file save is requested.
for ith_rawData = 1:length(directoryList)
    directoryName = directoryList{ith_rawData};
    if 7~=exist(directoryName, 'dir') && 0==saveFlags.flag_forceDirectoryCreation
        warning('on','backtrace');
        warning('Unable to find directory: %s',directoryName)
        error('MAT file save specified that copies files into a non-existing directory. Unable to continue.');
    end

    % Create the mat save directory if needed
    if  saveFlags.flag_forceDirectoryCreation    
        fcn_DebugTools_makeDirectory(directoryName);
    end

    bagName = rawDataCellArray{ith_rawData}.Identifiers.SourceBagFileName;
    % Make sure bagName is good
    if contains(bagName,'.')
        bagName_clean = extractBefore(bagName,'.');
    else
        bagName_clean = bagName;
    end

    % Save to the name
    matData = rawDataCellArray{ith_rawData};
    matFileName = char(bagName_clean);
    matDirectory = directoryName;
    flag_forceMATfileOverwrite = saveFlags.flag_forceMATfileOverwrite;
    fcn_INTERNAL_saveMATfile(matData, matFileName, matDirectory, flag_forceMATfileOverwrite);

end





%% Plot the results 
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
    % Nothing to plot
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

%% fcn_INTERNAL_saveMATfile
function  fcn_INTERNAL_saveMATfile(rawData, matFileName, matDirectory, flag_forceMATfileOverwrite)

MAT_fname = cat(2,matFileName,'.mat');
MAT_fullPath = fullfile(matDirectory, MAT_fname);
if 2~=exist(MAT_fullPath,'file') || 1==flag_forceMATfileOverwrite
    save(MAT_fullPath,'rawData','-mat','-v7.3');
elseif 0==flag_forceMATfileOverwrite &&  2==exist(MAT_fullPath,'file')
    warning('on','backtrace');
    warning('Unable to write to file: %s, without causing overwrite',MAT_fullPath)
    error('MAT file save specified that copies files over existing file, but over-copy not allowed. Unable to continue.');
end

end % Ends fcn_INTERNAL_saveMATfile
