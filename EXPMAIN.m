% File that runs the experiment.

% Nick Hedger & gizemkucukoglu       
% Main Changes made by NH:         
     
% 1) Added GUI (only important fields are session/block number/
% filename and binocular/ monocular).
% 2) Allow for stopping experiment after each trial and loading from where
% participants quitted. 
% 3) Everything is bundled into a structure (InputDatastruct) / .mat file to stop spitting out
% loads of files.
% 4) Added fixed trial order checkbox for debugging.
% 5) A log file is printed with a .txt file of experiment events.

% Binocular session = 486 trials (2 light fields x 9 gloss levels x 9 depth values x 3 stereo conditions) 
% Monocular session = 162 trials (2 light fields x 9 gloss levels x 9 depth values x 1 stereo condition/ mono) 

% Total = 648 trials

clear all

%% Use GUI to get subject info
% Runs the GUI
% Create main experimental structure.
InputDatastruct=struct();
InputDatastruct=RunExp;
% Subject number
nsub = InputDatastruct.nsub;
% Initials (mandatory, for creating filename)
subjInitials = InputDatastruct.subname;  
% Sex
subsex = InputDatastruct.subsex;
% Age
subage = InputDatastruct.subage;
% Session (mandatory)
session   = InputDatastruct.nblock;
% Note
subnote = InputDatastruct.subnote;
% Fixed or random order. Leave unchecked for experiment so that the trial
% order randomizes.
isfixed = InputDatastruct.isfixed;

%% Ensure sessions have different filenames.
if InputDatastruct.isbinocular==0 && InputDatastruct.ismonocular==0
    error('Please re-run the GUI and select either monocular or binocular session')
end

if InputDatastruct.isbinocular==1
 GlossShapeYardstickExp_Mouse_NH_BINOC(subjInitials,session,InputDatastruct);
else

%     Currently the monocular block is split into 2 sessions (simply
%     because this is the way it was before. The two sessions are saved in
%     different locations in the structure.
if session ==1
    datadir='S1';
elseif session ==2
    datadir='S2';
end
 GlossShapeYardstickExp_Mouse_NH(subjInitials,session,InputDatastruct);
end

% 
% %% Run experiment with info gained from GUI.
% 
