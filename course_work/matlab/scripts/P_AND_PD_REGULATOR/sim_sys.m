function [FIGS,k1] = sim_sys(InitialConditions,PATH,Kkr)


%������� ���������� � �������� ���� ����������
assignin('base','end_time',700);%------------------------------------------------------------------����� ���������
 FStep=0.1 ;
    assignin('base','FStep',FStep);
%������� ���������� � �������� ���� ����������
assignin('base','T',InitialConditions.T);
assignin('base','h',InitialConditions.h);
assignin('base','d',InitialConditions.d);
assignin('base','K',InitialConditions.K);

name_system = 'sim_P';                 %��� �����

% ���������� �-��
figure_name = [strrep(name_system,'sim_',''),'_sys'];%��� �������
figure_file_path=['images/',figure_name];% ���� � �������
figure_file_path = join(figure_file_path);
FIGS.names{1} = figure_name ;
FIGS.path{1}=figure_file_path;
FIGS.description{1}=' ������� ��������� �������� ���������� $X$ ��� ������ $k$.';

handle = load_system(name_system); %�������� �����

set_param(handle,'StopTime','end_time' ,'SolverPrmCheckMsg','warning'...
    ,'SolverResetMethod','robust','Solver','ode113','SolverType','Fixed-step','FixedStep','FStep',...
    'SaveFormat','Array','SaveOutput','off','ReturnWorkspaceOutputs','off')

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
Cellfig{1} = figure('Units', 'normalized', 'OuterPosition', [0 0 1 1],'PaperOrientation','Landscape');
K=[Kkr Kkr/5 Kkr/10 Kkr/20 Kkr/50 ];
k1=K(1);
for i=1:5
    k=K(i);
        %��������� ����������
    assignin('base','k',k); %��������� � ������ ����� k

    %���������� ������� � �������� � ������� �������� ������� ������
    [t,~,x] = sim(name_system);
    assignin('base','x',x);
    
    figure(Cellfig{1});%target figure
    plot(t,x,Cellfigparam{i}{1},'LineWidth',Cellfigparam{i}{2});grid on, hold on
    xlabel('$$t$$,sec','Interpreter','latex'),ylabel('$$X$$','Interpreter','latex')
    leg{i} =['$k=',num2str(k,3),'$'] ;
end


%��� ����� ��������������� �������� 
for j=1:length(t)
    xsettmax(j)=0.95;
end
for j=1:length(t)
    xsettmin(j)=1.05;
end
for j=1:length(x)
    xsett(j)=1;
end

%������ �����
plot(t,xsettmax,'black--','LineWidth',0.7);
plot(t,xsett,'black--','LineWidth',0.7);
plot(t,xsettmin,'black--','LineWidth',0.7);

leg{i+1}='$1.05$';
leg{i+2}='$1$';
leg{i+3}='$0.95$';
legend(leg,'Interpreter','latex');

prints(FIGS.names{1},PATH.images); %save to pdf and crop with dos
close(Cellfig{1}); %��������� , ����� �� �������� ������

%% 
%�������� �������
save_system(handle);
close_system(handle);
end