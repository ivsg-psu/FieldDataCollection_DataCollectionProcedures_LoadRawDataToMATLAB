function structureDiagnostic = fcn_LoadRawDataToMATLAB_loadRawFromFile_Diagnostic(filePath, datatype, topicName, varargin)
% fcn_LoadRawDataToMATLAB_loadRawFromFile_Diagnostic
% loads  the raw data collected with the Penn State Mapping Van.
% This is the parse diagnostic data, whose data type is diagnostic
%
% FORMAT:
%
%      structureDiagnostic =
%      fcn_LoadRawDataToMATLAB_loadRawFromFile_Diagnostic(filePath,
%      datatype, topicName, (figNum))
%
% INPUTS:
%
%     filePath: file path of the diagnostic data (format txt)
%
%     datatype: the datatype should be diagnostic
%
%     topicName: the name of the topic
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
%     See the script: script_test_fcn_LoadRawDataToMATLAB_loadRawFromFile_Diagnostic
%     for a full test suite.
%
% This function was written on 2020_11_15 by Liming Gao
% Maintained by S. Brennan, Xinyu Cao, Mariam Abdellatief  and Aneesh Batchu
% Questions or comments? sbrennan@psu.edu
% Reference:
% Document/Sick LiDAR Message Info.txt

% REVISION HISTORY:
%
% As: fcn_Data+Clean_loadRawDataFromFile_Diagnostic
%
% 2020_11_15 by Liming Gao
% - Function created
%
% 2023_06_16 by Xinyu Cao and Aneesh Batchu
% - Modified function to load the raw data (from file) collected with
%   % the Penn State Mapping Van.
%
% 2023_06_26 - X. Cao
% - The old diagnostic topics 'diagnostic_trigger' and
% 'diagnostic_encoder' are replaced with 'Trigger_diag' and 'Encoder_diag'
%
% 2023_06_29 by Sean Brennan, sbrennan@psu.edu
% - Fixed bug where centiSeconds is being filled with NaNs
%
% 2023_07_04 sbrennan@psu.edu
% - Fixed return at end of function to be 'end', keeping in function
%   % format
% - Added fid to fprint to allow printing to file
%
% 2024_10_03 sbrennan@psu.edu
% - Added debugging as it is throwing errors
%
% 2025_09_20: sbrennan@psue.edu
% - In fcn_DataClean_loadRawDataFromFile_Diagnostic
%   % * Renamed function to fcn_LoadRawDataToMATLAB_loadRawDataFromFile_Diagnostic
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
%   % * To: fcn_LoadRawDataToMATLAB_loadRawFromFile_Diagnostic

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


