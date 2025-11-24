% script_test_fcn_LoadRawDataToMATLAB_fillTestDataStructure.m
% tests fcn_LoadRawDataToMATLAB_fillTestDataStructure.m

% REVISION HISTORY:
%
% As: script_test_fcn_Data+Clean_fillTestDataStructure
%
% 2023_06_19 by Sean Brennan, sbrennan@psu.edu
% - Wrote the code originally
% 
% As: script_test_fcn_LoadRawDataToMATLAB_stitchStructures
% 
% 2025_11_23 by Sean Brennan, sbrennan@psu.edu
% - Corrected script name
% - Fixed rev history to be Markdown format
% - Added TO+-DO list

% TO-DO:
% 
% 2025_11_23 by Sean Brennan, sbrennan@psu.edu
% - (add items here)


%% Set up the workspace
close all

%% Basic call
testDataStructure = fcn_LoadRawDataToMATLAB_fillTestDataStructure;

% Make sure its type is correct
assert(isstruct(testDataStructure));

fprintf(1,'The data structure for testDataStructure: \n')
disp(testDataStructure)

%% Basic call in verbose mode
fprintf(1,'\n\nDemonstrating "verbose" mode by printing to console: \n');
error_type = [];
fid = 1;
testDataStructure = fcn_LoadRawDataToMATLAB_fillTestDataStructure(error_type,fid);

% Make sure its type is correct
assert(isstruct(testDataStructure));

fprintf(1,'The data structure for testDataStructure: \n')
disp(testDataStructure)

%% Standard noise call
testDataStructure = fcn_LoadRawDataToMATLAB_fillTestDataStructure(1);

% Make sure its type is correct
assert(isstruct(testDataStructure));

fprintf(1,'The data structure for testDataStructure: \n')
disp(testDataStructure)

%% Fail conditions
if 1==0
    
end
