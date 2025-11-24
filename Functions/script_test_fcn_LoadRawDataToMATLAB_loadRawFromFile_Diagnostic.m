% script_test_fcn_LoadRawDataToMATLAB_loadRawFromFile_Diagnostic
% Tests: fcn_LoadRawDataToMATLAB_loadRawFromFile_Diagnostic


% REVISION HISTORY
% 
% As: script_test_fcn_LoadRawDataToMATLAB_loadRawFromFile_Diagnostic
% 
% 2025_11_23 by Sean Brennan, sbrennan@psu.edu
% - Created first draft of the script

% TO-DO:
% 
% 2025_11_23 by Sean Brennan, sbrennan@psu.edu
% - Need to add test cases


%% Set up the workspace
close all

%% Code demos start here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   _____                              ____   __    _____          _
%  |  __ \                            / __ \ / _|  / ____|        | |
%  | |  | | ___ _ __ ___   ___  ___  | |  | | |_  | |     ___   __| | ___
%  | |  | |/ _ \ '_ ` _ \ / _ \/ __| | |  | |  _| | |    / _ \ / _` |/ _ \
%  | |__| |  __/ | | | | | (_) \__ \ | |__| | |   | |___| (_) | (_| |  __/
%  |_____/ \___|_| |_| |_|\___/|___/  \____/|_|    \_____\___/ \__,_|\___|
%
%
% See: https://patorjk.com/software/taag/#p=display&f=Big&t=Demos%20Of%20Code
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Figures start with 1

close all;
fprintf(1,'Figure: 1XXXXXX: DEMO cases\n');

%% DEMO case: Load one diagnostic file
figNum = 10001;
titleString = sprintf('DEMO case: Load one diagnostic file');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); close(figNum);

filePath = fullfile(pwd,'Data','TestLoadData','_slash_Encoder_diag.csv');
datatype = 'diagnostic';
topicName = '/Encoder_diag';

% Call the function
structureDiagnostic = fcn_LoadRawDataToMATLAB_loadRawFromFile_Diagnostic(filePath, datatype, topicName, (figNum));
 
% sgtitle(titleString, 'Interpreter','none');

% Check variable types
assert(isstruct(structureDiagnostic))

% Check variable sizes
assert(size(structureDiagnostic,1)==1); 
assert(size(structureDiagnostic,1)==1); 

% Check variable values
% Too many

% % Make sure plot opened up
% assert(isequal(get(gcf,'Number'),figNum));

% Make sure plot did NOT open up
figHandles = get(groot, 'Children');
assert(~any(figHandles==figNum));

%% Test cases start here. These are very simple, usually trivial
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  _______ ______  _____ _______ _____
% |__   __|  ____|/ ____|__   __/ ____|
%    | |  | |__  | (___    | | | (___
%    | |  |  __|  \___ \   | |  \___ \
%    | |  | |____ ____) |  | |  ____) |
%    |_|  |______|_____/   |_| |_____/
%
%
%
% See: https://patorjk.com/software/taag/#p=display&f=Big&t=TESTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Figures start with 2

close all;
fprintf(1,'Figure: 2XXXXXX: TEST mode cases\n');

%% TEST case: Load Encoder_diag diagnostic file
figNum = 20001;
titleString = sprintf('DEMO case: Load Encoder_diag diagnostic file');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); close(figNum);

filePath = fullfile(pwd,'Data','TestLoadData','_slash_Encoder_diag.csv');
datatype = 'diagnostic';
topicName = '/Encoder_diag';

% Call the function
structureDiagnostic = fcn_LoadRawDataToMATLAB_loadRawFromFile_Diagnostic(filePath, datatype, topicName, (figNum));
 
% sgtitle(titleString, 'Interpreter','none');

% Check variable types
assert(isstruct(structureDiagnostic))

% Check variable sizes
assert(size(structureDiagnostic,1)==1); 
assert(size(structureDiagnostic,1)==1); 

% Check variable values
% Too many

% % Make sure plot opened up
% assert(isequal(get(gcf,'Number'),figNum));

% Make sure plot did NOT open up
figHandles = get(groot, 'Children');
assert(~any(figHandles==figNum));


%% TEST case: Load Trigger_diag diagnostic file
figNum = 20002;
titleString = sprintf('DEMO case: Load Trigger_diag diagnostic file');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); close(figNum);

filePath = fullfile(pwd,'Data','TestLoadData','_slash_Trigger_diag.csv');
datatype = 'diagnostic';
topicName = '/Trigger_diag';

% Call the function
structureDiagnostic = fcn_LoadRawDataToMATLAB_loadRawFromFile_Diagnostic(filePath, datatype, topicName, (figNum));
 
% sgtitle(titleString, 'Interpreter','none');

% Check variable types
assert(isstruct(structureDiagnostic))

% Check variable sizes
assert(size(structureDiagnostic,1)==1); 
assert(size(structureDiagnostic,1)==1); 

% Check variable values
% Too many

% % Make sure plot opened up
% assert(isequal(get(gcf,'Number'),figNum));

% Make sure plot did NOT open up
figHandles = get(groot, 'Children');
assert(~any(figHandles==figNum));

