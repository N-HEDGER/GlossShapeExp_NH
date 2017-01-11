# GlossShapeExp_NH
Gloss experiment with stereo implemened.

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

The main file that drives the experiment is EXPMAIN.m
