% run the bothPlot function
function [proNew sfaMean, rfaMean, A, p, h] = NCPplot(program,sub1,sub2,figureName)

newProgram={'Chart_17' 'Chart_21' 'Chart_25' 'Chart_26' 'Math_2' 'Math_4' 'Math_7' 'Math_24' 'Math_40' 'Math_49' };
formula={'Barinel' 'Jaccard' 'Ochiai' 'Op2' 'Tarantula' 'DStar'};
labels={'Barinel' 'Jaccard' 'Ochiai' 'Op2' 'Tarantula' 'DStar'};
combineData=[];
meanNCP=[];
group=[];

for i=1:length(formula)
    proNew='';
    %% This is the original experiment
    if sum(ismember(newProgram,program))==0
       %% SFA
        path=char(strcat('SFA-100repair\',formula(i),'\'));
        fileName=char(strcat('experimentData_',program,'.txt'));
        processFile(path,fileName);
        filePath=char(strcat(path,'0_',fileName));
        display(['we are running ',filePath]);
        [pre1,pre2,pre3,pre4,pre5,pre6]=textread(filePath,'%d%d%d%s%s%s','headerlines',0);
        if isempty(pre1)
            pre1=zeros(100,1);
        else
            pre1=pre1-1;
        end
        
        combineData=[combineData,pre1'];  %SFA
        group=[group,ones(1,length(pre1))*i];
        sfaMean(i)=mean(pre1);
        SFAncp=pre1;
        
        %% RFA
        path=char(strcat('RFA-100repair\',formula(i),'\'));
        fileName=char(strcat('experimentData_',program,'.txt'));
        processFile(path,fileName);
        filePath=char(strcat(path,'0_',fileName));
        [pre1,pre2,pre3,pre4,pre5,pre6]=textread(filePath,'%d%d%d%s%s%s','headerlines',0);
        if isempty(pre1)
            pre1=zeros(100,1)+1;
        end
        most=min(pre1)-1; 
        combineData=[combineData,ones(1,100)*most];  %RFA   pre1'
        group=[group,ones(1,100)*(i+0.5)];
        rfaMean(i)=most;
        RFAncp=ones(100,1)*most;
    else
        proNew=program;
       %% This is the new experiment, including 'Chart_17' 'Chart_21' 'Chart_25' 'Chart_26' 'Math_2' 'Math_4' 'Math_7' 'Math_24' 'Math_40' 'Math_49' 
       %% SFA
        path=char(strcat('SFA-100repair\',formula(i),'\'));
        fileName=char(strcat('experimentData_',program,'.txt'));
        processFile(path,fileName);
        filePath=char(strcat(path,'0_',fileName));
        display(['we are running ',filePath]);
        [pre1,pre2,pre3,pre4,pre5,pre6,pre7]=textread(filePath,'%d%d%d%d%s%s%s','headerlines',0);
        if isempty(pre1)
            pre1=zeros(100,1);
        else
            pre1=pre1-1;
        end
        
        combineData=[combineData,pre1'];  %SFA
        group=[group,ones(1,length(pre1))*i];
        sfaMean(i)=mean(pre1);
        SFAncp=pre1;
        
        path=char(strcat('SFA-100repair\',formula(i),'\'));
        fileName=char(strcat('experimentData_',program,'.txt'));
        processFile(path,fileName);
        filePath=char(strcat(path,'0_',fileName));
        [pre1,pre2,pre3,pre4,pre5,pre6,pre7]=textread(filePath,'%d%d%d%d%s%s%s','headerlines',0);
        if isempty(pre2)
            pre2=zeros(100,1);
        end
        most=min(pre2);
        combineData=[combineData,ones(1,100)*most];  %RFA  pre2'
        group=[group,ones(1,100)*(i+0.5)];
        rfaMean(i)=most;
        RFAncp=ones(100,1)*most;
    end

    %% A-test
    [A(i) p(i) h(i)]=WilcoxonTest(SFAncp,RFAncp);
end

color=[	[	28 28 28]/255;[255 69 0 ]/255];	% DodgerBlue255 69 0
boxplot(combineData,group,'factorgap',10,'Colors',color,'symbol','.')%,'PlotStyle', 'compact'  'Colors','kk';[0.5 0.5 0]
set(gca,'xtick',1.8:4.3:50)
set(gca,'Fontname','Linux Libertine');%'times new Roman'
set(gca,'xticklabel',{'Bar' 'Jac' 'Och' 'Op2' 'Tar' 'DSt'})

% set(gca,'FontSize',8,'XTickLabelRotation',45)
set(gca,'FontSize',7)%,'Font','Arial'
title(strrep(char(program),'_','\_'));

