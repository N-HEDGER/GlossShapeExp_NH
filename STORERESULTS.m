        data{trial,1} = trial;
        data{trial,2} = objnumber{trial};
        data{trial,3} = char(objname{trial});
        data{trial,4} = objScene{trial};
        data{trial,5} = objGlossLevel{trial};
        data{trial,6} = ((glossLevelResp-bar_xPosition)/6); %convert betw 0-100
        data{trial,7} = objBumpLevel{trial};
        data{trial,8} = ((bumpLevelResp-bar_xPosition)/150)+0.4; % convert betw 0.4-4.4
        save(strcat('Data/',datafilename), 'data');
        save(strcat('Data/TrialOrder_',subjInitials,'.mat'),'randomorder');
        Screen('Close');