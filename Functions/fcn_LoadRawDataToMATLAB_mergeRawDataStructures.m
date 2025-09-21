function [mergedRawDataCellArray, uncommonFieldsCellArray]  = fcn_LoadRawDataToMATLAB_mergeRawDataStructures(rawDataCellArray, varargin)
% fcn_DataClean_mergeRawDataStructures
% given a cell array of rawData files where the bag files may be in
% sequence, finds the files in sequence and creates merged data structures.
%
% FORMAT:
%
%      [mergedRawDataCellArray, uncommonFieldsCellArray] = fcn_DataClean_mergeRawDataStructures(...
%      rawDataCellArray, (thresholdTimeNearby), (fid), (figNum))
%
% INPUTS:
%
%      rawDataCellArray: a cell array of data structures containing data
%      fields filled for each ROS topic
%
%      (OPTIONAL INPUTS)
%
%      thresholdTimeNearby: the time, in seconds, allowed after one bag
%      file ends and the next one starts, to allow a merge. Default is 10
%      seconds in either direction (positive or negative). NOTE: sometimes
%      data is separated such that the subsequent data - portions of it at
%      least - are before the end of the previous data, usually by about 3
%      seconds.
%
%      fid: the fileID where to print. Default is 1, to print results to
%      the console.
%
%     figNum: a figure number to plot results. If set to -1, skips any
%     input checking or debugging, no figures will be generated, and sets
%     up code to maximize speed. As well, if given, this forces the
%     variable types to be displayed as output and as well makes the input
%     check process verbose.
%
% OUTPUTS:
%
%      mergedRawDataCellArray: a cell array of merged data structures
%      containing data fields filled for each ROS topic
%
%      uncommonFieldsCellArray: a cell array that lists the names of
%      structures or fields that could not be merged, corresponding to the
%      same index of mergedRawDataCellArray
%
% DEPENDENCIES:
%
%      fcn_DataClean_pullDataFromFieldAcrossAllSensors
%      fcn_DataClean_stitchStructures
%      fcn_geometry_fillColorFromNumberOrName
%      fcn_DataClean_plotRawData
%      fcn_plotRoad_plotLL
%
% EXAMPLES:
%
%     See the script: script_test_fcn_DataClean_mergeRawDataStructures
%     for a full test suite.
%
% This function was written on 2024_09_15 by S. Brennan
% Questions or comments? sbrennan@psu.edu

% Revision history
% 2024_09_15 - Sean Brennan, sbrennan@psu.edu
% -- wrote the code originally

%% Debugging and Input checks
% Check if flag_max_speed set. This occurs if the figNum variable input
% argument (varargin) is given a number of -1, which is not a valid figure
% number.
MAX_NARGIN = 4; % The largest Number of argument inputs to the function
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
        narginchk(1,MAX_NARGIN);
        
    end
end

% Does user want to specify thresholdTimeNearby?
thresholdTimeNearby = 10; % 10 seconds is allowed between the start of one and end of another
if 2 <= nargin
    temp = varargin{1};
    if ~isempty(temp)
        thresholdTimeNearby = temp;
    end
end

% Does user want to specify fid?
fid = []; 
if 3 <= nargin
    temp = varargin{2};
    if ~isempty(temp)
        fid = temp; 
    end
end

% Does user want to show the plots?
flag_do_plots = 0; % Default is to NOT show plots
if (0==flag_max_speed) && (MAX_NARGIN == nargin) 
    temp = varargin{end};
    if ~isempty(temp) % Did the user NOT give an empty figure number?
        figNum = temp;
        figure(figNum);
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

% 
% %% Make sure the image save directory is there if image save is requested.
% if 1==saveFlags.flag_saveImages && 7~=exist(saveFlags.flag_saveImages_directory,'dir') && 0==saveFlags.flag_forceDirectoryCreation
%     warning('on','backtrace');
%     warning('Unable to find directory: %s',saveFlags.flag_saveImages_directory)
%     error('Image save specified that copies image into a non-existing directory. Unable to continue.');
% end
% 
% % Create the image save directory if needed
% if 1==saveFlags.flag_saveImages && saveFlags.flag_forceDirectoryCreation 
%     directoryName = saveFlags.flag_saveImages_directory;
%     fcn_DebugTools_makeDirectory(directoryName);
% end
% 
% %% Make sure the MAT save directory is there if MAT file save is requested.
% if 1==saveFlags.flag_saveMatFile &&  7~=exist(saveFlags.flag_saveMatFile_directory,'dir') && 0==saveFlags.flag_forceDirectoryCreation
%     warning('on','backtrace');
%     warning('Unable to find directory: %s',saveFlags.flag_saveMatFile_directory)
%     error('MAT file save specified that copies files into a non-existing directory. Unable to continue.');
% end
% 
% % Create the image save directory if needed
% if  1==saveFlags.flag_saveMatFile && saveFlags.flag_forceDirectoryCreation 
%     directoryName = saveFlags.flag_saveMatFile_directory;
%     fcn_DebugTools_makeDirectory(directoryName);
% end

