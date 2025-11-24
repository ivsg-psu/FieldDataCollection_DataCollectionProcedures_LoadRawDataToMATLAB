function rawData  = fcn_LoadRawDataToMATLAB_loadMappingVanDataFromFile(bagFolderString, Identifiers, varargin)
% fcn_LoadRawDataToMATLAB_loadMappingVanDataFromFile
% imports raw data from mapping van bag files, and
% if a figure number is given, plots a summary
%
% FORMAT:
%
%      rawData = fcn_LoadRawDataToMATLAB_loadMappingVanDataFromFile(...
%      bagFolderString, Identifiers, (bagName), (fid), (Flags), (figNum))
%
% INPUTS:
%
%      bagFolderString: the folder name where the bag files are located as a
%      sub-directory
%
%      Identifiers: a required structure indicating the labels to attach to
%      the files that are being loaded. The Identifiers structure has
%      the following format:
%
%             clear Identifiers
%             Identifiers.Project = 'PennDOT ADS Workzones'; % This is the project sponsoring the data collection
%             Identifiers.ProjectStage = 'OnRoad'; % Can be 'Simulation', 'TestTrack', or 'OnRoad'
%             Identifiers.WorkZoneScenario = 'I376ParkwayPitt'; % Can be one of the ~20 scenarios, see key
%             Identifiers.WorkZoneDescriptor = 'WorkInRightLaneOfUndividedHighway'; % Can be one of the 20 descriptors, see key
%             Identifiers.Treatment = 'BaseMap'; % Can be one of 9 options, see key
%             Identifiers.DataSource = 'MappingVan'; % Can be 'MappingVan', 'AV', 'CV2X', etc. see key
%             Identifiers.AggregationType = 'PreRun'; % Can be 'PreCalibration', 'PreRun', 'Run', 'PostRun', or 'PostCalibration'
%             Identifiers.SourceBagFileName =''; % This is filled in automatically for each file
%
%      For a list of allowable Identifiers, see:
%      https://github.com/ivsg-psu/FieldDataCollection_VisualizingFieldData_LoadWorkZone
%
%      (OPTIONAL INPUTS)
%
%      bagName: the specific name of the bag file, for example:
%      "mapping_van_2024-07-10-19-36-59_3.bag". If within the name, the
%      extension ".bag" is dropped when naming the image output. If the
%      bagName is given as an empty input, e.g. [], then the entire
%      bagFolderString is queried for all bagNames.
%
%      fid: the fileID where to print. Default is 1 which print results to
%      the console.
%
%      Flags: a structure containing key flags to set the process. The
%      defaults, and explanation of each, are below:
%
%           Flags.flag_do_load_sick = 0; % Loads the SICK LIDAR data
%           Flags.flag_do_load_velodyne = 0; % Loads the Velodyne LIDAR
%           Flags.flag_do_load_cameras = 0; % Loads camera images
%           Flags.flag_select_scan_duration = 0; % Lets user specify scans from Velodyne
%           Flags.flag_do_load_GST = 0; % Load GPS GST sentence
%           Flags.flag_do_load_VTG = 0; % Load GPS VTG sentence
%
%      figNum: a figure number to plot results. If set to -1, skips any
%      input checking or debugging, no figures will be generated, and sets
%      up code to maximize speed.
%
% OUTPUTS:
%
%      rawData: a  data structure containing data fields filled for each
%      ROS topic. If multiple bag files are specified, a cell array of data
%      structures is returned.
%
% DEPENDENCIES:
%
%      fcn_DebugTools_checkInputsToFunctions
%
% EXAMPLES:
%
%     See the script: script_test_fcn_LoadRawDataToMATLAB_loadMappingVanDataFromFile
%     for a full test suite.
%
% This function was written on 2025_09_19 by S. Brennan
% Questions or comments? sbrennan@psu.edu

