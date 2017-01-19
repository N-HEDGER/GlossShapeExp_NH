function GlossShapeYardstickExp_Mouse_NH(subjInitials,session,InputDatastruct)
if session ==1
    datadir='S1';
elseif session ==2
    datadir='S2';
end

clc;

%% Prepare stimuli.

if session ==1
%     If the session is 1, prepare the stimulus arrays for block 1 and 2.
% If the session is 2, we dont need to do this as it was already set when
% first running block one.
InputDatastruct=prepare_stim(InputDatastruct,session);
end

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
datafilename = strcat('GlossYardstickExp_',subjInitials,'.mat'); % name of data file to write to

log_text=sprintf('Data/%s_monocular,log.txt',subjInitials{1});
log_text_fid=fopen(log_text,'a+');

% Navigate to the Data directory.
cd('Data')
% If the data filename exists, get rid of the loaded stimulus array.
if exist(datafilename{1})
    clear ('InputDatastruct')
    %     Instead, load the structure that was saved the first time the
    %     experiment was run.
    load(datafilename{1})
    
    formatSpecRestart=('Subject restarted at: %s');
    log_txt=sprintf(formatSpecRestart,num2str(clock));
    fprintf(log_text_fid,'%s\n',log_txt);
    
    
    % If the datafile exists, prompt to check the number of trials already
    % done.
    X = [' You have done ',num2str(InputDatastruct.(datadir).currenttrial),' trials in session ', num2str(session)];
    disp(X)
    % Ask for response.
    Q1=input('That filename already exists. You have done the above number of trials in this session, correct [0= no, 1= yes]');
    if Q1==0
        %         If incorrect, chose different initials.
        error('something has gone wrong')
    else
        %         If correct, load the data and start at the next trial from where
        %         they left off.
        
        InputDatastruct.(datadir).data=InputDatastruct.(datadir).data;
        InputDatastruct.(datadir).currenttrial=InputDatastruct.(datadir).currenttrial+1;
    end
else
    %     If the datafile is a new one, then create a cell to store the data.
    InputDatastruct.(datadir).data = cell(81,8);
    InputDatastruct.(datadir).currenttrial=1;
end
% Navigate back to the main directory.
cd('../')
%% Save important constants to the structure


    InputDatastruct.const.IM_WIDTH_DISP=540;
    InputDatastruct.const.IM_HEIGHT_DISP=540;
    InputDatastruct.const.noisesize=100;
    [widthW, heightW] = Screen('WindowSize', 0);
    InputDatastruct.const.wRectL = [0 0 widthW/2 heightW];
    InputDatastruct.const.wRectR = [(widthW/2)+1 0  widthW heightW];
    InputDatastruct.const.selectRect = [0 0 10 40];
    % Make a base rectangle for the slider bar
    InputDatastruct.const.baseBar_xSize = 600;
    InputDatastruct.const. baseBar_ySize = 10;
    InputDatastruct.const.textsize = 32;


%% Initialize experiment.

try

    % Get screen definitions and open window.
    screens = Screen('Screens');
    screenNumber = max(screens);    
    % Hide the mouse cursor:
    HideCursor;
    gray = GrayIndex(screenNumber); 
    white = WhiteIndex(screenNumber);
    black = BlackIndex(screenNumber);
    PsychImaging('PrepareConfiguration');
    PsychImaging('AddTask', 'General', 'UseFastOffscreenWindows');
    [window, windowRect] = PsychImaging('OpenWindow', 0, black);
    [screenXpixels, screenYpixels] = Screen('WindowSize', window);
    Screen('TextSize', window, InputDatastruct.const.textsize);
    
    % Do dummy calls to GetSecs, WaitSecs, KbCheck to make sure
    % they are loaded and ready when we need them - without delays
    % in the wrong moment:
    KbCheck;
    WaitSecs(0.1);
    GetSecs;

    % Set priority for script execution to realtime priority:
    priorityLevel=MaxPriority(window);
    Priority(priorityLevel);
    
    % Write instruction message for subject, centered in the
    % middle of the display, in white color.
    str=sprintf('Match the glossiness and bumpiness of the stimuli on the screen\n with the real objects to your left\n When you make your settings hit space to continue to next trial\n');
    message = ['test phase ...\n' str '... press mouse button to begin ...'];
    
