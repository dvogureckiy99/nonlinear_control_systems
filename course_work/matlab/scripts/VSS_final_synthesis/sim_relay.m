function [FIGS] = sim_relay(PATH,InitialConditions,name_system,K)
           

     set(0,'DefaultAxesFontSize',14,'DefaultAxesFontName','Times New Roman');%�����
     set(0,'DefaultTextFontSize',14,'DefaultTextFontName','Times New Roman'); %
 
    %������� ���������� � �������� ���� ����������
    assignin('base','T',InitialConditions.T);
    assignin('base','h',InitialConditions.h);
    assignin('base','d',InitialConditions.d);
    assignin('base','K',InitialConditions.K);
    
    %��� � ���� ������� ��� Latex
    % ������� ����������
    figure_name = [strrep(name_system,'sim_',''),'_ft_relay_2'];%��� �������
    figure_file_path=['images/',figure_name];% ���� � �������
    figure_file_path = join(figure_file_path);
    FIGS.names{1} = figure_name ;
    FIGS.path{1}=figure_file_path;
    FIGS.description{1}=' ������� ���������� ��� �������  ��� ���������� ��������� $x_1,x_2$.';

    % ���������� ���������
    figure_name = [strrep(name_system,'sim_',''),'_sv_relay'];%��� �������
    figure_file_path=['images/',figure_name];% ���� � �������
    figure_file_path = join(figure_file_path);
    FIGS.names{2} = figure_name ;
    FIGS.path{2}=figure_file_path;
    FIGS.description{2}=' ������� ��������� ���������� ���������.';
    
    % ������� ����������
    figure_name = [strrep(name_system,'sim_',''),'_ft_VSS_P_3'];%��� �������
    figure_file_path=['images/',figure_name];% ���� � �������
    figure_file_path = join(figure_file_path);
    FIGS.names{3} = figure_name ;
    FIGS.path{3}=figure_file_path;
    FIGS.description{3}=' ������� ���������� ��� ������� ��� ���� ���������� ��������� $x_1,x_2,x_3$.';

    handle = load_system(name_system); %�������� �����

    %��������� ����������
    R=1000;
    y0= 0;
    x0=0.1;
    z0=0;
    x0=x0*R;
    y0=y0*R;
    z0=z0*R;
    FStep=1;
    end_time=2500;
    %������� ���������� � �������� ���� ����������
    assignin('base','x0',x0);
    assignin('base','y0',y0);
    assignin('base','z0',z0);
    assignin('base','end_time',end_time);%------------------------------------------------------------------����� ���������1
    assignin('base','FStep',FStep);
    set_param(handle,'StopTime','end_time' ,'SolverPrmCheckMsg','warning'...
        ,'SolverResetMethod','robust','Solver','ode113','SolverType','Fixed-step','FixedStep','FStep',...
        'SaveFormat','Array','SaveOutput','off','ReturnWorkspaceOutputs','off');
    Cellfigparam{1}{1}='k-';
    Cellfigparam{1}{2}=2;
%     Cellfigparam{2}{1}='k--';
%     Cellfigparam{2}{2}=2;
%     Cellfigparam{3}{1}='k-';
%     Cellfigparam{3}{2}=1;
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
    Cellfig{3} = figure('Units', 'normalized', 'OuterPosition', [0 0 1 1],'PaperOrientation','Landscape');
    
for k=1:1
    %������� ���������� � �������� ���� ����������
    assignin('base','k1',K(1));
    assignin('base','k2',K(2));

    %���������� ������� � ������� b � �7������ �������� ������� ������
    [t,~,x,y,z] = sim(name_system);
    assignin('base','x',x);
    assignin('base','y',y);
    assignin('base','z',z);
    
    
    x = x(4:length(x));%change size x,y
    y = y(4:length(y));
    z = z(4:length(z));
    t = t(4:length(t));
    
    figure(Cellfig{1});%target figure
    plot(x,y,Cellfigparam{k}{1},'LineWidth',Cellfigparam{k}{2});grid on, hold on
    if k==1
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
     if k==1
     xlabel('$$x$$','Interpreter','latex'),ylabel('$$y(x)=\frac{d\,x}{d\,t}$$','Interpreter','latex'),zlabel('$$z(x)=\frac{d^2\,x}{d\,t^2}$$','Interpreter','latex')
     end
end
    prints(FIGS.names{1},PATH.images,Cellfig{1}); %save to pdf and crop with dos
    prints(FIGS.names{2},PATH.images,Cellfig{2}); %save to pdf and crop with dos
    prints(FIGS.names{3},PATH.images,Cellfig{3}); %save to pdf and crop with dos
    close(Cellfig{1}); %��������� , ����� �� �������� ������
    close(Cellfig{2}); %��������� , ����� �� �������� ������
    close(Cellfig{3}); %��������� , ����� �� �������� ������

    %% 
    %�������� �������
    save_system(handle);
    close_system(handle);
end