% This .m file aims to plot grouped boxplots of NCP scores obtained by SFA-based and RFA-based Nopol for each bug and SFL technique.
% The figure corresponds to Fig. 3. in our paper.
clear;
file={'Chart_3' 'Chart_5' 'Chart_9' 'Chart_13' 'Chart_17' 'Chart_21' 'Chart_25' 'Chart_26' 'Closure_61' 'Closure_62' 'Closure_67' 'Closure_72' ...
    'Lang_44' 'Lang_51' 'Lang_53' 'Lang_58' 'Math_2' 'Math_4' 'Math_7' 'Math_24' 'Math_40' 'Math_49' 'Math_69' 'Math_73' 'Math_81' 'Math_85'  ... 
   'Mockito_29' 'Mockito_38' 'Time_4' 'Time_7' 'Time_11' 'Time_12'};
formula={'Barinel' 'Jaccard' 'Ochiai' 'Op2' 'Tarantula' 'DStar'};
fig=figure(1)
set(fig,'color',[1 1 1]);
num=0.055;
set(fig, 'Position', [100, 100, 800, 600]); 
AllRank=[];
pro='';

for i=1:16%17:32
    sub1=4;
    sub2=4;
    figureName=i;
    subplot(sub1,sub2,figureName);
    [proNew sfaMean, rfaMean, A, p, h]=NCPplot(file(i),sub1,sub2,figureName);
    A1(i,:)=A;
    p1(i,:)=p;
    h1(i,:)=h;
    sfaMean1(i,:)=sfaMean;
    rfaMean1(i,:)=rfaMean;
    pro=strcat(pro,' ',proNew);
    if i==5
        le=legend(findobj(gca,'Tag','Box'),'RFA','SFA');
        set(le,'Box','off')
    end
    if(rem(i,4)==1)
    end
end
minus=rfaMean1-sfaMean1

fig=figure(2)
set(fig,'color',[1 1 1]);
num=0.055;
set(fig, 'Position', [100, 100, 800, 600]); 
AllRank=[];
pro='';
for i=17:32
    sub1=4;
    sub2=4;
    figureName=i;
    subplot(sub1,sub2,figureName-16);
    [proNew sfaMean, rfaMean, A, p, h]=NCPplot(file(i),sub1,sub2,figureName);
    A1(i,:)=A;
    p1(i,:)=p;
    h1(i,:)=h;
    sfaMean1(i,:)=sfaMean;
    rfaMean1(i,:)=rfaMean;
    pro=strcat(pro,' ',proNew);
    if i==5
        le=legend(findobj(gca,'Tag','Box'),'RFA','SFA');
        set(le,'Box','off')
    end
    if(rem(i,4)==1)
    end
end
minus=rfaMean1-sfaMean1
