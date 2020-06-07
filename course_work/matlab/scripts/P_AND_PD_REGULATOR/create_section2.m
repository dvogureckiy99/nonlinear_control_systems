function create_section2(InitialConditions,PATH,section_name)
%������ ����� � ����� components, ���������� ������� �����, � ��������� �
%������������ ������������
% section_name ? ��� �������� Tex file chapter
% PATH ? ��������� � ������
% InitialConditions ? ��������� �������
%���� 3 ���� ������:
%1)������� ���� ? �������� �������� � ���������� � �����
%2)hole file ? ��� �������� ����������� ������� �����, ������� �� ����� ����������, ������������ �����
%��������, ����������� �������� make_hole. 
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%���������� ����������� ��� �������� �������� � "hole_"
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%3)support file ? ��� �������� ������������� �����,� ������� ����� �������� ����������, ����������� ��� ����������� 
%������������� � �������� � ������ ���������� ����� , ������������ support(���������) �����,
%���� ���� �� ���������� � �������� �����, �� ���������� � �� ����������
%��� ������ ������� ������ ����.
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%���������� ����������� ��� ����� �������� � "support_"
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
% �����������, ��� ���������� ����� ����� ��������� � ������� , � �������� �� �������� �� ����� �
% "�������� ���� ��� ���������� ������...", ������� ������� �� ���������� �����.
section_title = '����������� ������ ��������� ������� ����������' ;
%% �������� ���� ��� ���������� ������ � ����� (�������� ������������� ������������ ������,��������) 
% � ������������ � ����� (��������������� �����).
Cellname_subsection{1} =  'hole_PR'; 
Cellname_subsection{2} =  'PR'; 
Cellname_subsection{3} =  'PDR';
Cellname_subsection{4} =  'hole_conclusion_PDR';
Cellname_subsection{5} =  'NE_influence';
Cellname_subsection{6} =  'hole_influence';
%%
disp(['��������� --- Chapter_name:"',section_name,'"']);
%% ������������ ���� � ����� � chapter (��� section)
path_subsection = [PATH.Texcomponents,section_name,'\']; %���� � ����� �����(chapter),
% � ������� ����� ��������� �����(section)��� ��������(subsection,����
% �������� ������������ ��� ������)
%% �������� �����, ���������� �����
mkdir(path_subsection);
%% ������������ ���� �  ����� � ��������� ��������(section) �����( chapter) ��� ����������� ��������.
file_path=[path_subsection ,section_name,'.tex'];        %���� � ����� � ��������� ��������(section) �����( chapter)
file_path = join(file_path);
fid = fopen(file_path,'w','l','UTF-8');                  
%% ���������� �������� Tex file
fprintf(fid,'%s\r',['\section{',section_title,'}']);    %������ ����� ����� ������
for i=1:length(Cellname_subsection)
    name_subsection = Cellname_subsection{i} ; %��������� ��� �� ������
    if (~strncmpi(name_subsection,'support_',8)) %��������, ��� ��� �� support ���� , �.�. ��� �������� �� ����� 
    fprintf(fid,'%s\r',['\input{components/',section_name,'/',name_subsection,'}']); %����������� ���� �� ���� ������
    end
end
fclose all; % ���������� ��� ��������� ����� , �������� � �.�.

%% ���������������� �������� tex files
for i=1:length(Cellname_subsection)
    name_subsection = Cellname_subsection{i} ; %��������� ��� �� ������
    if strncmpi(name_subsection,'hole_',5) %����� ������� ���� ��������
        description = ['Hole number:', num2str(i)];
        make_hole(path_subsection,name_subsection,description); %������ ����-�������� ��� ������
    else
        %������ ������ ������ ����� (�������� ������� ������ � ������)
        if strcmp(name_subsection,Cellname_subsection{2})
           k1koef=P_regulator(InitialConditions,PATH,path_subsection,name_subsection);
        end
        if strcmp(name_subsection,Cellname_subsection{3})
           [k1,k2,Setltime]=PD_regulator(InitialConditions,PATH,path_subsection,name_subsection,k1koef);
        end
        if strcmp(name_subsection,Cellname_subsection{5})
           NE_influence(InitialConditions,PATH,path_subsection,name_subsection,k1,k2,Setltime);
        end
    end
end



%% ������� worcspace �� ������
% clc;
% clear;
% close all;
end