%% Confirm length of cell array is valid
% How much data are there
NdataSets = length(rawDataCellArray);
for ith_mergedData = 1:NdataSets
    if isequal(fieldnames(rawDataCellArray{ith_mergedData}),{'Identifiers'})
        NdataSets = ith_mergedData-1;
        break;
    end
end


%% Find when did each data set starts and stops in time


% Get the max and min GPS times in each data set
earliestTimeGPS = nan(NdataSets,1);
latestTimeGPS   = nan(NdataSets,1);
for ith_mergedData = 1:NdataSets
    % Get all the GPS_time data, keeping only first row from sensors that
    % have "GPS" in name
    [dataArray,~] = fcn_LoadRawDataToMATLAB_pullDataFromFieldAcrossAllSensors(rawDataCellArray{ith_mergedData}, 'GPS_Time','GPS', 'first_row');
    if all(isempty([dataArray{:}]))
        mergedRawDataCellArray = cell(1,1);
        uncommonFieldsCellArray = cell(1,1);
        return;
    else
        earliestTimeGPS(ith_mergedData,1) = min(cell2mat(dataArray));
    end


    % Get all the GPS_time data, keeping only last row from sensors that
    % have "GPS" in name
    [dataArray,~] = fcn_LoadRawDataToMATLAB_pullDataFromFieldAcrossAllSensors(rawDataCellArray{ith_mergedData}, 'GPS_Time','GPS', 'last_row');
    latestTimeGPS(ith_mergedData,1) = max(cell2mat(dataArray));
end


%% Find how all the sequences are named and numbered
sequenceNumbers = nan(NdataSets,1);
sequenceNames = cell(NdataSets,1);
for ith_mergedData = 1:NdataSets
    sequenceNames{ith_mergedData} = rawDataCellArray{ith_mergedData}.Identifiers.SourceBagFileName;
    sequenceNumbers(ith_mergedData,1) = fcn_INTERNAL_findSequenceNumber(sequenceNames{ith_mergedData});
end

%% Summarize results thus far?
if fid>0

    % Show details
    fprintf(fid,'\nSUMMARY OF FILES FOUND:\n');
    Nheader = 50;
    Nfields = 20;
    fieldStrings{1} = 'NUMBER:';
    fieldStrings{2} = 'TIME_START: (sec)';
    fieldStrings{3} = 'TIME_END: (sec)';
    fcn_INTERNAL_printFields(fid, 'BAG FILE:',fieldStrings,Nheader,Nfields)
    t_smallest = min([earliestTimeGPS latestTimeGPS],[],'all');
    for ith_dataSet = 1:NdataSets
        fieldStrings{1} =  sprintf('%.0f',sequenceNumbers(ith_dataSet,1));
        fieldStrings{2} =  sprintf('%.2f',earliestTimeGPS(ith_dataSet,1)-t_smallest);
        fieldStrings{3} =  sprintf('%.2f',latestTimeGPS(ith_dataSet,1)-t_smallest);
        fcn_INTERNAL_printFields(fid, sequenceNames{ith_dataSet},fieldStrings,Nheader,Nfields)        
    end
end

%% Identify data belonging to each merge sequence
% Loop through all the files that are first in sequence, and for each, make
% a list of the indicies of the files that are subsequent in that sequence.
% Save the indicies within mergeIndexList and keep the first sequence's
% "short name" as this will name the merged file and data


% Find all the data folders that end in '_0'. These are the first in
% sequences. For each, check for data with _1 that starts near to time of
% _0, then _2 for those that end with _1, etc.
firstInSequenceIndicies = find(sequenceNumbers==0);
NmergedFiles = length(firstInSequenceIndicies);

% Prep the data storage variables
clear mergeIndexList shortMergedNames
mergeIndexList   = cell(NmergedFiles,1);
shortMergedNames = cell(NmergedFiles,1);

