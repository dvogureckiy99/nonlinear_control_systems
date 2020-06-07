function [FIGS ,k1v, k2v, mult,Settlingtime,index_min_S] = sim_sysPD(InitialConditions,PATH,k1koef,k2ust)
    %перенос переменных в основную базу переменных
    assignin('base','end_time',500);%------------------------------------------------------------------время симуляции
    FStep=0.1 ;
    assignin('base','FStep',FStep);
    %перенос переменных в основную базу переменных
    assignin('base','T',InitialConditions.T);
    assignin('base','h',InitialConditions.h);
    assignin('base','d',InitialConditions.d);
    assignin('base','K',InitialConditions.K);

    name_system = 'sim_PD';                 %имя схемы

    % Переходная х-ка
    figure_name = [strrep(name_system,'sim_',''),'_sys'];%имя графика
    figure_file_path=['images/',figure_name];% путь к графику
    figure_file_path = join(figure_file_path);
    FIGS.names{1} = figure_name ;
    FIGS.path{1}=figure_file_path;
    FIGS.description{1}=' Графики изменения выходной переменной $X$ для разных $k_1,k_2$.';
    
    handle = load_system(name_system); %загрузка схемы

    set_param(handle,'StopTime','end_time' ,'SolverPrmCheckMsg','warning'...
    ,'SolverResetMethod','robust','Solver','ode113','SolverType','Fixed-step','FixedStep','FStep',...
    'SaveFormat','Array','SaveOutput','off','ReturnWorkspaceOutputs','off')
    Cellfig{1} = figure('Units', 'normalized', 'OuterPosition', [0 0 1 1],'PaperOrientation','Landscape');
    
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
    k1v=[1 1 1 1 1].*k1koef.*100;
    mult=[1 5 11 12 15]; %k2=mult*k2kr(k1v)
    syms k1 ;
    for i=1:5
        k2(i)=double(subs(k2ust,k1,k1v(i)))*mult(i);
    end
    ST=0.05;RT = [ 0 1 ] ;
    
%%   проходим вхолостую определяя максимальное время регулирования для
%дальнейшей пересимуляции с правильным стоп таймом
    for i=1:5
    %установка параметров
    assignin('base','k1',k1v(i)); %загружаем в модель новое k
    assignin('base','k2',k2(i)); %загружаем в модель новое k
            %возвращает сигналы в массивах в порядке согласно номерам портов
        [t,~,x] = sim(name_system);
        assignin('base','x',x);
            A = stepinfo(x,t,'SettlingTimeThreshold',ST,'RiseTimeLimits',RT);
        S(i) = A.SettlingTime ;
    end
    assignin('base','end_time',ceil((min(S)*2)/20)*20);%------------------------------------------------------------------время симуляции1
    set_param(handle,'StopTime','end_time' );
%%    
    for i=1:5
        %установка параметров
        assignin('base','k1',k1v(i)); %загружаем в модель новое k
        assignin('base','k2',k2(i)); %загружаем в модель новое k
        
        %возвращает сигналы в массивах в порядке согласно номерам портов
        [t,~,x] = sim(name_system);
        assignin('base','x',x);

        A = stepinfo(x,t,'SettlingTimeThreshold',ST,'RiseTimeLimits',RT);
        S(i) = A.SettlingTime ;
        
        figure(Cellfig{1});%target figure
        plot(t,x,Cellfigparam{i}{1},'LineWidth',Cellfigparam{i}{2});grid on, hold on
        xlabel('$$t$$,sec','Interpreter','latex'),ylabel('$$X$$','Interpreter','latex')
        leg{i} =['$k_1=',num2str(k1v(i),3),',k_2=',num2str(k2(i),3),'$'] ;
    end
    Settlingtime = min(S);
    index_min_S = find(S==Settlingtime)
    %для линий установившегося значения 
    for j=1:length(t)
        xsettmax(j)=0.95;
    end
    for j=1:length(t)
        xsettmin(j)=1.05;
    end
    for j=1:length(x)
        xsett(j)=1;
    end

    %строим линии
    plot(t,xsettmax,'black--','LineWidth',0.7);
    plot(t,xsett,'black--','LineWidth',0.7);
    plot(t,xsettmin,'black--','LineWidth',0.7);

    leg{i+1}='$1.05$';
    leg{i+2}='$1$';
    leg{i+3}='$0.95$';
    legend(leg,'Interpreter','latex','Location','southeast');

    prints(FIGS.names{1},PATH.images); %save to pdf and crop with dos
    close(Cellfig{1}); %закрываем , чтобы не засорять память
    
    k2v=k2;
    %% 
    %закрытие системы
    save_system(handle);
    close_system(handle);
end