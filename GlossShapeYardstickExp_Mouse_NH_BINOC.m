function GlossShapeYardstickExp_Mouse_NH_BINOC(subjInitials,session,InputDatastruct)

clc;

%% Prepare stimuli.

InputDatastruct=prepare_stim(InputDatastruct,session);


%% Psychtoolbox definitions.

Screen('Preference', 'SkipSyncTests', 1);
%load MyGammaTable
% PsychDefaultSetup(2);
AssertOpenGL;
KbName('UnifyKeyNames');

% Reseed the random-number generator for each expt.
rand('state',sum(100*clock));

% Define key names
resp = KbName('space');
t = KbName('ESCAPE');

%% File I/O handling.

% Define filenames of input files and result file:
datafilename = strcat('GlossYardstickExpBINO_',subjInitials,'.mat'); % name of data file to write to


log_text=sprintf('Data/%s_Binocular,log.txt',subjInitials{1});
log_text_fid=fopen(log_text,'a+');

% Navigate to the Data directory.
cd('Data')
% If the data filename exists, get rid of the loaded stimulus array.
if exist(datafilename{1})
    clear ('InputDatastruct')
%     Instead, load the structure that was saved the first time the
%     experiment was run.
    load(datafilename{1})

% If the datafile exists, prompt to check the number of trials already
% done.
X = [' You have done ',num2str(InputDatastruct.BINO.currenttrial),' trials'];
disp(X)
% Ask for response.
    Q1=input('That filename already exists. You have done the above number of trials in this session, correct [0= no, 1= yes]');
    if Q1==0
%         If incorrect, chose different initials.
        error('something has gone wrong')
    else
%         If correct, load the data and start at the next trial from where
%         they left off.

        InputDatastruct.BINO.data=InputDatastruct.BINO.data;
        InputDatastruct.BINO.currenttrial=InputDatastruct.BINO.currenttrial+1;
    end
else
%     If the datafile is a new one, then create a cell to store the data.
    InputDatastruct.BINO.data = cell(486,8);
    InputDatastruct.BINO.currenttrial=1;
end
% Navigate back to the main directory.
cd('../')


%% Initialize experiment.

try

    % Get screenNumber of stimulation display. We choose the display with
    % the maximum index, which is usually the right one, e.g., the external
    % display on a Laptop:
    screens = Screen('Screens');
    screenNumber = max(screens);
    
    
    IM_WIDTH_DISP=505;
    IM_HEIGHT_DISP=505;
    noisesize=100;
    noise = 255*rand([IM_HEIGHT_DISP+noisesize IM_WIDTH_DISP+noisesize]);
    
    % Hide the mouse cursor:
    HideCursor;
    
    % Returns as default the mean gray value of screen:
    gray = GrayIndex(screenNumber); 
    white = WhiteIndex(screenNumber);
    black = BlackIndex(screenNumber);
    
    % 'window' is the handle used to direct all drawing commands to that 
    % window. 'windowRect' is a rectangle defining the size of the window.
    PsychImaging('PrepareConfiguration');
    PsychImaging('AddTask', 'General', 'UseFastOffscreenWindows');
    
      [window, windowRect] = PsychImaging('OpenWindow', 0, gray);
    %Screen('LoadNormalizedGammaTable', window, gammaTable*[1 1 1]);

    % Get the size of the on screen window
    [screenXpixels, screenYpixels] = Screen('WindowSize', window);

    % Set text size 
    Screen('TextSize', window, 32);
    
    % Do dummy calls to GetSecs, WaitSecs, KbCheck to make sure
    % they are loaded and ready when we need them - without delays
    % in the wrong moment:
    KbCheck;
    WaitSecs(0.1);
    GetSecs;

    % Set priority for script execution to realtime priority:
    priorityLevel=MaxPriority(window);
    Priority(priorityLevel);
    

    phaselabel='test';

    
    % Write instruction message for subject, centered in the
    % middle of the display, in white color.
    str=sprintf('Match the glossiness and bumpiness of the stimuli on the screen\n with the real objects to your left\n When you make your settings hit space to continue to next trial\n');
    message = ['test phase ...\n' str '... press mouse button to begin ...'];
  
  [xCenter, yCenter] = RectCenter(windowRect);
    [widthW, heightW] = Screen('WindowSize', 0);
    
    wRectL = [0 0 widthW/2 heightW];
    wRectR = [(widthW/2)+1 0  widthW heightW];
    
    [xCenterL, yCenterL] = RectCenter(wRectL);
    [xCenterR, yCenterR] = RectCenter(wRectR);
    
     % Draw instruction text:
    DrawFormattedText(window, message, xCenterL, yCenterL, WhiteIndex(window),[],1);
    DrawFormattedText(window, message, xCenterR, yCenterR, WhiteIndex(window),[],1);   
    
    % Update the display to show the instruction text:
    Screen('Flip', window);
    
    % Wait for mouse click:
    GetClicks(window);
    
    % Clear screen to background color (our 'gray' as set at the
    % beginning):
    Screen('Flip', window);
    
    % Wait a second before starting trial
    WaitSecs(1.000);
    
