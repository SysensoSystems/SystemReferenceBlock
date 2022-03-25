%% *|System Reference Block|*
%
% *System Reference Block* helps to refer the logic of a preferred Subsystem or Model.
% This block overcomes the limitations of Model Reference and combines the advanatages of Library Reference.
%
% Developed by: <http://www.sysenso.com Sysenso Systems>
%
% Contact: contactus@sysenso.com
%
% *Version Log*
% 1.0 - Initial Version
%
% *|Prerequisite|*
%
% * SIMULINK version 2016b-2021a
%
%% *|Advantages of using System Reference block|*
%
% # Referenced model configuration settings will not affect the model
% reference usage
% # System Reference Block just copies the logic of the desired system as like library reference, 
% whereas Model Reference block actually refers the system selected.
% # Virtual bus can pass the model boundries.
% # Goto and From blocks can cross system reference boundaries.
% # With System Reference block, we need reference Model or Subsystem.
%

%% *How to launch it:*
%
% 1. Add the utils folder to the path.
%
% <<\Images\addToPath.png>>
%
% 2. Open the library browser and select *System Reference* on the left pane.
% If not available, Enter the command *sl_refresh_customizations* in the command window and then open library browser.
%
% 3. Drag and Drop the *System Reference Block* on the right pane into the required system just like any other block.
%
% <<\Images\libraryBrowser.png>>
%
%% *Usage instructions*
%
% 1. Double click the System Reference block to open the *System Reference
% Block GUI*.
%
% <<\Images\systemReferenceGUI.png>>
%
% 2. Select the reference type.
%
% * System Reference block allows the user to select two types of reference.
%
% # Model Reference.
% # Subsystem Reference.
%
% 3. For Model Reference, browse the parent Model using Browse button.
% For Subsystem Reference, select the parent Subsystem and then click the GCB button.
%
%
% <<\Images\modelGUI.png>>
%
%
% <<\Images\subSystemGUI.png>>
%
%
% 4. Click *Apply*.
%
% 5. Now the selected Model is referred in the child Model.
%
% * In *System Reference Block*, only logic is copied. So when this block is
% viewed under mask, a copy of selected Model or subSystem will be placed into this block. A
% sample image is shown below.
%
%
% *Reference Type: Model*
%
%
% <<\Images\referencedModel.png>>
%
%
% *Reference Type: Subsystem*
%
%
% <<\Images\referencedsubSystem.png>>
%
%
%% *Context Menu*
%
% A set of new custom context menus are provided with the System Reference Block under the name "System Reference".
%
%
% <<\Images\contextMenu.png>>
%
%
% 1. Refresh Link: Checks whether the link exists between the child and the parent
% Model. If the process is unable to establish link which is either due to
% renaming the parent model/subsystem or the parent model is not in path,
% the foreground color of System Reference Block is changed to red.
%
% 2. Detect Changes: Compares the child and parent Model or subSystem for
% any block level changes or parameter changes. A text file stored in
% tempdir contains the list of changes between child and parent. If changes
% were found, the foreground color of System Reference Block is changed to
% magenta. Successful pull or push from context menu restores the original
% foreground color.
%
% 3. Pull Changes: Updates the child (System Reference Block) with the
% changes from the parent.
%
% 4. Push Changes: Updates the parent model or subSystem with the changes
% from the child.
%
% 5. Open Block: Opens the current System Reference Block to expose the
% contents inside it.
%
% 6. Open Block Parameters: Opens the GUI for System Reference.


