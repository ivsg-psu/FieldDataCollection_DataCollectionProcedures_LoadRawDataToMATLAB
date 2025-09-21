function fcn_DebugTools_replaceStringInDirectory(directoryPath, oldString, newString)
% Replaces 'oldString' with 'newString' in all files within 'directoryPath'.

% Get a list of all files in the directory
fileList = dir(fullfile(directoryPath, '*.*')); % Adjust file extension as needed

% Filter out directories from the list
fileList = fileList(~[fileList.isdir]);


for i = 1:length(fileList)
    fileName = fileList(i).name;
    if contains(fileName,newString)

        filePath = fullfile(directoryPath, fileName);
        numChanged = 0;
        numSkipped = 0;
        try
            % Read the entire file content
            fileContent = readlines(filePath);

            % Perform the string replacement
            modifiedContent = fileContent;
            for ith_line = 1:length(fileContent(:,1))
                thisLine = fileContent(ith_line,1);
                thisLineCharacters = char(thisLine);
                if contains(thisLine,oldString)
                    if thisLineCharacters(1)~='%'
                        modifiedContent(ith_line,1) = replace(thisLine, oldString, newString);
                        numChanged = numChanged+1;
                    else
                        numSkipped = numSkipped+1;
                    end
                end
            end

            % Write the modified content back to the file
            writelines(modifiedContent, filePath);

            if numChanged~=0
                temp = 2;
            end

            fprintf('Changed %.0f instances, skipped %.0f comments in %s\n', numChanged, numSkipped, fileName);
        catch ME
            warning('Error processing file %s: %s\n', fileName, ME.message);
        end % Ends try
    end % Ends check if file contains
end % Ends for loop
end % Ends function