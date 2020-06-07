function NE_influence(InitialConditions,PATH,path_subsection,name_subsection,k1,k2,Settlingtime)
%%
disp(['��������� --- subsection_name:"',name_subsection,'"']);
%% ������� ������������ ��� ������� � ������� ���������� ���� "�����" .
%% �������� ������
file_path=[path_subsection ,name_subsection,'.tex'];
file_path = join(file_path);
fid = fopen(file_path,'w','l','UTF-8');
fprintf(fid,'%s\r','\subsection{������ ������� ����������� �������� �� �������� �������� �������}');    
%% 1
f(fid,'��� ������������ ������� �� ����� ����������� 2 �������: � �� � ��� ����.');
f(fid,['����������� ����� ������� ����� ��������������� �� �� ',figref('sim_PD'),' � �������� �� � � ��� ����.']);
f(fid,['�� ����������� ����������� ������������� ������� ����������� $k_1=',num2str(k1),',k_2=',num2str(k2,3),'$. ']);
[FIGS] = sim_sysNE(InitialConditions,PATH,k1,k2,Settlingtime); %��������� ���������� ���������
f(fid,[' ������� ��������� �������� ���������� $X$ ��� ������� � �� � ��� ���� �� ',figref(FIGS.names{1}),' ']);
f(fid,'��� ������ �� ���� ���');
past_figures(fid,FIGS,1);%������� ����� ������
l(fid);
end