% REVISION HISTORY
%
% As: fcn_DataClean_loadMappingVanDataFromFile
%
% 2023_06_19 - Xinyu Cao,
% - The main part of the code will be
%   % functionalized as the function fcn_DataClean_loadrawDataFromFile The
%   % result of the code will be a structure store raw data from bag file
%
% 2023_06_19 by Sean Brennan, sbrennan@psu.edu
% - First functionalization of the code
%
% 2023_06_22 by Sean Brennan, sbrennan@psu.edu
% - Fixed fcn_DataClean_loadRawDataFromFile_SickLidar filename
% - To correct: fcn_DataClean_loadRawDataFromFile_sickLIDAR
%
% 2023_06_22 by Sean Brennan, sbrennan@psu.edu
% AGAIN - someone reverted the edits
% - Fixed fcn_DataClean_loadRawDataFromFile_SickLidar filename
% - To correct: fcn_DataClean_loadRawDataFromFile_sickLIDAR
%
% 2023_06_26 - X. Cao
% - Modified fcn_DataClean_loadRawDataFromFile_Diagnostic
% - The old diagnostic topics 'diagnostic_trigger' and
%   % 'diagnostic_encoder' are replaced with 'Trigger_diag' and 'Encoder_diag'
% - modified fcn_DataClean_loadRawDataFromFile_SparkFun_GPS
% - each sparkfun gps has three topics, sparkfun_gps_GGA, sparkfun_gps_VTG
% and sparkfun_gps_GST.
%
% 2023_07_04 by Sean Brennan, sbrennan@psu.edu
% - Added FID to fprint to allow printing to file
% - Moved loading print statements to this file, not subfiles
%
% 2023_07_02 - X. Cao
% - Added varagin to choose whether load LiDAR data
%
% 2024_08_29 by Sean Brennan, sbrennan@psu.edu
% - Added debug headers
% - Added varagin for the FID input
% - Added figNum input (to allow max_speed mode)
% - Fixed input argument checking area to be more clean
%
% 2024_09_05 by Sean Brennan, sbrennan@psu.edu
% - Added automated image summary output
%
% 2024_09_06 by Sean Brennan, sbrennan@psu.edu
% - Moved image output back out of the code
% - Added subPathStrings output
%
% 2024_09_27 by Sean Brennan, sbrennan@psu.edu
% - Fixed bad sensor names during loading
%
% 2024_10_10 - X. Cao
% - Add flag_do_load_GST and flag_do_load_VTG to let user decide whether they want to
%   % load GPS GST and VTG sentences
% - Comment out load cameras functions, still need to be tested
%
% 2024_10_28 - X. Cao
% - Add load IMU_Ouster_Front to the function
%
% 2025_09_20 by Sean Brennan, sbrennan@psu.edu
% * In fcn_LoadRawDataToMATLAB_loadMappingVanDataFromFile
% - Renamed function to fcn_LoadRawDataToMATLAB_initializeDataByType
% - Cleaned up docstrings in header
%
% 2025_11_23 by Sean Brennan, sbrennan@psu.edu
% - Corrected script name
% - Fixed rev history to be Markdown format
% - Added TO+-DO list
% - Renamed variables for clarity
%   % * from topic_+name to topicName


% TO-DO:
%
% 2025_11_23 by Sean Brennan, sbrennan@psu.edu
% - (add items here)



%% Debugging and Input checks
% Check if flag_max_speed set. This occurs if the figNum variable input
% argument (varargin) is given a number of -1, which is not a valid figure
% number.
MAX_NARGIN = 6; % The largest Number of argument inputs to the function
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
        narginchk(2,MAX_NARGIN);

        % Check if bagFolderString is a directory. If directory is not there, warn
        % the user.
        try
            fcn_DebugTools_checkInputsToFunctions(bagFolderString, 'DoesDirectoryExist');
        catch ME
            warning(['It appears that data was not pushed into a folder ' ...
                'that was not found. Typically, the data is located in: ' ...
                '\\LoadRawDataToMATLAB\LargeData ' ...
                'which is the folder where large data is imported for processing. ' ...
                'Note that this folder is too large to include in the code repository, ' ...
                'so it must be copied over from a data storage location. Within IVSG, ' ...
                'this storage location is the OndeDrive folder called GitHubMirror.']);
            rethrow(ME)
        end

    end
end


% Does user want to specify bagName?
bagName = [];
if 3 <= nargin
    temp = varargin{1};
    if ~isempty(temp)
        bagName = temp;
    end
