 function ObjectAnalysis(InitialConditions,PATH,section_name,name_subsection)
 %% �������� ������
path_subsection = [PATH.Texcomponents,section_name,'\'];%���� � subsection files
file_path=[path_subsection ,name_subsection,'.tex'];
file_path = join(file_path);
fid = fopen(file_path,'w','l','UTF-8');
%% 1
name='�������� ������';
f(fid,['\subsection{',name,'}']);

%% ��������� �������-------------------------------------------------------------------------change
T=InitialConditions.T;
K=InitialConditions.K;
h=InitialConditions.h;
d=InitialConditions.d;
s=InitialConditions.s;
e=InitialConditions.e;
L=InitialConditions.L;
g=InitialConditions.g;
process_num=InitialConditions.num_form_process;
process=InitialConditions.form_process{process_num};

key_cond="init_cond";
f(fid,[' ����������� ����������� ����������, �������������� ']);
f(fid,['������������ ���������� �������, ��������� � ',tabref(key_cond),'.']);
f(fid,'������ ����� �������� ����������� �������� ������ ���� ');
if process_num==1
    f(fid,[process,'��']);
    init = [T K h d e L g];
    line{1}='$T$ & $K$ & $h$ & $d$ & $\epsilon_{max},\%$ & $L_{m\,max},db$ & $\gamma,^{\circ}$';
    for j=1:1
        line{j+1}=' $';
        for i=1:(length(init)-1)
        line{j+1}=strcat(line{j+1},[num2str(init(i),3),'$ & $']);
        end
        line{j+1}=strcat(line{j+1},[num2str(init(i+1),3),'$ ']);
    end
else
    f(fid,join([process,'��']));
    init = [T K h d s e L g];
    line{1}='$T$ & $K$ & $h$ & $d$ & $\sigma_{max},\%$ & $\epsilon_{max},\%$ & $L_{m\,max},db$ & $\gamma,^{\circ}$';
    for j=1:1
        line{j+1}=' $';
        for i=1:(length(init)-1)
        line{j+1}=strcat(line{j+1},[num2str(init(i),3),'$ & $']);
        end
        line{j+1}=strcat(line{j+1},[num2str(init(i+1),3),'$ ']);
    end
end
f(fid,', � ����� ����������� �������� ������ ���� ���������� ���������.');

tex_table(fid,'������� �������',key_cond,line);
if process_num==1
    f(fid,['$\epsilon_{max},\%$ --- ����������� ���������� ���������� �������� ���������� � �������������� ������;']);
    l(fid);
    f(fid,['$L_{m\,max},db$ --- ����� ������������ � "�����" �� ���������;']);
    l(fid);
    f(fid,['$\gamma,^{\circ}$ --- ����� ������������ � "�����" �� ����.']);
else
    f(fid,['$\sigma_{max},\%$ --- ���������� �����������������;']);
    l(fid);
    f(fid,['$\epsilon_{max},\%$ --- ����������� ���������� ���������� �������� ���������� � �������������� ������;']);
    l(fid);
    f(fid,['$L_{m\,max},db$ --- ����� ������������ � "�����" �� ���������;']);
    l(fid);
    f(fid,['$\gamma,^{\circ}$ --- ����� ������������ � "�����" �� ����.']);
end
%%
fprintf(fid,'%s\r','\subsection{������ ������� � ���� ��}');

%load_system
name_system = 'sim_object';   %----------------------------- ---------------------------------------------- %��� �����

%��� ������
figure_name = name_system;
figure_file_path=['images/',figure_name];%,'-eps-converted-to'];
figure_file_path = join(figure_file_path);

%������������ ������
fprintf(fid,'%s\r',['������ ������� � ���� �� ������������ �� ���. \ref{fig:',figure_name,'}.']);

handle = load_system(name_system);
% ���������� �������� �����
prints(name_system,PATH.images); %save to pdf and crop with dos
%�������� �������
save_system(handle);
close_system(handle);

%fprintf(fid,'%s\r','\begin{wrapfigure}{l}{\linewidth}');
fprintf(fid,'%s\r','\begin{figure}[!h]\centering');
fprintf(fid,'%s','\includegraphics[width=\linewidth]{');
fprintf(fid,'%s}\r',figure_file_path);
fprintf(fid,'%s\r',['\caption{����������� ����� ������������ �������.}\label{fig:',figure_name,'}']);
fprintf(fid,'%s\r','\end{figure}');
%fprintf(fid,'%s\r','\end{wrapfigure}');
%% 2
fprintf(fid,'%s\r','\subsection{������ ������� � ���� ����������������� ��������� }');

%������� �������
%������������ ������
fprintf(fid,'%s\r',['��������� ', ...
                    '\eqref{eq:','dif_object_sym','} �������� � ���������� ���� � �����������, � ',...
                    '\eqref{eq:','dif_object','} �������� � ������������ �������� ����������.']);
                
