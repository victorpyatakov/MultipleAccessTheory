close all;
clear all;
clc;
%% ������� ������
T=10000;% ���������� ����
M=2;% ���������� ���������
P_send=1/M;% ����������� ��������
lymda_init=0.1;
lymda_inc=1;% ������������� �������� ������
lymda_end=10;
B=1;% ����� �������
%% ������� ��� ��������
outLymda=zeros(1,length(lymda_init:lymda_inc:lymda_end));
meanQueu=zeros(1,length(lymda_init:lymda_inc:lymda_end));
meanZaderjka=zeros(1,length(lymda_init:lymda_inc:lymda_end));
N_teor1=zeros(1,length(lymda_init:lymda_inc:lymda_end));
N_teor=zeros(1,length(lymda_init:lymda_inc:lymda_end));
delay_teor=zeros(1,length(lymda_init:lymda_inc:lymda_end));
%% �������������
count=1;
for lymda=lymda_init:lymda_inc:lymda_end
    
     

    
    disp(lymda);
    
%% ���������� ������� ��������� �� � ��������� ����. ��. ����� ���������
[P,Matrics_2]  = create_P( M,lymda,P_send );% �������� ������� ���������

C=P'-eye(M+1,M+1);
C(M+1,:)=1;
X=zeros(1,M+1);
X(M+1)=1;
Answ=X/C';% �������� ������ ����. ���������

for i=0:1:M
    N_teor(1,count)=N_teor(1,count)+Answ(i+1)*i; %������������� ������� ����� ������
end
%% ���������� ��� �������������  
Zayavki=poissrnd(lymda/M,M,T);% �������� ����� ������ �� �����
queue=zeros(M,B); %�������
sr_buffer=zeros(M,T);% ������� ������ � ������
Delay=zeros(M,1);% ��������
Otpravka=zeros(M,1);% ������� ���� � ��������
When_sms_come=zeros(M,1);%����� ������ ���������

    for t=1:T %% ���� �� �����
%% ������� ������ � ��������� � ���� ���� ������ � �������
         
        queue=queue+Zayavki(:,t);% ������� ���� �� ������ � ������ � �����
        queue(queue>B)=1;% ��������, ���� ����� ������ 1
        
      
%% ���� ��� ��������� ���������� �����
        if sum(queue)~=0 && sum(Zayavki(:,t))~=0
          
            for i=1:M
              
                if  When_sms_come(i)==0 && queue(i)~=0                  
                   
                      When_sms_come(i)=t;  % ���������� ����� �������� ������
                    
                end
               
            end
           
        end
        
%% ���� �� ��� ����� ��������
        if sum(queue)~=0
            
          send_mes=zeros(M,1);
          
            for Abon=1:M
                
                p=rand;

                 if p<P_send % ���� ���� �������� ������ ��� ��������, �� ����� ����������
                     
                     if queue(Abon,1)~=0 &&  When_sms_come( Abon,1)<t
                         
                         send_mes(Abon,1)=1;%������ �������� ���� ��� ��������
                    
                     end

                end
            end
        
        end
        
%% ��������
        if sum(queue)~=0
            
            if sum(send_mes)==1
                [maxel,ind]=max(send_mes); 
                
                if When_sms_come(ind,1)<t
                   
                    Delay(ind,1)=Delay(ind,1)+(t-When_sms_come(ind,1));%��������� ��������
                    Otpravka(ind,1)=Otpravka(ind,1)+1;%������� �����
                    queue(ind,1)=queue(ind,1)-1;%�������� �����( ���� ����� �� 1)
                    When_sms_come(ind,1)=0;%�������� ����� ������
                    
                end

            end
        end
              
              
    sr_buffer(:,t)=queue;
    end
   
outLymda(1,count)=(sum(Otpravka))/T;     % �������� ������������� 
meanQueu(1,count)=(sum(sum(sr_buffer)))/T; % ������� ����� ���������
meanZaderjka(1,count)=(sum(Delay))/(sum(Otpravka)); % ������� ��������
delay_teor(1,count)=N_teor(1,count)/ outLymda(1,count); % ������� �������� ������


count=count+1;
    
end
meanZaderjka(isnan(meanZaderjka))=0;
delay_teor(isnan(delay_teor))=0;
%% ����� ��������
 figure(1)
plot(lymda_init:lymda_inc:lymda_end,meanQueu);
grid on
 hx = xlabel('������� �������������� ');
 set(hx, 'FontName', 'Arial Cyr', 'FontSize', 11)
 hy = ylabel('������� ����� ������');
 set(hy, 'FontName', 'Arial Cyr', 'FontSize', 11)
 hold on;
plot(lymda_init:lymda_inc:lymda_end,N_teor,'r<');

 
  figure(2)
plot(lymda_init:lymda_inc:lymda_end,(meanZaderjka));
grid on
 hx = xlabel('������� �������������� ');
 set(hx, 'FontName', 'Arial Cyr', 'FontSize', 11)
 hy = ylabel('������� ��������');
 set(hy, 'FontName', 'Arial Cyr', 'FontSize', 11)
hold on;
 plot(lymda_init:lymda_inc:lymda_end,delay_teor,'r>');
 
