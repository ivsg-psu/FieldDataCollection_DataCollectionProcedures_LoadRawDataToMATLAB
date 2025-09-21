% script_test_fcn_LoadRawDataToMATLAB_determineDataType.m
% tests fcn_LoadRawDataToMATLAB_determineDataType.m

% Revision history
% 2025_09_20 - sbrennan@psu.edu
% -- wrote the code originally using
%    % script_test_fcn_LoadRawDataToMATLAB_determineDataType as a starter

%% Set up the workspace
close all


%% Check assertions for basic path operations and function testing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                              _   _                 
%      /\                     | | (_)                
%     /  \   ___ ___  ___ _ __| |_ _  ___  _ __  ___ 
%    / /\ \ / __/ __|/ _ \ '__| __| |/ _ \| '_ \/ __|
%   / ____ \\__ \__ \  __/ |  | |_| | (_) | | | \__ \
%  /_/    \_\___/___/\___|_|   \__|_|\___/|_| |_|___/
%                                                    
%                                                    
% See: https://patorjk.com/software/taag/#p=display&f=Big&t=Assertions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Basic test - 'Bin1' is 'gps'
topic_name = '/Bin1';
datatype = fcn_LoadRawDataToMATLAB_determineDataType(topic_name);
assert(strcmp(datatype,'gps'));

%% Basic test - 'GPS_fix' is 'gps'
topic_name = '/GPS_fix';
datatype = fcn_LoadRawDataToMATLAB_determineDataType(topic_name);
assert(strcmp(datatype,'gps'));

%% Basic test - 'adis_msg' is 'imu'
topic_name = '/adis_msg';
datatype = fcn_LoadRawDataToMATLAB_determineDataType(topic_name);
assert(strcmp(datatype,'imu'));

%% Basic test - 'adis_press' is 'imu'
topic_name = '/adis_press';
datatype = fcn_LoadRawDataToMATLAB_determineDataType(topic_name);
assert(strcmp(datatype,'imu'))

%% Basic test - 'adis_temp' is 'imu'
topic_name = '/adis_press';
datatype = fcn_LoadRawDataToMATLAB_determineDataType(topic_name);
assert(strcmp(datatype,'imu'))

%% Basic test - 'diagnostic_encoder' is 'diagnostic'
topic_name = '/diagnostic_encoder';
datatype = fcn_LoadRawDataToMATLAB_determineDataType(topic_name);
assert(strcmp(datatype,'diagnostic'))

%% Basic test - 'diagnostic_trigger' is 'diagnostic'
topic_name = '/diagnostic_trigger';
datatype = fcn_LoadRawDataToMATLAB_determineDataType(topic_name);
assert(strcmp(datatype,'diagnostic'))

%% Basic test - 'imu/data' is 'imu'
topic_name = '/imu/data';
datatype = fcn_LoadRawDataToMATLAB_determineDataType(topic_name);
assert(strcmp(datatype,'imu'))

%% Basic test - 'imu/data_raw' is 'imu'
topic_name = '/imu/data_raw';
datatype = fcn_LoadRawDataToMATLAB_determineDataType(topic_name);
assert(strcmp(datatype,'imu'))

%% Basic test - 'imu/mag' is 'imu'
topic_name = '/imu/mag';
datatype = fcn_LoadRawDataToMATLAB_determineDataType(topic_name);
assert(strcmp(datatype,'imu'))

%% Fail conditions
if 1==0
    %% ERROR for ...
end