fprintf(fid,'%s\r',['\begin{equation}\label{eq:','dif_object_sym','}',...
                    '    \left\{',...
                    '    \begin{aligned}',...
                    'p\,\left(T^2\,p^2+2\,h\,T\,p+1\right)\,x&=K\,u&&, \text{ ����}|u|\le d\\',...
                    'p\,\left(T^2\,p^2+2\,h\,T\,p+1\right)\,x&=K\,d\,\mathrm{sign}\left(u\right)&&, \text{ ����}|u|>d',...
                    '    \end{aligned}',...     
                    '    \right.',...
                    '\end{equation}']); 

%% ��������� �������-------------------------------------------------------------------------change
T=InitialConditions.T;
K=InitialConditions.K;
h=InitialConditions.h;
d=InitialConditions.d; 
%%
fprintf(fid,'%s\r',['\begin{equation}\label{eq:','dif_object','}',...
                    '    \left\{',...
                    '    \begin{aligned}',...
                    'p\,\left(',num2str(T^2),'\,p^2+',num2str(2*h*T),'\,p+1\right)\,x&=',num2str(K),'u',...
                    '&&, \text{ ����}|u|\le ',num2str(d),'\\',...
                    'p\,\left(',num2str(T^2),'\,p^2+',num2str(2*h*T),'\,p+1\right)\,x&=',num2str(K*d),...
                    '\mathrm{sign}\left(u\right)',...
                    '&&, \text{ ����}|u|> ',num2str(d),...
                    '    \end{aligned}',...     
                    '    \right.',...
                    '\end{equation}']);     
%%3
fprintf(fid,'%s\r','\subsection{������ ������������ ������� � ������������ ��������� }');
%������� �������
%������������ ������
fprintf(fid,'%s\r',['��������� ', ...
                    '\eqref{eq:','ss_object','} �������� � ������������ �������� ����������.']);
                
fprintf(fid,'%s\r',['\begin{equation}\label{eq:','ss_object','}',...
                    '    \left\{',...
                    '    \begin{aligned}',...
                    'x_1&=x , \\ \frac{d\,x_1}{d\,t}&=x_2 ,\\ \frac{d\,x_2}{d\,t}&=x_3,\\',...
                    '\frac{d\,x_3}{d\,t}&=',...
                    '    \left\{',...
                    '    \begin{aligned}',...
                    '-&']);
fprintf(fid,'%.4f\r',1/T^2);
fprintf(fid,'%s\r',['\,x_2-']);
fprintf(fid,'%.4f\r',2*h/T);
fprintf(fid,'%s\r',['\,x_3+']);
fprintf(fid,'%.4f\r',K/T^2);
fprintf(fid,'%s\r',['\,',...
                    'u',...
                    '&&, \text{ ����}|u|\le ']);
fprintf(fid,'%.1f\r',d);
fprintf(fid,'%s\r','\\-&');
fprintf(fid,'%.4f\r',1/T^2);
fprintf(fid,'%s\r',['\,x_2-']);
fprintf(fid,'%.4f\r',2*h/T);
fprintf(fid,'%s\r',['\,x_3+']);
fprintf(fid,'%.4f\r',K*d/T^2);
fprintf(fid,'%s\r',['\,',...
                    '\mathrm{sign}\left(u\right)',...
                    '&&, \text{ ����}|u|> ']);
fprintf(fid,'%.1f\r',d);
fprintf(fid,'%s\r',['    \end{aligned}',...     
                    '    \right.',...
                    '    \end{aligned}',...     
                    '    \right.',...
                    '\end{equation}']);  
%% Simulink model
name_system = 'sim_object_analysis';        %��� �����
figure_name = strrep(name_system,'sim_','');%��� �������

fprintf(fid,'%s\r','\subsection{������������ ������� ������� �� ���� �������� �����������}');
fprintf(fid,'%s\r','����� ���������� �������������� $h(t)$.');
fprintf(fid,'%s\r','�� ���� ����� ��� $u=1(t)$');
%������������ ������
fprintf(fid,'%s\r',['������ ������� � simulink ', ...
                    '������������ �� ���. \ref{fig:',name_system,'}.']);
fprintf(fid,'%s\r',['���������� �������������� ������� �� �������� ���������� � � �������� ', ...
                    '������������ �� ���. \ref{fig:',figure_name,'}.']);
fprintf(fid,'%s\r',['����� $x,y,x_1,y_1$ --- ��� �������������� ',...
                    '�������� ���������� ������� � ���������� ���������, ', ...
                    '�������� ��������� �������� ���������� ������� � ���������� ���������, ', ...
                    '�������� ���������� ������� ��� ����������� ��������, ', ...
                    '�������� ��������� �������� ���������� ��� ����������� ��������.']); 
              
