function create_specification(InitialConditions,PATH,section_name)
section_title = '���������' ;
%%
disp(['��������� --- Chapter_name:"',section_name,'"']);
%% ������������ ���� � ����� � chapter (��� section)
path_subsection = [PATH.Texcomponents,section_name,'\']; %���� � ����� �����(chapter),
% � ������� ����� ��������� �����(section)��� ��������(subsection,����
% �������� ������������ ��� ������)
%% �������� �����, ���������� �����
[status,msg]=mkdir(path_subsection);
%% ������������ ���� �  ����� � ��������� ��������(section) �����( chapter) ��� ����������� ��������.
file_path=[path_subsection ,section_name,'.tex'];        %���� � ����� � ��������� ��������(section) �����( chapter)
file_path = join(file_path);
fid = fopen(file_path,'w','l','UTF-8');                  
%% ���������� �������� Tex file
fprintf(fid,'%s\r',['\anonsection{',section_title,'}']);    %������ ����� ����� ������
fclose all; % ���������� ��� ��������� ����� , �������� � �.�.

%%�������� 
section_title = '��������' ;
%%
disp(['��������� --- Chapter_name:"',section_name,'"']);
%% ������������ ���� � ����� � chapter (��� section)
path_subsection = [PATH.Texcomponents,section_name,'\']; %���� � ����� �����(chapter),
% � ������� ����� ��������� �����(section)��� ��������(subsection,����
% �������� ������������ ��� ������)
%% �������� �����, ���������� �����
[status,msg]=mkdir(path_subsection);
%% ������������ ���� �  ����� � ��������� ��������(section) �����( chapter) ��� ����������� ��������.
file_path=[path_subsection ,section_name,'.tex'];        %���� � ����� � ��������� ��������(section) �����( chapter)
file_path = join(file_path);
fid = fopen(file_path,'w','l','UTF-8');                  
%% ���������� �������� Tex file
fprintf(fid,'%s\r',['\anonsection{',section_title,'}']);    %������ ����� ����� ������
fclose all; % ���������� ��� ��������� ����� , �������� � �.�.
%% ������� worcspace �� ������
% clc;
% clear;
% close all;
end