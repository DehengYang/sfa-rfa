% run the bothPlot function

function [sfaMean, rfaMean, A, p, h] = NCPplot(program,sub1,sub2,figureName)

formula={'Barinel' 'Jaccard' 'Ochiai' 'Op2' 'Tarantula' 'DStar'};
combineData=[];
meanNCP=[];
group=[];

for i=1:length(formula)
    
    %% SFA
    if (i>=2 && i<=4)
        path=char(strcat('SFA\',formula(i),'\'));
        fileName=char(strcat(program,'_NCP.txt'));
        filePath=char(strcat(path,fileName));
        display(['we are running ',filePath]);
        [pre1,pre2]=textread(filePath,'%d%d','headerlines',0);
        if isempty(pre1)
            pre1=zeros(100,1)-50;
        end
        combineData=[combineData,pre1'];  %SFA
        group=[group,ones(1,length(pre1))*i];
        sfaMean(i)=mean(pre1);
        SFAncp=pre1;
    else
        path=char(strcat('SFA\',formula(i),'\',program,'\save\'));
        fileName=char(strcat(program,'_NCP.txt'));
        filePath=char(strcat(path,fileName));
        display(['we are running ',filePath]);
        [pre1,pre2]=textread(filePath,'%d%d','headerlines',0);
        if isempty(pre1)
            pre1=zeros(100,1)-50;
        end
        combineData=[combineData,pre1'];  %SFA
        group=[group,ones(1,length(pre1))*i];
        sfaMean(i)=mean(pre1);
        SFAncp=pre1;
    end
    
    
    %% RFA
    path=char(strcat('RFA\',formula(i),'\',program,'\save\'));
    fileName=char(strcat(program,'_NCP.txt'));
    filePath=char(strcat(path,fileName));
    display(['we are running ',filePath]);
    [pre1,pre2]=textread(filePath,'%d%d','headerlines',0);
    if isempty(pre1)
        pre1=zeros(100,1)-50;
    end
    most=mode(pre1);
    combineData=[combineData,ones(1,100)*most];  %SFA
    group=[group,ones(1,100)*(i+0.5)];
    rfaMean(i)=most;
    RFAncp=ones(100,1)*most;
    
    %% A-test
    [A(i) p(i) h(i)]=WilcoxonTest(SFAncp,RFAncp);

end

subplot(sub1,sub2,figureName);
map=[ 0 1 0
    1 1 1];

boxplot(combineData,group,'factorgap',10,'symbol','.','color','bk')%'ck'  'ColorGroup',map,
set(gca,'xtick',1.8:4.3:50)
set(gca,'xticklabel',{'Bar' 'Jac' 'Op2' 'Tar' 'DSt'})
ylabel('NCP');


% boxplot(combineData,group,'labels',labels,'symbol','.','color','k');
% hold on;
% plot(1:6,meanNCP);
% set(gca,'FontSize',8,'XTickLabelRotation',45)
set(gca,'FontSize',8)
title(strrep(char(program),'_','\_'));