%% Fast Mode Tests
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  ______        _     __  __           _        _______        _
% |  ____|      | |   |  \/  |         | |      |__   __|      | |
% | |__ __ _ ___| |_  | \  / | ___   __| | ___     | | ___  ___| |_ ___
% |  __/ _` / __| __| | |\/| |/ _ \ / _` |/ _ \    | |/ _ \/ __| __/ __|
% | | | (_| \__ \ |_  | |  | | (_) | (_| |  __/    | |  __/\__ \ |_\__ \
% |_|  \__,_|___/\__| |_|  |_|\___/ \__,_|\___|    |_|\___||___/\__|___/
%
%
% See: http://patorjk.com/software/taag/#p=display&f=Big&t=Fast%20Mode%20Tests
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Figures start with 8

close all;
fprintf(1,'Figure: 8XXXXXX: FAST mode cases\n');

%% Basic example - NO FIGURE
figNum = 80001;
fprintf(1,'Figure: %.0f: FAST mode, empty figNum\n',figNum);
figure(figNum); close(figNum);

filePath = fullfile(pwd,'Data','TestLoadData','_slash_Encoder_diag.csv');
datatype = 'diagnostic';
topicName = '/Encoder_diag';

% Call the function
structureDiagnostic = fcn_LoadRawDataToMATLAB_loadRawFromFile_Diagnostic(filePath, datatype, topicName, ([]));
 
% sgtitle(titleString, 'Interpreter','none');

% Check variable types
assert(isstruct(structureDiagnostic))

% Check variable sizes
assert(size(structureDiagnostic,1)==1); 
assert(size(structureDiagnostic,1)==1); 

% Check variable values
% Too many

% % Make sure plot opened up
% assert(isequal(get(gcf,'Number'),figNum));


% Make sure plot did NOT open up
figHandles = get(groot, 'Children');
assert(~any(figHandles==figNum));


%% Basic fast mode - NO FIGURE, FAST MODE
figNum = 80002;
fprintf(1,'Figure: %.0f: FAST mode, figNum=-1\n',figNum);
figure(figNum); close(figNum);

filePath = fullfile(pwd,'Data','TestLoadData','_slash_Encoder_diag.csv');
datatype = 'diagnostic';
topicName = '/Encoder_diag';

% Call the function
structureDiagnostic = fcn_LoadRawDataToMATLAB_loadRawFromFile_Diagnostic(filePath, datatype, topicName, (-1));
 
% sgtitle(titleString, 'Interpreter','none');

% Check variable types
assert(isstruct(structureDiagnostic))

% Check variable sizes
assert(size(structureDiagnostic,1)==1); 
assert(size(structureDiagnostic,1)==1); 

% Check variable values
% Too many

% % Make sure plot opened up
% assert(isequal(get(gcf,'Number'),figNum));


% Make sure plot did NOT open up
figHandles = get(groot, 'Children');
assert(~any(figHandles==figNum));


%% Compare speeds of pre-calculation versus post-calculation versus a fast variant
figNum = 80003;
fprintf(1,'Figure: %.0f: FAST mode comparisons\n',figNum);
figure(figNum);
close(figNum);

filePath = fullfile(pwd,'Data','TestLoadData','_slash_Encoder_diag.csv');
datatype = 'diagnostic';
topicName = '/Encoder_diag';


 
Niterations = 10;

% Do calculation without pre-calculation
tic;
for ith_test = 1:Niterations
    % Call the function
    structureDiagnostic = fcn_LoadRawDataToMATLAB_loadRawFromFile_Diagnostic(filePath, datatype, topicName, ([]));
end
slow_method = toc;

% Do calculation with pre-calculation, FAST_MODE on
tic;
for ith_test = 1:Niterations
    % Call the function
    structureDiagnostic = fcn_LoadRawDataToMATLAB_loadRawFromFile_Diagnostic(filePath, datatype, topicName, (-1));
end
fast_method = toc;

% Make sure plot did NOT open up
figHandles = get(groot, 'Children');
assert(~any(figHandles==figNum));

% Plot results as bar chart
figure(373737);
clf;
hold on;

X = categorical({'Normal mode','Fast mode'});
X = reordercats(X,{'Normal mode','Fast mode'}); % Forces bars to appear in this exact order, not alphabetized
Y = [slow_method fast_method ]*1000/Niterations;
bar(X,Y)
ylabel('Execution time (Milliseconds)')


% Make sure plot did NOT open up
figHandles = get(groot, 'Children');
assert(~any(figHandles==figNum));


%% BUG cases
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  ____  _    _  _____
% |  _ \| |  | |/ ____|
% | |_) | |  | | |  __    ___ __ _ ___  ___  ___
% |  _ <| |  | | | |_ |  / __/ _` / __|/ _ \/ __|
% | |_) | |__| | |__| | | (_| (_| \__ \  __/\__ \
% |____/ \____/ \_____|  \___\__,_|___/\___||___/
%
% See: http://patorjk.com/software/taag/#p=display&v=0&f=Big&t=BUG%20cases
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% All bug case figures start with the number 9

% close all;

%% BUG 

%% Fail conditions
if 1==0
    %% ERROR for bad data folder
    bagName = "badData";
    rawdata = fcn_LoadRawDataToMATLAB_loadMappingVanDataFromFile(bagName, bagName);
end


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


% 
% %% Functions
% function lastPart = fcn_INTERNAL_findSequenceNumber(nameString) 
% % Finds the last part of a string, the part after the very last underscore
% % and returns this as a number
% if ~contains(nameString,'_')
%     lastPart = nan;
% else
%     stringLeft = nameString;
%     while contains(stringLeft,'_')
%         stringLeft = extractAfter(stringLeft,'_');
%     end
%     lastPart = str2double(stringLeft);
% end
% end
