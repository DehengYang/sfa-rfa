% This .m file aims to plot grouped boxplots of NCP scores obtained by SFA-based and RFA-based Nopol for each bug and SFL technique.
% The figure corresponds to Fig. 3. in our paper.
clear;
file={'Chart_4' 'Closure_12' 'Closure_22' 'Math_57' 'Math_58' 'Math_80' 'Math_87' 'Math_88' 'Math_105' 'Time_14' 'Time_16' 'Time_19'};
formula={'Barinel' 'Jaccard' 'Ochiai' 'Op2' 'Tarantula' 'DStar'};
fig=figure(1)
set(fig,'color',[1 1 1]);
num=0.055;
set(fig, 'Position', [100, 100, 800, 600]); 
AllRank=[];


for i=1:12%17:32
    sub1=3;
    sub2=4;
    figureName=i;
    subplot(sub1,sub2,figureName);
    [sfaMean, rfaMean, A, p, h]=NCPplot(file(i),sub1,sub2,figureName);
    A1(i,:)=A;
    p1(i,:)=p;
    h1(i,:)=h;
    sfaMean1(i,:)=sfaMean;
    rfaMean1(i,:)=rfaMean;
    if i==5
        le=legend(findobj(gca,'Tag','Box'),'RFA','SFA');
        set(le,'Box','off')
    end
    if(rem(i,4)==1)
    end
end
minus=rfaMean1-sfaMean1