end

% Does user want to specify fid?
fid = 1;
if 4 <= nargin
    temp = varargin{2};
    if ~isempty(temp)
        fid = temp;
    end
end

% Does user specify Flags?
% Set defaults
Flags.flag_do_load_SICK = 0;
Flags.flag_do_load_Velodyne = 0;
Flags.flag_do_load_cameras = 0;
Flags.flag_select_scan_duration = 0;
Flags.flag_do_load_GST = 0;
Flags.flag_do_load_VTG = 0;

if 5 <= nargin
    temp = varargin{3};
    if ~isempty(temp)
        Flags = temp;

        % try
        %     temp = Flags.flag_select_scan_duration; %#ok<NASGU>
        % catch
        %     prompt = "Do you want to load the LiDAR scan for the entire route? y/n [y]";
        %     user_input_txt = input(prompt,"s");
        %     if isempty(user_input_txt)
        %         user_input_txt = 'y';
        %     end
        %     if strcmp(user_input_txt,'y')
        %         Flags.flag_select_scan_duration = 0;
        %     else
        %         Flags.flag_select_scan_duration = 1;
        %     end
        % end
    end
end


% Does user want to show the plots?
flag_do_plots = 0; % Default is to NOT show plots
if (0==flag_max_speed) && (MAX_NARGIN == nargin)
    temp = varargin{end};
    if ~isempty(temp)
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

rawData = fcn_INTERNAL_readRawDataFromFolder(bagFolderString, fid, Flags);
if strcmp(bagFolderString(end),filesep)
    bagFolderStringCorrect = bagFolderString(1:end-1);
else
    bagFolderStringCorrect = bagFolderString;
end

% Grab the data's name
folderNames = split(bagFolderStringCorrect,filesep);
Identifiers.SourceBagFileName = folderNames{end};
rawData.Identifiers = Identifiers;

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

    % Plot the base station
    fcn_plotRoad_plotLL([],[],figNum);

    % % Test the function
    % clear plotFormat
    % plotFormat.LineStyle = '-';
    % plotFormat.LineWidth = 2;
    % plotFormat.Marker = 'none';
    % plotFormat.MarkerSize = 5;
    % plotFormat.Color = fcn_geometry_fillColorFromNumberOrName(2);


    fcn_LoadRawDataToMATLAB_plotRawData(rawData, (bagName), ([]), ([]), (figNum))
    h_legend = legend('Base station',bagName);
    set(h_legend,'Interpreter','none')

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

% fcn_INTERNAL_readRawDataFromFolder
function rawData = fcn_INTERNAL_readRawDataFromFolder(bagFolderString, fid, Flags)

flag_do_load_SICK = Flags.flag_do_load_SICK;
flag_do_load_Velodyne = Flags.flag_do_load_Velodyne;
flag_do_load_cameras = Flags.flag_do_load_cameras; %#ok<NASGU>
flag_select_scan_duration = Flags.flag_select_scan_duration;
flag_do_load_GST = Flags.flag_do_load_GST;
flag_do_load_VTG = Flags.flag_do_load_VTG;

% Grab the list of files in this directory
file_list = dir(bagFolderString);
num_files = length(file_list);

% Initialize an empty structure
rawData = struct;

if 1==fid
    fprintf(fid,'Loading data from files from folder: \n\t%s\n',bagFolderString);
end

% Search the contents of the directory for data files, creating a 'sensor'
% for each.
%    Sensor names must follow the format:
%
%        TYPE_Manufacturer_Location
%
%    where
%        TYPES allowed include: 'GPS','ENCODER','IMU','TRIGGER','NTRIP','LIDAR','TRANSFORM','DIAGNOSTIC','IDENTIFIERS'
%        Locations allowed include: Rear, Front, Top, Right, Left, Center

