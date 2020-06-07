function [FIGS] = sim_sysNE(InitialConditions,PATH,k1,k2,Settlingtime)
    %перенос переменных в основную базу переменных
    assignin('base','end_time',ceil((Settlingtime*2)/20)*20);%------------------------------------------------------------------время симуляции
    FStep=0.1 ;
    assignin('base','FStep',FStep);
    %перенос переменных в основную базу переменных
    assignin('base','T',InitialConditions.T);
    assignin('base','h',InitialConditions.h);
    assignin('base','d',InitialConditions.d);
    assignin('base','K',InitialConditions.K);

    name_system = 'sim_NE_influence';                 %имя схемы

    % Переходная х-ка
    figure_name = [strrep(name_system,'sim_',''),'_sys'];%имя графика
    figure_file_path=['images/',figure_name];% путь к графику
    figure_file_path = join(figure_file_path);
    FIGS.names{1} = figure_name ;
    FIGS.path{1}=figure_file_path;
    FIGS.description{1}=[' Графики изменения выходной переменной $X$'];
    
    handle = load_system(name_system); %загрузка схемы

    set_param(handle,'StopTime','end_time' ,'SolverPrmCheckMsg','warning'...
    ,'SolverResetMethod','robust','Solver','ode113','SolverType','Fixed-step','FixedStep','FStep',...
    'SaveFormat','Array','SaveOutput','off','ReturnWorkspaceOutputs','off')
    Cellfig{1} = figure('Units', 'normalized', 'OuterPosition', [0 0 1 1],'PaperOrientation','Landscape');
    
    Cellfigparam{1}{1}='k-';
    Cellfigparam{1}{2}=3;
    Cellfigparam{2}{1}='k-';
    Cellfigparam{2}{2}=1;
    
        %установка параметров
        assignin('base','k1',k1); %загружаем в модель новое k
        assignin('base','k2',k2); %загружаем в модель новое k
        
        %возвращает сигналы в массивах в порядке согласно номерам портов
        [t,~,x] = sim(name_system);
        assignin('base','x',x);

        figure(Cellfig{1});%target figure
        
    for i=1:2
        plot(t,x(:,i),Cellfigparam{i}{1},'LineWidth',Cellfigparam{i}{2});grid on, hold on
        xlabel('$$t$$,sec','Interpreter','latex'),ylabel('$$X$$','Interpreter','latex')
    end
        
        leg{2} =['ПХ с НЭ'] ;
        leg{1} =['ПХ без НЭ'];
    
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
