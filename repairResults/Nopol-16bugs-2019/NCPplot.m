% run the bothPlot function
function [proNew sfaMean, rfaMean, A, p, h] = NCPplot(program,sub1,sub2,figureName)
% clear;
% fig=figure()
% % set (gca,'position',0.05*[1,1,9,9])
% % set(fig,'position',[100 100 700 600]);
% set(fig,'color',[1 1 1]);
% % sub1=1;
% % sub2=1;
% figureName=1;
% program = 'Closure_1';

times=2;

newProgram={'Chart_17' 'Chart_21' 'Chart_25' 'Chart_26' 'Math_2' 'Math_4' 'Math_7' 'Math_24' 'Math_40' 'Math_49' };
formula={'Barinel' 'Jaccard' 'Ochiai' 'Op2' 'Tarantula' 'DStar'};
labels={'Barinel' 'Jaccard' 'Ochiai' 'Op2' 'Tarantula' 'DStar'};
combineData=[];
meanNCP=[];
group=[];

for i=1:length(formula)
    proNew='';
   %% SFA
    path=char(strcat('SFA\',formula(i),'\'));
    fileName=char(strcat('experimentData_',program,'.txt'));
    processFile(path,fileName);
    filePath=char(strcat(path,'0_',fileName));
    disp(['we are running ',filePath]);
    [pre1,~,~,~,~,~]=textread(filePath,'%d%s%s%s%s%d','headerlines',0);
    if isempty(pre1)
        pre1=zeros(100,1);
    else
        pre1=pre1-1;
    end

    combineData=[combineData,pre1'];  %SFA
    group=[group,ones(1,length(pre1))*i*times];
    sfaMean(i)=mean(pre1);
    SFAncp=pre1;

    %% RFA
    path=char(strcat('RFA\',formula(i),'\'));
    fileName=char(strcat('experimentData_',program,'.txt'));
    processFile(path,fileName);
    filePath=char(strcat(path,'0_',fileName));
    [pre1,pre2,pre3,pre4,pre5,pre6]=textread(filePath,'%d%s%s%s%s%d','headerlines',0);
    if isempty(pre1)
        pre1=zeros(100,1)+1;
    end
    most=mode(pre1)-1; 
    combineData=[combineData,ones(1,100)*most];  %RFA   pre1'
    group=[group,ones(1,100)*(i+0.5)*times];
    rfaMean(i)=most;
    RFAncp=ones(100,1)*most;

    %% A-test
    [A(i) p(i) h(i)]=WilcoxonTest(SFAncp,RFAncp);
end

positions(1)=1.5;
for j =2:12    %length(positions)
%     i=tmp(j)
    if mod(j,2) == 0
        positions(j)=positions(j-1)+0.5;
    else
        positions(j)=positions(j-1)+1;
    end
end

color=[ [ 28 28 28]/255;[255 69 0 ]/255];	% DodgerBlue255 69 0  % color=repmat('rb',1,12);  ,'PlotStyle' ,'traditional','Notch','off', ... 'MedianStyle','line'
a=boxplot(combineData,group,'Colors',color,'symbol','.','widths',0.4,'positions', positions) ;%,'PlotStyle', 'compact'  'Colors','kk';[0.5 0.5 0]   'factorgap',10,  ,'OutlierSize',10   'FactorGap',0.5,


title(strrep(char(program),'_','\_'));
box on;

ax=gca;


ax.XTick=linspace(1.75,9.25,6);

for ax_cnt=1:(length(ax.XTick)-1)
   hold on;
   x1=0.5*(ax.XTick(ax_cnt)+ax.XTick(ax_cnt+1));
   xline=[x1,x1];
   y1=[min(combineData)-100,max(combineData)+100];
   plot(xline,y1,':','color',[28 28 28]/255,'linewidth',0.1)   %220 220 220
end


ax.XTickLabel = {'Bar' 'Jac' 'Och' 'Op2' 'Tar' 'Dst'};
ax.FontSize =8;
ax.YTick = linspace(min(combineData),max(combineData),6);
ytickformat('%4.0f')

ax.FontName='Times New Roman';