% Loop through all the files, keeping track of which files were used
NmaxLoops = 100; % What is the maximum number of files that can be merged?
flag_fileWasMerged = zeros(NdataSets,1);
for ith_merged = 1:NmergedFiles
    thisMergedIndex = firstInSequenceIndicies(ith_merged);

    % Mark this file as being merged
    flag_fileWasMerged(thisMergedIndex,1) = 1;

    % Produce a name for this merge sequence. Names are inhereted from the
    % _0 file.
    mergeName = sequenceNames{thisMergedIndex};
    shortMergedName = mergeName(1:end-2); % Cut off the '_0' at end
    shortMergedNames{ith_merged} = shortMergedName;

    % Build up the merge list. Start by initializing the variables for this
    % specific list
    Nmerged = 1;
    mergeIndexList{ith_merged} = thisMergedIndex;

    % Loop through all the files in each sequence, finding ones that are
    % both starting when the previous one ended in time, and also has a
    % numbered sequence that makes sense, e.g. the name goes from _0 to _1
    % to _2, etc.
    flag_keepGoing = 1; % Flag to keep the while loop going
    nextEndingTime = latestTimeGPS(thisMergedIndex); % This is the last time recorded on the current list
    Nloops = 0; % Number of times the while loop has run
    while 1==flag_keepGoing
        Nloops = Nloops+1;

        % Find any files whose earliest times are within the time nearby,
        % but requiring that the earliest time is AFTER the previous ending
        % time.
        time_difference = (earliestTimeGPS-nextEndingTime);
        % nextIndex = find((time_difference>=0).*(abs(time_difference)<=thresholdTimeNearby));
        nextIndex = find(abs(time_difference)<=thresholdTimeNearby);

        % Make sure only one file was found
        if length(nextIndex)>1
            error('Multiple files found where the end of one file is time-aligned with the end of the next file.');
        end


        if isempty(nextIndex)
            flag_keepGoing = 0;
        else
            % Find all files that are next in sequence. For example, if we
            % just did all the _2 files, then we are looking for all the
            % files that end with _3.
            indexDataFilesNextInSequence = find(sequenceNumbers==Nmerged);
            if isempty(indexDataFilesNextInSequence)
                flag_keepGoing = 0;
            else
                % Check that the nextIndex is within the list of the files
                % next in sequence
                if ismember(nextIndex, indexDataFilesNextInSequence)
                    Nmerged = Nmerged+1;
                    mergeIndexList{ith_merged} = [mergeIndexList{ith_merged}; nextIndex];
                    nextEndingTime = latestTimeGPS(nextIndex);

                    % Mark this file as being merged
                    flag_fileWasMerged(nextIndex,1) = 1;

                else
                    flag_keepGoing = 0;
                end
            end
        end

        % Make sure code is not trapped in this while loop for some reason
        if Nloops>NmaxLoops
            error('Very large number of files merged (N>100). Error likely and so exiting');
        end

    end % Ends while loop
end % Ends for loop that loops through "starting" bag files

%% Warn user of any files that were not merged?
if fid>0

    % Find which indicies were not merged
    indiciesNotMerged = find(flag_fileWasMerged==0);
    for ith_notMerged = 1:length(indiciesNotMerged)
        if 1==ith_notMerged
            fprintf(fid,'\nWARNING:\n');
            fprintf(fid,'The following files did not participate in any merge:\n');
        end
        unmergedIndex = indiciesNotMerged(ith_notMerged);
        mergeName = sequenceNames{unmergedIndex};
        fprintf(fid,'\t%s\n',mergeName);
    end
end

%% Perform merge
mergedRawDataCellArray  = cell(NmergedFiles,1);
uncommonFieldsCellArray = cell(NmergedFiles,1);



