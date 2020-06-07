function [FIGS,Settlingt,init] = sim_VSS_final(PATH,InitialConditions,name_system,param)
           
     set(0,'DefaultAxesFontSize',14,'DefaultAxesFontName','Times New Roman');%шрифт
 
    %перенос переменных в основную базу переменных
    assignin('base','T',InitialConditions.T);
    assignin('base','h',InitialConditions.h);
    assignin('base','d',InitialConditions.d);
    assignin('base','K',InitialConditions.K);
    
    %имя и путь графика для Latex
    % фазовые траектории
    figure_name = [strrep(name_system,'sim_',''),'_ft_VSS_final_2_mal'];%имя графика
    figure_file_path=['images/',figure_name];% путь к графику
    figure_file_path = join(figure_file_path);
    FIGS.names{1} = figure_name ;
    FIGS.path{1}=figure_file_path;
    FIGS.description{1}=' Фазовые траектории для системы в <<малом>> с переменной структурой для переменных состояния $x_1,x_2$.';

    % Переменные состояния
    figure_name = [strrep(name_system,'sim_',''),'_sv_VSS_final_mal'];%имя графика
    figure_file_path=['images/',figure_name];% путь к графику
    figure_file_path = join(figure_file_path);
    FIGS.names{2} = figure_name ;
    FIGS.path{2}=figure_file_path;
    FIGS.description{2}=' Графики изменения переменных состояния в <<малом>>.';
    
    % Переменные состояния
    figure_name = [strrep(name_system,'sim_',''),'_sv_VSS_final_3_mal'];%имя графика
    figure_file_path=['images/',figure_name];% путь к графику
    figure_file_path = join(figure_file_path);
    FIGS.names{3} = figure_name ;
    FIGS.path{3}=figure_file_path;
    FIGS.description{3}=' График изменения переменных состояния в <<малом>> в трехмерном пространстве.';
    
    
    % фазовые траектории
    figure_name = [strrep(name_system,'sim_',''),'_ft_VSS_final_2_bol'];%имя графика
    figure_file_path=['images/',figure_name];% путь к графику
    figure_file_path = join(figure_file_path);
    FIGS.names{4} = figure_name ;
    FIGS.path{4}=figure_file_path;
    FIGS.description{4}=' Фазовые траектории для системы в <<большом>> с переменной структурой для переменных состояния $x_1,x_2$.';

    % Переменные состояния
    figure_name = [strrep(name_system,'sim_',''),'_sv_VSS_final_bol'];%имя графика
    figure_file_path=['images/',figure_name];% путь к графику
    figure_file_path = join(figure_file_path);
    FIGS.names{5} = figure_name ;
    FIGS.path{5}=figure_file_path;
    FIGS.description{5}=' Графики изменения переменных состояния в <<большом>>.';
    
    handle = load_system(name_system); %загрузка схемы

    %установка параметров
    R=100;
    y0=[ 0 0 ];
    x0=[ 0 0];
    z0=[0 0];
    zad=[1 100];
    init=[zad; y0; z0];
    x0=x0*R;
    y0=y0*R;
    z0=z0*R;
    
    
    FStep=10^-2;
    end_time=1000;
    %перенос переменных в основную базу переменных
    assignin('base','end_time',end_time);%------------------------------------------------------------------время симуляции1
    assignin('base','FStep',FStep);
    set_param(handle,'StopTime','end_time' ,'SolverPrmCheckMsg','warning'...
        ,'SolverResetMethod','robust','Solver','ode113','SolverType','Fixed-step','FixedStep','FStep',...
        'SaveFormat','Array','SaveOutput','off','ReturnWorkspaceOutputs','off');
    Cellfigparam{1}{1}='k-';
    Cellfigparam{1}{2}=2;
     Cellfigparam{2}{1}='k--';
    Cellfigparam{2}{2}=2;
    Cellfig{1} = figure('Units', 'normalized', 'OuterPosition', [0 0 1 1],'PaperOrientation','Landscape');
    Cellfig{2} = figure('Units', 'normalized', 'OuterPosition', [0 0 1 1],'PaperOrientation','Landscape');
    Cellfig{3} = figure('Units', 'normalized', 'OuterPosition', [0 0 1 1],'PaperOrientation','Landscape');
    Cellfig{4} = figure('Units', 'normalized', 'OuterPosition', [0 0 1 1],'PaperOrientation','Landscape');
    Cellfig{5} = figure('Units', 'normalized', 'OuterPosition', [0 0 1 1],'PaperOrientation','Landscape');
    
     %перенос переменных в основную базу переменных
     k=1;
    C1=param{k}(3);
    C2=param{k}(4);
    alpha=param{k}(1);
    betta=param{k}(2);
    k1=param{k}(5);
    k2=param{k}(6);
    ds=param{k}(7);
    sw1=param{k}(8);
    assignin('base','a',alpha);
    assignin('base','b',betta);
    assignin('base','C1',C1);
    assignin('base','C2',C2);
    assignin('base','k1',k1);
    assignin('base','k2',k2);
    assignin('base','ds',ds); 
    assignin('base','sw1',sw1); 
    
    
    ymax=0;
    ymin=0;
    ST=0.05; RT = [ 0 1 ] ;
    
    %% проходим вхолостую определяя максимальное время регулирования для
    %дальнейшей пересимуляции с правильным стоп таймом
    for k=1:length(zad)
    assignin('base','x0',x0(k));
    assignin('base','y0',y0(k));
    assignin('base','z0',z0(k));
    assignin('base','zad',zad(k));
    %возвращает сигналы в массиве b в п7орядке согласно номерам портов
    [t,~,x,y,z] = sim(name_system);
    assignin('base','x',x);
    S(k)=stepinfo(x,t,'SettlingTimeThreshold',ST,'RiseTimeLimits',RT);
    Settlingtime(k) = S(k).SettlingTime ;
    %assignin('base','Settlingtime123',Settlingtime);
    end

    
  %% 1  
    end_time=max(Settlingtime(1))*1.5;
    assignin('base','end_time',end_time);%------------------------------------------------------------------время симуляции1
    set_param(handle,'StopTime','end_time' );
    assignin('base','x0',x0(1));
    assignin('base','y0',y0(1));
    assignin('base','z0',z0(1));
    assignin('base','zad',zad(1));
    for k=1:1



        %возвращает сигналы в массиве b в п7орядке согласно номерам портов
        [t,~,x,y,z] = sim(name_system);
        assignin('base','x',x);
        assignin('base','y',y);
        assignin('base','z',z);



        %расчёт максимума и минимума  y из всех значений
        if ymax<max(x)
        ymax=max(x);
        end
         if ymin>min(x)
        ymin=min(x);
        end

        x = x(4:length(x));%change size x,y
        y = y(4:length(y));
        z = z(4:length(z));
        t = t(4:length(t));

           S(1)=stepinfo(x,t,'SettlingTimeThreshold',ST,'RiseTimeLimits',RT);
        Settlingtime(1) = S(1).SettlingTime ;
        Settlingt(1)=Settlingtime(1);
        figure(Cellfig{1});%target figure
        plot(x,y,Cellfigparam{k}{1},'LineWidth',Cellfigparam{k}{2});grid on, hold on
        leg2{2*k-1} =['$[ C_1=',num2str(C1,3),' ; C_2=',num2str(C2,3),' ; \alpha=',num2str(alpha,3),' ; \beta=',num2str(betta,3),']$'] ;
        leg2{2*k} =['$x_0=',num2str(x(1),3),',y_0=',num2str(y(1),3),',z_0=',num2str(z(1),3),'$'] ;
        if k==length(param)
            xlabel('$$x$$','Interpreter','latex'),ylabel('$$y(x)=\frac{d\,x}{d\,t}$$','Interpreter','latex') 
        end
        plot(x(1),y(1),'kx','MarkerFaceColor','k','MarkerSize',10);grid on, hold on

        figure(Cellfig{2});%target figure
        subplot(3,1,1);
        plot(t,z,Cellfigparam{k}{1},'LineWidth',Cellfigparam{k}{2});grid on,hold on ;  
        xlabel('$$t$$,sec','Interpreter','latex'),ylabel('$$z(x)=\frac{d^2\,x}{d\,t^2}$$','Interpreter','latex')
        subplot(3,1,2);
        plot(t,y,Cellfigparam{k}{1},'LineWidth',Cellfigparam{k}{2});grid on,hold on ;
        xlabel('$$t$$,sec','Interpreter','latex'),ylabel('$$y(x)=\frac{d\,x}{d\,t}$$','Interpreter','latex')
        subplot(3,1,3);
        plot(t,x,Cellfigparam{k}{1},'LineWidth',Cellfigparam{k}{2});grid on,hold on ;  
        xlabel('$$t$$,sec','Interpreter','latex'),ylabel('$$x$$','Interpreter','latex')

        figure(Cellfig{3});%target figure
        plot3(x,y,z,Cellfigparam{k}{1},'LineWidth',Cellfigparam{k}{2});grid on,hold on ;
         plot3(x(1),y(1),z(1),'kx','MarkerFaceColor','k','MarkerSize',10);grid on, hold on
         if k==length(param)
         xlabel('$$x$$','Interpreter','latex'),ylabel('$$y(x)=\frac{d\,x}{d\,t}$$','Interpreter','latex'),zlabel('$$z(x)=\frac{d^2\,x}{d\,t^2}$$','Interpreter','latex')
         end

    end
    figure(Cellfig{1});%target figure 
     legend(leg2,'Interpreter','latex','Location','southoutside');
    figure(Cellfig{2});%target figure
    subplot(3,1,3);
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
%% 2
    end_time=max(Settlingtime(2))*1.5;
    assignin('base','end_time',end_time);
     assignin('base','x0',x0(2));
    assignin('base','y0',y0(2));
    assignin('base','z0',z0(2));
    assignin('base','zad',zad(2));
    for k=1:1
    
    

    %возвращает сигналы в массиве b в п7орядке согласно номерам портов
    [t,~,x,y,z] = sim(name_system);
    assignin('base','x',x);
    assignin('base','y',y);
    assignin('base','z',z);
    
    
    %расчёт максимума и минимума  y из всех значений
    if ymax<max(x)
    ymax=max(x);
    end
     if ymin>min(x)
    ymin=min(x);
    end
    
    x = x(4:length(x));%change size x,y
    y = y(4:length(y));
    z = z(4:length(z));
    t = t(4:length(t));
    
    S(1)=stepinfo(x,t,'SettlingTimeThreshold',ST,'RiseTimeLimits',RT);
    Settlingtime(1) = S(1).SettlingTime ;
            Settlingt(2)=Settlingtime(1);
    figure(Cellfig{4});%target figure
    plot(x,y,Cellfigparam{k}{1},'LineWidth',Cellfigparam{k}{2});grid on, hold on
    leg2{2*k-1} =['$[ C_1=',num2str(C1,3),' ; C_2=',num2str(C2,3),' ; \alpha=',num2str(alpha,3),' ; \beta=',num2str(betta,3),']$'] ;
    leg2{2*k} =['$x_0=',num2str(x(1),3),',y_0=',num2str(y(1),3),',z_0=',num2str(z(1),3),'$'] ;
    if k==length(param)
        xlabel('$$x$$','Interpreter','latex'),ylabel('$$y(x)=\frac{d\,x}{d\,t}$$','Interpreter','latex') 
    end
    plot(x(1),y(1),'kx','MarkerFaceColor','k','MarkerSize',10);grid on, hold on
    
    figure(Cellfig{5});%target figure
    subplot(3,1,1);
    plot(t,z,Cellfigparam{k}{1},'LineWidth',Cellfigparam{k}{2});grid on,hold on ;  
    xlabel('$$t$$,sec','Interpreter','latex'),ylabel('$$z(x)=\frac{d^2\,x}{d\,t^2}$$','Interpreter','latex')
    subplot(3,1,2);
    plot(t,y,Cellfigparam{k}{1},'LineWidth',Cellfigparam{k}{2});grid on,hold on ;
    xlabel('$$t$$,sec','Interpreter','latex'),ylabel('$$y(x)=\frac{d\,x}{d\,t}$$','Interpreter','latex')
    subplot(3,1,3);
    plot(t,x,Cellfigparam{k}{1},'LineWidth',Cellfigparam{k}{2});grid on,hold on ;  
    xlabel('$$t$$,sec','Interpreter','latex'),ylabel('$$x$$','Interpreter','latex')
    end
    figure(Cellfig{4});%target figure 
     legend(leg2,'Interpreter','latex','Location','southoutside');
    figure(Cellfig{5});%target figure
    subplot(3,1,3);
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

    prints(FIGS.names{1},PATH.images,Cellfig{1}); %save to pdf and crop with dos
    prints(FIGS.names{2},PATH.images,Cellfig{2}); %save to pdf and crop with dos
    prints(FIGS.names{3},PATH.images,Cellfig{3}); %save to pdf and crop with dos
    prints(FIGS.names{4},PATH.images,Cellfig{4}); %save to pdf and crop with dos
    prints(FIGS.names{5},PATH.images,Cellfig{5}); %save to pdf and crop with dos
    close(Cellfig{1}); %закрываем , чтобы не засорять память
    close(Cellfig{2}); %закрываем , чтобы не засорять память
    close(Cellfig{3}); %закрываем , чтобы не засорять память
    close(Cellfig{4}); %закрываем , чтобы не засорять память
    close(Cellfig{5}); %закрываем , чтобы не засорять память

    %% 
    %закрытие системы
    save_system(handle);
    close_system(handle);
end
