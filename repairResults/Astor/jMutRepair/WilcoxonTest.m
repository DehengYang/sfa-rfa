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
A;