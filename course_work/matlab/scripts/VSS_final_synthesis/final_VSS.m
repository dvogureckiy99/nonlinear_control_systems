function final_VSS(InitialConditions,PATH,path_subsection,name_subsection,section_name)
%%
disp(['��������� --- subsection_name:"',name_subsection,'"']);
%% ������� ������������ ��� ������� � ������� ���������� ���� "�����" .
%% �������� ������
file_path=[path_subsection ,name_subsection,'.tex'];
file_path = join(file_path);
fid = fopen(file_path,'w','l','UTF-8');
f(fid,'\clearpage');
fprintf(fid,'%s\r','\subsection{������������ ������� ���������������� ���������� ���}');
%%
%% ��������� �������-------------------------------------------------------------------------change
T=InitialConditions.T;
K=InitialConditions.K;
h=InitialConditions.h;
d=InitialConditions.d;
%%
name_system = 'sim_final_VSS';
FIGS = save_system_fig(PATH,name_system,'����������� ����� ���������� ���.');
f(fid,['�� ������ ����� ���� ���� ������������� ��� ��� ����� ������������ � ������ ����������  $S_1$, ���������� ����� ������ ���������. ����� ��� ������� ��� � ���������� ��������� (��) �� ������������� �������� ������� ��� ������� ���������� � ������ ������������ $S_2=10x_1+6x_2+d$, ��� �������� d ���������� ���������� ����� ����������� ����� $S_1$ � $S_2$. �������� $d$ ���������� �������� �������� � ��� �� ����������� ������ ��������. ��� ��������� ���������� ���� �������� � ��������� ����������� ������� ������������ �������� ���� ���������������. ����������� ����� ��� ������������� ������������ ��  ',figref(FIGS.names{1}),'. ']);
past_figures(fid,FIGS,1);

l(fid);
% count=4; %--------------------------------------------------------------------------------------------���������� �������� 8 max
% mn{1}=[2,2];%----------------------------------------------------change ��������� � alpha �  betta �����.  
% [C1, C2, alpha, betta, iter ,time ] = choose_coeff(InitialConditions,mn{1}) ;
alpha=14;
beta=-200;
C1=50;
C2=227.25;
k1=2;
k2=43.1;
ds=1;
sw1=1;
param{1}=[alpha beta C1 C2 k1 k2 ds sw1];
[FIGS,Settlingtime,init] = sim_VSS_final(PATH,InitialConditions,name_system,param);
f(fid,['��������� �������� ������� ��������� �� ������� ����������� ',...
'������������� ��������� � ������� ��� ���������� ������� �� ���������',...
' ����������. ������� ���������� � ������� �� ',figref(FIGS.names{1}),'. ']);
f(fid,['� ���������� �� ',figref(FIGS.names{2}),' ������� ��������� �������� ���������� � � �����������, � �� ',figref(FIGS.names{3}),' ������� ��������� ������� ��������� ��� ���� ���������� ���������. ']);

key5='tab_settlinhtime_VSS_final';
f(fid,['� ',tabref(key5),' ��������� ����� ������������� ��� ������ ��������� ����������']);
title='��������� �����������';
line{1}=['zad & ���������� & $\alpha$ & $\beta$ & $C_1$ & $C_2$ & $k_1$ & $k_2$ & $ds$ & $sw1$ & $t_p$'];
for j=1:length(Settlingtime)
    line{j+1}=['$',num2str(init(1,j)),'$ & '];
        mas=abs(init(1,:));
        if abs(init(1,j))==min(mas)
            line{j+1}=strcat(line{j+1},'� �����');
        elseif abs(init(1,j))==max(mas)
            line{j+1}=strcat(line{j+1},'� �������');
        end
    line{j+1}=strcat(line{j+1},'& $');
    for i=1:length(param{1})
    line{j+1}=strcat(line{j+1},[num2str(param{1}(i),3),'$ & $']);
    end
    line{j+1}=strcat(line{j+1},[num2str(Settlingtime(j),3),'$ ']);
end

tex_table(fid,title,key5,line);
width = [0.7 1 0.6 0.7 1];
past_figures(fid,FIGS,width);

l(fid);
f(fid,'�������� ����������� �������� ���������� � �������������� ������ ��������� $\epsilon=0$ � ��� ������������� �������� ����������� �������� $\epsilon\le',num2str(InitialConditions.e,3),'$.');
%f(fid,'����������������� ����� .');
%% ��������� ����� (������ \frac �� \cfraq ) (������ ��� ����� ��������)
fclose all; % ���������� ��� ��������� ����� , �������� � �.�.
replaceinfile('frac', 'cfrac',file_path,'-nobak');

%% ������� worcspace �� ������
% clc;
% clear;
% close all;
end



