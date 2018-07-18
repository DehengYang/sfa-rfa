%%
% % ranksum（），用这个。
% % Wilcoxon秩和检验
% % 在Matlab中，秩和检验由函数ranksum实现。命令为：
% % [p,h]=ranksum(x,y,alpha)
% % 其中x，y可为不等长向量，alpha为给定的显著水平，它必须为0和1之间的数量。p返回
% % 产生两独立样本的总体是否相同的显著性概率，h返回假设检验的结果。如果x和y的总
% % 体差别不显著，则h为零；如果x和y的总体差别显著，则h为1。如果p接近于零，则可对
% % 原假设质疑。
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
% % A-statistic≥0.64或≤0.36表示有中等程度的改进，A-statistic≥0.72或≤0.29则表示改进效果较大
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