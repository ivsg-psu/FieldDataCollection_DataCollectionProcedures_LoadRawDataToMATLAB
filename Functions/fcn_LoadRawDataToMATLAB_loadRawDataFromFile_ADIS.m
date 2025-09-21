function IMU_data_structure = fcn_LoadRawDataToMATLAB_loadRawDataFromFile_ADIS(file_path,datatype,fid,topic_name)

% This function is used to load the raw data collected with the Penn State Mapping Van.
% This is the parse Adis IMU data, whose data type is ins
% Input Variables:
%      file_path = file path of the IMU data
%      datatype  = the datatype should be imu
% Returned Results:
%      IMU_data_structure

% Author: Liming Gao
% Created Date: 2020_11_15
% Modify Date: 2023_06_16
%
% Modified by Xinyu Cao, Aneesh Batchu and Mariam Abdellatief on 2023_06_16
% 
% This function is modified to load the raw data (from file) collected with
% the Penn State Mapping Van.


% Updates:
% As: fcn_DataClean_loadRawDataFromFile_ADIS
% 2023_06_22 sbrennan@psu.edu
% -- fixed type error for imu (it was listed as ins, which is deprecated)
% -- fixed error in datatype (typo in variable name)
% 2023_07_04 sbrennan@psu.edu
% -- fixed return at end of function to be 'end', keeping in function
% format
% -- added fid to fprint to allow printing to file
% 2025_09_20: sbrennan@psue.edu
% * In fcn_LoadRawDataToMATLAB_loadRawDataFromFile_ADIS
% -- Renamed function to fcn_LoadRawDataToMATLAB_loadRawDataFromFile_ADIS


% To do lists:
% -- Need test script to catch errors
% -- Need to functionalize code into standard form
% 
% Reference:
% 



flag_do_debug = 0;  % Flag to show the results for debugging
flag_do_plots = 0;  % % Flag to plot the final results
flag_check_inputs = 1; % Flag to perform input checking

if flag_do_debug
    st = dbstack; %#ok<*UNRCH>
    fprintf(1,'STARTING function: %s, in file: %s\n',st(1).name,st(1).file);
end


