function structureLidarSICK = fcn_LoadRawDataToMATLAB_loadRawFromFile_LidarSICK(filePath, datatype, varargin)
% fcn_LoadRawDataToMATLAB_loadRawFromFile_LidarSICK
% loads the raw data collected with the Penn State Mapping Van.
% This is the Sick Lidar data, whose data type is lidar2d
%
% FORMAT:
%
%      structureLidarSICK =
%      fcn_LoadRawDataToMATLAB_loadRawFromFile_LidarSICK(filePath,
%      datatype, (figNum))
%
% INPUTS:
%
%     filePath: file path of the Sick Lidar data (format txt)
%
%     datatype: the datatype should be lidar2d
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
%      structureLidarSICK: a structure containing the read data
%
% DEPENDENCIES:
%
%      fcn_DebugTools_checkInputsToFunctions
%
% EXAMPLES:
%
%     See the script: script_test_fcn_LoadRawDataToMATLAB_loadRawFromFile_LidarSICK
%     for a full test suite.
%
% This function was written on 2020_11_15 by Liming Gao
% Maintained by S. Brennan, Xinyu Cao, and Aneesh Batchu
% Questions or comments? sbrennan@psu.edu 
% Reference:
% Document/Sick LiDAR Message Info.txt

% REVISION HISTORY:
% 
% As: fcn_Data+Clean_loadRawDataFromFile_sickLIDAR
%
% 2020_11_15 by Liming Gao
% - Function created
%
% 2023_06_16 by Xinyu Cao and Aneesh Batchu
% - Modified 
% 
% 2023_07_04 sbrennan@psu.edu
% - Fixed return at end of function to be 'end', keeping in function
%   % format
% - Added fid to fprint to allow printing to file
% - Added entry and exit debugging prints
% - Removed variable clearing at end of function because this is automatic
% 
% As: fcn_LoadRawDataToMATLAB_loadRawDataFromFile_sickLIDAR
%
% 2025_09_20 by Sean Brennan, sbrennan@psu.edu
% - In fcn_LoadRawDataToMATLAB_loadRawFromFile_LidarSICK
%   % * Renamed function to fcn_LoadRawDataToMATLAB_loadRawFromFile_LidarSICK
% 
% 2025_11_23 by Sean Brennan, sbrennan@psu.edu
% - Corrected script name
% - Fixed rev history to be Markdown format
% - Added TO+-DO list
% - Changed variable names for clarity
%   % * from file_+path to filePath
%   % * from Sick_Lidar__structure to structureLidarSICK
% - Renamed function
%   % * From: fcn_LoadRawDataToMATLAB_loadRawDataFromFile_sickLIDAR
%   % * To: fcn_LoadRawDataToMATLAB_loadRawFromFile_LidarSICK

% TO-DO:
% 
% 2025_11_23 by Sean Brennan, sbrennan@psu.edu
% - (add items here)


%% Debugging and Input checks

% Check if flag_max_speed set. This occurs if the figNum variable input
% argument (varargin) is given a number of -1, which is not a valid figure
% number.
MAX_NARGIN = 3; % The largest Number of argument inputs to the function
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
        narginchk(2,MAX_NARGIN);

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


if strcmp(datatype,'lidar2d')
    opts = detectImportOptions(filePath);
    sick_lidar_data = readmatrix(filePath, opts);
    Npoints = size(sick_lidar_data,1);
    data_length = size(sick_lidar_data,2);
    lidar_spec_length = 10;
    single_scan_length = (data_length-lidar_spec_length)/2;
    range_data_start = lidar_spec_length + 1;
    range_data_end = lidar_spec_length + single_scan_length;
    intensity_data_start = range_data_end + 1;
    intensity_data_end = range_data_end + single_scan_length;
    structureLidarSICK = fcn_LoadRawDataToMATLAB_initializeDataByType(datatype,Npoints);
    % if iscell(sick_lidar_data)
    % 
    %     sick_lidar_data = cell2mat(sick_lidar_data);
    % end
    secs = sick_lidar_data(:,2);
    nsecs = sick_lidar_data(:,3);
    % structureLidarSICK.GPS_Time           = secs + nsecs*10^-9;  % This is the GPS time, UTC, as reported by the unit
    % data_structure.Trigger_Time       = default_value;  % This is the Trigger time, UTC, as calculated by sample
    structureLidarSICK.ROS_Time           = secs + nsecs*10^-9;  % This is the ROS time that the data arrived into the bag
    structureLidarSICK.centiSeconds       = 2;  % This is the hundreth of a second measurement of sample period (for example, 20 Hz = 5 centiseconds)
    % structureLidarSICK.Npoints            = length(secs);  % This is the number of data points in the array
    structureLidarSICK.angle_min          = sick_lidar_data(:,4);  % This is the start angle of scan [rad]
    structureLidarSICK.angle_max          = sick_lidar_data(:,5);  % This is the end angle of scan [rad]
    structureLidarSICK.angle_increment    = sick_lidar_data(:,6);  % This is the angle increment between each measurements [rad]
    structureLidarSICK.time_increment     = sick_lidar_data(:,7);  % This is the time increment between each measurements [s]
    structureLidarSICK.scan_time          = sick_lidar_data(:,8);  % This is the time between scans [s]
    structureLidarSICK.range_min          = sick_lidar_data(:,9);  % This is the minimum range value [m]
    structureLidarSICK.range_max          = sick_lidar_data(:,10);  % This is the maximum range value [m]
    structureLidarSICK.ranges             = sick_lidar_data(:,range_data_start:range_data_end);  % This is the range data of scans [m]
    structureLidarSICK.intensities        = sick_lidar_data(:,intensity_data_start:intensity_data_end);  % This is the intensities data of scans (Ranging from 0 to 255)
    

    % Process Sick Time topics
    dataFolder = fileparts(filePath);
    sick_time_file_name = '_slash_sick_lms500_slash_sicktime.csv';
    sick_time_filePath = fullfile(dataFolder,sick_time_file_name);
    if isfile(sick_time_filePath)
        sick_time_opts = detectImportOptions(sick_time_filePath);
        sick_time_opts.PreserveVariableNames = true;
        sick_time_table = readtable(sick_time_filePath,sick_time_opts);

        sick_time_secs = sick_time_table.secs_1;
        sick_time_nsecs = sick_time_table.nsecs_1;
        structureLidarSICK.Sick_Time = sick_time_secs + sick_time_nsecs*10^-9;
    end

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


