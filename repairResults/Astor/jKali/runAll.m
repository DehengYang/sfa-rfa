clear;
file={'Chart_1' 'Chart_5' 'Chart_13' 'Chart_15' 'Math_80' 'Math_81' 'Math_82' 'Math_84' 'Math_85'};

formula={'Barinel' 'Jaccard' 'Ochiai' 'Op2' 'Tarantula' 'DStar'};
fig=figure('color',[1 1 1]);

% set(fig, 'Position', [100, 100, 800, 600]);   
A1=[];
p1=[];
h1=[];
for i=1:length(file)
    sub1=2;
    sub2=5;
    figureName=i;
    subplot(sub1,sub2,figureName);
    [sfaMean, rfaMean, A, p, h]=NCPplot(file(i),sub1,sub2,figureName);
    A1(i,:)=A;
    p1(i,:)=p;
    h1(i,:)=h;
    sfaMean1(i,:)=sfaMean;
    rfaMean1(i,:)=rfaMean;
    if i==5
        legend(findobj(gca,'Tag','Box'),'RFA','SFA')
    end
end

minus=rfaMean1-sfaMean1