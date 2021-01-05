close all;
clear all;
clc;

lymda=1;
y=exp(-lymda);
M=3;
p=1/M;
P=zeros(M+1,M+1);

P(1,1)=y^3;

P(1,2)=nchoosek(3,1)*y^(3-1)*(1-y)^1;
P(1,3)=nchoosek(3,2)*y^(3-2)*(1-y)^2;
P(1,4)=1-y^3;

%% �������� �� 1

P(2,1)=1*p*(1-p)^(1-1)*y^(3-1);

P(2,3)=nchoosek(3-1,1)*(1-y)^1*y^(3-1-1)*(1-1*p*(1-p)^(1-1))+nchoosek(3-1,1+1)*(1-y)^(1+1)*y^(3-1-(1+1))*(1*p*(1-p)^(1-1));

P(2,4)=nchoosek(3-1,2)*(1-y)^2*y^(3-1-2)*(1-1*p*(1-p)^(1-1));%+nchoosek(3-1,2+1)*(1-y)^(2+1)*y^(3-1-(2+1))*(1*p*(1-p)^(1-1));

P(2,2)=1-sum(P(2,:));

%%�������� �� 2

P(3,2)=2*p*(1-p)^(2-1)*y^(3-2);


P(3,4)=nchoosek(3-2,1)*(1-y)^1*y^(3-2-1)*(1-2*p*(1-p)^(2-1));

P(3,3)=1-sum(P(3,:));

%% �������� �� 3

P(4,3)=3*p*(1-p)^(3-1);
P(4,4)=1-3*p*(1-p)^(3-1);