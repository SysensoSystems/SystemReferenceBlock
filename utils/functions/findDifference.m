function [foundChanges,addedBlocks,removedBlocks,modifiedBlocks] = findDifference(reference, source, varargin)
% Helps to find the difference in blocks and parameters between reference and
% source model/subsystem
%
% Syntax:
% >> [foundChanges,addedBlocks,removedBlocks,modifiedBlocks] = findDifference(reference, source)
% >> foundChanges = findDifference(reference, source)
%
% reference - Reference block that has to be compared with a source copy.
% source - Source version of a model/subsystem.
% addedBlocks - blocks that are in reference but not in source
% removedBlocks - blocks that are in source but not in reference
% modifiedBlocks - blocks that have different parameters/values.
%

% Input validation.
if isempty(varargin{1})
    verboseMode = false;
else
    verboseMode = true;
end

load_system(strtok(reference,'/'));
load_system(strtok(source,'/'));
childBlocksOld = find_system(reference,'LookUnderMasks', 'on', 'type', 'block');
parentBlocks = find_system(source,'LookUnderMasks', 'on', 'type', 'block');
childBlocks = setdiff(childBlocksOld,reference);
parentBlocks = setdiff(parentBlocks,source);

% rename "SystemReference" to "corresponding model name" to avoid unwanted differences
childBlockAsParentBlock = regexprep(childBlocks, reference, source);
% Stores the parameter changes and block changes between reference and source
if verboseMode
    filePath = [tempdir 'Changes.txt'];
    fid = fopen(filePath, 'wt+');
end

modifiedBlocks = {};
for ind = 1:length(childBlocks)
    currentBlock = childBlockAsParentBlock{ind};
    if any(strcmp(childBlockAsParentBlock{ind}, parentBlocks))
        % if both reference and source has the block
        childBlockParams = get_param(childBlocks{ind}, 'DialogParameters');
        parentBlockParams = get_param(childBlockAsParentBlock{ind}, 'DialogParameters');
        if isstruct(childBlockParams)
            childParamFields = fieldnames(childBlockParams);
        else
            childParamFields = {};
        end
        if isstruct(parentBlockParams)
            parentParamFields = fieldnames(parentBlockParams);
        else
            parentParamFields = {};
        end
        
        % find the parameters with different values
        for k = 1:length(childParamFields)
            childParamValues = get_param(childBlocks{ind}, childParamFields{k});
            if strcmp(parentParamFields{k},childParamFields{k})
                parentBlockValues = get_param(childBlockAsParentBlock{ind}, childParamFields{k});
                if ~isequal(childParamValues, parentBlockValues)
                    if verboseMode
                        fprintf(fid,'Parameter Changes:\n');
                        fprintf(fid,'Block Path: %s \n', currentBlock);
                        fprintf(fid,'Block Name: %s \n', childParamFields{k});
                        fprintf(fid,'ParentValue: %s, ', num2str(parentBlockValues));
                        fprintf(fid,'ChildValue: %s\n', num2str(childParamValues));
                        fprintf(fid,'\n');
                    end
                    modifiedBlocks = [modifiedBlocks; currentBlock];
                end
            else
                if verboseMode
                    fprintf(fid,'Parameter Changes:\n');
                    fprintf(fid,'Block Path: %s \n', currentBlock);
                    fprintf(fid,'Parameter Name: %s \n', childParamFields{k});
                    fprintf(fid,'ParentValue: None , ChildValue: %s\n', num2str(childParamValues));
                    fprintf(fid,'\n');
                end
                modifiedBlocks = [modifiedBlocks; currentBlock];
            end
        end
    else
        continue;
    end
end

% Block difference between reference and source model/subsystem
removedBlocks = setdiff(parentBlocks, childBlockAsParentBlock);
addedBlocks = setdiff(childBlockAsParentBlock, parentBlocks);
modifiedBlocks = unique(modifiedBlocks);
if ~isempty(removedBlocks) || ~isempty(addedBlocks) || ~isempty(modifiedBlocks)
    if verboseMode
        fprintf(fid,'Changes in Blocks:');
        fprintf(fid,'\n');
        fprintf(fid,'Removed Blocks: %s\n', char(removedBlocks));
        fprintf(fid,'Added Blocks: %s\n', char(addedBlocks));
        fprintf(fid,'Modified Blocks: %s\n', char(modifiedBlocks));
    end
    foundChanges = true;
else
    foundChanges = false;
end
if verboseMode
    fclose(fid);
end

end