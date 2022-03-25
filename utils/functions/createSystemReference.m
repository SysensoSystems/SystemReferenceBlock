function createSystemReference(systemBlock)
% Helps to copy the logic for system referencing.
% Two types of references.
% useOption - 1(Model)
% useOption - 2(Subsystem)
%

userDataObj = get_param(systemBlock,'UserData');
Simulink.SubSystem.deleteContents(systemBlock);
set_param(systemBlock,'UserDataPersistent','on');
% Initially load the system.
try
    load_system(userDataObj.modelName);
catch
    msgbox(['Please ensure that the model ' userDataObj.modelName ' is added to path'],'Error');
    return;
end
if isequal(userDataObj.useOption,1)
    % Copy the content of the model to SystemReference block.
    try
        Simulink.BlockDiagram.copyContentsToSubSystem(userDataObj.modelName,systemBlock);
    catch
        msgbox('Process failed','Error');
        return;
    end
elseif isequal(userDataObj.useOption,2)
    [~,systemLocalModel] = fileparts(tempname);
    untitledSystemHandle = new_system(systemLocalModel);
    % Copy the content of the subsystem in a model to SystemReference block.
    try
        Simulink.SubSystem.copyContentsToBlockDiagram(userDataObj.subSystemName,untitledSystemHandle);
        Simulink.BlockDiagram.copyContentsToSubSystem(untitledSystemHandle,systemBlock);
    catch
        msgbox('Process failed','Error');
        bdclose(untitledSystemHandle);
        return;
    end
    bdclose(untitledSystemHandle);
end
% Add the model or Subsystem name to the mask.
if isequal(userDataObj.useOption, 2)
    blockName = [userDataObj.modelName ' : ' strrep(get_param(userDataObj.subSystemName,'Name'),char(10),' ')];
    maskDisplay = ['color(''black'')' char(10) 'disp(' ''''  blockName  '''' ')'];
else
    maskDisplay = ['color(''black'')' char(10) 'disp(' ''''  userDataObj.modelName  '''' ')'];
end
set_param(systemBlock,'MaskDisplay',maskDisplay);

end