%%
if strcmp(datatype, 'diagnostic')

    opts = detectImportOptions(filePath);
    opts.PreserveVariableNames = true;
    datatable = readtable(filePath,opts);
    Npoints = height(datatable);
    structureDiagnostic = fcn_LoadRawDataToMATLAB_initializeDataByType(datatype,Npoints);
    switch topicName
        case '/Trigger_diag'
            time_stamp = (datatable.rosbagTimestamp)*10^-9; % This is rosbag timestamp
            secs = datatable.secs;
            nsecs = datatable.nsecs;
            % structureDiagnostic.GPS_Time           = secs + nsecs*10^-9;  % This is the GPS time, UTC, as reported by the unit
            % structureDiagnostic.Trigger_Time       = default_value;  % This is the Trigger time, UTC, as calculated by sample
            % structureDiagnostic.ROS_Time           = secs + nsecs*10^-9;  % This is the ROS time that the data arrived into the bag
            structureDiagnostic.ROS_Time           = time_stamp;
            structureDiagnostic.centiSeconds       = 100;  % This is the hundreth of a second measurement of sample period (for example, 20 Hz = 5 centiseconds)
            % structureDiagnostic.Npoints            = height(datatable);  % This is the number of data points in the array
            structureDiagnostic.Seq                = datatable.seq;
            structureDiagnostic.err_failed_mode_count             = datatable.err_failed_mode_count;
            structureDiagnostic.err_failed_checkInformation       = datatable.err_failed_checkInformation;
            structureDiagnostic.err_failed_XI_format              = datatable.err_failed_XI_format;
            structureDiagnostic.err_trigger_unknown_error_occured = datatable.err_trigger_unknown_error_occured;
            structureDiagnostic.err_bad_uppercase_character       = datatable.err_bad_uppercase_character;
            structureDiagnostic.err_bad_lowercase_character       = datatable.err_bad_lowercase_character;
            structureDiagnostic.err_bad_three_adj_element         = datatable.err_bad_three_adj_element;
            structureDiagnostic.err_bad_first_element             = datatable.err_bad_first_element;
            structureDiagnostic.err_bad_character                 = datatable.err_bad_character;
            structureDiagnostic.err_wrong_element_length          = datatable.err_wrong_element_length;

        case '/Encoder_diag'
            time_stamp = (datatable.rosbagTimestamp)*10^-9; % This is rosbag timestamp
            secs = datatable.secs;
            nsecs = datatable.nsecs;
            % structureDiagnostic.GPS_Time           = secs + nsecs*10^-9;  % This is the GPS time, UTC, as reported by the unit
            % structureDiagnostic.Trigger_Time       = default_value;  % This is the Trigger time, UTC, as calculated by sample
            % structureDiagnostic.ROS_Time           = secs + nsecs*10^-9;  % This is the ROS time that the data arrived into the bag
            structureDiagnostic.ROS_Time           = time_stamp;
            structureDiagnostic.centiSeconds       = 1;  % This is the hundreth of a second measurement of sample period (for example, 20 Hz = 5 centiseconds)
            % structureDiagnostic.Npoints            = height(datatable);  % This is the number of data points in the array
            structureDiagnostic.Seq                = datatable.seq;
            structureDiagnostic.err_wrong_element_length_encoder  = datatable.err_wrong_element_length;
            structureDiagnostic.err_bad_element_structure         = datatable.err_bad_element_structure;
            structureDiagnostic.err_failed_time                   = datatable.err_failed_time;
            structureDiagnostic.err_bad_uppercase_character_encoder = datatable.err_bad_uppercase_character;
            structureDiagnostic.err_bad_lowercase_character_encoder = datatable.err_bad_lowercase_character;
            structureDiagnostic.err_bad_character_encoder           = datatable.err_bad_character;

        case '/sparkfun_gps_diag_rear_left'
            time_stamp = (datatable.rosbagTimestamp)*10^-9; % This is rosbag timestamp
            secs = datatable.secs;
            nsecs = datatable.nsecs;
            % structureDiagnostic.GPS_Time    = secs + nsecs*10^-9;  % This is the GPS time, UTC, as reported by the unit
            % dataStructure.Trigger_Time       = default_value;  % This is the Trigger time, UTC, as calculated by sample
            % structureDiagnostic.ROS_Time           = secs + nsecs*10^-9;  % This is the ROS time that the data arrived into the bag
            structureDiagnostic.ROS_Time           = time_stamp;
            structureDiagnostic.centiSeconds       = 10;  % This is the hundreth of a second measurement of sample period (for example, 20 Hz = 5 centiseconds)
            % structureDiagnostic.Npoints            = height(datatable);  % This is the number of data points in the array
            % Data related to trigger box and encoder box
            structureDiagnostic.Seq                = datatable.seq;  % This is the sequence of the topic
            % Data related to SparkFun GPS Diagnostic
            structureDiagnostic.DGPS_mode          = datatable.LockStatus;  % Mode indicating DGPS status (for example, navmode 6)
            structureDiagnostic.numSatellites      = datatable.NumOfSats;  % Number of satelites visible
            structureDiagnostic.BaseStationID      = datatable.BaseStationID;  % Base station that was used for correction
            structureDiagnostic.HDOP               = datatable.HDOP; % DOP in horizontal position (ratio, usually close to 1, smaller is better)
            structureDiagnostic.AgeOfDiff          = datatable.AgeOfDiff;  % Age of correction data [s]
            structureDiagnostic.NTRIP_Status       = datatable.NTRIP_Status;  % The status of NTRIP connection (Ture, conencted, False, disconencted)

        case '/sparkfun_gps_diag_rear_right'
            time_stamp = (datatable.rosbagTimestamp)*10^-9; % This is rosbag timestamp
            secs = datatable.secs;
            nsecs = datatable.nsecs;
            % structureDiagnostic.GPS_Time    = secs + nsecs*10^-9;  % This is the GPS time, UTC, as reported by the unit
            % dataStructure.Trigger_Time       = default_value;  % This is the Trigger time, UTC, as calculated by sample
            structureDiagnostic.ROS_Time           = secs + nsecs*10^-9;  % This is the ROS time that the data arrived into the bag
            structureDiagnostic.ROS_Time           = time_stamp;
            structureDiagnostic.centiSeconds       = 10;  % This is the hundreth of a second measurement of sample period (for example, 20 Hz = 5 centiseconds)
            % structureDiagnostic.Npoints            = height(datatable);  % This is the number of data points in the array
            % Data related to trigger box and encoder box
            structureDiagnostic.Seq                = datatable.seq;  % This is the sequence of the topic
            % Data related to SparkFun GPS Diagnostic
            structureDiagnostic.DGPS_mode          = datatable.LockStatus;  % Mode indicating DGPS status (for example, navmode 6)
            structureDiagnostic.numSatellites      = datatable.NumOfSats;  % Number of satelites visible
            structureDiagnostic.BaseStationID      = datatable.BaseStationID;  % Base station that was used for correction
            structureDiagnostic.HDOP               = datatable.HDOP; % DOP in horizontal position (ratio, usually close to 1, smaller is better)
            structureDiagnostic.AgeOfDiff          = datatable.AgeOfDiff;  % Age of correction data [s]
            structureDiagnostic.NTRIP_Status       = datatable.NTRIP_Status;  % The status of NTRIP connection (Ture, conencted, False, disconencted)

        otherwise
            warning('on','backtrace');
            warning('Unrecognized toic found');
            error('Unrecognized topic requested: %s',topicName)
    end

else
    warning('on','backtrace');
    warning('Diagnostic utility called with type that is not ''diagnostic''. Type was: %s',datatype);
    error('Wrong data type requested for datatype. Unable to proceed.')
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




