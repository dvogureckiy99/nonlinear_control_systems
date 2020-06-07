function FIGS = sim_center(PATH,InitialConditions,k1,k2,w2)
name_system = 'sim_linear_2_por';                 %имя схемы

 set(0,'DefaultAxesFontSize',14,'DefaultAxesFontName','Times New Roman');%шрифт
 set(0,'DefaultTextFontSize',14,'DefaultTextFontName','Times New Roman'); %
 
%перенос переменных в основную базу переменных
    assignin('base','T',InitialConditions.T);
    assignin('base','h',InitialConditions.h);
    assignin('base','d',InitialConditions.d);
    assignin('base','K',InitialConditions.K);

%имя и путь графика для Latex
% фазовые траектории
figure_name = [strrep(name_system,'sim_',''),'_ft_center'];%имя графика
figure_file_path=['images/',figure_name];% путь к графику
figure_file_path = join(figure_file_path);
FIGS.names{1} = figure_name ;
FIGS.path{1}=figure_file_path;
FIGS.description{1}=' Фазовые траектории для системы с переменной структурой с разными начальными условиями.';

% Переменные состояния
figure_name = [strrep(name_system,'sim_',''),'_sv_center'];%имя графика
figure_file_path=['images/',figure_name];% путь к графику
figure_file_path = join(figure_file_path);
FIGS.names{2} = figure_name ;
FIGS.path{2}=figure_file_path;
FIGS.description{2}=' Графики изменения выходной переменной и её производной.';

handle = load_system(name_system); %загрузка схемы

%установка параметров
R=50;
y0=[0.1    , 0.2          ];
x0=-y0*R;
y0=y0*R;
mn=[1.1 1.1];
for i=1:2
   T(i)=mn(i)*2*pi/sqrt(w2(i)); 
end
FStep=10^-2;                     %----------------------------------------------------------------------------change
end_time = max(T) ;                  %------------------------------------------------------------------время симуляции1
%перенос переменных в основную базу переменных
    
    Cellfigparam{1}{1}='k-';
    Cellfigparam{1}{2}=2;
    Cellfigparam{2}{1}='k--';
    Cellfigparam{2}{2}=2;
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
    Cellfig{1} = figure('Units', 'normalized', 'OuterPosition', [0 0 1 1],'PaperOrientation','Landscape');
    Cellfig{2} = figure('Units', 'normalized', 'OuterPosition', [0 0 1 1],'PaperOrientation','Landscape');
    
    for k=1:2
    %перенос переменных в основную базу переменных
    assignin('base','end_time',end_time);
    assignin('base','FStep',FStep);
    set_param(handle,'StopTime','end_time' ,'SolverPrmCheckMsg','warning'...
        ,'SolverResetMethod','robust','Solver','ode113','SolverType','Fixed-step','FixedStep','FStep',...
        'SaveFormat','Array','SaveOutput','off','ReturnWorkspaceOutputs','off')
    
     assignin('base','k1',k1(k));
    assignin('base','k2',k2(k));
    assignin('base','y0',x0(k));
    assignin('base','x0',y0(k));

    %возвращает сигналы в массиве b в п7орядке согласно номерам портов
    [t,~,x,y] = sim(name_system);
    assignin('base','x',x);
    assignin('base','y',y);
    
    x = x(2:length(x));%change size x,y
    y = y(2:length(y));
    t = t(2:length(t));
    
    if k==2
        count = int32(min(T)/FStep);
        x1 = x(1:count);%change size x,y
        y1 = y(1:count);
        t1 = t(1:count); 
        figure(Cellfig{1});%target figure
        plot(x1,y1,Cellfigparam{k}{1},'LineWidth',Cellfigparam{k}{2});grid on, hold on
        plot(x1(1),y1(1),'kx','MarkerFaceColor','k','MarkerSize',10);grid on, hold on
    else
        figure(Cellfig{1});%target figure
        plot(x,y,Cellfigparam{k}{1},'LineWidth',Cellfigparam{k}{2});grid on, hold on
        plot(x(1),y(1),'kx','MarkerFaceColor','k','MarkerSize',10);grid on, hold on
    end
    
    

    figure(Cellfig{2});%target figure
    leg{2*k-1} =['$k_1=',num2str(k1(k),3),'$'] ;
    leg{2*k}   =['$(x_0=',num2str(x(1),3),',y_0=',num2str(y(1),3),')$'] ;
    subplot(1,2,1);
    plot(t,y,Cellfigparam{k}{1},'LineWidth',Cellfigparam{k}{2});grid on,hold on ;
    xlabel('$$t$$,sec','Interpreter','latex'),ylabel('$$y(X)=\frac{d\,X}{d\,t}$$','Interpreter','latex')
    subplot(1,2,2);
    plot(t,x,Cellfigparam{k}{1},'LineWidth',Cellfigparam{k}{2});grid on,hold on ;  
    xlabel('$$t$$,sec','Interpreter','latex'),ylabel('$$X$$','Interpreter','latex')
%     leg2{k} =['$k_1=',num2str(k1(k),3),'$'] ;
    end
%  figure(Cellfig{2});%target figure
%  hL = subplot(2,2,3.5);
%  poshL = get(hL,'position');     % Getting its position
%  lgd=legend(hL,[h{1};h{2}],leg2,'Interpreter','latex');%,'Location','southoutside');
%  set(lgd,'position',poshL,'Box','off');      % Adjusting legend's position
%  axis(hL,'off');                 % Turning its axis off
 figure(Cellfig{1});%target figure
 legend(leg,'Interpreter','latex','Location','southoutside');
 
prints(FIGS.names{1},PATH.images,Cellfig{1}); %save to pdf and crop with dos
prints(FIGS.names{2},PATH.images,Cellfig{2}); %save to pdf and crop with dos
close(Cellfig{1}); %закрываем , чтобы не засорять память
close(Cellfig{2}); %закрываем , чтобы не засорять память

%% 
%закрытие системы
save_system(handle);
close_system(handle);

end
