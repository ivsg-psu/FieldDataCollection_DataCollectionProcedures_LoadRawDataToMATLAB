% script_test_fcn_DataClean_trimRepeatsFromField.m
% tests fcn_DataClean_trimRepeatsFromField.m

% Revision history
% 2023_06_26 - sbrennan@psu.edu
% -- wrote the code originally

%% Set up the workspace
close all


% DOES NOT WORK?
% dataStructure = fcn_DataClean_fillTestDataStructure;


%% Example call 1 - using only defaults, pull out GPS_Time

% Grab example data
fullExampleFilePath = fullfile(cd,'Data','ExampleData_pullDataFromFieldAcrossAllSensors.mat');
load(fullExampleFilePath,'dataStructure');

field_string = 'GPS_Time';
sensor_identifier_string = []; % 'GPS'
entry_location = [];
fid = [];

% Call the function
[dataArray,sensorNames] = fcn_LoadRawDataToMATLAB_pullDataFromFieldAcrossAllSensors(dataStructure,field_string,(sensor_identifier_string), (entry_location), (fid));

% Check that results are all cell arrays
assert(iscell(dataArray))
assert(iscell(sensorNames))

% Assert they have same length
assert(length(dataArray)==length(sensorNames))

%% Example call 2 - pull out GPS_Time from only sensors that have "GPS" in name

% Grab example data
fullExampleFilePath = fullfile(cd,'Data','ExampleData_pullDataFromFieldAcrossAllSensors.mat');
load(fullExampleFilePath,'dataStructure');

field_string = 'GPS_Time';
sensor_identifier_string = 'GPS';
entry_location = [];
fid = [];

% Call the function
[dataArray,sensorNames] = fcn_LoadRawDataToMATLAB_pullDataFromFieldAcrossAllSensors(dataStructure,field_string,(sensor_identifier_string), (entry_location), (fid));

% Check that results are all cell arrays
assert(iscell(dataArray))
assert(iscell(sensorNames))

% Assert they have same length
assert(length(dataArray)==length(sensorNames))

%% Example call 3 - pull out GPS_Time from only sensors that have "GPS" in name, keeping only 1st data and printing to console

% Grab example data
fullExampleFilePath = fullfile(cd,'Data','ExampleData_pullDataFromFieldAcrossAllSensors.mat');
load(fullExampleFilePath,'dataStructure');

field_string = 'GPS_Time';
sensor_identifier_string = 'GPS';
entry_location = [];
fid = [];

% Call the function
[dataArray,sensorNames] = fcn_LoadRawDataToMATLAB_pullDataFromFieldAcrossAllSensors(dataStructure,field_string,(sensor_identifier_string), (entry_location), (fid));

% Check that results are all cell arrays
assert(iscell(dataArray))
assert(iscell(sensorNames))

% Assert they have same length
assert(length(dataArray)==length(sensorNames))

%% Example call 4 - pull out GPS_Time from only sensors that have "GPS" in name, keeping only last data and printing to console

% Grab example data
fullExampleFilePath = fullfile(cd,'Data','ExampleData_pullDataFromFieldAcrossAllSensors.mat');
load(fullExampleFilePath,'dataStructure');

field_string = 'GPS_Time';
sensor_identifier_string = 'GPS';
entry_location = 'last_row';
fid = 1;

% Call the function
[dataArray,sensorNames] = fcn_LoadRawDataToMATLAB_pullDataFromFieldAcrossAllSensors(dataStructure,field_string,(sensor_identifier_string), (entry_location), (fid));

% Check that results are all cell arrays
assert(iscell(dataArray))
assert(iscell(sensorNames))

% Assert they have same length
assert(length(dataArray)==length(sensorNames))



%%

%%

%% CASE 1: Basic Example - pull centiSeconds from every sensor
% Fill in the initial data
dataStructure = fcn_LoadRawDataToMATLAB_fillTestDataStructure;
fid = 1;

fprintf(1,'\nCASE 1: Demonstrating pulling centiseconds from every sensor, without being verbose: \n');
[data,sensorNames] = fcn_LoadRawDataToMATLAB_pullDataFromFieldAcrossAllSensors(dataStructure, 'centiSeconds');

% Print the result in nice table:
fprintf(1,'\nHere is the result, as a table of centiseconds query over all sensors:\n');
fixed_length_string = fcn_DebugTools_debugPrintStringToNCharacters('Sensors:',25);
fprintf(1,'%s \t %s\n',fixed_length_string,'centiSeconds:');
for ith_data = 1:length(data)
    fixed_length_string = fcn_DebugTools_debugPrintStringToNCharacters(sensorNames{ith_data},25);
    fprintf(1,'%s \t %.3f\n',fixed_length_string,data{ith_data});
end
fprintf(1,'\n');

% Make sure it worked
sensor_names = fieldnames(dataStructure); % Grab all the fields that are in dataStructure structure
for ith_data = 1:length(sensor_names)
    % Grab the sensor subfield name
    sensor_name = sensor_names{ith_data};
    
    % If not empty, check it
    if ~isempty(data{ith_data})
        assert(dataStructure.(sensor_name).centiSeconds(1,1)== data{ith_data});
    end
