function sl_customization(cm)
%% Register custom menu function.

cm.addCustomMenuFcn('Simulink:PreContextMenu',@getMyMenuItems);
end

%% Define the custom menu function.
function schemaFcns = getMyMenuItems(callbackInfo)

schemaFcns = {@SystemReferenceMenu};
end

%% Define container schema for context menu items.
function schema = SystemReferenceMenu(callbackInfo,blockPath)

currentBlock = gcb;
try
    if strcmp(get_param(currentBlock,'SystemReferenceBlock'),'on')
        schema = sl_container_schema;
        schema.label = 'System Reference';
        schema.childrenFcns = {@refreshLinkMenu, @detectChangesMenu ,@pullChangesMenu, @pushChangesMenu, @openBlockMenu ,@openBlockParameterMenu};
        schema.state = 'Enabled';
    else
        schema.state = 'Hidden';
    end
catch
    schema.state = 'Hidden';
end
end

%% Define action schema for detecting changes in systems
function schema = refreshLinkMenu(callbackInfo,blockPath)

currentBlock = gcb;
schema = sl_action_schema;
schema.label = 'Refresh Link';
schema.callback = @refreshLinkCallback;
userDataFlag = get_param(currentBlock,'userdata');
if ~isempty(userDataFlag)
    schema.state = 'Enabled';
else
    schema.state = 'Disabled';
end
end
%% Define callback for LookForChanges function
function refreshLinkCallback(callbackInfo)

currentBlock = gcb;
blockUserdata = get_param(currentBlock,'userdata');
try
    load_system(blockUserdata.modelName);
    set_param(currentBlock,'ForegroundColor','black');
    msgbox('Link Refreshed');
catch
    msgbox('Cannot connect to Parent, Please add parent in path','Error');
    set_param(currentBlock,'ForegroundColor','red');
end
end

%% Compares the parent and child for changes using in-built visdiff function
function schema = detectChangesMenu(callbackInfo,blockPath)

currentBlock = gcb;
schema = sl_action_schema;
blockUserdata = get_param(currentBlock,'userdata');
schema.label = 'Detect Changes';
schema.callback = @detectChangesCallback;
if ~isempty(blockUserdata)
    schema.state = 'Enabled';
else
    schema.state = 'Disabled';
end
end
%% Callback for detectChangesMenu function
function detectChangesCallback(callbackInfo)

currentBlock = gcb;
blockUserdata = get_param(currentBlock,'userdata');
if blockUserdata.useOption == 1
    foundChanges = findDifference(currentBlock,blockUserdata.modelName,1);
else
    foundChanges = findDifference(currentBlock,blockUserdata.subSystemName,1);
end
if foundChanges
    filePath = [tempdir 'Changes.txt'];
    open(filePath);
    set_param(currentBlock,'ForegroundColor','magenta');
else
    msgbox('No changes detected');
end
end

%% Define action schema for pulling changes from parent
function schema = pullChangesMenu(callbackInfo,blockPath)

currentBlock = gcb;
schema = sl_action_schema;
blockUserdata = get_param(currentBlock,'userdata');
schema.label = 'Pull Changes';
schema.callback = @pullChangesCallback;
if ~isempty(blockUserdata)
    schema.state = 'Enabled';
else
    schema.state = 'Disabled';
end
end
%% Update the reference block if there is change in refered model.
function pullChangesCallback(callbackInfo)

currentBlock = gcb;
set_param(currentBlock,'ForegroundColor','black');
createSystemReference(currentBlock);
msgbox('SystemReference block updated successfully');

end

%% Define action schema for pushing changes to parent
function schema = pushChangesMenu(callbackInfo,blockPath)

currentBlock = gcb;
schema = sl_action_schema;
blockUserdata = get_param(currentBlock,'userdata');
schema.label = 'Push Changes';
schema.callback = @pushChangesCallback;
if ~isempty(blockUserdata)
    schema.state = 'Enabled';
else
    schema.state = 'Disabled';
end

end
%% Update the parent if there is change in referenced model.
function pushChangesCallback(callbackInfo)

currentBlock = gcb;
userDataObj = get_param(currentBlock,'userdata');
if userDataObj.useOption == 1
    % Copy the content of the SystemReference block to parent model.
    try
        set_param(currentBlock,'ForegroundColor','black');
        Simulink.BlockDiagram.deleteContents(userDataObj.modelName);
        Simulink.SubSystem.copyContentsToBlockDiagram(currentBlock,userDataObj.modelName);
    catch
        msgbox('Process failed','Error');
        set_param(currentBlock,'ForegroundColor','magenta');
        return;
    end
elseif userDataObj.useOption == 2
    untitledSystemHandle = new_system;
    % Copy the content of the SystemReference block to parent subsystem.
    try
        set_param(currentBlock,'ForegroundColor','black');
        Simulink.SubSystem.copyContentsToBlockDiagram(currentBlock,untitledSystemHandle);
        Simulink.SubSystem.deleteContents(userDataObj.subSystemName);
        Simulink.BlockDiagram.copyContentsToSubSystem(untitledSystemHandle,userDataObj.subSystemName);
    catch
        msgbox('Process failed','Error');
        set_param(currentBlock,'ForegroundColor','magenta');
        return;
    end
    delete(untitledSystemHandle);
end
msgbox('SystemReference parent updated successfully');

end

%% Opens the logic inside the System Reference block (Alternative to "Look Under Mask")
function schema = openBlockMenu(callbackInfo,blockPath)
    
currentBlock = gcb;
schema = sl_action_schema;
blockUserdata = get_param(currentBlock,'userdata');
schema.label = 'Open Block';
schema.callback = @openBlockCallback;
if ~isempty(blockUserdata)
    schema.state = 'Enabled';
else
    schema.state = 'Disabled';
end
end

function openBlockCallback(callbackInfo)

currentBlock = gcb;
open_system(currentBlock,'force');

end
%% Block parameters
function schema = openBlockParameterMenu(callbackInfo,blockPath)

schema = sl_action_schema;
schema.state = 'Enabled';
schema.label = 'Open Block Parameters';
schema.callback = @openBlockParameterCallback;

end
%% Callback for openBlockParameterMenu function: Block paramter with the loaded setting in shown.
function openBlockParameterCallback(callbackInfo)

currentBlock = gcb;
systemReferenceBlockGUI(currentBlock,0);

end