%     Define experiment stop point for for loop.
     ntrials=length(InputDatastruct.BINO.objnumber); 

    %%%%%%%%%%%%%%%%%%%%%%
    % slider bar stuff
    %%%%%%%%%%%%%%%%%%%%%%   
    % Get the centre coordinate of the window
    [xCenter, yCenter] = RectCenter(windowRect);
    
    % Make a base rectangle for the selector
    selectRect = [0 0 10 40];
    
    % Make a base rectangle for the slider bar
    baseBar_xSize = 600;
    baseBar_ySize = 10;
    baseBar =[0 0 baseBar_xSize baseBar_ySize];
    
   
    bar_xPosition = xCenterL - (baseBar_xSize/2);
    bar_yPosition = screenYpixels*0.9;
  
    % Make a rectangle for the ticks on the slider bar
    tick = [0 0 4 10];
    
    
    [imRectL,dh,dv] = CenterRect([0 0 IM_WIDTH_DISP IM_HEIGHT_DISP], wRectL)
    [imRectR,dh,dv] = CenterRect([0 0 IM_WIDTH_DISP IM_HEIGHT_DISP], wRectR)
    
    [noiserectL,dh,dv] = CenterRect([0 0 IM_WIDTH_DISP+noisesize IM_HEIGHT_DISP+noisesize], wRectL)
    [noiserectR,dh,dv] = CenterRect([0 0 IM_WIDTH_DISP+noisesize IM_HEIGHT_DISP+noisesize], wRectR)
    
    
    % Define blue color
    blue = [0 0 255];
    
    % Here we set the initial position of the mouse to be in the centre of the
    % slider bar
   SetMouse(xCenterL, bar_yPosition, window);
    
    % We now set the slider bars' initial position 
    sx = xCenterL;
    sx2 = xCenterL;
    bumpRect = OffsetRect(selectRect, sx, bar_yPosition);
    glossRect = OffsetRect(selectRect, sx2, bar_yPosition+100);
    

    log_txt=sprintf('Subject is doing binocular block');
    fprintf(log_text_fid,'%s\n',log_txt);
    current_time=GetSecs;
    log_txt=sprintf('Experimental loop begin at %f',current_time);
    fprintf(log_text_fid,'%s\n',log_txt);
    log_txt=sprintf('Experimental loop begin at %s',num2str(clock));
    fprintf(log_text_fid,'%s\n',log_txt);


    formatSpec=('Trial %s Stimulus: %s');
    formatSpecTexture=('Textures drawn at: %f');
    formatSpecFlip=('Textures flipped at: %f');
    formatSpecResponse=('Response made at: %f');
    formatSpecQuit=('Subject quitted at: %s');
    
    
    
    
      

    % loop through trials
    for trial=InputDatastruct.BINO.currenttrial:ntrials
        

        WaitSecs(0.500);
        
        % initialize KbCheck and variables to make sure they're
        % properly initialized/allocted by Matlab - this to avoid time
        % delays in the critical reaction time measurement part of the
        % script:
        
        % Load the first stimulus file name based on the data in structure.
        stimfilenameL=char(InputDatastruct.BINO.objnameL{trial}(1));
        stimfilenameR=char(InputDatastruct.BINO.objnameR{trial}(1));
        
        imdataL=load(char(stimfilenameL));
        imdataR=load(char(stimfilenameR));

                trialtxt=num2str(trial);
        stimtxt=stimfilenameL;
        log_txt=sprintf(formatSpec,trialtxt,stimtxt);
        fprintf(log_text_fid,'%s\n',log_txt);
        jRobot=java.awt.Robot;
        
        
        while 1 

