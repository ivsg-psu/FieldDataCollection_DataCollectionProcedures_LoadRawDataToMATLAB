% script_test_fcn_DebugTools_replaceStringInDirectory
% Define your directory path, old string, and new string
myDirectory = fullfile(cd,'Functions');

stringToFind = '_DataClean_';
stringToReplaceWith = '_LoadRawDataToMATLAB_';

% Call the function to perform the replacement
fcn_DebugTools_replaceStringInDirectory(myDirectory, stringToFind, stringToReplaceWith);
