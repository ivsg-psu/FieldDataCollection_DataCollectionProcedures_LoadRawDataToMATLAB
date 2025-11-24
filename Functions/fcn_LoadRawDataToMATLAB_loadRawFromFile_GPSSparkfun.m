function structureGPSSparkfun = fcn_LoadRawDataToMATLAB_loadRawFromFile_GPSSparkfun(filePath,datatype,topicName, varargin)
% fcn_LoadRawDataToMATLAB_loadRawFromFile_GPSSparkfun
% This function is used to load the raw data collected with the Penn State
% Mapping Van. Specifically, this process text files containing recordings
% from the SparkFun GPS data, whose data type is gps Input Variables.
%
% FORMAT:
%
%      structureGPSSparkfun =
%      fcn_LoadRawDataToMATLAB_loadRawFromFile_GPSSparkfun(filePath,
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
%      structureGPSSparkfun: a structure containing the read data
%
% DEPENDENCIES:
%
%      fcn_DebugTools_checkInputsToFunctions
%
% EXAMPLES:
%
%     See the script: script_test_fcn_LoadRawDataToMATLAB_loadRawFromFile_GPSSparkfun
%     for a full test suite.
%
% This function was written on 2023_06_16 by xinyu Cao
% Maintained by S. Brennan, Xinyu Cao
% Questions or comments? sbrennan@psu.edu

% REVISION HISTORY:
%
% As: fcn_Data+Clean_loadRawDataFromFile_Sparkfun_GPS
%
% 2023_06_16 - X. Cao
% - created first version of this function
%
% 2023_06_26 - X. Cao
% - Each sparkfun gps has three topics, sparkfun_gps_GGA, sparkfun_gps_VTG
%   % and sparkfun_gps_GST. An if else statement was added to load different
%   % topics.
%
% 2023_07_04 sbrennan@psu.edu
% - Fixed return at end of function to be 'end', keeping in function
%   % format
% - Added fid to fprint to allow printing to file
% - Added entry and exit debugging prints
% - Removed variable clearing at end of function because this is automatic
%
% 2024_09_15 xfc5113@psu.edu
% - Added Trigger_Time field for VTG messages
%
% As:
%
% 2025_09_20 by Sean Brennan, sbrennan@psu.edu
% - In fcn_LoadRawDataToMATLAB_loadRawDataFromFile_Sparkfun_GPS
%   % * Renamed function to fcn_LoadRawDataToMATLAB_loadRawDataFromFile_Sparkfun_GPS
%
% As: fcn_LoadRawDataToMATLAB_loadRawFromFile_GPSSparkfun
%
% 2025_11_23 by Sean Brennan, sbrennan@psu.edu
% - Corrected script name
% - Fixed rev history to be Markdown format
% - Added TO+-DO list
% - Changed variable names for clarity
%   % * from file_+path to filePath
%   % * from structureGPSSparkfun to structureGPSSparkfun
% - Renamed function
%   % * From: fcn_LoadRawDataToMATLAB_loadRawDataFromFile_Sparkfun_GPS
%   % * To: fcn_LoadRawDataToMATLAB_loadRawFromFile_GPSSparkfun

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


if strcmp(datatype,'gps')
    opts = detectImportOptions(filePath);
    opts.PreserveVariableNames = true;
    datatable = readtable(filePath,opts);
    % Npoints = height(datatable);
    % structureGPSSparkfun = struct; % fcn_LoadRawDataToMATLAB_initializeDataByType(datatype,Npoints);

    if contains(topicName,"GGA")
        structureGPSSparkfun = fcn_LoadRawDataToMATLAB_initializeDataByType(datatype);
        GPSsecs = datatable.GPSSecs; % For data collected after 2023-06-06, new fields GPSSecs are added
        GPSmicrosecs = datatable.GPSMicroSecs; % For data collected after 2023-06-06, new fields GPSMicroSecs are added
        time_stamp = (datatable.rosbagTimestamp)*10^-9; % This is rosbag timestamp



        structureGPSSparkfun.GPS_Time     = GPSsecs + GPSmicrosecs*10^-6;  % This is the GPS time, UTC, as reported by the unit


        % FOR DEBUGGING:
        % fprintf(1,'GPS microseconds:\n');
        % format long
        % disp(GPSmicrosecs(1:20,1));

        structureGPSSparkfun.ROS_Time           = time_stamp;  % This is the ROS time that the data arrived into the bag
        structureGPSSparkfun.centiSeconds       = 10;  % This is the hundreth of a second measurement of sample period (for example, 20 Hz = 5 centiseconds)
        % structureGPSSparkfun.Npoints            = height(datatable);  % This is the number of data points in the array
        structureGPSSparkfun.Latitude           = datatable.Latitude;  % The latitude [deg]
        structureGPSSparkfun.Longitude          = datatable.Longitude;  % The longitude [deg]
        structureGPSSparkfun.Altitude           = datatable.Altitude;  % The altitude above sea level [m]
        structureGPSSparkfun.GeoSep             = datatable.GeoSep;    %
        % structureGPSSparkfun.xEast = default_value;
        % structureGPSSparkfun.xEast_Sigma        = default_value;  % Sigma in xEast [m]
        % structureGPSSparkfun.yNorth = default_value;
        % structureGPSSparkfun.yNorth_Sigma       = default_value;  % Sigma in yNorth [m]
        % structureGPSSparkfun.zUp = default_value;
        % structureGPSSparkfun.zUp_Sigma          = default_value;  % Sigma in zUp [m]

        % structureGPSSparkfun.velNorth           = default_value;  % Velocity in north direction (ENU) [m/s]
        % structureGPSSparkfun.velNorth_Sigma     = default_value;  % Sigma in velNorth [m/s]
        % structureGPSSparkfun.velEast            = default_value;  % Velocity in east direction (ENU) [m/s]
        % structureGPSSparkfun.velEast_Sigma      = default_value;  % Sigma in velEast [m/s]
        % structureGPSSparkfun.velUp              = default_value;  % Velocity in up direction (ENU) [m/s]
        % structureGPSSparkfun.velUp_Sigma        = default_value;  % Velocity in up direction (ENU) [m/s]
        % structureGPSSparkfun.velMagnitude       = default_value;  % Velocity magnitude (ENU) [m/s]
        % structureGPSSparkfun.velMagnitude_Sigma = default_value;  % Sigma in velMagnitude [m/s]
        structureGPSSparkfun.numSatellites      = datatable.NumOfSats;  % Number of satelites visible
        structureGPSSparkfun.DGPS_mode          = datatable.LockStatus;  % Mode indicating DGPS status (for example, navmode 6;
        % structureGPSSparkfun.Roll_deg           = default_value;  % Roll (angle about X) in degrees, ISO coordinates
        % structureGPSSparkfun.Roll_deg_Sigma     = default_value;  % Sigma in Roll
        % structureGPSSparkfun.Pitch_deg          = default_value;  % Pitch (angle about y) in degrees, ISO coordinates
        % structureGPSSparkfun.Pitch_deg_Sigma    = default_value;  % Sigma in Pitch
        % structureGPSSparkfun.Yaw_deg            = default_value;  % Yaw (angle about z) in degrees, ISO coordinates
        % structureGPSSparkfun.Yaw_deg_Sigma      = default_value;  % Sigma in Yaw
        % structureGPSSparkfun.OneSigmaPos        = default_value;  % Sigma in position
        % time_diff = time_stamp - structureGPSSparkfun.ROS_Time;
        structureGPSSparkfun.HDOP               = datatable.HDOP; % DOP in horizontal position (ratio, usually close to 1, smaller is better)
        structureGPSSparkfun.AgeOfDiff          = datatable.AgeOfDiff;  % Age of correction data [s]

        % Event functions
        % dataStructure.EventFunctions = {}; % These are the functions to determine if something went wrong
        %rawdata.SparkFun_GPS_RearLeft = SparkFun_GPS_RearLeft;
    elseif contains(topicName,"VTG")
        structureGPSSparkfun = struct;

        time_stamp = (datatable.rosbagTimestamp)*10^-9; % This is rosbag timestamp

        structureGPSSparkfun.Trigger_Time       = nan;
        structureGPSSparkfun.ROS_Time           = time_stamp;
        structureGPSSparkfun.centiSeconds       = 10;  % This is the hundreth of a second measurement of sample period (for example, 20 Hz = 5 centiseconds)
        % structureGPSSparkfun.Npoints            = height(datatable);  % This is the number of data points in the array
        structureGPSSparkfun.SpdOverGrndKmph    = datatable.SpdOverGrndKmph;
    elseif contains(topicName,"GST")
        structureGPSSparkfun = struct;
        GPSsecs = datatable.GPSSecs; % For data collected after 2023-06-06, new fields GPSSecs are added
        GPSmicrosecs = datatable.GPSMicroSecs; % For data collected after 2023-06-06, new fields GPSMicroSecs are added
        time_stamp = (datatable.rosbagTimestamp)*10^-9; % This is rosbag timestamp
        structureGPSSparkfun.GPS_Time           = GPSsecs + GPSmicrosecs*10^-6;  % This is the GPS time, UTC, as reported by the unit
        % structureGPSSparkfun.Trigger_Time       = default_value;  % This is the Trigger time, UTC, as calculated by sample
        structureGPSSparkfun.ROS_Time           = time_stamp;
        structureGPSSparkfun.centiSeconds       = 10;  % This is the hundreth of a second measurement of sample period (for example, 20 Hz = 5 centiseconds)
        % structureGPSSparkfun.Npoints            = height(datatable);  % This is the number of data points in the array
        structureGPSSparkfun.StdLat             = datatable.StdLat;
        structureGPSSparkfun.StdLon             = datatable.StdLon;
        structureGPSSparkfun.StdAlt             = datatable.StdAlt;
    elseif contains(topicName,"PVT")
        structureGPSSparkfun = fcn_LoadRawDataToMATLAB_initializeDataByType(datatype);
        time_stamp = (datatable.rosbagTimestamp)*10^-9; % This is rosbag timestamp
        structureGPSSparkfun.ROS_Time = time_stamp;
        structureGPSSparkfun.iTOW = datatable.iTOW; % GPS Millisecond time of week [ms]
        structureGPSSparkfun.Year = datatable.year;
        structureGPSSparkfun.Month = datatable.month;
        structureGPSSparkfun.Day = datatable.day;
        structureGPSSparkfun.Hour = datatable.hour;
        structureGPSSparkfun.Minute = datatable.min;
        structureGPSSparkfun.Second = datatable.sec;
        structureGPSSparkfun.Valid = datatable.valid; % Validity flags, need to check later, might be a structure contain differnet flags
        structureGPSSparkfun.timeAccuracy = datatable.tAcc; % time accuracy estimate [ns] (UTC)
        structureGPSSparkfun.nanoSecs = datatable.nano;
        % Calculate GPS time in second, the actual GPS epoch is 1980/01/06,
        % use 1970/01/01 here to have the same time line with UTC Time
        % (Need to discuss)
        gps_epoch = datetime(1970,1,1,0,0,0,'TimeZone','UTC');
        current_utc_time = datetime(datatable.year, datatable.month, datatable.day, datatable.hour, datatable.min, datatable.sec, 'TimeZone', 'UTC');
        elapsed_seconds = seconds(current_utc_time - gps_epoch);
        GPS_TimeSeconds = elapsed_seconds;
        structureGPSSparkfun.GPS_Time = GPS_TimeSeconds+structureGPSSparkfun.nanoSecs*(10^-9);
        structureGPSSparkfun.fixType = datatable.fixType; % DGPS Mode, need to discuss whether we want to use our standard
        structureGPSSparkfun.flags = datatable.flags; %
        structureGPSSparkfun.flags2 = datatable.flags2;
        structureGPSSparkfun.numSatellites = datatable.numSV;
        structureGPSSparkfun.Latitude     = datatable.lat;  % The latitude [deg/1e-7]
        structureGPSSparkfun.Longitude    = datatable.lon;  % The longitude [deg/1e-7]
        structureGPSSparkfun.Altitude     = datatable.height;  % The altitude above Ellipsoid [mm]
        structureGPSSparkfun.HightAboveSea  = datatable.hMSL;  % The altitude above sea level [mm]
        structureGPSSparkfun.HonAccuracyEst   = datatable.hAcc;  % Horizontal accuracy estimate [mm]
        structureGPSSparkfun.VerAccuracyEst    = datatable.vAcc;  % Vertical accuracy estimate [mm]
        structureGPSSparkfun.velEast    = datatable.velE;  % NED East Velocity [mm/s]
        structureGPSSparkfun.velNorth    = datatable.velN;  % NED North Velocity [mm/s]
        structureGPSSparkfun.velDown    = datatable.vAcc;  % NED Down Velocity [mm/s]
        structureGPSSparkfun.goundSpeed  = datatable.gSpeed;  % Ground Speed [mm/s]
        structureGPSSparkfun.headingMotion    = datatable.heading;  % Heading of motion [deg /1e-5]
        structureGPSSparkfun.SpeedAccuracyEst    = datatable.sAcc;  % Speed accuracy estimate [mm/s]
        structureGPSSparkfun.HeadingAccuracyEst    = datatable.headAcc;  % Heading accuracy estimate [deg /1e-5]
        structureGPSSparkfun.PDOP  = datatable.pDOP;  % Position DOP [1/0.01]

        structureGPSSparkfun.reserved = datatable.reserved1; % Reserved (Don't understand)
        structureGPSSparkfun.headingVehicle = datatable.headVeh; % Heading of vehicle [deg/1e-5]
        structureGPSSparkfun.MagneticDec = datatable.magDec; % # Magnetic declination [deg/1e-2]
        structureGPSSparkfun.MagneticAccuracyEst = datatable.magAcc; % Magnetic declination accuracy [deg 1e-2]
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

