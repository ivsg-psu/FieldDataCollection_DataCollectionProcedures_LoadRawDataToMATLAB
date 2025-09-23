function fcn_LoadRawDataToMATLAB_plotRawDataPositions(rawDataCellArray, varargin)
% fcn_LoadRawDataToMATLAB_plotRawDataPositions
% Produces plots of the data and, via optional saveFlag inputs, 
% can save images (PNG and FIG files) to user-chosen directories.
%
% FORMAT:
%
%      fcn_LoadRawDataToMATLAB_plotRawDataPositions(rawDataCellArray, (saveFlags), (plotFlags))
%
% INPUTS:
%
%      rawDataCellArray: a cell array of data structures containing data
%      fields filled for each ROS topic
%
%      (OPTIONAL INPUTS)
%
%      saveFlags: a structure of flags to determine how/where/if the
%      results are saved. The defaults are below
%
%         saveFlags.flag_saveImages = 0; % Set to 1 to save each image
%         file into the directory
%
%         saveFlags.flag_saveImages_directory = ''; % String with full
%         path to the directory where to save image files
%
%         saveFlags.flag_forceDirectoryCreation = 1; % Set to 1 to force
%         directory to be created if it does not exist
%
%         saveFlags.flag_forceImageOverwrite = 1; % Set to 1 to overwrite
%         existing files. If set to 0, and file exists, file will not be
%         created.
%
%      plotFlags: a structure of figure numbers to plot results. If set to
%      -1, skips any input checking or debugging, no figures will be
%      generated, and sets up code to maximize speed. The structure has the
%      following format:
%
%         plotFlags.fig_num_plotAllRawTogether = 1111; % This is the figure
%         where all the bag files are plotted together. Set to [] to NOT
%         plot results all together.
%
%         plotFlags.fig_num_plotAllRawIndividually = []; % This is the
%         number starting the count for all the figures that open,
%         individually, for each bag file after it is loaded. The figure
%         number is incremented for each plot. Set to [] to NOT
%         plot individual plots.
%
%     NOTE: the default values are those given above.
%
% OUTPUTS:
%
%      (none)
%
% DEPENDENCIES:
%
%      fcn_DebugTools_checkInputsToFunctions
%      fcn_LoadRawDataToMATLAB_plotRawData
%
% EXAMPLES:
%
%     See the script: script_test_fcn_LoadRawDataToMATLAB_plotRawDataPositions
%     for a full test suite.
%
% This function was written on 2025_09_20 by S. Brennan
% Questions or comments? sbrennan@psu.edu

% Revision history
% 2025_09_20 - Sean Brennan, sbrennan@psu.edu
% -- wrote the code originally using 
%    script_test_fcn_DataClean_loadRawDataFromDirectories as a starter

%% Debugging and Input checks

% Check if flag_max_speed set. This occurs if the fig_num variable input
% argument (varargin) is given a number of -1, which is not a valid figure
% number.
flag_max_speed = 0;
if (nargin==3 && isequal(varargin{end},-1))
    flag_do_debug = 0; % % % % Flag to plot the results for debugging
    flag_check_inputs = 0; % Flag to perform input checking
    flag_max_speed = 1;
else
    % Check to see if we are externally setting debug mode to be "on"
    flag_do_debug = 0; % % % % Flag to plot the results for debugging
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
    debug_fig_num = 999978; %#ok<NASGU>
else
    debug_fig_num = []; %#ok<NASGU>
end


%% check input arguments
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

if 0 == flag_max_speed
    if flag_check_inputs == 1
        % Are there the right number of inputs?
        narginchk(1,3);

    end
end

% Does user specify saveFlags?
% Set defaults
saveFlags.flag_saveImages = 0;
saveFlags.flag_saveImages_directory = '';
if 2 <= nargin
    temp = varargin{1};
    if ~isempty(temp)
        saveFlags = temp;
    end
end

% Does user want to specify plotFlags?
% Set defaults
plotFlags.fig_num_plotAllRawTogether = 1111;
plotFlags.fig_num_plotAllRawIndividually = [];
flag_do_plots = 1;
if (0==flag_max_speed) &&  (3<=nargin)
    temp = varargin{end};
    if ~isempty(temp)
        plotFlags = temp;
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

%% Make sure the image save directory is there if image save is requested.
if 1==saveFlags.flag_saveImages && 7~=exist(saveFlags.flag_saveImages_directory,'dir') && 0==saveFlags.flag_forceDirectoryCreation
    warning('on','backtrace');
    warning('Unable to find directory: %s',saveFlags.flag_saveImages_directory)
    error('Image save specified that copies image into a non-existing directory. Unable to continue.');
end

% Create the image save directory if needed
if 1==saveFlags.flag_saveImages && saveFlags.flag_forceDirectoryCreation 
    directoryName = saveFlags.flag_saveImages_directory;
    fcn_DebugTools_makeDirectory(directoryName);
end


