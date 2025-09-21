function Velodyne_Lidar_structure = fcn_LoadRawDataToMATLAB_loadRawDataFromFile_velodyneLIDAR(file_path,datatype,fid,varargin)

% This function is used to load the raw data collected with the Penn State Mapping Van.
% This is the Velodyne Lidar data, whose data type is lidar3d
% Input Variables:
%      file_path = file path of the Velodyne Lidar data (format txt)
%      datatype  = the datatype should be lidar3d
% Returned Results:
%      Velodyne_Lidar_structure

% Author: Xinyu Cao
% Created Date: 2023_07_18
% To do: 
% - Merge X, Y, Z and Intensity into a matrix
% 
% This function is modified to load the raw data (from file) collected with
% the Penn State Mapping Van.
% Reference:
% Document/Velodyne LiDAR Point Cloud Message Info.txt

%% Revision history:
% As: fcn_DataClean_loadRawDataFromFile_velodyneLIDAR
% 2023_07_18 by X. Cao
% -- start writing function
% 2024-02-09 by X. Cao
% -- fix a small bug, remove one useless input
% 2024-07-02 by X. Cao
% -- added varagin to select the duration of scan that will be loaded
% 2024-10-10 by X. Cao
% -- update loading directories based on the new parsing functions
% -- add commetns
% 2024-10-28 by X. Cao
% -- replace Host_Time with ROS_Time
% 2025_09_20: sbrennan@psu.edu
% * In fcn_DataClean_loadRawDataFromFile_velodyneLIDAR
% -- Renamed function to fcn_DataClean_loadRawDataFromFile_velodyneLIDAR


flag_do_debug = 0;  % Flag to show the results for debugging
flag_do_plots = 0;  % % Flag to plot the final results
flag_check_inputs = 1; % Flag to perform input checking

if flag_do_debug
    st = dbstack; %#ok<*UNRCH>
    fprintf(1,'STARTING function: %s, in file: %s\n',st(1).name,st(1).file);
end

if flag_check_inputs
    % Are there the right number of inputs?
    narginchk(3,4);
end

if 4 == nargin
    flag_select_scan_duration = varargin{1};
else
    flag_select_scan_duration = 0;
end




if strcmp(datatype,'lidar3d')
    opts = detectImportOptions(file_path);
    velodyne_lidar_table = readtable(file_path, opts);
    velodyne_lidar_table.Properties.VariableNames = {'seq','ros_time','header_time','host_time','device_time','scan_filename'};
    % The number of rows in the file, also the number of scans
    Nscans = height(velodyne_lidar_table);
    scan_filenames_array = string(velodyne_lidar_table.scan_filename);
    Velodyne_Lidar_structure = fcn_LoadRawDataToMATLAB_initializeDataByType(datatype);
    ROS_Time = velodyne_lidar_table.ros_time;
    host_time = velodyne_lidar_table.host_time;
    device_time = velodyne_lidar_table.device_time;
    % Sick_Lidar_structure.GPS_Time           = secs + nsecs*10^-9;  % This is the GPS time, UTC, as reported by the unit
    % data_structure.Trigger_Time       = default_value;  % This is the Trigger time, UTC, as calculated by sample
    Velodyne_Lidar_structure.Seq                = velodyne_lidar_table.seq;
    Velodyne_Lidar_structure.ROS_Time           = ROS_Time;  % This is the ROS time that the data arrived into the bag
    Velodyne_Lidar_structure.centiSeconds       = 10;  % This is the hundreth of a second measurement of sample period (for example, 20 Hz = 5 centiseconds)
    Velodyne_Lidar_structure.Npoints            = Nscans;  % This is the number of data points in the array
    Velodyne_Lidar_structure.Host_Time        = host_time;
    Velodyne_Lidar_structure.Device_Time        = device_time;
    
    % Save the data structure and layout information first, these data will
    % be used to process the actual point cloud data later
    % 2D structure of the point cloud. If the cloud is unordered, 
    % height is 1 and width is the length of the point cloud.
    % Velodyne_Lidar_structure.Height             = velodyne_lidar_table.Height; 
    % Velodyne_Lidar_structure.Width          = velodyne_lidar_table.Width;  
    % Velodyne_Lidar_structure.is_bigendian   = velodyne_lidar_table.is_bigendian;  % Is this data bigendian?
    % Velodyne_Lidar_structure.point_step    = velodyne_lidar_table.point_step;  % This is the length of a point in bytes
    % Velodyne_Lidar_structure.row_step        = velodyne_lidar_table.row_step;  % This is the length of a row in bytes
    % Velodyne_Lidar_structure.is_dense         = velodyne_lidar_table.is_dense;  %  True if there are no invalid points
    Velodyne_Lidar_structure.scan_filename        = scan_filenames_array;
    points_cell = {};
    [bagFolderPath,~,~] = fileparts(file_path);
    [mainFolderPath,~,~] = fileparts(bagFolderPath);
    % Hash tree may have different names, but 'hashVelodyne' always exists, 
    % the function will look for the folder start with 'hashVelodyne' 
    pointcloud_folder = "hashVelodyne*";
    % Let user choose the scan range
    if flag_select_scan_duration == 1
        user_input_txt = sprintf('There are %d scans, please enter the scan duration you want to load. [idx_start:idx_end]', Nscans);
        user_input = input(user_input_txt);
        scan_duration = user_input;
    else
        scan_duration = 1:Nscans;
    end

    % Use hash tags to load pointCloud data for each scan
    for idx_scan = scan_duration
        scan_filename = scan_filenames_array(idx_scan);
        scan_filename_char = char(scan_filename);
        points_file_fullPath = fullfile(mainFolderPath,pointcloud_folder,scan_filename_char(1:2),scan_filename_char(3:4),scan_filename+'.txt');
        
        points_file_struct = dir(points_file_fullPath);
        points_file = fullfile(points_file_struct.folder,points_file_struct.name);
        opts_scan = detectImportOptions(points_file);
        pointcloud = readmatrix(points_file,opts_scan);

        points_cell{idx_scan,1} = pointcloud;
        clear pointcloud

    end
    Velodyne_Lidar_structure.PointCloud = points_cell;
    % Velodyne_Lidar_structure.LiDAR_Time = LiDAR_Time;
    % Loading completed
 
else
    error('Wrong data type requested: %s',dataType)
end




% Close out the loading process
if flag_do_debug 
    fprintf(1,'ENDING function: %s, in file: %s\n\n',st(1).name,st(1).file);
end

end
