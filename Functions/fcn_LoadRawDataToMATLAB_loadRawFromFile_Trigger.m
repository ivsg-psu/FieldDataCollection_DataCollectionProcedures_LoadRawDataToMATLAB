function structureTrigger = fcn_LoadRawDataToMATLAB_loadRawFromFile_Trigger(filePath,datatype, varargin)
% fcn_LoadRawDataToMATLAB_loadRawFromFile_Trigger
% loads the raw data collected with the Penn State Mapping Van.
% This is the parse Encoder data, whose data type is encoder
%
% FORMAT:
%
%      structureDiagnostic =
%      fcn_LoadRawDataToMATLAB_loadRawFromFile_Trigger(filePath,
%      datatype, topicName, (figNum))
%
% INPUTS:
%
%     filePath: file path of the diagnostic data (format txt)
%
%     datatype: the datatype should be encoder
%
%     (OPTIONAL INPUTS)
%
%     figNum: a figure number to plot results or fid to print to. If set to
%     -1, skips any input checking or debugging, no figures will be
%     generated, and sets up code to maximize speed. As well, if given,
%     this forces the variable types to be displayed as output and as well
%     makes the input check process verbose
%
% OUTPUTS:
%
%      structureDiagnostic: a structure containing the read data
%
% DEPENDENCIES:
%
%      fcn_DebugTools_checkInputsToFunctions
%
% EXAMPLES:
%
%     See the script: script_test_fcn_LoadRawDataToMATLAB_loadRawFromFile_Trigger
%     for a full test suite.
%
% This function was written on 2020_11_15 by Liming Gao
% Maintained by S. Brennan, Xinyu Cao
% Questions or comments? sbrennan@psu.edu
% Reference:
% Document/Sick LiDAR Message Info.txt

% REVISION HISTORY:
% 
% As: fcn_DataClean_loadRawDataFromFile_parse_Trigger
% 
% 2023_06_16 by Xinyu Cao, Aneesh Batchu and Mariam Abdellatief
% - Modified to load the raw data (from file) collected with
%   % the Penn State Mapping Van.
%
% 2023_07_04 sbrennan@psu.edu
% - Fixed return at end of function to be 'end', keeping in function
%   % format
% - Added fid to fprint to allow printing to file
% - Added entry and exit debugging prints
% - Removed variable clearing at end of function because this is automatic
% 
% 2024_07_03 xfc5113@psu.edu
% - Added modeCount to the struct array
% 
% 2024_07_08 xfc5113@psu.edu
% - convert mode field from cell array to string array
% 
% 2024_11_18 xfc5113@psu.edu
% - fix the typo for mode field. (Mode -> mode)
% 
% 2025_09_20 by Sean Brennan, sbrennan@psu.edu
% - In fcn_LoadRawDataToMATLAB_loadRawDataFromFile_parse_Trigger
%   % * Renamed function to fcn_LoadRawDataToMATLAB_loadRawDataFromFile_parse_Trigger
% 
% 2025_11_23 by Sean Brennan, sbrennan@psu.edu
% - Corrected script name
% - Fixed rev history to be Markdown format
% - Added TO+-DO list

% TO-DO:
% 
% 2025_11_23 by Sean Brennan, sbrennan@psu.edu
% - (add items here)


%% Debugging and Input checks

% Check if flag_max_speed set. This occurs if the figNum variable input
% argument (varargin) is given a number of -1, which is not a valid figure
% number.
MAX_NARGIN = 4; % The largest Number of argument inputs to the function
flag_max_speed = 0; % The default. This runs code with all error checking
if (nargin==MAX_NARGIN && isequal(varargin{end},-1))
    flag_do_debug = 0; % Flag to plot the results for debugging
    flag_check_inputs = 0; % Flag to perform input checking
    flag_max_speed = 1;
else
    % Check to see if we are externally setting debug mode to be "on"
    flag_do_debug = 0; % Flag to plot the results for debugging
    flag_check_inputs = 1; % Flag to perform input checking
    MATLABFLAG_LOADRAWDATATOMATLAB_FLAG_CHECK_INPUTS = getenv("MATLABFLAG_LOADRAWDATATOMATLAB_FLAG_CHECK_INPUTS");
    MATLABFLAG_LOADRAWDATATOMATLAB_FLAG_DO_DEBUG = getenv("MATLABFLAG_LOADRAWDATATOMATLAB_FLAG_DO_DEBUG");
    if ~isempty(MATLABFLAG_LOADRAWDATATOMATLAB_FLAG_CHECK_INPUTS) && ~isempty(MATLABFLAG_LOADRAWDATATOMATLAB_FLAG_DO_DEBUG)
        flag_do_debug = str2double(MATLABFLAG_LOADRAWDATATOMATLAB_FLAG_DO_DEBUG);
        flag_check_inputs  = str2double(MATLABFLAG_LOADRAWDATATOMATLAB_FLAG_CHECK_INPUTS);
    end