for file_idx = 1:num_files

    % Check that the list is the file. If it is a directory, the isdir flag
    % will be 1.
    if file_list(file_idx).isdir ~= 1
        % Get the file name
        thisFileName = file_list(file_idx).name;

        % Remove the extension?
        file_name_noext = extractBefore(thisFileName,'.');

        topicName = strrep(file_name_noext,'_slash_','/');


        % Find the type of data for this topic
        datatype = fcn_LoadRawDataToMATLAB_determineDataType(topicName);

        % Tell the user what we are doing
        if 1==fid
            fprintf(fid,'\t Loading file: %s, with topic name: %s, with datatype: %s \n',thisFileName, topicName,datatype);
        end

        thisFullFIlePath = fullfile(bagFolderString,thisFileName);
        % topic name is used to decide the sensor
        %         topic sicm_lms500/sick_time

        if (any([contains(topicName,'sick_lms500/scan') contains(topicName,'sick_lms_5xx/scan')])) && flag_do_load_SICK
            error('Need to add test case')
            SickLiDAR = fcn_LoadRawDataToMATLAB_loadRawFromFile_LidarSICK(thisFullFIlePath,datatype,fid);
            rawData.Lidar_Sick_Rear = SickLiDAR;
            % disp('Ignore for 2023-11-15')

        elseif contains(topicName, 'Bin1')
            error('Need to add test case')
            Hemisphere_DGPS = fcn_LoadRawDataToMATLAB_loadRawDataFromFile_Hemisphere(thisFullFIlePath,datatype,fid);
            rawData.GPS_Hemisphere_SensorPlatform = Hemisphere_DGPS;

        elseif contains(topicName, 'GPS_Novatel')
            error('Need to add test case')
            GPS_Novatel = fcn_LoadRawDataToMATLAB_loadRawDataFromFile_Novatel_GPS(thisFullFIlePath,datatype,fid);
            rawData.GPS_Novatel_SensorPlatform = GPS_Novatel;

        elseif contains(topicName, 'Garmin_GPS')
            error('Need to add test case')
            GPS_Garmin = fcn_LoadRawDataToMATLAB_loadRawDataFromFile_Garmin_GPS(thisFullFIlePath,datatype,fid);
            rawData.GPS_Garmin_TopCenter = GPS_Garmin;

        elseif contains(topicName, 'Novatel_IMU')
            error('Need to add test case')
            Novatel_IMU = fcn_LoadRawDataToMATLAB_loadRawDataFromFile_IMU_Novatel(thisFullFIlePath,datatype,fid);
            rawData.IMU_Novatel_TopCenter = Novatel_IMU;

        elseif contains(topicName, 'parseEncoder')
            parseEncoder = fcn_LoadRawDataToMATLAB_loadRawFromFile_Encoder(thisFullFIlePath,datatype,fid);
            rawData.Encoder_Raw = parseEncoder;

        elseif contains(topicName, 'imu/data_raw')
            error('Need to add test case')
            adis_IMU_dataraw = fcn_LoadRawDataToMATLAB_loadRawDataFromFile_IMU_ADIS(thisFullFIlePath,datatype,fid,topicName);
            rawData.IMU_adis_dataraw = adis_IMU_dataraw;

        elseif contains(topicName, 'imu/rpy/filtered')
            error('Need to add test case')
            adis_IMU_filtered_rpy = fcn_LoadRawDataToMATLAB_loadRawDataFromFile_IMU_ADIS(thisFullFIlePath,datatype,fid,topicName);
            rawData.IMU_adis_filtered_rpy = adis_IMU_filtered_rpy;

        elseif contains(topicName, 'imu/data')
            error('Need to add test case')
            adis_IMU_data = fcn_LoadRawDataToMATLAB_loadRawDataFromFile_IMU_ADIS(thisFullFIlePath,datatype,fid,topicName);
            rawData.IMU_adis_data = adis_IMU_data;

        elseif contains(topicName, 'imu/mag')
            error('Need to add test case')
            adis_IMU_mag = fcn_LoadRawDataToMATLAB_loadRawDataFromFile_IMU_ADIS(thisFullFIlePath,datatype,fid,topicName);
            rawData.IMU_adis_mag = adis_IMU_mag;

        elseif contains(topicName, 'adis_msg')
            error('Need to add test case')
            adis_msg = fcn_LoadRawDataToMATLAB_loadRawDataFromFile_ADIS(thisFullFIlePath,datatype,fid,topicName);
            rawData.adis_msg = adis_msg;

        elseif contains(topicName, 'adis_temp')
            error('Need to add test case')
            adis_temp = fcn_LoadRawDataToMATLAB_loadRawDataFromFile_ADIS(thisFullFIlePath,datatype,fid,topicName);
            rawData.adis_temp = adis_temp;

        elseif contains(topicName, 'adis_press')
            error('Need to add test case')
            adis_press = fcn_LoadRawDataToMATLAB_loadRawDataFromFile_ADIS(thisFullFIlePath,datatype,fid,topicName);
            rawData.adis_press = adis_press;

        elseif contains(topicName,'parseTrigger')
            parseTrigger = fcn_LoadRawDataToMATLAB_loadRawFromFile_Trigger(thisFullFIlePath,datatype,fid);
            rawData.Trigger_Raw = parseTrigger;

        elseif contains(topicName, 'GPS_SparkFun_RearLeft_GGA')
            SparkFun_GPS_RearLeft_GGA = fcn_LoadRawDataToMATLAB_loadRawFromFile_GPSSparkfun(thisFullFIlePath, datatype,topicName, fid);
            rawData.GPS_SparkFun_LeftRear_GGA = SparkFun_GPS_RearLeft_GGA;

        elseif contains(topicName, 'GPS_SparkFun_RearLeft_VTG') && flag_do_load_VTG
            error('Need to add test case')
            SparkFun_GPS_RearLeft_VTG = fcn_LoadRawDataToMATLAB_loadRawFromFile_GPSSparkfun(thisFullFIlePath, datatype,topicName, fid);
            rawData.Velocity_Estimate_SparkFun_LeftRear = SparkFun_GPS_RearLeft_VTG;

        elseif contains(topicName, 'GPS_SparkFun_RearLeft_GST') && flag_do_load_GST
            error('Need to add test case')
            SparkFun_GPS_RearLeft_GST = fcn_LoadRawDataToMATLAB_loadRawFromFile_GPSSparkfun(thisFullFIlePath, datatype,topicName, fid);
            rawData.GPS_SparkFun_LeftRear_GST = SparkFun_GPS_RearLeft_GST;

        elseif contains(topicName, 'GPS_SparkFun_RearLeft_PVT')
            error('Need to add test case')
            SparkFun_GPS_RearLeft_PVT = fcn_LoadRawDataToMATLAB_loadRawFromFile_GPSSparkfun(thisFullFIlePath, datatype,topicName, fid);
            rawData.GPS_SparkFun_LeftRear_PVT = SparkFun_GPS_RearLeft_PVT;

        elseif contains(topicName, 'GPS_SparkFun_RearRight_GGA')
            sparkfun_gps_rear_right_GGA = fcn_LoadRawDataToMATLAB_loadRawFromFile_GPSSparkfun(thisFullFIlePath, datatype,topicName, fid);
            rawData.GPS_SparkFun_RightRear_GGA = sparkfun_gps_rear_right_GGA;

        elseif contains(topicName, 'GPS_SparkFun_RearRight_VTG') && flag_do_load_VTG
            error('Need to add test case')
            sparkfun_gps_rear_right_VTG = fcn_LoadRawDataToMATLAB_loadRawFromFile_GPSSparkfun(thisFullFIlePath, datatype,topicName, fid);
            rawData.Velocity_Estimate_SparkFun_RightRear  = sparkfun_gps_rear_right_VTG;

        elseif contains(topicName, 'GPS_SparkFun_RearRight_GST') && flag_do_load_GST
            error('Need to add test case')
            sparkfun_gps_rear_right_GST = fcn_LoadRawDataToMATLAB_loadRawFromFile_GPSSparkfun(thisFullFIlePath, datatype,topicName, fid);
            rawData.GPS_SparkFun_RightRear_GST = sparkfun_gps_rear_right_GST;

        elseif contains(topicName, 'GPS_SparkFun_RearRight_PVT')
            error('Need to add test case')
            SparkFun_GPS_RearRight_PVT = fcn_LoadRawDataToMATLAB_loadRawFromFile_GPSSparkfun(thisFullFIlePath, datatype,topicName, fid);
            rawData.GPS_SparkFun_RightRear_PVT = SparkFun_GPS_RearRight_PVT;

        elseif contains(topicName, 'Trigger_diag')           
            diagnostic_trigger = fcn_LoadRawDataToMATLAB_loadRawFromFile_Diagnostic(thisFullFIlePath,datatype,topicName, fid);
            rawData.Diag_Trigger = diagnostic_trigger;

        elseif contains(topicName, 'Encoder_diag')
            diagnostic_encoder = fcn_LoadRawDataToMATLAB_loadRawFromFile_Diagnostic(thisFullFIlePath,datatype,topicName, fid);
            rawData.Diag_Encoder = diagnostic_encoder;

        elseif contains(topicName, 'GPS_SparkFun_Front_GGA')
            SparkFun_GPS_Front_GGA = fcn_LoadRawDataToMATLAB_loadRawFromFile_GPSSparkfun(thisFullFIlePath, datatype,topicName, fid);
            rawData.GPS_SparkFun_Front_GGA = SparkFun_GPS_Front_GGA;

        elseif contains(topicName, 'GPS_SparkFun_Front_PVT')
            error('Need to test')
            SparkFun_GPS_Front_PVT = fcn_LoadRawDataToMATLAB_loadRawFromFile_GPSSparkfun(thisFullFIlePath, datatype,topicName, fid);
            rawData.GPS_SparkFun_Front_PVT = SparkFun_GPS_Front_PVT;

        elseif contains(topicName, 'GPS_SparkFun_Front_VTG') && flag_do_load_VTG
            error('Need to test')
            SparkFun_GPS_Front_VTG = fcn_LoadRawDataToMATLAB_loadRawFromFile_GPSSparkfun(thisFullFIlePath, datatype,topicName, fid);
            rawData.Velocity_Estimate_SparkFun_Front = SparkFun_GPS_Front_VTG;

        elseif contains(topicName, 'GPS_SparkFun_Front_GST') && flag_do_load_GST
            error('Need to test')
            SparkFun_GPS_Front_GST = fcn_LoadRawDataToMATLAB_loadRawFromFile_GPSSparkfun(thisFullFIlePath, datatype,topicName, fid);
            rawData.GPS_SparkFun_Front_GST = SparkFun_GPS_Front_GST;

        elseif contains(topicName, 'GPS_SparkFun_Temp_GGA')
            error('Need to test')
            SparkFun_GPS_Temp_GGA = fcn_LoadRawDataToMATLAB_loadRawFromFile_GPSSparkfun(thisFullFIlePath, datatype,topicName, fid);
            rawData.GPS_SparkFun_Temp_GGA = SparkFun_GPS_Temp_GGA;

            %             elseif contains(topicName, 'DIAG_SparkFun_RearLeft')
            %                 sparkfun_gps_diag_rear_left = fcn_LoadRawDataToMATLAB_loadRawFromFile_Diagnostic(thisFullFIlePath,datatype,topicName, fid);
            %                 rawData.Diag_GPS_SparkFun_LeftRear = sparkfun_gps_diag_rear_left;
            %
            %             elseif contains(topicName, 'DIAG_SparkFun_RearRight')
            %                 sparkfun_gps_diag_rear_right = fcn_LoadRawDataToMATLAB_loadRawFromFile_Diagnostic(thisFullFIlePath,datatype,topicName, fid);
            %                 rawData.Diag_GPS_SparkFun_RightRear = sparkfun_gps_diag_rear_right;


            %             elseif contains(topicName,'ntrip_info')
            %                 ntrip_info = fcn_LoadRawDataToMATLAB_loadRawDataFromFile_NTRIP(full_file_path,datatype,fid);
            %                 rawData.ntrip_info = ntrip_info;
            %           Comment out due to format error with detectImportOptions
            %             elseif (contains(topicName,'rosout') && ~contains(topicName,'agg'))
            %
            %                 ROSOut = fcn_LoadRawDataToMATLAB_loadRawDataFromFile_ROSOut(full_file_path,datatype,fid);
            %                 rawData.ROSOut = ROSOut;

        elseif contains(topicName,'tf')
            error('Need to test')
            transform_struct = fcn_LoadRawDataToMATLAB_loadRawDataFromFile_Transform(thisFullFIlePath,datatype,fid);
            rawData.Transform = transform_struct;

        elseif (contains(topicName,'velodyne_packets')) && (flag_do_load_Velodyne)
            error('Need to test')
            if flag_select_scan_duration
                Velodyne_lidar_struct = fcn_LoadRawDataToMATLAB_loadRawDataFromFile_velodyneLIDAR(thisFullFIlePath,datatype,fid,flag_select_scan_duration);
            else
                Velodyne_lidar_struct = fcn_LoadRawDataToMATLAB_loadRawDataFromFile_velodyneLIDAR(thisFullFIlePath,datatype,fid);
            end


            rawData.Lidar_Velodyne_Rear = Velodyne_lidar_struct;

        elseif (contains(topicName,'ousterO1/imu'))
            error('Need to test')
            ousterOS1_imu_struct = fcn_LoadRawDataToMATLAB_loadRawDataFromFile_IMU_Ouster(thisFullFIlePath,datatype,fid);
            rawData.IMU_Ouster_Front = ousterOS1_imu_struct;

            %
            %
            % elseif contains(topicName,'/rear_left_camera/image_rect_color/compressed') && (flag_do_load_cameras)
            %     rear_left_camera_folder = 'images/rear_left_camera/';
            %     Camera_Rear_Left_struct = fcn_LoadRawDataToMATLAB_loadRawDataFromFile_Cameras(file_path,datatype,fid);
            %     rawData.Camera_Rear_Left = Camera_Rear_Left_struct;
            %
            % elseif contains(topicName,'/rear_center_camera/image_rect_color/compressed') && (flag_do_load_cameras)
            %     rear_center_camera_folder = 'images/rear_center_camera/';
            %     Camera_Rear_Center_struct = fcn_LoadRawDataToMATLAB_loadRawDataFromFile_Cameras(file_path,datatype,fid);
            %     rawData.Camera_Rear_Center = Camera_Rear_Center_struct;
            %
            % elseif contains(topicName,'/rear_right_camera/image_rect_color/compressed') && (flag_do_load_cameras)
            %     rear_right_camera_folder = 'images/rear_right_camera/';
            %     Camera_Rear_Right_struct = fcn_LoadRawDataToMATLAB_loadRawDataFromFile_Cameras(file_path,datatype,fid);
            %     rawData.Camera_Rear_Right = Camera_Rear_Right_struct;
            %
            % elseif contains(topicName,'/front_left_camera/image_rect_color/compressed') && (flag_do_load_cameras)
            %     front_left_camera_folder = 'images/front_left_camera/';
            %     Camera_Front_Left_struct = fcn_LoadRawDataToMATLAB_loadRawDataFromFile_Cameras(file_path,datatype,fid);
            %     rawData.Camera_Front_Left = Camera_Front_Left_struct;
            %
            % elseif contains(topicName,'/front_center_camera/image_rect_color/compressed') && (flag_do_load_cameras)
            %     front_center_camera_folder = 'images/front_center_camera/';
            %     Camera_Front_Center_struct = fcn_LoadRawDataToMATLAB_loadRawDataFromFile_Cameras(file_path,datatype,fid);
            %     rawData.Camera_Front_Center = Camera_Front_Center_struct;
            %
            % elseif contains(topicName,'/front_right_camera/image_rect_color/compressed') && (flag_do_load_cameras)
            %     front_right_camera_folder = 'images/front_right_camera/';
            %     Camera_Front_Right_struct = fcn_LoadRawDataToMATLAB_loadRawDataFromFile_Cameras(file_path,datatype,fid);
            %     rawData.Camera_Front_Right = Camera_Front_Right_struct;


        else
            if 1==fid
                fprintf(fid,'\t\tWARNING: Topic not processed: %s\n',topicName);
            end

        end
    end % Ends check if the directory list is a file
end % Ends loop through directory list

end % fcn_INTERNAL_readRawDataFromFolder