%             ShowCursor;
            % make texture image out of image matrix.
            texL=Screen('MakeTexture', window, fliplr(im2uint8(imdataL.gammaCorrected)));
            texR=Screen('MakeTexture', window, fliplr(im2uint8(imdataR.gammaCorrected)));
            
            
          
            noisetex=Screen('MakeTexture', window, noise);
            
            
    
            % Draw texture image to backbuffer. It will be automatically
            % centered in the middle of the display if you don't specify a
            % different destination:
            imgxLeft = screenXpixels/2 - 550/2;
            imgxRight = imgxLeft + 550;
            imgyTop = screenYpixels*0.15;
            imgyBottom = imgyTop + 550;

            
                        Screen('DrawTexture', window, noisetex, [], [noiserectL]);    
            Screen('DrawTexture', window, noisetex, [], [noiserectR]);
            
            Screen('DrawTexture', window, texL, [], [imRectL]);    
            Screen('DrawTexture', window, texR, [], [imRectR]);
            

            Screen('TextSize', window, 16);
            
            baseBarBump = OffsetRect(baseBar, bar_xPosition, bar_yPosition);
            rectColor = [0 0 0];
            Screen('FillRect', window, rectColor, baseBarBump);
            
            baseBarGloss = OffsetRect(baseBar, bar_xPosition, bar_yPosition+100);
            rectColor2 = [0 0 0];
            Screen('FillRect', window, rectColor2, baseBarGloss);
            
            
            
            % add ticks to the bar, bar is 1000 pixels in x-dimension so the ticks
            % should be at every 100th
            vec=0:60:600;
            for i=0:60:600
                
                tick_offset = OffsetRect(tick, bar_xPosition+i-2, bar_yPosition+20);
                Screen('FillRect', window, rectColor, tick_offset);
                tick_offset2 = OffsetRect(tick, bar_xPosition+i-2, bar_yPosition+120);
                Screen('FillRect', window, rectColor, tick_offset2);
                % Write the number text
                message = strcat(int2str((length(vec)-round(i/60))));
                message2 = strcat(num2str((length(vec)-round(i/60))));
                DrawFormattedText(window, message, bar_xPosition+i-4, (bar_yPosition+30), white, [], 1,[],[]);
                DrawFormattedText(window, message2, bar_xPosition+i-4, (bar_yPosition+130), white, [], 1,[],[]);
                
                k=num2str(trial);
                DrawFormattedText(window, k, 1, 1, white, [], 1,[],1);
                
            end
            
            labelGloss = 'Gloss';
            labelBump = 'Bumpiness';
            
            DrawFormattedText(window, labelBump, bar_xPosition+500, (bar_yPosition-10), white,[],1,[],[]);
            DrawFormattedText(window, labelGloss, bar_xPosition+500, (bar_yPosition+90), white,[],1,[],[]);
            
            % Get the current position of the mouse
            [mx, my, buttons] = GetMouse(window);
            %     [clicks,mx,my,whichButton] = GetClicks(window);
            
            % Find the central position of the square
            [cx, cy] = RectCenter(bumpRect);
            [cx2, cy2] = RectCenter(glossRect);

            % See if the mouse cursor is inside the square
            inside_gloss = IsInRect(mx, my, baseBarGloss);
            inside_bump = IsInRect(mx, my, baseBarBump);

            
            % If we are clicking on the square allow its position to be modified by
            % moving the mouse, correcting for the offset between the centre of the
            % square and the mouse position
            % If we are clicking on the square allow its position to be modified by
            % moving the mouse, correcting for the offset between the centre of the
            % square and the mouse position
            if inside_gloss == 1 && sum(buttons) > 0
                sx2 = 2560-mx;
            elseif inside_bump ==1 && sum(buttons) >0
                sx = 2560-mx;
            end
            
            % Center the rectangle on its new screen position
            bumpRect = CenterRectOnPointd(selectRect, sx, bar_yPosition);
            glossRect = CenterRectOnPointd(selectRect, sx2, bar_yPosition+100);
            
            % Draw the rect to the screen
            Screen('FillRect', window, blue, bumpRect);
            Screen('FillRect', window, blue, glossRect);

            
            % Draw a white dot where the mouse cursor is
            Screen('DrawDots', window, [2560-mx my], 10, white, [], 2);
            
            [KeyIsDown, endrt, KeyCode]=KbCheck;
            if KeyCode(resp)
               glossLevelResp = sx2
               bumpLevelResp = sx
               break;
            end
            
            % Flip to the screen
            
            Screen('Flip', window);
            
            % Check to see if the mouse button has been released and if so reset
            % the offset cue
            if sum(buttons) <= 0
                offsetSet = 0;
            end
            Screen('Close');

        end
        
             log_txt=sprintf(formatSpecResponse,GetSecs);
          fprintf(log_text_fid,'%s\n',log_txt);
        
        % Clear screen to background color after subjects response (on test phase)
        Screen('FillRect', window, gray, [0 0 screenXpixels screenYpixels]);
        sx = xCenter;
        sx2 = xCenter;
        Screen('Flip', window);
        WaitSecs(0.300);
        
        % Write trial result to mat file:
        %Put everything into a big cell with the two responses at the end
        InputDatastruct.BINO.data{trial,1} = trial;
        InputDatastruct.BINO.data{trial,2} =  InputDatastruct.BINO.objnumber{trial};
        InputDatastruct.BINO.data{trial,3} = char(InputDatastruct.BINO.objnameL{trial});
        InputDatastruct.BINO.data{trial,4} =  InputDatastruct.BINO.objScene{trial};
        InputDatastruct.BINO.data{trial,5} =  InputDatastruct.BINO.objGlossLevel{trial};
        InputDatastruct.BINO.data{trial,6} =  InputDatastruct.BINO.stereo{trial};
        %         InputDatastruct.BINO.data{trial,6} = ((glossLevelResp-bar_xPosition)/6); %convert betw 0-100
        InputDatastruct.BINO.data{trial,7} = ((2560-glossLevelResp)-980)/60; %convert betw 0-100
        InputDatastruct.BINO.data{trial,8} =  InputDatastruct.BINO.objBumpLevel{trial};
        %         InputDatastruct.BINO.data{trial,8} = ((bumpLevelResp-bar_xPosition)/150)+0.4; % convert betw 0.4-4.4
        InputDatastruct.BINO.data{trial,9} = ((2560-bumpLevelResp)-980)/60;

