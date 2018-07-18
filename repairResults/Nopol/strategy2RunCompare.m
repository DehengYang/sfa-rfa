clear,clc;
formula={'Ochiai'};
labels={'Ochiai' 'Och-New'};
program={'Chart_3' 'Closure_62' 'Lang_44'  'Math_81' 'Mockito_38' 'Time_12'};
distance=[];
figure('color',[1 1 1]);

for i= 1:length(program) 
    combine=[];
    group=[];
    path=char(strcat('SFA-100repair\',formula,'\'));
    fileName=char(strcat('experimentData_',program(i),'.txt'));
    filePath=char(strcat(path,'0_',fileName));
    [pre1,pre2,pre3,pre4,pre5,pre6]=textread(filePath,'%d%d%d%s%s%s','headerlines',0);
    if isempty(pre1)
        pre1=zeros(100,1);
    end
    combine=[combine,pre1'-1];
    group=[group,ones(1,length(pre1))*1];

    
    path=char('Och-New-100repair\');
    fileName=char(strcat('experimentData_',program(i),'.txt'));
    processFile(path,fileName);
    filePath=char(strcat(path,'0_',fileName));
    [new1,new2,new3,new4,new5,new6]=textread(filePath,'%d%d%d%s%s%s','headerlines',0);
    if isempty(pre1)
        new1=zeros(100,1);
    end
    combine=[combine,new1'-1];
    group=[group,ones(1,length(new1))*2];
    
    [A(i) p(i) h(i)]=WilcoxonTest(pre1,new1);

    mean1(i)=mean(pre1);
    mean2(i)=mean(new1);
    mean3(i)=mean1(i)-mean2(i);
    subplot(2,3,i);
    colors=[[28 28 28]/255;[255 69 0 ]/255];	% DodgerBlue255 69 0 
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