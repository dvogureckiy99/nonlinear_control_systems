clc
clear
InitialConditions.T=9;
InitialConditions.K=3;
InitialConditions.h=6;
InitialConditions.d=0.6;
%% начальные условия-------------------------------------------------------------------------change
T=InitialConditions.T;
K=InitialConditions.K;
h=InitialConditions.h;
d=InitialConditions.d;
paramchoose=["k1k2","ab","c1c2","one_param","Ts" ];
key=paramchoose(2);
testPWM = 1; %тестировать ли схему с ШИМ ?
withPWM = 1; %тестировать ли схему с PWM или просто с диксретизацией сигнала
testtugether = 0 ;%тестировать ли схему с ШИМ вместе с обычной ?
regulirov=["in_mal","in_bol"];
regulir=regulirov(2);
if testPWM==1
name_system = 'sim_final_VSS_PWM';
else
   name_system = 'sim_final_VSS'; 
end
av=[14 100 200];% 
% for i=1:5
%     av=[av 100];
% end
a=av(1);
bv=[ -200 -200 -200];%
b=bv(1);
% C1v=[];
% for i=1:5
%     C1v=[C1v 50];
% end
% C2v=[230 240 250 260 270];
C1v=[50 50 100 200]; %
C1=C1v(2);   
C2v=[227.25 250 455.8 910.5]; %1
C2=C2v(2);
% k1v=[];
% for i=1:5
%     k1v=[k1v 2];
% end
k1v=[1 2 10];
k1=k1v(2);
% k2v=[46 46.2 46.4 46.6 46.8];
k2v=[20 43.1 214];
k2=k2v(2);
ds=1;
sw1v=[d 1 10 100 1e3 ] ;
sw1=sw1v(2); 
if regulir=="in_mal"
    zad=1;
else
    zad=100;
end
if regulir=="in_mal"
    end_time=40;
else
end_time=300;
end
handle = load_system(name_system); %загрузка схемы

%установка параметров
x0=0;
y0=0;
z0=0;

%параметры ШИМ
Tsv=[2 4 6] ;
Ts=1e-2; %sec
Am=d;%высота пилы

%% setting 
if testPWM==1
    if key==paramchoose(5)
       FStep=2;
    else
       FStep=Ts/10;
    end
else
FStep=1e-2;
end

%перенос переменных в основную базу переменных
assignin('base','end_time',end_time);%------------------------------------------------------------------время симуляции1
assignin('base','FStep',FStep);
%set_param(handle,'StopTime','end_time' ,'SolverPrmCheckMsg','warning'...
 %  ,'SolverResetMethod','robust','Solver','ode8','SolverType','Fixed-step','FixedStep','FStep',...
%    'SaveFormat','Array','SaveOutput','off','ReturnWorkspaceOutputs','off');
set_param(handle,'StopTime','end_time','Solver','ode8','SolverType','Fixed-step','FixedStep','FStep');
    Cellfigparam{1}{1}='k-';
    Cellfigparam{1}{2}=2;
    Cellfigparam{2}{1}='k-';
    Cellfigparam{2}{2}=1;
    Cellfigparam{3}{1}='k--';
    Cellfigparam{3}{2}=1;
    Cellfigparam{4}{1}='k:';
    Cellfigparam{4}{2}=1;
    Cellfigparam{5}{1}='k-.';
    Cellfigparam{5}{2}=1;
 Cellfig{1} = figure('Units', 'normalized', 'OuterPosition', [0 0 1 1],'PaperOrientation','Landscape');
