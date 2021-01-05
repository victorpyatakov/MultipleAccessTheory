function [ P,Matrics_2 ] = create_P( M,lymda,P_send )

y=exp((-1*lymda)/M);

% Matrics_2=[y^2 2*y*(1-y) 1-y^2-2*y*(1-y);...
%            P_send*y 1-(P_send*y+(1-P_send)*(1-y)) (1-P_send)*(1-y);...
%            0 2*P_send*(1-P_send) P_send^2+(1-P_send)^2];



P=zeros(M+1,M+1);

for i=0:M %по строке сверху вниз
    
    for j=0:M %по столбцам слева на право
        
        if i==0%переходы из 0 состояния
            
            if j==0
                P(i+1,j+1)=y^M;
            elseif j>0 && j<M
                P(i+1,j+1)= nchoosek(M,j)*(y^(M-j))*(1-y)^j;
            else
                 P(i+1,j+1)=(1-y)^M;
               
            end
            
            
        elseif i>0 && i<M
            
             if j==i-1
               P(i+1,j+1)=  i*P_send*((1-P_send)^(i-1))*(y^(M-i));
               
             elseif j>i
                 a=j-i;
                  if a+1>M-i
                     P(i+1,j+1)=nchoosek(M-i,a)*((1-y)^a)*(y^(M-i-a))*(1-i*P_send*((1-P_send)^(i-1)));
                
                  else
                 P(i+1,j+1)=nchoosek(M-i,a)*((1-y)^a)*(y^(M-i-a))*(1-i*P_send*((1-P_send)^(i-1)))+...
                    + nchoosek(M-i,a+1)*((1-y)^(a+1))*(y^(M-i-(a+1)))*i*P_send*((1-P_send)^(i-1));
                 end
                if j==M
                    P(i+1,i+1)=1-sum(P(i+1,:));
%                      v=y^(M-i)*nchoosek(M-i,1)*(1-y)*(y^(M-i-1))*i*P_send*(1-P_send)^(i-1);
                end
             end
        else%случай М
            
            if j==i-1
                P(i+1,j+1)=M*P_send*((1-P_send)^(M-1));
            elseif j==M
                 P(i+1,j+1)=1-M*P_send*((1-P_send)^(M-1));
            end
        end
        
        
        
    end
end



%%%%%%%%%%%%%%%%


y=exp(-lymda);
M=3;
p=1/M;
P1=zeros(M+1,M+1);

P1(1,1)=y^3;

P1(1,2)=nchoosek(3,1)*y^(3-1)*(1-y)^1;
P1(1,3)=nchoosek(3,2)*y^(3-2)*(1-y)^2;
P1(1,4)=(1-y)^3;

%% переходы из 1

P1(2,1)=1*p*(1-p)^(1-1)*y^(3-1);

P1(2,3)=nchoosek(3-1,1)*(1-y)^1*y^(3-1-1)*(1-1*p*(1-p)^(1-1))+nchoosek(3-1,1+1)*(1-y)^(1+1)*y^(3-1-(1+1))*(1*p*(1-p)^(1-1));

P1(2,4)=nchoosek(3-1,2)*(1-y)^2*y^(3-1-2)*(1-1*p*(1-p)^(1-1));%+nchoosek(3-1,2+1)*(1-y)^(2+1)*y^(3-1-(2+1))*(1*p*(1-p)^(1-1));

P1(2,2)=1-sum(P1(2,:));

%%переходы из 2

P1(3,2)=2*p*(1-p)^(2-1)*y^(3-2);


P1(3,4)=nchoosek(3-2,1)*(1-y)^1*y^(3-2-1)*(1-2*p*(1-p)^(2-1));

P1(3,3)=1-sum(P1(3,:));

%% переходы из 3

P1(4,3)=3*p*(1-p)^(3-1);
P1(4,4)=1-3*p*(1-p)^(3-1);

Matrics_2=P1;
end

