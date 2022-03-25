classdef SystemReferenceBlockClass < handle
    % SystemReferenceBlockClass opens a dialog box where user can browse
    % the desired model or subsystem and select the type of referencing.
    % 1. Model Reference
    % 2. Sub-System Reference
    %
    % Syntax: SystemReferenceBlockClass(<blockPath>,<skipGUILoad>);
    %
    % <blockPath>   - Block Path.
    % <skipLoadGUI> - 0 (or) 1.
    % 0 - shows the System Reference GUI
    % 1 - Opens the refered model.
    %
    % Example: SystemReferenceBlockClass(gcb,0)
    
    properties (Hidden)
        figureHandle
        aboutPanel
        parametersPanel
        browseContainer
        browseButton
        openButton
        modelNameEditBox
        referencePopupMenu
        modelRefContainer
        pushButtonContainer
        applyButton
        closeButton
        helpButton
        screenSize
        figureHeight
        subSystemContainer
        subSystemNameEdit
        gcbButton
    end
    properties
        modelName
        fileName
        filePath
        blockPath
        useOption
    end
    %----------------------------------------------------------------------
    methods
        function obj = SystemReferenceBlockClass(blockPath,skipLoadGUI)
            % Open the model if the model is browsed already.
            
            blockUserdata = get_param(blockPath,'Userdata');
            if ~isempty(blockUserdata) && skipLoadGUI
                if isequal(blockUserdata.useOption,2)
                    try
                        load_system(blockUserdata.modelName);
                        open_system(blockUserdata.subSystemName);
                        return;
                    catch
                        msgbox(['Please make sure that the model ' blockUserdata.modelName ' is added to path'], 'Error');
                        return;
                    end
                else
                    try
                        open_system(blockUserdata.modelName);
                        return;
                    catch
                        msgbox(['Please make sure that the model ' blockUserdata.modelName ' is added to path'], 'Error');
                        return;
                    end
                end
            end
            % Open the already exisitng figure else open a new figure.
            figureObject = findobj('Name','Block Parameters: System Reference');
            if ~isempty(figureObject)
                figure(figureObject);
                return;
            end
            % Initialization.
            obj.blockPath = blockPath;
            set_param(obj.blockPath,'LinkStatus','none');
            set_param(obj.blockPath,'UserDataPersistent','on');
            loadFlag = 0;
            obj.figureHeight = 0.3;
            if ~isempty(blockUserdata)
                loadFlag = 1;
            end
            % Set the GUI size.
            obj.screenSize = get(0,'ScreenSize');
            obj.figureHandle = figure('Name','Block Parameters: System Reference','NumberTitle','off','Visible','off','Menubar','none','Toolbar','none','resize','on');
            set(obj.figureHandle,'Units','Pixels','Position',[0.3*obj.screenSize(3) 0.1*obj.screenSize(4) 0.45*obj.screenSize(3) 0.2*obj.screenSize(4)]);
            movegui(obj.figureHandle,'center');
            mainContainer = uiflowcontainer('v0','Parent',obj.figureHandle);
            % About Panel.
            set(mainContainer,'FlowDirection','TopDown');
            obj.aboutPanel = uipanel('parent',mainContainer,'Title','System Reference Block','FontSize',10);
            aboutString = 'System Reference Block allows the user to refer a logic from a Model or a Subsystem.';
            aboutContainer = uiflowcontainer('v0','parent',obj.aboutPanel);
            set(aboutContainer,'FlowDirection','LefttoRight');
            uicontrol('parent',aboutContainer,'Style','text','String',aboutString,'Min',3,'HorizontalAlignment','left','FontSize',10);
            set(obj.aboutPanel,'HeightLimits',[60,60]);
            % Paramters Panel.
            obj.parametersPanel = uipanel('parent',mainContainer,'Title','Parameters','FontSize',10);
            parametersMainContainer = uiflowcontainer('v0','Parent',obj.parametersPanel);
            set(parametersMainContainer,'FlowDirection','TopDown');
            % Reference type.
            referenceContainer = uiflowcontainer('v0','Parent',parametersMainContainer);
            set(referenceContainer,'FlowDirection','LefttoRight');
            set(referenceContainer,'HeightLimits',[30,30]);
            referenceText = uicontrol('parent',referenceContainer,'Style','checkbox','CData',nan(1,1,3),'String','Select the reference type','HorizontalAlignment','center','FontSize',10);
            set(referenceText,'WidthLimits',[180 180]);
            obj.referencePopupMenu = uicontrol('parent',referenceContainer,'Style','popupmenu','String',{'Model','Subsystem'},'FontSize',10);
            % Model Browser.
            obj.browseContainer = uiflowcontainer('v0','Parent',parametersMainContainer);
            set(obj.browseContainer,'FlowDirection','LefttoRight');
            set(obj.browseContainer,'HeightLimits',[30,30]);
            mdlText = uicontrol('parent',obj.browseContainer,'Style','checkbox','CData',nan(1,1,3),'String','Model Name','HorizontalAlignment','center','FontSize',10);
            set(mdlText,'WidthLimits',[80 80]);
            obj.modelNameEditBox = uicontrol('parent',obj.browseContainer,'Style','edit','FontSize',10,'HorizontalAlignment','left');
            obj.browseButton = uicontrol('parent',obj.browseContainer,'Style','pushbutton','String','Browse','FontSize',10);
            set(obj.browseButton,'WidthLimits',[60 60]);
            obj.openButton = uicontrol('parent',obj.browseContainer,'Style','pushbutton','String','Open','FontSize',10);
            set(obj.openButton,'WidthLimits',[60 60]);
            set(obj.browseContainer,'visible','on');
            % Subsystem
            obj.subSystemContainer = uiflowcontainer('v0','Parent',parametersMainContainer);
            set(obj.subSystemContainer,'FlowDirection','LefttoRight');
            set(obj.subSystemContainer,'HeightLimits',[30,30]);
            subText = uicontrol('parent',obj.subSystemContainer,'Style','checkbox','CData',nan(1,1,3),'String','Subsystem Name','HorizontalAlignment','center','FontSize',10);
            set(subText,'WidthLimits',[180 180]);
            obj.subSystemNameEdit = uicontrol('parent',obj.subSystemContainer,'Style','edit','String','','UserData','');
            obj.gcbButton = uicontrol('parent',obj.subSystemContainer,'Style','Pushbutton','String','GCB','FontSize',10);
            set(obj.gcbButton,'WidthLimits',[60 60]);
            set(obj.subSystemContainer,'visible','off');
            % Pusbbuttons - Apply,help and Close.
            obj.pushButtonContainer = uiflowcontainer('v0','parent',parametersMainContainer);
            set(obj.pushButtonContainer,'HeightLimits',[30 30]);
            uicontainer('parent',obj.pushButtonContainer);
            obj.applyButton = uicontrol('parent',obj.pushButtonContainer,'Style','Pushbutton','String','Apply','FontSize',10);
            set(obj.applyButton,'WidthLimits',[60 60]);
            obj.closeButton = uicontrol('parent',obj.pushButtonContainer,'Style','Pushbutton','String','Close','FontSize',10);
            set(obj.closeButton,'WidthLimits',[60 60]);
            obj.helpButton = uicontrol('parent',obj.pushButtonContainer,'Style','Pushbutton','String','Help','FontSize',10);
            set(obj.helpButton,'WidthLimits',[60 60]);
            uicontainer('parent',obj.pushButtonContainer);
            % Callbacks.
            set(obj.browseButton,'Callback',@(h,e)browseButtonCallback(obj,h,e));
            set(obj.openButton,'Callback',@(h,e)openButtonCallback(obj,h,e));
            set(obj.referencePopupMenu,'Callback',@(h,e)referencePopupCallback(obj,h,e));
            set(obj.gcbButton,'Callback',@(h,e)gcbButtonCallback(obj,h,e));
            set(obj.applyButton,'Callback',@(h,e)applyButtonCallback(obj,h,e));
            set(obj.closeButton,'Callback',@(h,e)closeButtonCallback(obj,h,e));
            set(obj.helpButton,'Callback',@(h,e)helpButtonCallback(obj,h,e));
            % Load the data if already set.
            if loadFlag
                loadData(obj,blockUserdata);
            else
                obj.useOption = 1;
            end
            set(obj.figureHandle,'visible','on');
        end
        
        %------------------------------------------------------------------
        function gcbButtonCallback(obj,~,~)
            % Outputs the blockpath of the selected block
            
            currentBlock = gcb;
            if isempty(currentBlock)
                msgbox('No subsystem has been selected.','Error');
                return;
            elseif isequal(currentBlock,obj.blockPath)
                msgbox('System Reference block can''t refer by itself. Please select a different Subsystem.','Error');
                return;
            else
                try
                    modelName = bdroot(currentBlock);
                    load_system(modelName);
                    allSubsystem = find_system(modelName,'BlockType','SubSystem');
                    if ~any(strcmp(currentBlock,allSubsystem))
                        msgbox('The subsystem is not present in the model file.','Error');
                        return;
                    end
                catch
                    msgbox('Invalid subsystem name','Error');
                    return;
                end
                set(obj.subSystemNameEdit,'String',strrep(currentBlock,char(10),' '));
                set(obj.subSystemNameEdit,'UserData',currentBlock);
                obj.modelName = modelName;
            end
        end
        
        %------------------------------------------------------------------
        function loadData(obj,blockUserdata)
            % Loads the available data in the GUI.
            
            set(obj.modelNameEditBox,'String',blockUserdata.modelName);
            obj.modelName = blockUserdata.modelName;
            % Reference Type.
            set(obj.referencePopupMenu,'Value',blockUserdata.useOption);
            obj.useOption = blockUserdata.useOption;
            if blockUserdata.useOption == 2
                set(obj.subSystemContainer,'visible','on');
                set(obj.browseContainer,'visible','off');
                set(obj.subSystemNameEdit,'String',strrep(blockUserdata.subSystemName,char(10),' '));
                set(obj.subSystemNameEdit,'UserData',blockUserdata.subSystemName);
            end
            obj.filePath = blockUserdata.filePath;
            load_system(obj.modelName);
        end
        
        %------------------------------------------------------------------
        function referencePopupCallback(obj,h,~)
            % Helps to refresh the contents of the block parameters when the
            % options in poup menu changed.
            
            popupValue = h.Value;
            if isequal(popupValue,1)
                % Enable the model reference paramters.
                set(obj.browseContainer,'visible','on');
                set(obj.modelRefContainer,'visible','on');
                set(obj.modelNameEditBox,'String','');
                set(obj.subSystemNameEdit,'String','','UserData','');
                set(obj.subSystemContainer,'visible','off');
            elseif isequal(popupValue,2)
                % Enable the subsystem reference paramters.
                set(obj.modelNameEditBox,'String','');
                set(obj.browseContainer,'visible','off');
                set(obj.modelRefContainer,'visible','off');
                set(obj.subSystemContainer,'visible','on');
            end
            obj.useOption = popupValue;
        end
        
        %------------------------------------------------------------------
        function browseButtonCallback(obj,~,~)
            % Browse the model.
            
            [obj.fileName,obj.filePath,~] = uigetfile({'*.slx';'*.mdl'},'Select the model');
            if obj.fileName == 0
                msgbox('Please select a valid model','Error');
                return;
            end
            obj.modelName = strtok(obj.fileName,'.');
            % Check if the filepath is in the MATLAB path.
            try
                load_system(obj.modelName);
            catch excObj
                if strcmpi(excObj.identifier,'Simulink:Commands:OpenSystemUnknownSystem')
                    % Ask the user to add the file path.
                    answer = questdlg('The selected model path is not in MATLAB path. Do you want to add the model path','Add model path','Yes','No','Yes');
                    if strcmp(answer,'Yes')
                        addpath(genpath(obj.filePath(1:end-1)));
                        try
                            load_system(obj.modelName);
                        catch excObj
                            if strcmpi(excObj.identifier,'Simulink:Commands:LoadingNewerModel')
                                errordlg(excObj.message, 'Model Version Error', 'modal');
                                return;
                            end
                        end
                    end
                elseif strcmpi(excObj.identifier,'Simulink:Commands:LoadingNewerModel')
                    errordlg(excObj.message, 'Model Version Error', 'modal');
                    return;
                else
                    return;
                end
            end
            % Set the model name in editbox.
            set(obj.modelNameEditBox,'String',obj.modelName);
        end
        
        %------------------------------------------------------------------
        function openButtonCallback(obj,~,~)
            % Open the system loaded.
            
            if ~isempty(obj.modelNameEditBox.String)
                open_system(obj.modelName);
            end
        end
        
        %------------------------------------------------------------------
        function applyButtonCallback(obj,~,~)
            % Get the essential data from GUI.
            
            if obj.useOption == 2
                subsystemPath = get(obj.subSystemNameEdit,'UserData');
                obj.modelName = bdroot(subsystemPath);
                saveUserdata.useOption = obj.useOption;
                saveUserdata.modelName = obj.modelName;
                saveUserdata.subSystemName = subsystemPath;
                saveUserdata.filePath = obj.filePath;
            else
                saveUserdata.useOption = obj.useOption;
                saveUserdata.modelName = obj.modelName;
                saveUserdata.filePath = obj.filePath;
            end
            set_param(obj.blockPath,'userdata',saveUserdata);
            % Create the system references.
            createSystemReference(obj.blockPath);
            % Store all collected data in block userdata.
            close(obj.figureHandle);
        end
        
        %------------------------------------------------------------------
        function closeButtonCallback(obj,~,~)
            
            close(obj.figureHandle);
        end
        
        %------------------------------------------------------------------
        function helpButtonCallback(obj,~,~)
            
            currentFilePath = mfilename('fullpath');
            utilsIndex = strfind(currentFilePath,'utils');
            rootFolder = currentFilePath(1:utilsIndex-2);
            docFolder = [rootFolder '\doc'];
            winopen([docFolder '\SystemReference_doc.pdf']);
        end
    end
end