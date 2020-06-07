function [FIGS] = sim_VSS_DCS(PATH,InitialConditions,name_system,param,zad)
           

     set(0,'DefaultAxesFontSize',14,'DefaultAxesFontName','Times New Roman');%�����
          set(0,'DefaultTextFontSize',14,'DefaultTextFontName','Times New Roman'); %
 
    %������� ���������� � �������� ���� ����������
    assignin('base','T',InitialConditions.T);
    assignin('base','h',InitialConditions.h);
    assignin('base','d',InitialConditions.d);
    assignin('base','K',InitialConditions.K);
    
    %��� � ���� ������� ��� Latex
%     num=1;
%     figure_name = [strrep(name_system,'sim_',''),'_DCS_SAWnew'];%��� �������
%     figure_file_path=['images/',figure_name];% ���� � �������
%     figure_file_path = join(figure_file_path);
%     FIGS.names{num} = figure_name ;
%     FIGS.path{num}=figure_file_path;
%     FIGS.description{num}=' �������������� ����  � ��������� � ��� ���� ������';
%     
    num=1;
    figure_name = [strrep(name_system,'sim_',''),'_DCS_pwm1'];%��� �������
    figure_file_path=['images/',figure_name];% ���� � �������
    figure_file_path = join(figure_file_path);
    FIGS.names{num} = figure_name ;
    FIGS.path{num}=figure_file_path;
    FIGS.description{num}=' ���1';
    
   
     num=2;
    figure_name = [strrep(name_system,'sim_',''),'_DCS_pwm2'];%��� �������
    figure_file_path=['images/',figure_name];% ���� � �������
    figure_file_path = join(figure_file_path);
    FIGS.names{num} = figure_name ;
    FIGS.path{num}=figure_file_path;
    FIGS.description{num}=' ���2';
    
    num=3;
    figure_name = [strrep(name_system,'sim_',''),'_DCS_PWM'];%��� �������
    figure_file_path=['images/',figure_name];% ���� � �������
    figure_file_path = join(figure_file_path);
    FIGS.names{num} = figure_name ;
    FIGS.path{num}=figure_file_path;
    FIGS.description{num}=' ����������� �� ������ (���=���1+���2)';
    
    num=4;
    figure_name = [strrep(name_system,'sim_',''),'_DCS_upr'];%��� �������
    figure_file_path=['images/',figure_name];% ���� � �������
    figure_file_path = join(figure_file_path);
    FIGS.names{num} = figure_name ;
    FIGS.path{num}=figure_file_path;
    FIGS.description{num}=' ����������� ����������� ������ ';
    
    num=5;
    figure_name = [strrep(name_system,'sim_',''),'_DCS_upr_ogr'];%��� �������
    figure_file_path=['images/',figure_name];% ���� � �������
    figure_file_path = join(figure_file_path);
    FIGS.names{num} = figure_name ;
    FIGS.path{num}=figure_file_path;
    FIGS.description{num}=' ����������� ����������� ������ ����� ���������';
    
    handle = load_system(name_system); %�������� �����

    %��������� ����������
    R=100;
    y0=[ 0 0 ];
    x0=[ 0 0 ];
    z0=[0 0];
    x0=x0*R;
    y0=y0*R;
    z0=z0*R;
    
    FStep=1e-3;
    end_time=1000;
    %������� ���������� � �������� ���� ����������
    assignin('base','end_time',end_time);%------------------------------------------------------------------����� ���������1
    assignin('base','FStep',FStep);
    set_param(handle,'StopTime','end_time' ,'SolverPrmCheckMsg','warning'...
        ,'SolverResetMethod','robust','Solver','ode8','SolverType','Fixed-step','FixedStep','FStep',...
        'SaveFormat','Array','SaveOutput','off','ReturnWorkspaceOutputs','off');
    Cellfigparam{1}{1}='k-';
    Cellfigparam{1}{2}=2;
     Cellfigparam{2}{1}='k--';
    Cellfigparam{2}{2}=2;
    Cellfigparam{2}{2}=2;
    for i=1:length(FIGS.names)
    Cellfig{i} = figure('Units', 'normalized', 'OuterPosition', [0 0 1 1],'PaperOrientation','Landscape');
    end
