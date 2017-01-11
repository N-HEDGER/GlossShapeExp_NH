% File that runs the experiment.

% Nick Hedger & gizemkucukoglu       
% Main Changes made by NH:         
     
% 1) Added GUI (only important fields are session/block number and
% filename).
% 2) Allow for stopping experiment after each trial and loading from where
% participants quitted. 
% 3) Everything is bundled into a structure (InputDatastruct) / .mat file to stop spitting out
% loads of files.
% 4) Added fixed trial order checkbox for debugging.


% Need to fix prepare stim for the binocular presentation.
% Need to check scaling of responses.


clear all

%% Use GUI to get subject info
% Runs the GUI
InputDatastruct=struct();
InputDatastruct=RunExp;
% Subject number
nsub = InputDatastruct.nsub;
% Initials (mandatory)
subjInitials = InputDatastruct.subname;  
% Sex
subsex = InputDatastruct.subsex;
% Age
subage = InputDatastruct.subage;
% Session (mandatory)
session   = InputDatastruct.nblock;
% Note
subnote = InputDatastruct.subnote;
% Fixed or random order. Leave unchecked.
isfixed = InputDatastruct.isfixed;

%% Ensure sessions have different filenames.
if InputDatastruct.isbinocular==0 && InputDatastruct.ismonocular==0
    error('Please re-run the GUI and select either monocular or binocular session')
end

if InputDatastruct.isbinocular==1
 GlossShapeYardstickExp_Mouse_NH_BINOC(subjInitials,session,InputDatastruct);
else
    
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


         