%     Get centres of all rectangles (main window, left and right monitors).
   
    [widthW, heightW] = Screen('WindowSize', 0);
    
    [xCenterL, yCenterL] = RectCenter(InputDatastruct.const.wRectL);
    [xCenterR, yCenterR] = RectCenter(InputDatastruct.const.wRectR);
    
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
     ntrials=length(InputDatastruct.(datadir).objnumber); 

    [xCenter, yCenter] = RectCenter(windowRect);
    
    
    %%%%%%%%%%%%%%%%%%%%%%
    % slider bar stuff
    %%%%%%%%%%%%%%%%%%%%%%   
    % Get the centre coordinate of the window
    selectRect = [0 0 10 40];
    
    % Make a base rectangle for the slider bar
    baseBar =[0 0  InputDatastruct.const.baseBar_xSize  InputDatastruct.const.baseBar_ySize];
    bar_xPosition = xCenterL - (InputDatastruct.const.baseBar_xSize/2);
    bar_yPosition = screenYpixels*0.75;
    
    % Make a rectangle for the ticks on the slider bar
    tick = [0 0 4 10];

    [imRectL,dh,dv] = CenterRect([0 0 InputDatastruct.const.IM_WIDTH_DISP InputDatastruct.const.IM_HEIGHT_DISP], InputDatastruct.const.wRectL)
    [imRectR,dh,dv] = CenterRect([0 0 InputDatastruct.const.IM_WIDTH_DISP InputDatastruct.const.IM_HEIGHT_DISP], InputDatastruct.const.wRectR)
    
    [noiserectL,dh,dv] = CenterRect([0 0 InputDatastruct.const.IM_WIDTH_DISP+InputDatastruct.const.noisesize InputDatastruct.const.IM_HEIGHT_DISP+InputDatastruct.const.noisesize], InputDatastruct.const.wRectL)
    [noiserectR,dh,dv] = CenterRect([0 0 InputDatastruct.const.IM_WIDTH_DISP+InputDatastruct.const.noisesize InputDatastruct.const.IM_HEIGHT_DISP+InputDatastruct.const.noisesize], InputDatastruct.const.wRectR)
    
    
    % Define blue color
    blue = [0 0 255];
    
    % Here we set the initial position of the mouse to be in the centre of the
    % slider bar
    SetMouse(xCenterL, bar_yPosition, window);
    
    % We now set the slider bars' initial position 
    sx = xCenterL;
    sx2 = xCenterL;
    bumpRect = OffsetRect(InputDatastruct.const.selectRect, sx, bar_yPosition);
    glossRect = OffsetRect(InputDatastruct.const.selectRect, sx2, bar_yPosition+100);

    %% Set up formatting for text output
    
    % Put initial information into the log.
    log_txt=sprintf('Subject is doing block %f',InputDatastruct.nblock);
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
    
    for trial=InputDatastruct.(datadir).currenttrial:ntrials
        

        WaitSecs(0.500);
        
        % Load the first stimulus file name based on the data in structure.
        stimfilename=char(InputDatastruct.(datadir).objname(trial)); 
        imdata=load(char(stimfilename));
        
        % Print trial and stimulus info to file
        trialtxt=num2str(trial);
        stimtxt=stimfilename;
        log_txt=sprintf(formatSpec,trialtxt,stimtxt);
        fprintf(log_text_fid,'%s\n',log_txt);
        jRobot=java.awt.Robot;
        noise = 255*rand([InputDatastruct.const.IM_HEIGHT_DISP+InputDatastruct.const.noisesize InputDatastruct.const.IM_WIDTH_DISP+InputDatastruct.const.noisesize]);
        black=zeros(InputDatastruct.const.IM_HEIGHT_DISP,InputDatastruct.const.IM_HEIGHT_DISP);
 
        while 1 

            % make texture image out of image matrix.
            
            tex=Screen('MakeTexture', window, fliplr(im2uint8(imdata.gammaCorrected)));
            noisetex=Screen('MakeTexture', window, noise);
            black=Screen('MakeTexture', window, black);
            % Draw
            
            Screen('DrawTexture', window, noisetex, [], [noiserectL]);
            Screen('DrawTexture', window, noisetex, [], [noiserectR]);
            Screen('DrawTexture', window, tex, [], [imRectL]);
            Screen('DrawTexture', window, black, [], [imRectR]);
            
        
            %             Screen('DrawTexture', window, tex, [], [imRectR]);
            Screen('TextSize', window, InputDatastruct.const.textsize/2);
            
           Screen('TextSize', window, InputDatastruct.const.textsize/2);  
            baseBarBump = OffsetRect(baseBar, bar_xPosition, bar_yPosition);
            baseBarBumpR = OffsetRect(baseBar, bar_xPosition+2560, bar_yPosition);
            rectColor = [200 200 200];
            Screen('FillRect', window, rectColor, baseBarBump);
            Screen('FillRect', window, rectColor, baseBarBumpR);
            
            baseBarGloss = OffsetRect(baseBar, bar_xPosition, bar_yPosition+100);
            baseBarGlossR = OffsetRect(baseBar, bar_xPosition+2560, bar_yPosition+100);
            rectColor2 = [200 200 200];
            Screen('FillRect', window, rectColor2, baseBarGloss);
            Screen('FillRect', window, rectColor2, baseBarGlossR);
            
            
            % add ticks to the bar.
            vec=0:60:600;
            for i=0:60:600
                
                tick_offset = OffsetRect(tick, bar_xPosition+i-2, bar_yPosition-5);
                Screen('FillRect', window, rectColor, tick_offset);
                tick_offsetR = OffsetRect(tick, (bar_xPosition+i-2)+2560, bar_yPosition-5);
                Screen('FillRect', window, rectColor, tick_offset);
                Screen('FillRect', window, rectColor, tick_offsetR);
                
                tick_offset2 = OffsetRect(tick, bar_xPosition+i-2, bar_yPosition+95);
                tick_offset2R = OffsetRect(tick, (bar_xPosition+i-2)+2560, bar_yPosition+95);
                Screen('FillRect', window, rectColor, tick_offset2);
                 Screen('FillRect', window, rectColor, tick_offset2R);
                % Write the number text
                message = strcat(int2str((length(vec)-round(i/50)+1)));
                message2 = strcat(num2str((length(vec)-round(i/50)+1)));
                
                
                DrawFormattedText(window, message, bar_xPosition+i-4, (bar_yPosition+30), white, [], 1,[],[]);
                DrawFormattedText(window, message2, bar_xPosition+i-4, (bar_yPosition+130), white, [], 1,[],[]);
                
                DrawFormattedText(window, message, (bar_xPosition+i-4)+2560, (bar_yPosition+30), white, [], 1,[],[]);
                DrawFormattedText(window, message2, (bar_xPosition+i-4)+2560, (bar_yPosition+130), white, [], 1,[],[]);
                
                k=num2str(trial);
                DrawFormattedText(window, k, 1, 1, white, [], 1,[],1);
                
            end
            
            labelGloss = 'Gloss';
            labelBump = 'Bumpiness';
            
            DrawFormattedText(window, labelBump, bar_xPosition+650, (bar_yPosition-10), white,[],1,[],[]);
            DrawFormattedText(window, labelGloss, bar_xPosition+650, (bar_yPosition+90), white,[],1,[],[]);
            
            DrawFormattedText(window, labelBump, (bar_xPosition+650)+2560, (bar_yPosition-10), white,[],1,[],[]);
            DrawFormattedText(window, labelGloss, (bar_xPosition+650)+2560, (bar_yPosition+90), white,[],1,[],[]);
            
            % Get the current position of the mouse
            [mx, my, buttons] = GetMouse(window);
            
            % Find the central position of the square
            [cx, cy] = RectCenter(bumpRect);
            [cx2, cy2] = RectCenter(glossRect);
            
            % See if the mouse cursor is inside the square
            inside_gloss = IsInRect(mx, my, baseBarGloss);
            inside_bump = IsInRect(mx, my, baseBarBump);

            
            % If we are clicking on the square allow its position to be modified by
            % moving the mouse, correcting for the offset between the centre of the
            % square and the mouse position
            if inside_gloss == 1 && sum(buttons) > 0
                sx2 = 2560-mx;
            elseif inside_bump ==1 && sum(buttons) >0
                sx = 2560-mx;
            end
            
            % Center the rectangle on its new screen position
            bumpRect = CenterRectOnPointd(InputDatastruct.const.selectRect, sx, bar_yPosition);
            glossRect = CenterRectOnPointd(InputDatastruct.const.selectRect, sx2, bar_yPosition+100);
            
            bumpRectR = CenterRectOnPointd(InputDatastruct.const.selectRect, sx+2560, bar_yPosition);
            glossRectR = CenterRectOnPointd(InputDatastruct.const.selectRect, sx2+2560, bar_yPosition+100);
            
            
            % Draw the rect to the screen
            Screen('FillRect', window, blue, bumpRect);
            Screen('FillRect', window, blue, glossRect);
              Screen('FillRect', window, blue, bumpRectR);
            Screen('FillRect', window, blue, glossRectR);
            
            % Draw a white dot where the mouse cursor is
             Screen('DrawDots', window, [2560-mx my], 10, white, [], 2);
             Screen('DrawDots', window, [(2560-mx)+2560 my], 10, white, [], 2);
            
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
        
         % Print time of response to external file
        log_txt=sprintf(formatSpecResponse,GetSecs);
        fprintf(log_text_fid,'%s\n',log_txt);
        
        % Clear screen to background color after subjects response (on test phase)
        Screen('FillRect', window, black, [0 0 screenXpixels screenYpixels]);
        sx = xCenter;
        sx2 = xCenter;
        Screen('Flip', window);
        WaitSecs(0.300);
        
        % Write trial result to mat file:
        %Put everything into a big cell with the two responses at the end
        InputDatastruct.(datadir).data{trial,1} = trial;
        InputDatastruct.(datadir).data{trial,2} =  InputDatastruct.(datadir).objnumber{trial};
        InputDatastruct.(datadir).data{trial,3} = char(InputDatastruct.(datadir).objname{trial});
        InputDatastruct.(datadir).data{trial,4} =  InputDatastruct.(datadir).objScene{trial};
        InputDatastruct.(datadir).data{trial,5} =  InputDatastruct.(datadir).objGlossLevel{trial};
        InputDatastruct.(datadir).data{trial,6} = ((2560-glossLevelResp)-bar_xPosition)/50; %convert betw 0-100
        InputDatastruct.(datadir).data{trial,7} =  InputDatastruct.(datadir).objBumpLevel{trial};
        InputDatastruct.(datadir).data{trial,8} = ((2560-bumpLevelResp)-bar_xPosition)/50;

        % Keep the current trial updated for if the subjects quit.
        InputDatastruct.(datadir).currenttrial=trial;
        
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