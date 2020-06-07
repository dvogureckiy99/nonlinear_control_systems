function DCS(InitialConditions,PATH,path_subsection,name_subsection,section_name)
%%
disp(['��������� --- subsection_name:"',name_subsection,'"']);
%% ������� ������������ ��� ������� � ������� ���������� ���� "�����" .
%% �������� ������
file_path=[path_subsection ,name_subsection,'.tex'];
file_path = join(file_path);
fid = fopen(file_path,'w','l','UTF-8');
%f(fid,'\clearpage');
%fprintf(fid,'%s\r','\subsection{���}');
%%
%% ��������� �������-------------------------------------------------------------------------change
T=InitialConditions.T;
K=InitialConditions.K;
h=InitialConditions.h;
d=InitialConditions.d;
%%
name_system = 'sim_final_VSS_PWM';
FIGS = save_system_fig(PATH,name_system,'����������� ����� ���������� ��� � ���. ');
f(fid,['����� �������� � ����������� ��� ��  ',figref(FIGS.names{1}),'. ']);
        figure_name=FIGS.names{1};
        figure_path=FIGS.path{1};
        description=FIGS.description{1};
        width=1;
    fprintf(fid,'%s\r','\begin{sidewaysfigure}[!h]\centering');
    fprintf(fid,'%s','\includegraphics[width=');
    fprintf(fid,'%.1f',width);
    fprintf(fid,'%s','\linewidth]{');
    fprintf(fid,'%s}\r',figure_path);
    fprintf(fid,'%s\r',['\caption{',description,'}\label{fig:',figure_name,'}']);
    fprintf(fid,'%s\r','\end{sidewaysfigure}');

l(fid);
% count=4; %--------------------------------------------------------------------------------------------���������� �������� 8 max
% mn{1}=[2,2];%----------------------------------------------------change ��������� � alpha �  betta �����.  
% [C1, C2, alpha, betta, iter ,time ] = choose_coeff(InitialConditions,mn{1}) ;
alpha=47.084107;
beta=-35.313081;
C1=0.761702;
C2=11;
k1=3;
k2=200;
ds=1;
zad=[1 100];
param{1}=[alpha beta C1 C2 k1 k2 ds];
[FIGS,ST] = sim_VSS_final_DCS(PATH,InitialConditions,name_system,param,zad);
f(fid,['��������� �������� ������� ��������� �� ������� ����������� ',...
'������������� ��������� � ������� ��� ���������� ������� �� ���������',...
' ����������. ']);
f(fid,['�� ',figref(FIGS.names{2}),' ������� ��������� �������� ����������. ']);

past_figures(fid,FIGS,0.6);
f(fid,['����� ����������� �������� ��� ���������� "� �����" �������� ������� ',figref(FIGS.names{1}),' ����� ',...
    num2str(ST(1),3),' ���.']);
f(fid,['����� ����������� �������� ��� ���������� "� �������" �������� ������� ',figref(FIGS.names{2}),' ����� ',...
    num2str(ST(2),3),' ���.']);
f(fid,'� ���������� �����, ��� ���������� ������� �� �������� ������������� ������� �������.');
[FIGS] = sim_VSS_DCS(PATH,InitialConditions,name_system,param,zad);
past_figures(fid,FIGS,0.6);
l(fid);

%% ��������� ����� (������ \frac �� \cfraq ) (������ ��� ����� ��������)
fclose all; % ���������� ��� ��������� ����� , �������� � �.�.
replaceinfile('frac', 'cfrac',file_path,'-nobak');

%% ������� worcspace �� ������
% clc;
% clear;
% close all;
end



