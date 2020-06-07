function FIGS = sim_focus(PATH,InitialConditions,k,p)
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
figure_name = [strrep(name_system,'sim_',''),'_ft_focus'];%имя графика
figure_file_path=['images/',figure_name];% путь к графику
figure_file_path = join(figure_file_path);
FIGS.names{1} = figure_name ;
FIGS.path{1}=figure_file_path;
FIGS.description{1}=' Фазовые траектории для системы с переменной структурой с разными начальными условиями.';

% Переменные состояния
figure_name = [strrep(name_system,'sim_',''),'_sv_focus'];%имя графика
figure_file_path=['images/',figure_name];% путь к графику
figure_file_path = join(figure_file_path);
FIGS.names{2} = figure_name ;
FIGS.path{2}=figure_file_path;
FIGS.description{2}=' Графики изменения выходной переменной и её производной.';

handle = load_system(name_system); %загрузка схемы

%установка параметров
R=1;
y0=[0.1               ];
x0=[ 0.1];
x0=x0*R;
y0=y0*R;
k1 = k(1);
k2 = k(2);
FStep=10^-2;
%перенос переменных в основную базу переменных
    assignin('base','end_time',20);%------------------------------------------------------------------время симуляции1
    assignin('base','FStep',FStep);
    assignin('base','k1',k1);
    assignin('base','k2',k2);
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
assignin('base','p',p);
    Cellfig{2} = figure('Units', 'normalized', 'OuterPosition', [0 0 1 1],'PaperOrientation','Landscape');
    Cellfig{3} = figure('Units', 'normalized', 'OuterPosition', [0 0 1 1],'PaperOrientation','Landscape');
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
   
    figure(Cellfig{2});%target figure
    plot(x,y,Cellfigparam{1}{1},'LineWidth',Cellfigparam{1}{2});grid on, hold on
    leg2{2*k-1} =['$x_0=',num2str(x(1),3),',y_0=',num2str(y(1),3),'$'] ;
    
    % legend( ['ПХ по скорости с нелинейным элементом' ]...
    %     'Location','southoutside','Box','off' ) 
    plot(x(1),y(1),'kx','MarkerFaceColor','k','MarkerSize',10);grid on, hold on
    %leg2{2*k} =['$x_0=',num2str(x0(k),3),',y_0=',num2str(y0(k),3),'$'] ;

    figure(Cellfig{3});%target figure
    subplot(1,2,1);
    plot(t,y,Cellfigparam{1}{1},'LineWidth',Cellfigparam{1}{2});grid on,hold on ;
    xlabel('$$t$$,sec','Interpreter','latex'),ylabel('$$y(X)=\frac{d\,X}{d\,t}$$','Interpreter','latex')
    subplot(1,2,2);
    plot(t,x,Cellfigparam{1}{1},'LineWidth',Cellfigparam{1}{2});grid on,hold on ;  
    xlabel('$$t$$,sec','Interpreter','latex'),ylabel('$$X$$','Interpreter','latex')
    %leg1{k} =['$x_0=',num2str(x0(k),3),',y_0=',num2str(y0(k),3),'$'] ;
    end
% legend(leg1,'Interpreter','latex','Location','southoutside');
 figure(Cellfig{2});%target figure
% leg2{k+1}=txt1;
% leg2{k+2}=txt2;
 legend(leg2,'Interpreter','latex','Location','southoutside');
prints(FIGS.names{1},PATH.images,Cellfig{2}); %save to pdf and crop with dos
prints(FIGS.names{2},PATH.images,Cellfig{3}); %save to pdf and crop with dos
close(Cellfig{2}); %закрываем , чтобы не засорять память
close(Cellfig{3}); %закрываем , чтобы не засорять память

%% 
%закрытие системы
save_system(handle);
close_system(handle);

end