%% Plot the results 
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

    if flag_do_debug
        fprintf(1,'\nBEGINNING PLOTTING: \n');
    end

    %% Plot all of them together?
    if ~isempty(plotFlags.fig_num_plotAllRawTogether)
        fig_num_plotAllRawTogether = plotFlags.fig_num_plotAllRawTogether;
        figure(fig_num_plotAllRawTogether);
        clf;

        % Test the function
        clear plotFormat
        plotFormat.LineStyle = '-';
        plotFormat.LineWidth = 2;
        plotFormat.Marker = 'none';
        plotFormat.MarkerSize = 5;

        legend_entries = cell(length(rawDataCellArray)+1,1);
        for ith_rawData = 1:length(rawDataCellArray)
            bagName = rawDataCellArray{ith_rawData}.Identifiers.SourceBagFileName;

            % Merged data structures have bagNames that are cell arrays.
            % Use the first one for the name
            if iscell(bagName)
                bagName = bagName{1};
            end
       
            if flag_do_debug
                fprintf(1,'\tPlotting file %.0d of %.0d: %s\n', ith_rawData, length(rawDataCellArray), bagName);
            end
            plotFormat.Color = fcn_geometry_fillColorFromNumberOrName(ith_rawData);
            colorMap = plotFormat.Color;
            fcn_LoadRawDataToMATLAB_plotRawData(rawDataCellArray{ith_rawData}, (bagName), (plotFormat), (colorMap), (fig_num_plotAllRawTogether))
            legend_entries{ith_rawData} = bagName;

        end

        % Plot the base station
        fcn_plotRoad_plotLL([],[],fig_num_plotAllRawTogether);
        legend_entries{end} = 'Base Station';

        h_legend = legend(legend_entries);
        set(h_legend,'Interpreter','none','FontSize',6)
    
        % Force the plot to fit
        geolimits('auto');

        title(rawDataCellArray{1}.Identifiers.WorkZoneScenario,'interpreter','none','FontSize',12)

        if length(legend_entries)>4
            for ith_entry = 1:length(legend_entries)-1
                legend_entries{ith_entry} = '';
            end
            legend_entries{1} = 'Individual runs';
            legend(legend_entries)
        end

        % Save the image to file?
        if 1==saveFlags.flag_saveImages
            imageDirectory = saveFlags.flag_saveImages_directory;
            destinationLastFileSep = find(imageDirectory==filesep,1,'last');
            imageName = imageDirectory(destinationLastFileSep+1:end);
            fcn_INTERNAL_saveImages(imageName, imageDirectory, saveFlags.flag_forceImageOverwrite);
        end

    end




    %% Plot all individually, and save all images and mat files
    if ~isempty(plotFlags.fig_num_plotAllRawIndividually)
        fig_num_plotAllRawIndividually = plotFlags.fig_num_plotAllRawIndividually;


        for ith_rawData = 1:length(rawDataCellArray)
            fig_num = fig_num_plotAllRawIndividually -1 +ith_rawData;
            figure(fig_num);
            clf;

            % Plot the base station
            fcn_plotRoad_plotLL([],[],fig_num);

            % Plot the data
            bagName = rawDataCellArray{ith_rawData}.Identifiers.SourceBagFileName;
            fcn_LoadRawDataToMATLAB_plotRawData(rawDataCellArray{ith_rawData}, (bagName), ([]), ([]), (fig_num))

            pause(0.1);


            % Save the image to file?
            if 1==saveFlags.flag_saveImages

                % Make sure bagName is good
                if contains(bagName,'.')
                    bagName_clean = extractBefore(bagName,'.');
                else
                    bagName_clean = bagName;
                end

                % Save to the name
                imageName = char(bagName_clean);
                imageDirectory = saveFlags.flag_saveImages_directory;                
                fcn_INTERNAL_saveImages(imageName, imageDirectory, saveFlags.flag_forceImageOverwrite);

            end

            % % Save the mat file?
            % if 1 == saveFlags.flag_saveMatFile
            %     fcn_INTERNAL_saveMATfile(rawDataCellArray{ith_rawData}, char(bagName_clean), saveFlags);
            % end
        end
    end


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


%% fcn_INTERNAL_saveImages
function fcn_INTERNAL_saveImages(imageName, imageDirectory, flag_forceImageOverwrite)
% Saves images to file

pause(2); % Wait 2 seconds so that images can load

% Save PNG file
Image = getframe(gcf);
PNG_image_fname = cat(2,imageName,'.png');
PNG_imagePath = fullfile(imageDirectory,PNG_image_fname);
if 2~=exist(PNG_imagePath,'file') || 1==flag_forceImageOverwrite
    imwrite(Image.cdata, PNG_imagePath);
end

% Save FIG file
FIG_image_fname = cat(2,imageName,'.fig');
FIG_imagePath = fullfile(imageDirectory,FIG_image_fname);
if 2~=exist(FIG_imagePath,'file') || 1==flag_forceImageOverwrite
    savefig(FIG_imagePath);
end
end % Ends fcn_INTERNAL_saveImages
