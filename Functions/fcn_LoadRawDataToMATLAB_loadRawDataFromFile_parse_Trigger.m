function parseTrigger = fcn_LoadRawDataToMATLAB_loadRawDataFromFile_parse_Trigger(file_path,datatype,fid)

% This function is used to load the raw data collected with the Penn State Mapping Van.
% This is the parse Encoder data, whose data type is imu
% Input Variables:
%      file_path = file path of the parseTrigger data
%      datatype  = the datatype should be trigger
% Returned Results:
%      parseTrigger

% Author: Liming Gao
% Created Date: 2020_11_15
% Modify Date: 2023_06_16
%
% Modified by Xinyu Cao, Aneesh Batchu and Mariam Abdellatief on 2023_06_16
% 
% This function is modified to load the raw data (from file) collected with
% the Penn State Mapping Van.


% Updates:
% As: fcn_DataClean_loadRawDataFromFile_parse_Trigger
% 2023_07_04 sbrennan@psu.edu
% -- fixed return at end of function to be 'end', keeping in function
% format
% -- added fid to fprint to allow printing to file
% -- added entry and exit debugging prints
% -- removed variable clearing at end of function because this is automatic
% 2024_07_03 xfc5113@psu.edu
% -- added modeCount to the struct array
% 2024_07_08 xfc5113@psu.edu
% -- convert mode field from cell array to string array
% 2024_11_18 xfc5113@psu.edu
% -- fix the typo for mode field. (Mode -> mode)
% 2025_09_20: sbrennan@psu.edu
% * In fcn_LoadRawDataToMATLAB_loadRawDataFromFile_parse_Trigger
% -- Renamed function to fcn_LoadRawDataToMATLAB_loadRawDataFromFile_parse_Trigger


flag_do_debug = 0;  % Flag to show the results for debugging
flag_do_plots = 0;  % % Flag to plot the final results
flag_check_inputs = 1; % Flag to perform input checking

if flag_do_debug
    st = dbstack; %#ok<*UNRCH>
    fprintf(fid,'STARTING function: %s, in file: %s\n',st(1).name,st(1).file);
end


if strcmp(datatype,'trigger')
    opts = detectImportOptions(file_path);
    opts.PreserveVariableNames = true;
    datatable = readtable(file_path,opts);
    Npoints = height(datatable);
    parseTrigger = fcn_LoadRawDataToMATLAB_initializeDataByType(datatype,Npoints);

    parseTrigger.mode = datatable.mode;
    time_stamp = (datatable.rosbagTimestamp)*10^-9; % This is rosbag timestamp
    % parseTrigger.GPS_Time                          = secs + nsecs*(10^-9);  % This is the GPS time, UTC, as reported by the unit
    % parseTrigger.Trigger_Time                      = default_value;  % This is the Trigger time, UTC, as calculated by sample
    % parseTrigger.ROS_Time                          = secs + nsecs*(10^-9);  % This is the ROS time that the data arrived into the bag
    parseTrigger.ROS_Time  = time_stamp;
    parseTrigger.centiSeconds                      = 100;  % This is the hundreth of a second measurement of sample period (for example, 20 Hz = 5 centiseconds)
    % parseTrigger.Npoints                           = height(datatable);  % This is the number of data points in the array
    mode_cell = datatable.mode;  
    mode_string = string(mode_cell);
    mode_string_clean = erase(mode_string,"''");
    mode_string_clean = erase(mode_string_clean,"""");
    parseTrigger.mode                              = mode_string_clean;     % This is the mode of the trigger box (I: Startup, X: Freewheeling, S: Syncing, L: Locked)
    parseTrigger.modeCount                         = datatable.mode_counts; % This is the count of the Locked mode (empty for other mode)
    parseTrigger.adjone                            = datatable.adjone;   % This is phase adjustment magnitude relative to the calculated period of the output pulse
    parseTrigger.adjtwo                            = datatable.adjtwo;   % This is phase adjustment magnitude relative to the calculated period of the output pulse
    parseTrigger.adjthree                          = datatable.adjthree; % This is phase adjustment magnitude relative to the calculated period of the output pulse
    % Data below are error monitoring messages
    parseTrigger.err_failed_mode_count             = datatable.err_failed_mode_count;
    parseTrigger.err_failed_XI_format              = datatable.err_failed_XI_format;
    parseTrigger.err_failed_checkInformation       = datatable.err_failed_checkInformation;
    parseTrigger.err_trigger_unknown_error_occured = datatable.err_trigger_unknown_error_occured;
    parseTrigger.err_bad_uppercase_character       = datatable.err_bad_uppercase_character;
    parseTrigger.err_bad_lowercase_character       = datatable.err_bad_lowercase_character;
    parseTrigger.err_bad_three_adj_element         = datatable.err_bad_three_adj_element;
    parseTrigger.err_bad_first_element             = datatable.err_bad_first_element;
    parseTrigger.err_bad_character                 = datatable.err_bad_character;
    parseTrigger.err_wrong_element_length          = datatable.err_wrong_element_length;

else
    error('Wrong data type requested: %s',dataType)
end



% Close out the loading process
if flag_do_debug
    fprintf(1,'ENDING function: %s, in file: %s\n\n',st(1).name,st(1).file);
end

end