%������� ���������� � �������� ���� ����������
assignin('base','T',T);
assignin('base','K',K);
assignin('base','h',h);
assignin('base','d',d);

%load_system
handle = load_system(name_system);
%open_system('D:\education\6_sem\nonlinear_control_systems\kursach\matlab\models\object_anal.slx');
assignin('base','end_time',5000);%------------------------------------------------------------------����� ���������1
set_param(handle,'StopTime','end_time' ,'SolverPrmCheckMsg','warning'...
    ,'SolverResetMethod','robust','Solver','ode23','SolverType','Variable-step','InitialStep','10^-1');   

%�������� ��������� ��������� ������������ ����� ������������� ���
%���������� ������������� � ���������� ���� ������
%���������� ������� � ������� b � ������� �������� ������� ������
[t,s,x,y,x1,y1] = sim(name_system);
assignin('base','y',y);
assignin('base','y1',y1);
assignin('base','t',t);
ST=0.05;RT = [ 0 1 ] ;
S(1)=stepinfo(y,t,'SettlingTimeThreshold',ST,'RiseTimeLimits',RT);
S(2)=stepinfo(y1,t,'SettlingTimeThreshold',ST,'RiseTimeLimits',RT);
end_time = max([S(1).SettlingTime,S(2).SettlingTime]) ; 
assignin('base','end_time',ceil((end_time*2)/500)*500);%------------------------------------------------------------------����� ���������1
set_param(handle,'StopTime','end_time' );

%���������� ������� � ������� b � ������� �������� ������� ������
[t,s,x,y,x1,y1] = sim(name_system);
assignin('base','x',x);
assignin('base','y',y);
assignin('base','x1',x1);
assignin('base','y1',y1);
assignin('base','t',t);

% ���������� �������� �����
prints(name_system,PATH.images); %save to pdf and crop with dos
%�������� �������
save_system(handle);
close_system(handle);

%����������� ����� � latex
%fprintf(fid,'%s\r','\begin{wrapfigure}{l}{\linewidth}');
fprintf(fid,'%s\r','\begin{figure}[!h]\centering');
fprintf(fid,'%s','\includegraphics[width=\linewidth]{');
fprintf(fid,'%s}\r',['images/',name_system]);
fprintf(fid,'%s\r',['\caption{������ ������� � simulink.}\label{fig:',name_system,'}']);
fprintf(fid,'%s\r','\end{figure}');
%fprintf(fid,'%s\r','\end{wrapfigure}');
%% ������
figure_file_path=['images/',figure_name];%,'-eps-converted-to'];
figure_file_path = join(figure_file_path);

S = Object_graph(x,y,x1,y1,t,PATH,figure_name); % ����� �������������

%fprintf(fid,'%s\r','\begin{wrapfigure}{l}{\linewidth}');
fprintf(fid,'%s\r','\begin{figure}[!h]\centering');
fprintf(fid,'%s','\includegraphics[width=\linewidth]{');
fprintf(fid,'%s}\r',figure_file_path);
fprintf(fid,'%s\r',['\caption{���������� �������������� ������� �� �������� ���������� � � ��������.}\label{fig:',figure_name,'}']);
fprintf(fid,'%s\r','\end{figure}');
%fprintf(fid,'%s\r','\end{wrapfigure}');

%% ������ �� �������
%������ ������� �������������
fprintf(fid,'\r%s\r',['��� ������ �� ���� ������������ ����������� �������� ���������� ',... 
    '������������ ������������� ����������, �������� � ��������� ����� ������, �� � ���� ���������� ����������� ',...
    '� �������� � ��������������� �������� �� $t_p=']);
fprintf(fid,'%.0f$\r',S);
key='steady_speed';
fprintf(fid,'%s\r',['������. �������������� �������� �������� ������� � ������� \ref{tab:',key,'}.']);
tex_table2x2(fid,'�������������� �������� ��������',key,'� ��','��� ��',num2str(y(length(y)),3),num2str(y1(length(y1)),3));
fprintf(fid,'%s\r',['������� �����, ��� ��� �������� �������������� ������������� �������� ������� � �� � ��� ��.']);
fprintf(fid,'\r%s\r',[...
'��� ���� � ������� � ���������� ��������� ���������� �������� ������ � �������� ������ , ��� � ������� ��� ����������� ��������, ' ,...
'������ ��� �� � ������� ���������� ���� <<���������>> ������������ ������������ �������� �������, ����������� �� ��������� �� ��� �������� ������.',...
]);
%% ��������� ����� (������ \frac �� \cfraq ) (������ ��� ����� ��������)
fclose all; % ���������� ��� ��������� ����� , �������� � �.�.
replaceinfile('frac', 'cfrac',file_path,'-nobak');

%% ������� worcspace �� ������
% clc;
% clear ;
% close all;
end