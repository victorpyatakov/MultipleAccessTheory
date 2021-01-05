close all;
clear all;
clc;

%параметры моделирования Алохи
M = 3;
p = 1/M;
b = 1;
T = 10000;
P = zeros(M+1,M+1);
lamd = 0.1:1:40;


Size = length(lamd);
enterLam=zeros(1,Size);
exitLam=zeros(1,Size);
D=zeros(1,Size);
N=zeros(1,Size);
teorN = zeros(1,Size);
teorD = zeros(1,Size);
teorLam = zeros(1,Size);
sendingAbons = [];

for i_lamd = 1:length(lamd)
    lam = lamd(i_lamd);
    lam = lam/M;
    y = exp(-lam);
    fun = @(n) ((M-n)*(1-y)-n*p*((1-p)^(n-1)));
    
    for i_abon = 1:M
       abon(i_abon) = struct('newMsg',poissrnd(lam,1,T),'buf',[],'timeBuf',[],'numOfSentMsg',0,'numOfMsgInQue',0,'avgDelay',0.0);        
    end    
    for currentWindow = 1:T
        %fprintf('В окне № %d ',currentWindow);
        for currentAbon = 1:length(abon)
            %fprintf(' у абонента %d',currentAbon);
            if(~isempty(abon(currentAbon).buf))%подсчёт заявок в очереди 
                abon(currentAbon).numOfMsgInQue = abon(currentAbon).numOfMsgInQue + 1;
                %fprintf(' буфер = 1');
                if (rand < p)%абонент передаёт?
                    %fprintf(' и он передаёт,');
                    sendingAbons = [sendingAbons, currentAbon];
                else
                    %fprintf(' и он не передаёт,');
                end
            else
                %fprintf(' буфер = 0');
            end
            if (abon(currentAbon).newMsg(currentWindow) > 0)%пришли сообщения?
                %fprintf(' пришло %d заявок,', abon(currentAbon).newMsg(currentWindow));
                if (isempty(abon(currentAbon).buf))%если буфер пустой, записываем
                    %fprintf(' записали в буфер');
                    abon(currentAbon).buf = [abon(currentAbon).buf, 1];
                    abon(currentAbon).timeBuf = [abon(currentAbon).timeBuf, currentWindow];
                else
                    %fprintf(' заявки отброшены');
                end
            else
               % fprintf(' заявок не пришло');
            end
            %fprintf(' \n');
        end
        if (length(sendingAbons) == 1)%абонент один в канале?
            %fprintf(' Успех.');
            abon(sendingAbons(1)).numOfSentMsg = abon(sendingAbons(1)).numOfSentMsg + 1;
            %fprintf(' Сообщ. отпр. с задержкой %d',(currentWindow - abon(sendingAbons(1)).timeBuf(1)));
            abon(sendingAbons(1)).avgDelay = abon(sendingAbons(1)).avgDelay + (currentWindow - abon(sendingAbons(1)).timeBuf(1));
            abon(sendingAbons(1)).timeBuf = [];
            abon(sendingAbons(1)).buf = [];
        elseif (length(sendingAbons) == 0)
            %fprintf(' Пусто');
        else
            %fprintf(' Конфликт');   
        end
       % fprintf(' \n');
        sendingAbons = [];
    end
   
    for i = 1:length(abon)
       N(i_lamd) = N(i_lamd) + abon(i).numOfMsgInQue;
       D(i_lamd) = D(i_lamd) + (abon(i).avgDelay / abon(i).numOfSentMsg);
       exitLam(1,i_lamd) = exitLam(1,i_lamd) + abon(i).numOfSentMsg;
    end
    enterLam(1,i_lamd) = lamd(i_lamd);
    root = fzero(fun,[0.0 M]);
    teorN(1,i_lamd) = root(1);
    P = create_P(M,lam,p);
  
    %teorLam(1,i_lamd) = 1-S(1,1);
    teorD(1,i_lamd) = teorN(1,i_lamd);
    fprintf('%d из %d циклов выполнено \n',i_lamd,length(lamd)) 
end    

exitLam = exitLam./(T);
teorD = teorD./exitLam;
N = N./(T);
D = D./ M;

plot(enterLam, exitLam,'LineWidth',2);
xlabel('Интенсивность входного потока');
ylabel('Интенсивность выходного потока');
grid on;
hold on;
plot(enterLam, teorLam,'LineWidth',2);
legend('Практ','Теор');
title('Зависимсоть выходной интенсивности от входной');

figure(2)
plot(enterLam,D,'LineWidth',2);
xlabel('Интенсивность входного потока');
ylabel('Средняя задержка');
grid on;
hold on;
plot(enterLam, teorD,'LineWidth',2);
legend('Практ','Теор');
title('Зависимость средней задержки от интенсивности входного потока');

figure(3)
plot(enterLam,N,'LineWidth',2);
xlabel('Интенсивность входного потока');
ylabel('Среднее число заявок в очереди');
grid on;
hold on;
plot(enterLam, teorN,'LineWidth',2);
legend('Практ','Теор');
title('Зависимость среднего числа заявок в очереди от интенсивности входного потока');


