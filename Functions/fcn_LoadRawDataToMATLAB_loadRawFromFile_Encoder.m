function structureEncoder = fcn_LoadRawDataToMATLAB_loadRawFromFile_Encoder(filePath,datatype, varargin)
% fcn_LoadRawDataToMATLAB_loadRawFromFile_Encoder
% loads the raw data collected with the Penn State Mapping Van.
% This is the parse Encoder data, whose data type is encoder
%
% FORMAT:
%
%      structureDiagnostic =
%      fcn_LoadRawDataToMATLAB_loadRawFromFile_Encoder(filePath,
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
%     See the script: script_test_fcn_LoadRawDataToMATLAB_loadRawFromFile_Encoder
%     for a full test suite.
%
% This function was written on 2020_11_15 by Liming Gao
% Maintained by S. Brennan, Xinyu Cao
% Questions or comments? sbrennan@psu.edu
% Reference:
% Document/Sick LiDAR Message Info.txt

% REVISION HISTORY:
% 
% As: fcn_DataClean_loadRawDataFromFile_parse_Encoder
% 
% 2023_06_16 by Xinyu Cao
% 
% 2023_07_04 by Sean Brennan, sbrennan@psu.edu
% - Fixed return at end of function to be 'end', keeping in function
%   % format
% - Added fid to fprint to allow printing to file
% - Added entry and exit debugging prints
% - Removed variable clearing at end of function because this is automatic
% 
% 2025_09_20 by Sean Brennan, sbrennan@psu.edu
% - In fcn_LoadRawDataToMATLAB_loadRawDataFromFile_parse_Encoder
%   % * Renamed function to fcn_LoadRawDataToMATLAB_loadRawDataFromFile_parse_Encoder
% 
% 2025_11_23 by Sean Brennan, sbrennan@psu.edu
% - Corrected script name
% - Fixed rev history to be Markdown format
% - Added TO+-DO list
% - Changed variable names for clarity
%   % * from file_+path to filePath
%   % * from diagnostic__structure to structureDiagnostic
% - Renamed function
%   % * From: fcn_LoadRawDataToMATLAB_loadRawDataFromFile_sickLIDAR
%   % * To: fcn_LoadRawDataToMATLAB_loadRawFromFile_Encoder

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



if strcmp(datatype,'encoder')
    opts = detectImportOptions(filePath);
    opts.PreserveVariableNames = true;
    datatable = readtable(filePath,opts);
    Npoints = height(datatable);
    structureEncoder = fcn_LoadRawDataToMATLAB_initializeDataByType(datatype,Npoints);
    % secs = datatable.secs;
    % nsecs = datatable.nsecs;
    time_stamp = (datatable.rosbagTimestamp)*10^-9; % This is rosbag timestamp
%     structureEncoder.GPS_Time         = secs + nsecs * 10^-9;  % This is the GPS time, UTC, as reported by the unit
    % structureEncoder.Trigger_Time         = datatable.time;  % This is the Trigger time, UTC, as calculated by sample
    % structureEncoder.ROS_Time           = secs + nsecs * 10^-9;  % This is the ROS time that the data arrived into the bag
    structureEncoder.ROS_Time           = time_stamp;  % This is the ROS time that the data arrived into the bag
    structureEncoder.centiSeconds       = 1;  % This is the hundreth of a second measurement of sample period (for example, 20 Hz = 5 centiseconds)
    % structureEncoder.Npoints            = height(datatable);  % This is the number of data points in the array
    % structureEncoder.CountsPerRev       = default_value;  % How many counts are in each revolution of the encoder (with quadrature)
    structureEncoder.C1Counts             = datatable.C1;  % A vector of the counts measured by the encoder, Npoints long
    structureEncoder.C2Counts             = datatable.C2;   % A vector of the counts measured by the encoder, Npoints long
    % structureEncoder.DeltaCounts        = default_value;  % A vector of the change in counts measured by the encoder, with first value of zero, Npoints long
    % structureEncoder.LastIndexCount     = default_value;  % Count at which last index pulse was detected, Npoints long
    % structureEncoder.AngularVelocity    = default_value;  % Angular velocity of the encoder
    % structureEncoder.AngularVelocity_Sigma    = default_value; 
    structureEncoder.Mode = string(erase((datatable.mode),"""")); % A vector of the mode of the encoder box, T indicaes triggered.

else
    error('Wrong data type requested: %s',datatype)
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






