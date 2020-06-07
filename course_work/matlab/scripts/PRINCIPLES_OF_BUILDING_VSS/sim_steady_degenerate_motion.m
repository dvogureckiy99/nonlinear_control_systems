function FIGS = sim_steady_degenerate_motion(PATH,InitialConditions,k,p1,name_system)
           

     set(0,'DefaultAxesFontSize',14,'DefaultAxesFontName','Times New Roman');%шрифт
     set(0,'DefaultTextFontSize',14,'DefaultTextFontName','Times New Roman'); %
 
    %перенос переменных в основную базу переменных
    assignin('base','T',InitialConditions.T);
    assignin('base','h',InitialConditions.h);
    assignin('base','d',InitialConditions.d);
    assignin('base','K',InitialConditions.K);
    mn=1.01;
    assignin('base','p',p1{1}(1)*mn);
    assignin('base','k',k);
    p=p1{1};
    %имя и путь графика для Latex
    % фазовые траектории
    figure_name = [strrep(name_system,'sim_',''),'_ft_SDM'];%имя графика
    figure_file_path=['images/',figure_name];% путь к графику
    figure_file_path = join(figure_file_path);
    FIGS.names{1} = figure_name ;
    FIGS.path{1}=figure_file_path;
    FIGS.description{1}=' Фазовые траектории для системы с переменной структурой с разными начальными условиями.';

    % Переменные состояния
    figure_name = [strrep(name_system,'sim_',''),'_sv_SDM'];%имя графика
    figure_file_path=['images/',figure_name];% путь к графику
    figure_file_path = join(figure_file_path);
    FIGS.names{2} = figure_name ;
    FIGS.path{2}=figure_file_path;
    FIGS.description{2}=' Графики изменения выходной переменной и её производной.';

    handle = load_system(name_system); %загрузка схемы

    %установка параметров
    R=200;
    y0=[ 0.1  ];
    x0=[ 0.1];
    x0=x0*R;
    y0=y0*R;
    FStep=10^-2;
    %перенос переменных в основную базу переменных
    assignin('base','end_time',15);%------------------------------------------------------------------время симуляции1
    assignin('base','FStep',FStep);
    set_param(handle,'StopTime','end_time' ,'SolverPrmCheckMsg','warning'...
        ,'SolverResetMethod','robust','Solver','ode113','SolverType','Fixed-step','FixedStep','FStep',...
        'SaveFormat','Array','SaveOutput','off','ReturnWorkspaceOutputs','off')
    Cellfigparam{1}{1}='k-';
    Cellfigparam{1}{2}=2;
    %     Cellfigparam{2}{1}='k-';
%     Cellfigparam{2}{2}=1;
%     Cellfigparam{3}{1}='k--';
%     Cellfigparam{3}{2}=2;
%     Cellfigparam{4}{1}='k--';
%     Cellfigparam{4}{2}=1;
%     Cellfigparam{5}{1}='k-.';
%     Cellfigparam{5}{2}=2;
%     Cellfigparam{6}{1}='k-.';
%     Cellfigparam{6}{2}=1;
%     Cellfigparam{7}{1}='k-';
%     Cellfigparam{7}{2}=2;
%     Cellfigparam{8}{1}='k-';
%     Cellfigparam{8}{2}=1;
ymax=0;
ymin=0;
    Cellfig{1} = figure('Units', 'normalized', 'OuterPosition', [0 0 1 1],'PaperOrientation','Landscape');
    Cellfig{2} = figure('Units', 'normalized', 'OuterPosition', [0 0 1 1],'PaperOrientation','Landscape');
for k=1:length(x0)
    %перенос переменных в основную базу переменных
    assignin('base','y0',x0(k));
    assignin('base','x0',y0(k));

    

    %возвращает сигналы в массиве b в п7орядке согласно номерам портов
    [t,~,x,y] = sim(name_system);
    assignin('base','x',x);
    assignin('base','y',y);
    
    x = x(2:length(x));%change size x,y
    y = y(2:length(y));
    t = t(2:length(t));
    
    %расчёт максимума и минимума  y из всех значений
    if ymax<max(y)
    ymax=max(y);
    end
    if ymin>min(y)
    ymin=min(y);
    end
    figure(Cellfig{1});%target figure
    plot(x,y,Cellfigparam{1}{1},'LineWidth',Cellfigparam{1}{2});grid on, hold on
    leg2{2*k-1} =['$x_0=',num2str(x(1),3),',y_0=',num2str(y(1),3),'$'] ;
    plot(x(1),y(1),'kx','MarkerFaceColor','k','MarkerSize',10);grid on, hold on
    leg2{2*k} =['$x_0=',num2str(x(1),3),',y_0=',num2str(y(1),3),'$'] ;
    if k==length(x0)
        step=(ymax-ymin)/21;
        plot([ymin/p(1) ymax/p(1)],[ymin ymax],'k:','LineWidth',1);%строим  1 прямую сепаратрисы седловой траектории
        
        txt1 = ['$$y\,=\,',num2str(p(1),3),'\,X$$'];   
        text(ymax/1.7/p(1), ymax/1.7-step*4 ,txt1,'Interpreter','latex','FontSize',14); %подпись
        
%         plot([ymin/p(2) ymax/p(2)],[ymin ymax],'k:','LineWidth',1);%строим 2 прямую сепаратрисы седловой траектории
%         
%         txt2 = ['$$y\,=\,',num2str(p(2),3),'\,X$$'];   
%         text(ymax/2/p(2), ymax/2+step*4 ,txt2,'Interpreter','latex'); %подпись
        
        xlabel('$$X$$','Interpreter','latex'),ylabel('$$y(X)=\frac{d\,X}{d\,t}$$','Interpreter','latex') 
    end
    % legend( ['ПХ по скорости с нелинейным элементом' ]...
    %     'Location','southoutside','Box','off' ) 
    
    

    figure(Cellfig{2});%target figure
    subplot(1,2,1);
    plot(t,y,Cellfigparam{1}{1},'LineWidth',Cellfigparam{1}{2});grid on,hold on ;
    xlabel('$$t$$,sec','Interpreter','latex'),ylabel('$$y(X)=\frac{d\,X}{d\,t}$$','Interpreter','latex')
    subplot(1,2,2);
    plot(t,x,Cellfigparam{1}{1},'LineWidth',Cellfigparam{1}{2});grid on,hold on ;  
    xlabel('$$t$$,sec','Interpreter','latex'),ylabel('$$X$$','Interpreter','latex')
    %leg1{k} =['$x_0=',num2str(x0(k),3),',y_0=',num2str(y0(k),3),'$'] ;
    end
    % legend(leg1,'Interpreter','latex','Location','southoutside');
    figure(Cellfig{1});%target figure
    % leg2{k+1}=txt1;
    % leg2{k+2}=txt2;
     legend(leg2,'Interpreter','latex','Location','southoutside');
    prints(FIGS.names{1},PATH.images,Cellfig{1}); %save to pdf and crop with dos
    prints(FIGS.names{2},PATH.images,Cellfig{2}); %save to pdf and crop with dos
    close(Cellfig{1}); %закрываем , чтобы не засорять память
    close(Cellfig{2}); %закрываем , чтобы не засорять память

    %% 
    %закрытие системы
    save_system(handle);
    close_system(handle);
end