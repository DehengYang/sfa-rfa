% run the bothPlot function
function [sfaMean, rfaMean, A, p, h] = NCPplot(program,sub1,sub2,figureName)

% newProgram={'Chart_17' 'Chart_21' 'Chart_25' 'Chart_26' 'Math_2' 'Math_4' 'Math_7' 'Math_24' 'Math_40' 'Math_49' };
formula={'Barinel' 'Jaccard' 'Ochiai' 'Op2' 'Tarantula' 'DStar'};
labels={'Barinel' 'Jaccard' 'Ochiai' 'Op2' 'Tarantula' 'DStar'};
combineData=[];
meanNCP=[];
group=[];

for i=1:length(formula)
    %% SFA
    filePath=char(strcat('SFA\',formula(i),'\',lower(program),'_NCP.txt'));
    display(['we are running ',filePath]);
    [sfa_ncp]=textread(filePath,'%d','headerlines',0);
    if isempty(sfa_ncp)
        sfa_ncp=zeros(100,1);
    else
        sfa_ncp=sfa_ncp-1;  % as we have to calculate the number of candidate patches before we find the validate patch, therefore I use the ncp-1 to exclude the valid patch.
    end
    combineData=[combineData,sfa_ncp'];  %SFA
    group=[group,ones(1,length(sfa_ncp))*i];
    sfaMean(i)=mean(sfa_ncp);
    SFAncp=sfa_ncp;
        
    %% RFA
    filePath=char(strcat('RFA\',formula(i),'\',program,'_NCP.txt'));
    [rfa_ncp]=textread(filePath,'%d','headerlines',0);
        if isempty(rfa_ncp)
            rfa_ncp=zeros(100,1)+1;
        end
        most=min(rfa_ncp)-1; 
        combineData=[combineData,ones(1,100)*most];  %RFA   pre1'
        group=[group,ones(1,100)*(i+0.5)];
        rfaMean(i)=most;
        RFAncp=ones(100,1)*most;
        
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

