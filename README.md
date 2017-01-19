# GlossShapeExp_NH
Gloss experiment with stereo implemened.

Gloss/ stereo experiment.

Summary of main changes made:

1) Added GUI
2) Allowed for participants to quit at any time at the end of each trial.
3) Everything is now bundled into a big structure rather than spitting out loads of files
4) Added fixed trial order for debugging.
5) Spits out a log.txt file for each particpant, with trial info and timing of events.
6) Binocular session and monocular session implemented:

Binocular session = 486 trials (2 light fields x 9 gloss levels x 9 depth values x 3 stereo conditions) 
Monocular session = 162 trials (2 light fields x 9 gloss levels x 9 depth values x 1 stereo condition (mono)) 

Stimuli are 15 cm on the monitors in the SS lab.

The main file that drives the experiment is EXPMAIN.m. 

Still to do:

1) Run pilot


