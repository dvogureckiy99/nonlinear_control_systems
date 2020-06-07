function [FIGS,Settlingtime] = sim_VSS_final_DCS(PATH,InitialConditions,name_system,param,zad)
           

     set(0,'DefaultAxesFontSize',14,'DefaultAxesFontName','Times New Roman');%шрифт
     set(0,'DefaultTextFontSize',14,'DefaultTextFontName','Times New Roman'); %
 
    %перенос переменных в основную базу переменных
    assignin('base','T',InitialConditions.T);
    assignin('base','h',InitialConditions.h);
    assignin('base','d',InitialConditions.d);
    assignin('base','K',InitialConditions.K);
    
    %имя и путь графика для Latex
    % Переменные состояния
    figure_name = [strrep(name_system,'sim_',''),'_sv_DCS_mal'];%имя графика
    figure_file_path=['images/',figure_name];% путь к графику
    figure_file_path = join(figure_file_path);
    FIGS.names{1} = figure_name ;
    FIGS.path{1}=figure_file_path;
    FIGS.description{1}=' Графики изменения переменных состояния в <<малом>>.';
   
  
    % Переменные состояния
    figure_name = [strrep(name_system,'sim_',''),'_sv_DCS_bol'];%имя графика
    figure_file_path=['images/',figure_name];% путь к графику
    figure_file_path = join(figure_file_path);
    FIGS.names{2} = figure_name ;
    FIGS.path{2}=figure_file_path;
    FIGS.description{2}=' Графики изменения переменных состояния в <<большом>>.';
    
    
    num=3;
    figure_name = [strrep(name_system,'sim_',''),'_DCS_SAW'];%имя графика
    figure_file_path=['images/',figure_name];% путь к графику
    figure_file_path = join(figure_file_path);
    FIGS.names{num} = figure_name ;
    FIGS.path{num}=figure_file_path;
    FIGS.description{num}=' Генерируем пилу';
    
    handle = load_system(name_system); %загрузка схемы

    %установка параметров
    R=100;
    y0=[ 0 0 ];
    x0=[0 0];
    z0=[0 0];
    x0=x0*R;
    y0=y0*R;
    z0=z0*R;
    
    FStep=10^-3;
    end_time=1000;
    %перенос переменных в основную базу переменных
    assignin('base','end_time',end_time);%------------------------------------------------------------------время симуляции1
    assignin('base','FStep',FStep);
    set_param(handle,'StopTime','end_time' ,'SolverPrmCheckMsg','warning'...
        ,'SolverResetMethod','robust','Solver','ode8','SolverType','Fixed-step','FixedStep','FStep',...
        'SaveFormat','Array','SaveOutput','off','ReturnWorkspaceOutputs','off');
    Cellfigparam{1}{1}='k-';
    Cellfigparam{1}{2}=2;
     Cellfigparam{2}{1}='k--';
    Cellfigparam{2}{2}=2;
    for i=1:length(FIGS.names)
    Cellfig{i} = figure('Units', 'normalized', 'OuterPosition', [0 0 1 1],'PaperOrientation','Landscape');
    end
    
     %перенос переменных в основную базу переменных
     k=1;
    C1=param{k}(3);
    C2=param{k}(4);
    alpha=param{k}(1);
    betta=param{k}(2);
    k1=param{k}(5);
    k2=param{k}(6);
    ds=param{k}(7);
    assignin('base','a',alpha);
    assignin('base','b',betta);
    assignin('base','C1',C1);
    assignin('base','C2',C2);
    assignin('base','k1',k1);
    assignin('base','k2',k2);
    assignin('base','ds',ds); 
    
    ymax=0;
    ymin=0;
    ST=0.05; RT = [ 0 1 ] ;
    
    %проходим вхолостую определяя максимальное время регулирования для
    %дальнейшей пересимуляции с правильным стоп таймом
    for k=1:2
            assignin('base','zad',zad(k));
       assignin('base','x0',x0(k));
    assignin('base','y0',y0(k));
    assignin('base','z0',z0(k));
    %возвращает сигналы в массиве b в п7орядке согласно номерам портов
    [t,~,x] = sim(name_system);
    assignin('base','x',x(:,1));
    S(k)=stepinfo(x(:,1),t,'SettlingTimeThreshold',ST,'RiseTimeLimits',RT);
    Settlingtime(k) = S(k).SettlingTime ;
    end
    end_time=max(Settlingtime);
    assignin('base','end_time2',end_time);
    end_time=ceil((end_time*3)/5)*5;
    assignin('base','end_time',end_time);%------------------------------------------------------------------время симуляции1
    set_param(handle,'StopTime','end_time' );
    
                assignin('base','zad',zad(1));
    assignin('base','x0',x0(1));
    assignin('base','y0',y0(1));
    assignin('base','z0',z0(1));
    for k=1:1



        %возвращает сигналы в массиве b в п7орядке согласно номерам портов
        [t,~,x] = sim(name_system);
         assignin('base','x',x(:,1));
       


        %расчёт максимума и минимума  y из всех значений
        if ymax<max(x)
        ymax=max(x);
        end
         if ymin>min(x)
        ymin=min(x);
        end


           S(1)=stepinfo(x(:,1),t,'SettlingTimeThreshold',ST,'RiseTimeLimits',RT);
        Settlingtime(1) = S(1).SettlingTime ;

        figure(Cellfig{1});%target figure
        plot(t,x(:,1),Cellfigparam{k}{1},'LineWidth',Cellfigparam{k}{2});grid on,hold on ;  
        xlabel('$$t$$,sec','Interpreter','latex'),ylabel('$$X$$','Interpreter','latex')
        

    end
   
    figure(Cellfig{1});%target figure
    %------------координаты линии времени регулирования линию
    for j=1:length(param)
        for i=1:length(t)
            mag(i)=Settlingtime(j);
        end
        Set{j}=mag;
    end
    Step = (ymax-ymin)/(length(t));
    Ymax(1) = ymin;
    for i=2:length(t)
        Ymax(i)=Step+Ymax(i-1);
    end
    for i=1:length(param)
        %txt = ['$$ t_{p',num2str(i),'}$$'];   
       % text(Settlingtime(i),ymin-6*Step,txt,'Interpreter','latex');
        plot(Set{i},Ymax,Cellfigparam{2}{1},'LineWidth',1);grid on,hold on ;
    end

    %%новый 
                assignin('base','zad',zad(2));
     assignin('base','x0',x0(2));
    assignin('base','y0',y0(2));
    assignin('base','z0',z0(2));
    for k=1:1
    
    

    %возвращает сигналы в массиве b в п7орядке согласно номерам портов
    [t,~,x] = sim(name_system);
    assignin('base','x',x(:,1));
    saw=x(:,3);
    
    %расчёт максимума и минимума  y из всех значений
    if ymax<max(x)
    ymax=max(x);
    end
     if ymin>min(x)
    ymin=min(x);
    end
    
    
       S(2)=stepinfo(x(:,1),t,'SettlingTimeThreshold',ST,'RiseTimeLimits',RT);
    Settlingtime(2) = S(2).SettlingTime ;
    
    
    figure(Cellfig{2});%target figure
    plot(t,x(:,1),Cellfigparam{k}{1},'LineWidth',Cellfigparam{k}{2});grid on,hold on ;  
    xlabel('$$t$$,sec','Interpreter','latex'),ylabel('$$X$$','Interpreter','latex')
    
    figure(Cellfig{3});
    count=end_time/FStep;
    part=50; %начало в процентах
    part=part/100;
    start=int64(part*count);
    ended=int64(start+1/FStep);
   % assignin('base','S_T1',start);
    %assignin('base','S_T2',ended);
     plot(t(start:ended),saw(start:ended),'k-','LineWidth',2);grid on,hold on ; 
end
    figure(Cellfig{2});%target figure
    %------------координаты линии времени регулирования линию
    for j=1:length(param)
        for i=1:length(t)
            mag(i)=Settlingtime(j);
        end
        Set{j}=mag;
    end
    Step = (ymax-ymin)/(length(t));
    Ymax(1) = ymin;
    for i=2:length(t)
        Ymax(i)=Step+Ymax(i-1);
    end
    for i=1:length(param)
        %txt = ['$$ t_{p',num2str(i),'}$$'];   
       % text(Settlingtime(i),ymin-6*Step,txt,'Interpreter','latex');
        plot(Set{i},Ymax,Cellfigparam{2}{1},'LineWidth',1);grid on,hold on ;
    end

    for i=1:length(Cellfig)
    prints(FIGS.names{i},PATH.images,Cellfig{i}); %save to pdf and crop with dos
    close(Cellfig{i}); %закрываем , чтобы не засорять память
    end

    %% 
    %закрытие системы
    save_system(handle);
    close_system(handle);
end
