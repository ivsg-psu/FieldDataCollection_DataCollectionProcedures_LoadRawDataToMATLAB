function Hemisphere_DGPS = fcn_LoadRawDataToMATLAB_loadRawDataFromFile_Hemisphere(file_path,datatype,fid)

% This function is used to load the raw data collected with the Penn State Mapping Van.
% This is the Hemisphere GPS data, whose data type is gps

% Input Variables:
%      file_path = file path of the Sick Lidar data (format txt)
%      datatype  = the datatype should be lidar2d
% Returned Results:
%      Hemisphere_DGPS
% Author: Liming Gao

% Created Date: 2020_11_15

% Revisions:
% As: fcn_DataClean_loadRawDataFromFile_Hemisphere
% 2023_06_16 by Xinyu Cao, Aneesh Batchu and Mariam Abdellatief
% -- Edited for new GPS systems (Sparkfun)
% 2023_006_25 by Sean Brennan
% -- Fixed centiSeconds to 5, not 10, to agree with the data.
% 2023_07_04 sbrennan@psu.edu
% -- fixed return at end of function to be 'end', keeping in function
% format
% -- added fid to fprint to allow printing to file
% 2025_09_20: sbrennan@psu.edu
% * In fcn_LoadRawDataToMATLAB_loadRawDataFromFile_Hemisphere
% -- Renamed function to fcn_LoadRawDataToMATLAB_loadRawDataFromFile_Hemisphere


% This function is modified to load the raw data (from file) collected with
% the Penn State Mapping Van.
%
% Updates:
%
% To do lists:
% 
% Reference:
% To be added


flag_do_debug = 0;  % Flag to show the results for debugging
flag_do_plots = 0;  % % Flag to plot the final results
flag_check_inputs = 1; % Flag to perform input checking

if flag_do_debug
    st = dbstack; %#ok<*UNRCH>
    fprintf(1,'STARTING function: %s, in file: %s\n',st(1).name,st(1).file);
end


%%

% the field name from mat_file is different from database, so we process
% them seperately
% Unknown value are remained as default_value = NaN


if strcmp(datatype,'gps')
    opts = detectImportOptions(file_path);
    opts.PreserveVariableNames = true;
    datatable = readtable(file_path,opts);
    Npoints = height(datatable);
    Hemisphere_DGPS = fcn_LoadRawDataToMATLAB_initializeDataByType(datatype,Npoints);
    
    secs = datatable.secs;
    nsecs = datatable.nsecs;
    Hemisphere_DGPS.StdDevResid = datatable.StdDevResid;
    Hemisphere_DGPS.GPS_Time           = secs+nsecs*10^-9;  % This is the GPS time, UTC, as reported by the unit
    % data_structure.Trigger_Time       = default_value;  % This is the Trigger time, UTC, as calculated by sample
    Hemisphere_DGPS.ROS_Time           = datatable.rosbagTimestamp;  % This is the ROS time that the data arrived into the bag
    Hemisphere_DGPS.centiSeconds       = 5;  % This is the hundreth of a second measurement of sample period (for example, 20 Hz = 5 centiseconds)
    % Hemisphere_DGPS.Npoints            = Npoints;  % This is the number of data points in the array
    Hemisphere_DGPS.Latitude           = datatable.Latitude;  % The latitude [deg]
    Hemisphere_DGPS.Longitude          = datatable.Longitude;  % The longitude [deg]
    Hemisphere_DGPS.Altitude           = datatable.Height;  % The altitude above sea level [m]
    % Hemisphere_DGPS_LLA = [data_structure.Latitude, data_structure.Longitude, data_structure.Altitude];
    % Hemisphere_DGPS_xyz = lla2enu(Hemisphere_DGPS_LLA,TestTrack_base_lla, 'ellipsoid');
    % Hemisphere_DGPS.xEast              = default_value;  % The xEast value (ENU) [m]
    % Hemisphere_DGPS.xEast_Sigma        = default_value;  % Sigma in xEast [m]
    % Hemisphere_DGPS.yNorth             = default_value;  % The yNorth value (ENU) [m]
    % Hemisphere_DGPS.yNorth_Sigma       = default_value;  % Sigma in yNorth [m]
    % Hemisphere_DGPS.zUp                = default_value;  % The zUp value (ENU) [m]
    % Hemisphere_DGPS.zUp_Sigma          = default_value;  % Sigma in zUp [m]
    Hemisphere_DGPS.velNorth           = datatable.VNorth;  % Velocity in north direction (ENU) [m/s]
    % Hemisphere_DGPS.velNorth_Sigma     = default_value;  % Sigma in velNorth [m/s]
    Hemisphere_DGPS.velEast            = datatable.VEast;  % Velocity in east direction (ENU) [m/s]
    % Hemisphere_DGPS.velEast_Sigma      = default_value;  % Sigma in velEast [m/s]
    Hemisphere_DGPS.velUp              = datatable.VUp;  % Velocity in up direction (ENU) [m/s]
    % Hemisphere_DGPS.velUp_Sigma        = default_value;  % Velocity in up direction (ENU) [m/s]
    % Hemisphere_DGPS.velMagnitude       = default_value;  % Velocity magnitude (ENU) [m/s]
    % Hemisphere_DGPS.velMagnitude_Sigma = default_value;  % Sigma in velMagnitude [m/s]
    Hemisphere_DGPS.numSatellites      = datatable.NumOfSats;  % Number of satelites visible
    Hemisphere_DGPS.DGPS_mode          = datatable.NavMode;  % Mode indicating DGPS status (for example, navmode 6;
    % Hemisphere_DGPS.Roll_deg           = default_value;  % Roll (angle about X) in degrees, ISO coordinates
    % Hemisphere_DGPS.Roll_deg_Sigma     = default_value;  % Sigma in Roll
    % Hemisphere_DGPS.Pitch_deg          = default_value;  % Pitch (angle about y) in degrees, ISO coordinates
    % Hemisphere_DGPS.Pitch_deg_Sigma    = default_value;  % Sigma in Pitch
    % Hemisphere_DGPS.Yaw_deg            = default_value;  % Yaw (angle about z) in degrees, ISO coordinates
    % Hemisphere_DGPS.Yaw_deg_Sigma      = default_value;  % Sigma in Yaw
    % Hemisphere_DGPS.OneSigmaPos        = default_value;  % Sigma in position
    % Hemisphere_DGPS.HDOP                = default_value; % DOP in horizontal position (ratio, usually close to 1, smaller is better)
    Hemisphere_DGPS.AgeOfDiff          = datatable.AgeOfDiff;

else
    error('Wrong data type requested: %s',dataType)
end

% Close out the loading process
if flag_do_debug
    fprintf(1,'ENDING function: %s, in file: %s\n\n',st(1).name,st(1).file);
end

end