%     Cellfig{4} = figure('Units', 'normalized', 'OuterPosition', [0 0 1 1],'PaperOrientation','Landscape');
%     Cellfig{5} = figure('Units', 'normalized', 'OuterPosition', [0 0 1 1],'PaperOrientation','Landscape');
    
     %������� ���������� � �������� ���� ����������
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
    
    %�������� ��������� ��������� ������������ ����� ������������� ���
    %���������� ������������� � ���������� ���� ������
    for k=1:2
    assignin('base','zad',zad(k));
    assignin('base','x0',x0(k));
    assignin('base','y0',y0(k));
    assignin('base','z0',z0(k));
    %���������� ������� � ������� b � �7������ �������� ������� ������
    [t,~,x] = sim(name_system);
    %assignin('base','x',x);
    S(k)=stepinfo(x(:,1),t,'SettlingTimeThreshold',ST,'RiseTimeLimits',RT);
    Settlingtime(k) = S(k).SettlingTime ;
    end
    end_time=max(Settlingtime);
    end_time=ceil((end_time*3)/5)*5;
    assignin('base','end_time', end_time);%------------------------------------------------------------------����� ���������1
    set_param(handle,'StopTime','end_time' );
    assignin('base','zad',zad(1));
    assignin('base','x0',x0(1));
    assignin('base','y0',y0(1));
    assignin('base','z0',z0(1));
    
%���������� ������� � ������� b � �7������ �������� ������� ������
        [t,~,ret] = sim(name_system);
         assignin('base','x',ret);
%          saw=ret(:,4);
         pwm=ret(:,2);
         pwm1=ret(:,4);
         pwm2=ret(:,5);
         upr=ret(:,6);
         uprogr=ret(:,7);
%         assignin('base','saw',saw);
%         assignin('base','pwm1',pwm1);
%         assignin('base','pwm2',pwm2);
          assignin('base','compare',pwm);

%% �������
%         figure(Cellfig{1});
%         count=end_time/FStep;
%         part=50; %������ � ���������
%         part=part/100;
%         start=int64(part*count);
%         ended=start+1/FStep;
%          plot(t(start:ended),saw(start:ended),'k-','LineWidth',2);grid on,hold on ; 
         
    START_PR=10; %������ � ��������� �� ����� ���� ���������
    LEN_PR=0.05; %����� � ��������� �� ����� ���� ���������
    figure(Cellfig{2});
    count=end_time/FStep;
    start=int64((START_PR/100)*count);
    if start==0
        start=1;
    end
    ended=int64(start+(LEN_PR/100)*count);
    %assignin('base','S_T1',start);
   % assignin('base','S_T2',ended);
     plot(t(start:ended),pwm1(start:ended),'k-','LineWidth',2);grid on,hold on ; 
     
     figure(Cellfig{3});
    count=end_time/FStep;
    start=int64((START_PR/100)*count);
    if start==0
        start=1;
    end
    ended=int64(start+(LEN_PR/100)*count);
     plot(t(start:ended),pwm2(start:ended),'k-','LineWidth',2);grid on,hold on ; 
     
     figure(Cellfig{4});
    count=end_time/FStep;
    start=int64((START_PR/100)*count);
    if start==0
        start=1;
    end
    ended=int64(start+(LEN_PR/100)*count);
     plot(t(start:ended),pwm(start:ended),'k-','LineWidth',2);grid on,hold on ;
     
    START_PR=0; %������ � ��������� �� ����� ���� ���������
    LEN_PR=60; %����� � ��������� �� ����� ���� ���������
        figure(Cellfig{5});
    count=end_time/FStep;
    start=int64((START_PR/100)*count);
    if start==0
        start=1;
    end
    ended=int64(start+(LEN_PR/100)*count);
     plot(t(start:ended),upr(start:ended),'k-','LineWidth',0.5);grid on,hold on ; 
     
     figure(Cellfig{6});
    count=end_time/FStep;
    start=int64((START_PR/100)*count);
    if start==0
        start=1;
    end
    ended=int64(start+(LEN_PR/100)*count);
     plot(t(start:ended),uprogr(start:ended),'k-','LineWidth',0.5);grid on,hold on ; 
         %%
   %%------------
    for i=1:length(Cellfig)
    prints(FIGS.names{i},PATH.images,Cellfig{i}); %save to pdf and crop with dos
    close(Cellfig{i}); %��������� , ����� �� �������� ������
    end

    %% 
    %�������� �������
    save_system(handle);
    close_system(handle);
end