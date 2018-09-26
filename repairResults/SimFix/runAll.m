% This .m file aims to plot grouped boxplots of NCP scores obtained by SFA-based and RFA-based Nopol for each bug and SFL technique.
% The figure corresponds to Fig. 3. in our paper.
clear;
file={'Chart_12' 'Lang_33' 'Math_5' 'Math_35' 'Math_53' 'Math_63' 'Math_75'};
formula={'Barinel' 'Jaccard' 'Ochiai' 'Op2' 'Tarantula' 'DStar'};
fig=figure(1)
set(fig,'color',[1 1 1]);
num=0.055;
% set(fig, 'Position', [100, 100, 800, 600]); 
AllRank=[];
% pro='';

for i=1:7%17:32
    sub1=2;
    sub2=4;
    figureName=i;
    subplot(sub1,sub2,figureName);
    [sfaMean, rfaMean, A, p, h]=NCPplot(file(i),sub1,sub2,figureName);
    A1(i,:)=A;
    p1(i,:)=p;
    h1(i,:)=h;
    sfaMean1(i,:)=sfaMean;
    rfaMean1(i,:)=rfaMean;
%     pro=strcat(pro,' ',proNew);
    if i==5
        le=legend(findobj(gca,'Tag','Box'),'RFA','SFA');
        set(le,'Box','off')
    end
    if(rem(i,4)==1)
    end
end
minus=rfaMean1-sfaMean1