end

%% CASE 2: Basic Example - pull centiSeconds from every sensor (verbose)
% Fill in the initial data
dataStructure = fcn_LoadRawDataToMATLAB_fillTestDataStructure;
fid = 1;


fprintf(1,'\nCASE 2: Demonstrating pulling centiseconds from every sensor, being verbose: \n\n');

[data,sensorNames] = fcn_LoadRawDataToMATLAB_pullDataFromFieldAcrossAllSensors(dataStructure, 'centiSeconds', [],[], fid);

% Print the result in nice table:
fprintf(1,'Example table of centiseconds query over all sensors:\n');
fixed_length_string = fcn_DebugTools_debugPrintStringToNCharacters('Sensors:',25);
fprintf(1,'%s \t %s\n',fixed_length_string,'centiSeconds:');
for ith_data = 1:length(data)
    fixed_length_string = fcn_DebugTools_debugPrintStringToNCharacters(sensorNames{ith_data},25);
    fprintf(1,'%s \t %.3f\n',fixed_length_string,data{ith_data});
end
fprintf(1,'\n');

% Make sure it worked
sensor_names = fieldnames(dataStructure); % Grab all the fields that are in dataStructure structure
for ith_data = 1:length(sensor_names)
    % Grab the sensor subfield name
    sensor_name = sensor_names{ith_data};
    
    % If not empty, check it
    if ~isempty(data{ith_data})
        assert(dataStructure.(sensor_name).centiSeconds(1,1)== data{ith_data});
    end
end


%% CASE 3: Basic Example - pull centiSeconds from every GPS sensor
% Fill in the initial data
dataStructure = fcn_LoadRawDataToMATLAB_fillTestDataStructure;
fid = 1;


fprintf(1,'\nCASE 3: Demonstrating pulling centiseconds from only GPS sensors, NOT verbose: \n\n');

[data,sensorNames] = fcn_LoadRawDataToMATLAB_pullDataFromFieldAcrossAllSensors(dataStructure, 'centiSeconds','GPS');

% Print the result in nice table:
fprintf(1,'\nThe results are now shown as a table of centiseconds query over just GPS sensors:\n');
fixed_length_string = fcn_DebugTools_debugPrintStringToNCharacters('Sensors:',25);
fprintf(1,'%s \t %s\n',fixed_length_string,'centiSeconds:');
for ith_data = 1:length(data)
    fixed_length_string = fcn_DebugTools_debugPrintStringToNCharacters(sensorNames{ith_data},25);
    fprintf(1,'%s \t %.3f\n',fixed_length_string,data{ith_data});
end
fprintf(1,'\n');


% Make sure it worked
sensor_names = fieldnames(dataStructure); % Grab all the fields that are in dataStructure structure
current_hit = 1;
for ith_data = 1:length(sensor_names)
    % Grab the sensor subfield name
    sensor_name = sensor_names{ith_data};
    
    if contains(lower(sensor_name),lower('GPS'))
        % If not empty, check it
        if ~isempty(data{current_hit})
            assert(dataStructure.(sensor_name).centiSeconds(1,1)== data{current_hit});
            current_hit = current_hit+1;
        end
    end
end


%% Basic Example - pull bad name from every sensor - produces emtpy matrix
% Fill in the initial data
dataStructure = fcn_LoadRawDataToMATLAB_fillTestDataStructure;

data = fcn_LoadRawDataToMATLAB_pullDataFromFieldAcrossAllSensors(dataStructure, 'goofybadname');
assert(isempty(cell2mat(data)));

%% Basic Example - pull first_row value from GPS_Time, for all sensors
% Fill in the initial data
dataStructure = fcn_LoadRawDataToMATLAB_fillTestDataStructure;

[data, ~] = fcn_LoadRawDataToMATLAB_pullDataFromFieldAcrossAllSensors(dataStructure, 'GPS_Time','','first_row');

assert(iscell(data));
assert(length(data)==8);

%% Basic Example - pull first_row value from GPS_Time, for all GPS sensors
% Fill in the initial data
dataStructure = fcn_LoadRawDataToMATLAB_fillTestDataStructure;

[data, ~] = fcn_LoadRawDataToMATLAB_pullDataFromFieldAcrossAllSensors(dataStructure, 'GPS_Time','GPS','first_row');

assert(iscell(data));
assert(length(data)==3);


%% Basic Example - pull first_row value from GPS_Time, for all GPS sensors
% Fill in the initial data
dataStructure = fcn_LoadRawDataToMATLAB_fillTestDataStructure;
fid = 1;

[data, ~] = fcn_LoadRawDataToMATLAB_pullDataFromFieldAcrossAllSensors(dataStructure, 'GPS_Time','GPS','last_row');

assert(iscell(data));
assert(length(data)==3);

if 1==0 % BAD error cases start here



end
