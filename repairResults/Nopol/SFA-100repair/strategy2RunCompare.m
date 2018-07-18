clear,clc;
formula={'Ochiai'};
labels={'Ochiai' 'Och-New'};
% program={'Chart_3' 'Chart_5' 'Closure_61' 'Closure_62' 'Lang_44'  'Lang_58' 'Math_73' 'Math_81' 'Mockito_29' 'Mockito_38' 'Time_4' 'Time_12'};
program={'Chart_3' 'Closure_62' 'Lang_44'  'Math_81' 'Mockito_38' 'Time_12'};

% program={'Chart_3' 'Chart_5' 'Chart_9' 'Chart_13' 'Closure_61' 'Closure_62' 'Closure_67' 'Closure_72' ...
%     'Lang_44'  'Lang_58' 'Math_69' 'Math_73' 'Math_81' 'Math_85' ...
%     'Mockito_29' 'Mockito_38' 'Time_4' 'Time_7' 'Time_11' 'Time_12'};
%''Lang_51' 'Lang_53' 
distance=[];
figure('color',[1 1 1]);
for i= 1:length(program) % 2.660743213390416 2.660743213390416  0.4  2.464966880026944
%     break;
    combine=[];
    group=[];

    % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %     

%     [suspiciousAll,suspList]=readRankList(formula,program(i),char(strcat('collectRFASuspiciousness 0th\',formula,'\',formula, ...
%     '_susp_0\',formula,'_',program(i),'.txt')));
%      filePath=char(strcat('collectRFASuspiciousness 0th\',formula,'\repairInfo_',program(i),'_0.txt'));
% %      [statementFaulty]=readFaultyStatement(filePath);
%     [statementFaulty]=readAllFStatement(formula, program(i));
%     sumSuspiciouness1=sum(suspList);
%     [percentageSFA,collectTimesSFA]=simulateStatementSelection(suspiciousAll,100, ...
%         length(suspList),statementFaulty,sum(suspList),1);
%     combine=[combine,collectTimesSFA-1];
%     group=[group,ones(1,length(collectTimesSFA))*2];
%     
%     faultySusp=0;
%     for j=1:length(suspList)
%         st=suspiciousAll(j).statement;
%         if checkInStruct(st,statementFaulty)==1
%             disp('nice')
%             faultySusp=faultySusp+suspiciousAll(j).suspicious;
%         end
%     end
%     PERS(i)=double(faultySusp/sumSuspiciouness1);
    
    path=char(strcat('SFA-100repair\',formula,'\'));
    fileName=char(strcat('experimentData_',program(i),'.txt'));
%     processFile(path,fileName);
    filePath=char(strcat(path,'0_',fileName));
    [pre1,pre2,pre3,pre4,pre5,pre6]=textread(filePath,'%d%d%d%s%s%s','headerlines',0);
    if isempty(pre1)
        pre1=zeros(100,1);
    end
    combine=[combine,pre1'-1];
    group=[group,ones(1,length(pre1))*1];

     
    
    
       % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %  
    [suspiciousAll,suspList]=readRankList(formula,program(i),char(strcat('collectRFASuspiciousness 0th\',formula,'\',formula, ...
    '_susp_0\',formula,'_',program(i),'.txt')));
% %     filePath=char(strcat('collectRFASuspiciousness 0th\',formula,'\repairInfo_',program(i),'_0.txt'));
% %     [statementFaulty]=readFaultyStatement(filePath);
    [statementFaulty]=readAllFStatement(formula, program(i));
% 
% %     [suspListNew]=changeSuspiciousAll(suspList,suspiciousAll);
    [newSuspiciousAll,suspListNew]=changeSuspiciousAllForNewStrategy(suspList,suspiciousAll);
    sumSuspiciouness=sum(suspListNew);
    [percentageSFANew,collectTimesSFANew]=simulateStatementSelection(newSuspiciousAll,100, ...
        length(suspListNew),statementFaulty,sum(suspListNew),1);
    combine=[combine,collectTimesSFANew-1];
    group=[group,ones(1,length(collectTimesSFANew))*3];
    
    faultySusp2=0;
    for j=1:length(suspListNew)
        st=newSuspiciousAll(j).statement;
        if checkInStruct(st,statementFaulty)==1
            disp('nice')
            faultySusp2=faultySusp2+newSuspiciousAll(j).suspicious;
        end
    end
    PERS2(i)=double(faultySusp2/sumSuspiciouness);

%     path=char(strcat('Jaccard-SFA-NewStrategy\'));
%     fileName=char(strcat('experimentData_',program(i),'.txt'));
%     processFile(path,fileName);
%     filePath=char(strcat(path,'0_',fileName));
%     [pre1,pre2,pre3,pre4,pre5,pre6]=textread(filePath,'%d%d%d%s%s%s','headerlines',0);
% %     repairTimesRev(i)=pre1;
%     if isempty(pre1)
%         pre1=zeros(100,1);
%     end
%     combine=[combine,pre1'];
%     group=[group,ones(1,length(pre1))*2];    

%%
%     [A(i) p(i) h(i)]=WilcoxonTest(collectTimesSFANew',pre1);  %collectTimesSFA
    [A(i) p(i) h(i)]=WilcoxonTest(pre1,collectTimesSFANew');

    mean1(i)=mean(pre1);
    mean2(i)=mean(collectTimesSFANew);
    mean3(i)=mean1(i)-mean2(i);
    subplot(2,3,i);
    colors=[	[	28 28 28]/255;[255 69 0 ]/255];	% DodgerBlue255 69 0 
    boxplot(combine,group,'labels',labels,'symbol','.','Colors', colors);%,'FactorSeparator',1);%'Widths',0.9
    set(gca,'xtick',[1:2]);
    set(gca,'Fontname','Linux Libertine');%'times new Roman');
    set(gca,'xticklabel',labels)
    set(gca,'FontSize',13)%,'XTickLabelRotation',45)
%     set(gca,'yticklabel',get(gca,'ytick'));
    title(strrep(char(program(i)),'_','\_'),'FontSize',13);       
    
    if(rem(i,3)==1)
        ylabel('NCP');
    end
end

% figure;
for i=13:length(program)  %2.660743213390416 2.660743213390416  0.4  2.464966880026944 18:18%
    break;
    combine=[];
    group=[];

    % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %     

    [suspiciousAll,suspList]=readRankList(formula,program(i),char(strcat('collectRFASuspiciousness 0th\',formula,'\',formula, ...
    '_susp_0\',formula,'_',program(i),'.txt')));
     filePath=char(strcat('collectRFASuspiciousness 0th\',formula,'\repairInfo_',program(i),'_0.txt'));
%      [statementFaulty]=readFaultyStatement(filePath);
    [statementFaulty]=readAllFStatement(formula, program(i));
    sumSuspiciouness1=sum(suspList);
    [percentageSFA,collectTimesSFA]=simulateStatementSelection(suspiciousAll,100, ...
        length(suspList),statementFaulty,sum(suspList),1);
    combine=[combine,collectTimesSFA-1];
    group=[group,ones(1,length(collectTimesSFA))*2];
    
    faultySusp=0;
    for j=1:length(suspList)
        st=suspiciousAll(j).statement;
        if checkInStruct(st,statementFaulty)==1
            disp('nice')
            faultySusp=faultySusp+suspiciousAll(j).suspicious;
        end
    end
    PERS(i)=double(faultySusp/sumSuspiciouness1);
    
%     path=char(strcat('SFA-100repair\',formula,'\'));
%     fileName=char(strcat('experimentData_',program(i),'.txt'));
%     processFile(path,fileName);
%     filePath=char(strcat(path,'0_',fileName));
%     [pre1,pre2,pre3,pre4,pre5,pre6]=textread(filePath,'%d%d%d%s%s%s','headerlines',0);
%     if isempty(pre1)
%         pre1=zeros(100,1);
%     end
%     combine=[combine,pre1'];
%     group=[group,ones(1,length(pre1))*1];

     
    
    
       % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %  
    [suspiciousAll,suspList]=readRankList(formula,program(i),char(strcat('collectRFASuspiciousness 0th\',formula,'\',formula, ...
    '_susp_0\',formula,'_',program(i),'.txt')));
% %     filePath=char(strcat('collectRFASuspiciousness 0th\',formula,'\repairInfo_',program(i),'_0.txt'));
% %     [statementFaulty]=readFaultyStatement(filePath);
    [statementFaulty]=readAllFStatement(formula, program(i));
% 
% %     [suspListNew]=changeSuspiciousAll(suspList,suspiciousAll);
    [newSuspiciousAll,suspListNew]=changeSuspiciousAllForNewStrategy(suspList,suspiciousAll);
    sumSuspiciouness=sum(suspListNew);
    [percentageSFANew,collectTimesSFANew]=simulateStatementSelection(newSuspiciousAll,100, ...
        length(suspListNew),statementFaulty,sum(suspListNew),1);
    combine=[combine,collectTimesSFANew-1];
    group=[group,ones(1,length(collectTimesSFANew))*3];
    
    faultySusp2=0;
    for j=1:length(suspListNew)
        st=newSuspiciousAll(j).statement;
        if checkInStruct(st,statementFaulty)==1
            disp('nice')
            faultySusp2=faultySusp2+newSuspiciousAll(j).suspicious;
        end
    end
    PERS2(i)=double(faultySusp2/sumSuspiciouness);

%     path=char(strcat('Jaccard-SFA-NewStrategy\'));
%     fileName=char(strcat('experimentData_',program(i),'.txt'));
%     processFile(path,fileName);
%     filePath=char(strcat(path,'0_',fileName));
%     [pre1,pre2,pre3,pre4,pre5,pre6]=textread(filePath,'%d%d%d%s%s%s','headerlines',0);
% %     repairTimesRev(i)=pre1;
%     if isempty(pre1)
%         pre1=zeros(100,1);
%     end
%     combine=[combine,pre1'];
%     group=[group,ones(1,length(pre1))*2];    

%%
%     [A(i) p(i) h(i)]=WilcoxonTest(collectTimesSFANew',pre1);  %collectTimesSFA
    [A(i) p(i) h(i)]=WilcoxonTest(collectTimesSFA',collectTimesSFANew');

    mean1(i)=mean(collectTimesSFA);
    mean2(i)=mean(collectTimesSFANew);
    mean3(i)=mean1(i)-mean2(i);
    
    subplot(3,4,i-11);
    boxplot(combine,group,'labels',labels,'symbol','.');
    set(gca,'xtick',[1:2]);
    set(gca,'xticklabel',labels)
    set(gca,'FontSize',8,'XTickLabelRotation',45)
%     set(gca,'yticklabel',get(gca,'ytick'));
    title(strrep(char(program(i)),'_','\_'),'FontSize',8);                             
end