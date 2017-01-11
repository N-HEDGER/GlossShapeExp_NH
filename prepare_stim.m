% write images into mat file
function [InputDatastruct]= prepare_stim(InputDatastruct,session);


Stereolist={'-15','0','+15'};
eyelist={'L','R'};

if InputDatastruct.isbinocular==1
    ntrials=486;
    randomorder=randperm(ntrials);
    i=1
    for gloss=2:10
        for bump=2:10
            
            for lf=1:2
                
                for stereo=1:3
                    for eye=1
                stimfilenameL = strcat('ToneMapped_SOU/Mesh',Stereolist(stereo),eyelist(eye),'D',num2str(bump),'G',num2str(gloss),'L',num2str(lf),'.mat');
                stimfilenameR = strcat('ToneMapped_SOU/Mesh',Stereolist(stereo),eyelist(eye+1),'D',num2str(bump),'G',num2str(gloss),'L',num2str(lf),'.mat');
                stimlistL{i,1} = i;
                stimlistL{i,2} = stimfilenameL;
                stimlistL{i,3} = stimfilenameR;
                stimlistL{i,4} = gloss;
                stimlistL{i,5} = bump;
                stimlistL{i,6} = lf;
                stimlistL{i,7} = stereo;
                stimlistL{i,8} = randomorder(i);

               
                i = i+1;
                    end
                end
            end
        end
    end
        
    
InputDatastruct.stimlistL=stimlistL;

% randomise

if InputDatastruct.isfixed==0
sorted_listL = sortrows(stimlistL,8);
stimlistL=sorted_listL;
else
    stimlistL=stimlistL;
end
% Assign the stimlists for each block.



InputDatastruct.BINO.stimlistL=stimlistL;


InputDatastruct.BINO.objnumber = InputDatastruct.BINO.stimlistL(:,1);
InputDatastruct.BINO.objnameL = InputDatastruct.BINO.stimlistL(:,2);
InputDatastruct.BINO.objnameR = InputDatastruct.BINO.stimlistL(:,3);
InputDatastruct.BINO.objGlossLevel = InputDatastruct.BINO.stimlistL(:,4);
InputDatastruct.BINO.objBumpLevel = InputDatastruct.BINO.stimlistL(:,5);
InputDatastruct.BINO.objScene = InputDatastruct.BINO.stimlistL(:,6);
InputDatastruct.BINO.stereo = InputDatastruct.BINO.stimlistL(:,7);

ntrials=length(InputDatastruct.BINO.objnumber);   


if InputDatastruct.isfixed==1
    randomorder=1:ntrials;
else
    randomorder=randperm(ntrials);
end
    
%     Randomise each list (not really sure why you have to do this since the trials are already randomized, but it
%     was in the last version).
    InputDatastruct.BINO.randomorder=randomorder;
    InputDatastruct.BINO.objnumber=InputDatastruct.BINO.objnumber(randomorder);  
    InputDatastruct.BINO.objnameL=InputDatastruct.BINO.objnameL(randomorder);   
    InputDatastruct.BINO.objnameR=InputDatastruct.BINO.objnameR(randomorder);   
    InputDatastruct.BINO.objGlossLevel=InputDatastruct.BINO.objGlossLevel(randomorder);
    InputDatastruct.BINO.objBumpLevel = InputDatastruct.BINO.objBumpLevel(randomorder);
    InputDatastruct.BINO.objScene = InputDatastruct.BINO.objScene(randomorder);
    InputDatastruct.BINO.stereo = InputDatastruct.BINO.stereo(randomorder);






    
else
    

    


if session ==1
    datadir='S1';
elseif session ==2
    datadir='S2';
end


%% Loop through to generate a list of stimuli to load.

ntrials = 162;
randomorder=randperm(ntrials);

