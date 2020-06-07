function FIGS = sim_steady_degenerate_motion(PATH,InitialConditions,k,p1,name_system)
           

     set(0,'DefaultAxesFontSize',14,'DefaultAxesFontName','Times New Roman');%�����
     set(0,'DefaultTextFontSize',14,'DefaultTextFontName','Times New Roman'); %
 
    %������� ���������� � �������� ���� ����������
    assignin('base','T',InitialConditions.T);
    assignin('base','h',InitialConditions.h);
    assignin('base','d',InitialConditions.d);
    assignin('base','K',InitialConditions.K);
    mn=1.01;
    assignin('base','p',p1{1}(1)*mn);
    assignin('base','k',k);
    p=p1{1};
    %��� � ���� ������� ��� Latex
    % ������� ����������
    figure_name = [strrep(name_system,'sim_',''),'_ft_SDM'];%��� �������
    figure_file_path=['images/',figure_name];% ���� � �������
    figure_file_path = join(figure_file_path);
    FIGS.names{1} = figure_name ;
    FIGS.path{1}=figure_file_path;
    FIGS.description{1}=' ������� ���������� ��� ������� � ���������� ���������� � ������� ���������� ���������.';

    % ���������� ���������
    figure_name = [strrep(name_system,'sim_',''),'_sv_SDM'];%��� �������
    figure_file_path=['images/',figure_name];% ���� � �������
    figure_file_path = join(figure_file_path);
    FIGS.names{2} = figure_name ;
    FIGS.path{2}=figure_file_path;
    FIGS.description{2}=' ������� ��������� �������� ���������� � � �����������.';

    handle = load_system(name_system); %�������� �����

    %��������� ����������
    R=200;
    y0=[ 0.1  ];
    x0=[ 0.1];
    x0=x0*R;
    y0=y0*R;
    FStep=10^-2;
    %������� ���������� � �������� ���� ����������
    assignin('base','end_time',15);%------------------------------------------------------------------����� ���������1
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
    %������� ���������� � �������� ���� ����������
    assignin('base','y0',x0(k));
    assignin('base','x0',y0(k));

    

    %���������� ������� � ������� b � �7������ �������� ������� ������
    [t,~,x,y] = sim(name_system);
    assignin('base','x',x);
    assignin('base','y',y);
    
    x = x(2:length(x));%change size x,y
    y = y(2:length(y));
    t = t(2:length(t));
    
    %������ ��������� � ��������  y �� ���� ��������
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
        plot([ymin/p(1) ymax/p(1)],[ymin ymax],'k:','LineWidth',1);%������  1 ������ ����������� �������� ����������
        
        txt1 = ['$$y\,=\,',num2str(p(1),3),'\,X$$'];   
        text(ymax/1.7/p(1), ymax/1.7-step*4 ,txt1,'Interpreter','latex','FontSize',14); %�������
        
%         plot([ymin/p(2) ymax/p(2)],[ymin ymax],'k:','LineWidth',1);%������ 2 ������ ����������� �������� ����������
%         
%         txt2 = ['$$y\,=\,',num2str(p(2),3),'\,X$$'];   
%         text(ymax/2/p(2), ymax/2+step*4 ,txt2,'Interpreter','latex'); %�������
        
        xlabel('$$X$$','Interpreter','latex'),ylabel('$$y(X)=\frac{d\,X}{d\,t}$$','Interpreter','latex') 
    end
    % legend( ['�� �� �������� � ���������� ���������' ]...
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
    close(Cellfig{1}); %��������� , ����� �� �������� ������
    close(Cellfig{2}); %��������� , ����� �� �������� ������

    %% 
    %�������� �������
    save_system(handle);
    close_system(handle);
end