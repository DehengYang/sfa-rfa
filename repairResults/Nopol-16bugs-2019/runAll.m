% This .m file aims to plot grouped boxplots of NCP scores obtained by SFA-based and RFA-based Nopol for each bug and SFL technique.
% The figure corresponds to Fig. 3. in our paper.
clear;

file={'Closure_1' 'Closure_2' 'Closure_3' 'Closure_5' 'Closure_7' 'Closure_8' 'Closure_10' ...
    'Closure_14' 'Closure_15' 'Closure_16' 'Closure_113'  ...
    'Math_42' 'Time_18' 'Closure_120' 'Closure_121' 'Closure_131' };

formula={'Barinel' 'Jaccard' 'Ochiai' 'Op2' 'Tarantula' 'DStar'};
fig=figure();
set(fig,'color',[1 1 1]);
num=0.055;
set(fig, 'Position', [100, 100, 800, 600]); 
AllRank=[];
pro='';

for i=1:16 %32
    sub1=4;
    sub2=4;
    figureName=i;
    sub=subplot(sub1,sub2,figureName);
%     getpos(sub)
    [proNew sfaMean, rfaMean, A, p, h]=NCPplot(file(i),sub1,sub2,figureName);
    A1(i,:)=A;
    p1(i,:)=p;
    h1(i,:)=h;
    sfaMean1(i,:)=sfaMean;
    rfaMean1(i,:)=rfaMean;
    pro=strcat(pro,' ',proNew);
    if i==1
        le=legend(findobj(gca,'Tag','Box'),'RFA','SFA');
        set(le,'Box','off')
    end
    if mod(i,4)==1
        ylabel('NCP')
    end
%     if(rem(i,4)==1)
%     end
end
minus=rfaMean1-sfaMean1;