end

% flag_do_debug = 1;

if flag_do_debug % If debugging is on, print on entry/exit to the function
    st = dbstack; %#ok<*UNRCH>
    fprintf(1,'STARTING function: %s, in file: %s\n',st(1).name,st(1).file);
    debug_figNum = 999978; %#ok<NASGU>
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
        narginchk(3,MAX_NARGIN);

        % % Check the input_path to be sure it has 2 or 3 columns, minimum 2 rows
        % % or more
        % fcn_DebugTools_checkInputsToFunctions(input_path, '2or3column_of_numbers',[2 3]);
    end
end


% % Does user want to specify directoryQuery?
% directoryQuery = '*.*'; % Default is search only current directory
% if 3 >= nargin
%     temp = varargin{1};
%     if ~isempty(temp) % Did the user NOT give an empty value?
%        directoryQuery = temp;
%     end
% end

% Does user want to show the plots?
flag_do_plots = 0; % Default is to NOT show plots
if (0==flag_max_speed) && (MAX_NARGIN == nargin)
    temp = varargin{end};
    if ~isempty(temp) % Did the user NOT give an empty figure number?
        figNum = temp; %#ok<NASGU>
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

if strcmp(datatype,'trigger')
    opts = detectImportOptions(filePath);
    opts.PreserveVariableNames = true;
    datatable = readtable(filePath,opts);
    Npoints = height(datatable);
    structureTrigger = fcn_LoadRawDataToMATLAB_initializeDataByType(datatype,Npoints);

    structureTrigger.mode = datatable.mode;
    time_stamp = (datatable.rosbagTimestamp)*10^-9; % This is rosbag timestamp
    % structureTrigger.GPS_Time                          = secs + nsecs*(10^-9);  % This is the GPS time, UTC, as reported by the unit
    % structureTrigger.Trigger_Time                      = default_value;  % This is the Trigger time, UTC, as calculated by sample
    % structureTrigger.ROS_Time                          = secs + nsecs*(10^-9);  % This is the ROS time that the data arrived into the bag
    structureTrigger.ROS_Time  = time_stamp;
    structureTrigger.centiSeconds                      = 100;  % This is the hundreth of a second measurement of sample period (for example, 20 Hz = 5 centiseconds)
    % structureTrigger.Npoints                           = height(datatable);  % This is the number of data points in the array
    mode_cell = datatable.mode;  
    mode_string = string(mode_cell);
    mode_string_clean = erase(mode_string,"''");
    mode_string_clean = erase(mode_string_clean,"""");
    structureTrigger.mode                              = mode_string_clean;     % This is the mode of the trigger box (I: Startup, X: Freewheeling, S: Syncing, L: Locked)
    structureTrigger.modeCount                         = datatable.mode_counts; % This is the count of the Locked mode (empty for other mode)
    structureTrigger.adjone                            = datatable.adjone;   % This is phase adjustment magnitude relative to the calculated period of the output pulse
    structureTrigger.adjtwo                            = datatable.adjtwo;   % This is phase adjustment magnitude relative to the calculated period of the output pulse
    structureTrigger.adjthree                          = datatable.adjthree; % This is phase adjustment magnitude relative to the calculated period of the output pulse
    % Data below are error monitoring messages
    structureTrigger.err_failed_mode_count             = datatable.err_failed_mode_count;
    structureTrigger.err_failed_XI_format              = datatable.err_failed_XI_format;
    structureTrigger.err_failed_checkInformation       = datatable.err_failed_checkInformation;
    structureTrigger.err_trigger_unknown_error_occured = datatable.err_trigger_unknown_error_occured;
    structureTrigger.err_bad_uppercase_character       = datatable.err_bad_uppercase_character;
    structureTrigger.err_bad_lowercase_character       = datatable.err_bad_lowercase_character;
    structureTrigger.err_bad_three_adj_element         = datatable.err_bad_three_adj_element;
    structureTrigger.err_bad_first_element             = datatable.err_bad_first_element;
    structureTrigger.err_bad_character                 = datatable.err_bad_character;
    structureTrigger.err_wrong_element_length          = datatable.err_wrong_element_length;

else
    error('Wrong data type requested: %s',dataType)
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