% Keep the current trial updated for if the subjects quit.
InputDatastruct.BINO.currenttrial=trial;

% Save the data in the data directory
cd('Data')
save(datafilename{1},'InputDatastruct');
cd('../')
        Screen('Close');
        
% Prompt the observer to quite or begin new trial.
        NEWTRIAL='Press escape to quit or space for a new trial';
        
       
    DrawFormattedText(window, NEWTRIAL, xCenterL, yCenterL, WhiteIndex(window),[],1);
    DrawFormattedText(window, NEWTRIAL, xCenterR, yCenterR, WhiteIndex(window),[],1);
        Screen('Flip', window);
        [KeyIsDown,secs,keyCode]=KbCheck;
        
     while keyCode(resp)==0 && keyCode(t)==0 
      [KeyisDown,secs,keyCode]=KbCheck;
     end
     
     if keyCode(t)==1;
         Screen('CloseAll')
         log_txt=sprintf(formatSpecQuit,num2str(clock));
         fprintf(log_text_fid,'%s\n',log_txt);
     elseif keyCode(resp)==1;
         Screen('Flip', window);
     end
    end % for trial loop
    
    currenttrial
    
    % save datafile to folder 
    

% Cleanup at end of experiment - Close window, show mouse cursor, close
% result file, switch Matlab/Octave back to priority 0 -- normal
% priority:
Screen('CloseAll');
ShowCursor;
fclose('all');
Priority(0);

% End of experiment:
return;
catch
    % catch error: This is executed in case something goes wrong in the
    % 'try' part due to programming error etc.:
    
    % Do same cleanup as at the end of a regular session...
    Screen('CloseAll');
    ShowCursor;
    fclose('all');
    Priority(0);
    
    % Output the error message that describes the error:
    psychrethrow(psychlasterror);
end % try ... catch %

end