%%
figure(Cellfig{1});%target figure
    ST=0.05; RT = [ 0 1 ] ;
    if testPWM==1
        if withPWM==1
            set_param([name_system,'/Manual Switch'] , 'sw', '1') ;%PWM
        else
            set_param([name_system,'/Manual Switch'] , 'sw', '0') ;
        end
    end
    if key==paramchoose(1)
        len=length(k1v);
    elseif key==paramchoose(2)
            len=length(av);
    elseif key==paramchoose(3)
        len=length(C1v);
        elseif key==paramchoose(4)
            len=1;
    elseif key==paramchoose(5)
        len=length(Tsv);
    end
        iter=0;
    for i=1:len
        if key==paramchoose(1)
            k1=k1v(i);
            k2=k2v(i);
        elseif key==paramchoose(2)
            a=av(i);
        b=bv(i);
        elseif key==paramchoose(3)
             C1=C1v(i);
         C2=C2v(i);
         elseif key==paramchoose(5)
             Ts=Tsv(i);
        end

        %sw1=sw1v(i);
        %Ts=Tsv(i);
        [t,~,x] = sim(name_system);

        S=stepinfo(x(:,1),t,'SettlingTimeThreshold',ST,'RiseTimeLimits',RT);
        Settlingtime = S.SettlingTime 
        Peak = (S.Peak-zad)*100/zad;
        disp(['Overshoot in %  :',num2str(Peak,5),' .']);
        iter=iter+1
        hold on
        plot(t,x(:,1),Cellfigparam{i}{1},'LineWidth',Cellfigparam{i}{2});grid on
       xlabel('$$t$$,sec','Interpreter','latex'),ylabel('$$X$$','Interpreter','latex')
       if testtugether==0
            if key==paramchoose(1)    
                leg{i} =['$k_1=',num2str(k1v(i),3),',k_2=',num2str(k2v(i),3),',ST=',num2str(Settlingtime,7),'sec $'] ;
            elseif key==paramchoose(2)
                leg{i} =['$a=',num2str(av(i),3),',b=',num2str(bv(i),3),',ST=',num2str(Settlingtime,7),'sec $'] ;  
            elseif key==paramchoose(3)
                leg{i} =['$C1=',num2str(C1v(i),5),',C2=',num2str(C2v(i),5),',ST=',num2str(Settlingtime,7),'sec $'] ;  
            elseif key==paramchoose(5)
                leg{i} =['$Ts=',num2str(Ts,3),',Fstep=',num2str(FStep,3),',ST=',num2str(Settlingtime,7),'sec $'] ;
            end
            %leg{i} =['$sw1=',num2str(sw1v(i),3),',ST=',num2str(Settlingtime,7),'sec $'] ;
       else
             leg{1}=[' Сontinuo,','ST=',num2str(Settlingtime,7),'sec' ] ;
       end
    end

if key~=paramchoose(4)
  legend(leg,'Interpreter','latex','Location','southeast');
else
  leg=['Overshoot=',num2str(Peak,5),'%,ST=',num2str(Settlingtime,7),'sec'] ;
  legend(leg,'Interpreter','latex','Location','southeast');
end
% else
% leg =['$C1=',num2str(C1v(i),5),',C2=',num2str(C2v(i),5),',ST=',num2str(Settlingtime,7),'sec $'] ;
% legend(leg,'Interpreter','latex','Location','southeast');

if testtugether==1
    if testPWM==1 
        if withPWM==1
       set_param([name_system,'/Manual Switch'] , 'sw', '1'); %whith PWM --1  or with ограничением и дискрет --0 
        else
            set_param([name_system,'/Manual Switch'] , 'sw', '0')
        end
        [t,~,x] = sim(name_system);
        S=stepinfo(x(:,1),t,'SettlingTimeThreshold',ST,'RiseTimeLimits',RT);
        Settlingtime = S.SettlingTime 
       Peak = (S.Peak-zad)*100/zad;
            disp(['Overshoot in %  :',num2str(Peak,5),' .']);
        plot(t,x(:,1),Cellfigparam{4}{1},'LineWidth',Cellfigparam{4}{2});grid on
        leg{2}=[' PWM,','ST=',num2str(Settlingtime,7),'sec'] ;
      legend(leg,'Interpreter','latex','Location','southeast');
    else
   
    end
end
% end_time=Settlingtime;
% end_time=ceil((end_time*3)/5)*5;
% set_param(handle,'StopTime','end_time' );
% 
% sim(name_system);
    %закрытие системы
    
save_system(handle);
close_system(handle);