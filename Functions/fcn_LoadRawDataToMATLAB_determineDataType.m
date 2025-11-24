function datatype = fcn_LoadRawDataToMATLAB_determineDataType(topicName, varargin)
% fcn_LoadRawDataToMATLAB_determineDataType
% determines which standard data type relates to a ROS topic
%
% FORMAT:
%
%      datatype = fcn_LoadRawDataToMATLAB_determineDataType(topicName)
%
% INPUTS:
%
%     topicName: the name of the ROS topic.
%
%     (OPTIONAL INPUTS)
%
%     figNum: a figure number to plot results. If set to -1, skips any
%     input checking or debugging, no figures will be generated, and sets
%     up code to maximize speed. As well, if given, this forces the
%     variable types to be displayed as output and as well makes the input
%     check process verbose
%
% OUTPUTS:
%
%      datatype: a string listing the data type, one of:
%         'gps', 'ins', 'trigger', 'encoder', 'lidar2d', 'lidar3d'
%      if the data type is not recognized, it lists 'other'.
%
% DEPENDENCIES:
%
%      fcn_DebugTools_checkInputsToFunctions
%
% EXAMPLES:
%
%     See the script: script_test_fcn_LoadRawDataToMATLAB_determineDataType
%     for a full test suite.
%
% This function was written on 2023_06_19 by S. Brennan
% Questions or comments? sbrennan@psu.edu 

% REVISION HISTORY:
% 
% As: fcn_DataClean_determineDataType
% 
% 2023_06_16 - Xinyu Cao
% - First functionalization of the code
% 
% 2023_06_19 by Sean Brennan, sbrennan@psu.edu
% - Added structure
% 
% 2023_06_22 by Sean Brennan, sbrennan@psu.edu
% - Fixed INS to be IMU, as wrong datatype given (line 93)
% 
% 2024_09_29 by Sean Brennan, sbrennan@psu.edu
% - Changed topic name of "gps_sparkfun" to "gps". 
% - Fixed other topics that were causing problems
% 
% 2025_09_20 by Sean Brennan, sbrennan@psu.edu
% - Renamed to LoadRawDataToMATLAB
% - Changed topic name of "gps_fix" to "gps". 
% - Changed topic name of diagnostics to output diagnostic form 
% 
% 2025_09_28 by Sean Brennan, sbrennan@psu.edu
% - Added formatted docstrings
% - Added figNum input for speed
% 
% 2025_11_23 by Sean Brennan, sbrennan@psu.edu
% - Corrected script name
% - Fixed rev history to be Markdown format
% - Added TO+-DO list
% - Renamed topic+_name to topicName

% TO-DO:
% 
% 2025_11_23 by Sean Brennan, sbrennan@psu.edu
% - (add items here)


%% Debugging and Input checks

% Check if flag_max_speed set. This occurs if the figNum variable input
% argument (varargin) is given a number of -1, which is not a valid figure
% number.
MAX_NARGIN = 2; % The largest Number of argument inputs to the function
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
        narginchk(1,MAX_NARGIN);

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


topicName_lower = lower(topicName);
if any([contains(topicName_lower,'gps_sparkfun'), ...
        contains(topicName_lower,'bin1'), ...
        contains(topicName_lower,'gps_fix')])
    datatype = 'gps';
elseif any([contains(topicName_lower,'ins'), contains(topicName_lower,'imu'),contains(topicName_lower, 'adis')])
    datatype = 'imu';
elseif contains(topicName_lower,'trigger')&&(~contains(topicName_lower,'diag'))
    datatype = 'trigger';
elseif contains(topicName_lower,'encoder')&&(~contains(topicName_lower,'diag'))
    datatype = 'encoder';
elseif any([contains(topicName,'sick_lms500/scan') contains(topicName,'sick_lms_5xx/scan')])
    datatype = 'lidar2d';
elseif contains(topicName_lower,'velodyne')
    datatype = 'lidar3d';
elseif any([contains(topicName_lower,'diag'),...
        contains(topicName_lower,'diagnostic')])
    datatype = 'diagnostic';
elseif contains(topicName_lower,'ntrip')
    datatype = 'ntrip';
elseif contains(topicName_lower,'rosout')
    datatype = 'rosout';
elseif contains(topicName_lower,'tf')
    datatype = 'transform';
elseif contains(topicName_lower,'camera')
    datatype = 'camera';
else
    datatype = 'other';
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