for ith_mergedData = 1:NmergedFiles
    indiciesToMerge = mergeIndexList{ith_mergedData};
    mergedName = cat(2,shortMergedNames{ith_mergedData},'_merged');

    % Update user
    if fid>0
        fprintf(fid,'\nMERGING group %.0d of %.0d: %s\n',ith_mergedData, NmergedFiles, mergedName);
    end

    clear cellArrayOfStructures bagFileNames
    NfilesToMerge = length(indiciesToMerge);
    cellArrayOfStructures{NfilesToMerge} = struct; %#ok<AGROW>
    bagFileNames{NfilesToMerge} = ''; %#ok<AGROW>
    for ith_dataFile = 1:NfilesToMerge
        bagFileNames{ith_dataFile} = rawDataCellArray{indiciesToMerge(ith_dataFile)}.Identifiers.SourceBagFileName;
        if fid>0
            fprintf(fid,'\tAdding: %s\n',bagFileNames{ith_dataFile});
        end


        % Keep the identifiers for the first one
        if 1==ith_dataFile
            clear mergedIdentifiers
            mergedIdentifiers = rawDataCellArray{indiciesToMerge(1)}.Identifiers;            
        end

        % Remove the Identifiers field, as these do NOT ever match between
        % rawData files
        structureToAdd = rawDataCellArray{indiciesToMerge(ith_dataFile)};
        structureToAdd = rmfield(structureToAdd,'Identifiers');

        cellArrayOfStructures{ith_dataFile} = structureToAdd;
    end
    [stitchedStructure, uncommonFields] = fcn_LoadRawDataToMATLAB_stitchStructures(cellArrayOfStructures,fid);

    % Fill in the updated identifiers
    stitchedStructure.Identifiers = mergedIdentifiers;
    stitchedStructure.Identifiers.SourceBagFileName = bagFileNames;
    stitchedStructure.Identifiers.TimeRangesEachBagFile_earliestTimeGPS = earliestTimeGPS;
    stitchedStructure.Identifiers.TimeRangesEachBagFile_latestTimeGPS = latestTimeGPS;
    stitchedStructure.Identifiers.mergedName = mergedName;
    
    mergedRawDataCellArray{ith_mergedData} = stitchedStructure;
    uncommonFieldsCellArray{ith_mergedData} = uncommonFields;

    if fid>0
        if ~isempty(uncommonFields)
            fprintf(fid,'\tErrors found in the following fields: \n');
            for ith_field = 1:length(uncommonFields)
                fprintf(fid,'\t\t%s\n',uncommonFields{ith_field});
            end
        end
    end
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
if (1==flag_do_plots)
    % List what will be saved (nothing)
    clear saveFlags
    saveFlags.flag_saveImages = 0;
    saveFlags.flag_saveImages_directory  = [];
    saveFlags.flag_forceDirectoryCreation = 0;
    saveFlags.flag_forceImageOverwrite = 0;

    % List what will be plotted, and the figure numbers
    clear plotFlags
    plotFlags.fig_num_plotAllRawTogether = figNum;
    plotFlags.fig_num_plotAllRawIndividually = [];

    % Call function
    fcn_LoadRawDataToMATLAB_plotRawDataPositions(mergedRawDataCellArray, (saveFlags), (plotFlags))  

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

%% fcn_INTERNAL_findSequenceNumber
function lastPart = fcn_INTERNAL_findSequenceNumber(nameString)
if ~contains(nameString,'_')
    lastPart = nan;
else
    stringLeft = nameString;
    while contains(stringLeft,'_')
        stringLeft = extractAfter(stringLeft,'_');
    end
    lastPart = str2double(stringLeft);
end
end % Ends fcn_INTERNAL_findSequenceNumber



%% fcn_INTERNAL_printFields
function fcn_INTERNAL_printFields(fid, leadString,fieldStrings,Nheader,Nfields)
% Print the fields
fprintf(fid,'%s ',fcn_DebugTools_debugPrintStringToNCharacters(leadString,Nheader));
for jth_overlappingField = 1:length(fieldStrings)
    fieldToCheck = fieldStrings{jth_overlappingField};
    fprintf(fid,'%s ',fcn_DebugTools_debugPrintStringToNCharacters(fieldToCheck,Nfields));
end
fprintf(fid,'\n');

end % Ends fcn_INTERNAL_printFields


% %% fcn_INTERNAL_printSummary
% function fcn_INTERNAL_printSummary(fid, summaryTitleString,matrixToPrint,equality_result, sensorfields_initial,fieldsOverlappingIndicies,Nheader,Nfields,N_datasets,NoverlappingFields)
% 
% 
% fprintf(fid,'%s: \n',summaryTitleString);
% fcn_INTERNAL_printFields(fid, sprintf('\tCommonField:'),sensorfields_initial,fieldsOverlappingIndicies,Nheader,Nfields)
% 
% % Print structure results
% if ~isempty(matrixToPrint)
%     for ith_structure = 1:N_datasets
%         stringHeader = sprintf('\tStructure %.0d:',ith_structure);
%         fprintf(fid,'%s ',fcn_DebugTools_debugPrintStringToNCharacters(stringHeader,Nheader));
%         for jth_overlappingField = 1:NoverlappingFields
%             indexFieldToCheck = fieldsOverlappingIndicies(jth_overlappingField);
%             stringField = sprintf('%.0f',matrixToPrint(indexFieldToCheck,ith_structure));
%             fprintf(fid,'%s ',fcn_DebugTools_debugPrintStringToNCharacters(stringField,Nfields));
%         end
%         fprintf(fid,'\n');
%     end
% end
% 
% % Print equality results
% stringHeader = sprintf('\tEquality?');
% fprintf(fid,'%s ',fcn_DebugTools_debugPrintStringToNCharacters(stringHeader,Nheader));
% for jth_overlappingField = 1:NoverlappingFields
%     stringField = sprintf('%.0f',equality_result(jth_overlappingField,1));
%     fprintf(fid,'%s ',fcn_DebugTools_debugPrintStringToNCharacters(stringField,Nfields));
% end
% fprintf(fid,'\n');
% end % Ends fcn_INTERNAL_printSummary