%%
if strcmp(datatype, 'imu')
    
    opts = detectImportOptions(file_path);
    opts.PreserveVariableNames = true;
    datatable = readtable(file_path,opts);
    Npoints = height(datatable);
    IMU_data_structure = fcn_LoadRawDataToMATLAB_initializeDataByType(datatype,Npoints);
    switch topic_name
        case '/adis_msg'
            secs = datatable.secs;
            nsecs = datatable.nsecs;
            IMU_data_structure.GPS_Time           = secs + nsecs*10^-9;  % This is the GPS time, UTC, as reported by the unit
            % IMU_data_structure.Trigger_Time       = default_value;  % This is the Trigger time, UTC, as calculated by sample
            IMU_data_structure.ROS_Time           = datatable.rosbagTimestamp;  % This is the ROS time that the data arrived into the bag
            % IMU_data_structure.centiSeconds       = default_value;  % This is the hundreth of a second measurement of sample period (for example, 20 Hz = 5 centiseconds)
            IMU_data_structure.Npoints            = height(datatable);  % This is the number of data points in the array
            % IMU_data_structure.IMUStatus          = default_value; 

           
            % IMU_data_structure.XOrientation       = datatable.x; 
            % IMU_data_structure.XOrientation_Sigma = default_value; 
            % IMU_data_structure.YOrientation       = datatable.y;
            % IMU_data_structure.YOrientation_Sigma = default_value;
            % IMU_data_structure.ZOrientation       = datatable.z;
            % IMU_data_structure.ZOrientation_Sigma = default_value;
            % IMU_data_structure.WOrientation       = datatable.w;
            % IMU_data_structure.WOrientation_Sigma = default_value;
            % IMU_data_structure.Orientation_Sigma  = datatable.orientation_covariance;

            IMU_data_structure.XAccel             = datatable.x; 
            % IMU_data_structure.XAccel_Sigma       = default_value; 
            IMU_data_structure.YAccel             = datatable.y; 
            % IMU_data_structure.YAccel_Sigma       = default_value; 
            IMU_data_structure.ZAccel             = datatable.z; 
            % IMU_data_structure.ZAccel_Sigma       = default_value; 
            % IMU_data_structure.Accel_Sigma        = default;
            IMU_data_structure.XGyro              = datatable.x_1; 
            % IMU_data_structure.XGyro_Sigma        = default_value; 
            IMU_data_structure.YGyro              = datatable.y_1; 
            % IMU_data_structure.YGyro_Sigma        = default_value; 
            IMU_data_structure.ZGyro              = datatable.z_1; 
            % IMU_data_structure.ZGyro_Sigma        = default_value;
            % IMU_data_structure.Gyro_Sigma         = default_value;
            % Message below are not exist
            IMU_data_structure.XMagnetic          = datatable.x_2;
            % IMU_data_structure.XMagnetic_Sigma    = default_value;
            IMU_data_structure.YMagnetic          = datatable.y_2;
            % IMU_data_structure.YMagnetic_Sigma    = default_value;
            IMU_data_structure.ZMagnetic          = datatable.z_2;
            % IMU_data_structure.ZMagnetic_Sigma    = default_value;
            % IMU_data_structure.Magnetic_Sigma     = default_value;
            IMU_data_structure.Pressure           = datatable.pressure;
            % IMU_data_structure.Pressure_Sigma     = default_value;
            IMU_data_structure.Temperature        = datatable.temp;
            % IMU_data_structure.Temperature_Sigma  = default_value;



        case '/adis_press'
            secs = datatable.secs;
            nsecs = datatable.nsecs;
            IMU_data_structure.GPS_Time           = secs + nsecs*10^-9;  % This is the GPS time, UTC, as reported by the unit
            % IMU_data_structure.Trigger_Time       = default_value;  % This is the Trigger time, UTC, as calculated by sample
            IMU_data_structure.ROS_Time           = datatable.rosbagTimestamp;  % This is the ROS time that the data arrived into the bag
            % IMU_data_structure.centiSeconds       = default_value;  % This is the hundreth of a second measurement of sample period (for example, 20 Hz = 5 centiseconds)
            IMU_data_structure.Npoints            = height(datatable);  % This is the number of data points in the array
            % IMU_data_structure.IMUStatus          = default_value; 

           
            % IMU_data_structure.XOrientation       = datatable.x; 
            % IMU_data_structure.XOrientation_Sigma = default_value; 
            % IMU_data_structure.YOrientation       = datatable.y;
            % IMU_data_structure.YOrientation_Sigma = default_value;
            % IMU_data_structure.ZOrientation       = datatable.z;
            % IMU_data_structure.ZOrientation_Sigma = default_value;
            % IMU_data_structure.WOrientation       = datatable.w;
            % IMU_data_structure.WOrientation_Sigma = default_value;
            % IMU_data_structure.Orientation_Sigma  = datatable.orientation_covariance;

            % IMU_data_structure.XAccel             = datatable.x_2; 
            % IMU_data_structure.XAccel_Sigma       = default_value; 
            % IMU_data_structure.YAccel             = datatable.y_2; 
            % IMU_data_structure.YAccel_Sigma       = default_value; 
            % IMU_data_structure.ZAccel             = datatable.z_2; 
            % IMU_data_structure.ZAccel_Sigma       = default_value; 
            % IMU_data_structure.Accel_Sigma        = datatable.linear_acceleration_covariance;
            % IMU_data_structure.XGyro              = datatable.x_1; 
            % IMU_data_structure.XGyro_Sigma        = default_value; 
            % IMU_data_structure.YGyro              = datatable.y_1; 
            % IMU_data_structure.YGyro_Sigma        = default_value; 
            % IMU_data_structure.ZGyro              = datatable.z_1; 
            % IMU_data_structure.ZGyro_Sigma        = default_value;
            % IMU_data_structure.Gyro_Sigma         = datatable.angular_velocity_covariance;
            % Message below are not exist
            % IMU_data_structure.XMagnetic          = default_value;
            % IMU_data_structure.XMagnetic_Sigma    = default_value;
            % IMU_data_structure.YMagnetic          = default_value;
            % IMU_data_structure.YMagnetic_Sigma    = default_value;
            % IMU_data_structure.ZMagnetic          = default_value;
            % IMU_data_structure.ZMagnetic_Sigma    = default_value;
            % IMU_data_structure.Magnetic_Sigma     = default_value;
            IMU_data_structure.Pressure           = datatable.fluid_pressure;
            IMU_data_structure.Pressure_Sigma     = datatable.variance;
            % IMU_data_structure.Temperature        = default_value;
            % IMU_data_structure.Temperature_Sigma  = default_value;
 
        case '/adis_temp'
            secs = datatable.secs;
            nsecs = datatable.nsecs;
            IMU_data_structure.GPS_Time           = secs + nsecs*10^-9;  % This is the GPS time, UTC, as reported by the unit
            % IMU_data_structure.Trigger_Time       = default_value;  % This is the Trigger time, UTC, as calculated by sample
            IMU_data_structure.ROS_Time           = datatable.rosbagTimestamp;  % This is the ROS time that the data arrived into the bag
            % IMU_data_structure.centiSeconds       = default_value;  % This is the hundreth of a second measurement of sample period (for example, 20 Hz = 5 centiseconds)
            IMU_data_structure.Npoints            = height(datatable);  % This is the number of data points in the array
            % IMU_data_structure.IMUStatus          = default_value; 

           
            % IMU_data_structure.XOrientation       = datatable.x; 
            % IMU_data_structure.XOrientation_Sigma = default_value; 
            % IMU_data_structure.YOrientation       = datatable.y;
            % IMU_data_structure.YOrientation_Sigma = default_value;
            % IMU_data_structure.ZOrientation       = datatable.z;
            % IMU_data_structure.ZOrientation_Sigma = default_value;
            % IMU_data_structure.WOrientation       = datatable.w;
            % IMU_data_structure.WOrientation_Sigma = default_value;
            % IMU_data_structure.Orientation_Sigma  = datatable.orientation_covariance;

            % IMU_data_structure.XAccel             = datatable.x_2; 
            % IMU_data_structure.XAccel_Sigma       = default_value; 
            % IMU_data_structure.YAccel             = datatable.y_2; 
            % IMU_data_structure.YAccel_Sigma       = default_value; 
            % IMU_data_structure.ZAccel             = datatable.z_2; 
            % IMU_data_structure.ZAccel_Sigma       = default_value; 
            % IMU_data_structure.Accel_Sigma        = datatable.linear_acceleration_covariance;
            % IMU_data_structure.XGyro              = datatable.x_1; 
            % IMU_data_structure.XGyro_Sigma        = default_value; 
            % IMU_data_structure.YGyro              = datatable.y_1; 
            % IMU_data_structure.YGyro_Sigma        = default_value; 
            % IMU_data_structure.ZGyro              = datatable.z_1; 
            % IMU_data_structure.ZGyro_Sigma        = default_value;
            % IMU_data_structure.Gyro_Sigma         = datatable.angular_velocity_covariance;
            % Message below are not exist
            % IMU_data_structure.XMagnetic          = default_value;
            % IMU_data_structure.XMagnetic_Sigma    = default_value;
            % IMU_data_structure.YMagnetic          = default_value;
            % IMU_data_structure.YMagnetic_Sigma    = default_value;
            % IMU_data_structure.ZMagnetic          = default_value;
            % IMU_data_structure.ZMagnetic_Sigma    = default_value;
            % IMU_data_structure.Magnetic_Sigma     = default_value;
            % IMU_data_structure.Pressure           = datatable.fluid_pressure;
            % IMU_data_structure.Pressure_Sigma     = datatable.variance;
            IMU_data_structure.Temperature        = datatable.temperature;
            IMU_data_structure.Temperature_Sigma  = datatable.variance;
 


   
        otherwise
            error('Unrecognized topic requested: %s',topic_name)
    end

else
    error('Wrong data type requested: %s',datatype)

end


% Close out the loading process
if flag_do_debug
    fprintf(1,'ENDING function: %s, in file: %s\n\n',st(1).name,st(1).file);
end

end