i=1
for gloss=2:10
    for bump=2:10
        for lf=1:2
            stimfilename = strcat('Tone_Gamma_NY/GBMeshD',num2str(bump),'G',num2str(gloss),'L',num2str(lf),'.mat')
            stimlist{i,1} = i;
            stimlist{i,2} = stimfilename;
            stimlist{i,3} = gloss;
            stimlist{i,4} = bump;
            stimlist{i,5} = lf;
            stimlist{i,6} = randomorder(i);
            i = i+1;
            
        end
    end
end

% Put the stimlist into the main structure.
InputDatastruct.stimlist=stimlist;

% randomise

    if InputDatastruct.isfixed==1
    sorted_list=stimlist;
    else
    sorted_list = sortrows(stimlist,6);
    end


% Assign the stimlists for each block.
stimlist1 = sorted_list(1:81,:);
stimlist2 = sorted_list(82:162,:);

% Save the stimulus lists for Session 1 and Session 2 into the structure.
InputDatastruct.S1.stimlist1=stimlist1;
InputDatastruct.S2.stimlist2=stimlist2;
InputDatastruct.S2.currenttrial=0;

% Assign the variables that are looped through in the main file.
        InputDatastruct.(datadir).objnumber = InputDatastruct.(datadir).stimlist1(:,1);
        InputDatastruct.(datadir).objname = InputDatastruct.(datadir).stimlist1(:,2);
        InputDatastruct.(datadir).objGlossLevel = InputDatastruct.(datadir).stimlist1(:,3);
        InputDatastruct.(datadir).objBumpLevel = InputDatastruct.(datadir).stimlist1(:,4);
        InputDatastruct.(datadir).objScene = InputDatastruct.(datadir).stimlist1(:,5);
% Also assign for S2.
        InputDatastruct.S2.objnumber = InputDatastruct.S2.stimlist2(:,1);
        InputDatastruct.S2.objname = InputDatastruct.S2.stimlist2(:,2);
        InputDatastruct.S2.objGlossLevel = InputDatastruct.S2.stimlist2(:,3);
        InputDatastruct.S2.objBumpLevel = InputDatastruct.S2.stimlist2(:,4);
        InputDatastruct.S2.objScene = InputDatastruct.S2.stimlist2(:,5);
   
% Number of trials
        ntrials=length(InputDatastruct.(datadir).objnumber);    
    
% Set fixed or random trial order based on GUI checkbox.
    if InputDatastruct.isfixed==1
        randomorder=1:ntrials;
    else
    randomorder=randperm(ntrials);  
    end
    
%     Randomise each list (not really sure why you have to do this, but it
%     was in the last version).
    InputDatastruct.(datadir).randomorder=randomorder;
    InputDatastruct.(datadir).objnumber=InputDatastruct.(datadir).objnumber(randomorder);  
    InputDatastruct.(datadir).objname=InputDatastruct.(datadir).objname(randomorder);      
    InputDatastruct.(datadir).objGlossLevel=InputDatastruct.(datadir).objGlossLevel(randomorder);
    InputDatastruct.(datadir).objBumpLevel = InputDatastruct.(datadir).objBumpLevel(randomorder);
    InputDatastruct.(datadir).objScene = InputDatastruct.(datadir).objScene(randomorder);

    
    
    if InputDatastruct.isfixed==1
        randomorder=1:ntrials;
    else
    randomorder=randperm(ntrials);  
    end
    
    InputDatastruct.S2.randomorder=randomorder;
    InputDatastruct.S2.objnumber=InputDatastruct.S2.objnumber(randomorder);  
    InputDatastruct.S2.objname=InputDatastruct.S2.objname(randomorder);      
    InputDatastruct.S2.objGlossLevel=InputDatastruct.S2.objGlossLevel(randomorder);
    InputDatastruct.S2.objBumpLevel = InputDatastruct.S2.objBumpLevel(randomorder);
    InputDatastruct.S2.objScene = InputDatastruct.S2.objScene(randomorder);

    %     Create empty cell for data.
    InputDatastruct.S2.data = cell(81,8);
    

   
end


