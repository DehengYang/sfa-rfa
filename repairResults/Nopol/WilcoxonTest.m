%%
% % ranksum�������������
% % Wilcoxon�Ⱥͼ���
% % ��Matlab�У��Ⱥͼ����ɺ���ranksumʵ�֡�����Ϊ��
% % [p,h]=ranksum(x,y,alpha)
% % ����x��y��Ϊ���ȳ�������alphaΪ����������ˮƽ��������Ϊ0��1֮���������p����
% % ���������������������Ƿ���ͬ�������Ը��ʣ�h���ؼ������Ľ�������x��y����
% % ������������hΪ�㣻���x��y����������������hΪ1�����p�ӽ����㣬��ɶ�
% % ԭ�������ɡ�
% n = 8;
% file = cell(1,n);
% file(1)={'Chart_5'};
% file(2)={'Chart_13'};
% file(3)={'Chart_25'};
% file(4)={'Time_11'};
% file(5)={'Math_40'};
% file(6)={'Math_49'};
% file(7)={'Math_81'};
% file(8)={'Math_85'};
% i=8;
% % A-statistic��0.64���0.36��ʾ���еȳ̶ȵĸĽ���A-statistic��0.72���0.29���ʾ�Ľ�Ч���ϴ�
% curFile=char(strcat('testResults_pre\experimentData_',file(i),'.txt'));
% [pre1,pre2,pre3,pre4,pre5]=textread(curFile,'%d%d%s%s%s','headerlines',0);
% pre2=pre2/1000;
% 
% curFile=char(strcat('testResults_rev\experimentData_',file(i),'.txt'));
% [rev1,rev2,rev3,rev4,rev5]=textread(curFile,'%d%d%s%s%s','headerlines',0);
% rev2=rev2/1000;

%%
function [A p h]=WilcoxonTest(collectTimesPre,collectTimesRev)
X=collectTimesPre;
Y=collectTimesRev;
N = size(X,1);
M = size(Y,1);
[p,h,st] = ranksum(X,Y,'alpha',0.05);
A = (st.ranksum/N - (N+1)/2)/M;
if (A<0)
    A = (st.ranksum/M - (M+1)/2)/N;
end;
% [p_Wilcoxon,h_Wilcoxon] = ranksum(Y,X);%Wilcoxon rank sum test
A;

% mean(collectTimesPre);
% mean(collectTimesRev);