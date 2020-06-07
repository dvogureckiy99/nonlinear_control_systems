function create_section1(InitialConditions,PATH,section_name)
%������ ����� � ����� components, ���������� ������� �����, � ��������� �
%������������ ������������
% section_name ? ��� �������� Tex file chapter
% PATH ? ��������� � ������
% InitialConditions ? ��������� �������
%��� ������ �������� ������, ������� �� ����� ���������� ������������ �����
%��������, ����������� �������� make_hole. �����������, ��� ����� ��������
%����� ��������� � ������� , � �������� �� ��������� �������� �
% "�������� ���� ������ � ��������", ������� ������� �� ���������� �����
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%���������� ����������� ��� �������� �������� � "hole_"
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
section_title = '�������� ������� ������������ �������' ;
%% �������� ���� ������ � ��������
Cellname_subsection{1} =  'object_analysis_1'; 
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
fprintf(fid,'%s\r',['\section{',section_title,'}']);    %������ ����� ����� ������

f(fid,'�� ����� �������������� ��������������� ������� ����������  �������� ������� ������������ ������� ����������� �� ��� �������������� ������. ������ ��������� � ������� ����� ���� ������������ � ��������� �����. ���������� ��������� �� ��� �� ������� ����������� �������, �������� � ������� ����������� ���������� ���������������� ���������� �������� �������.');
l(fid);
for i=1:length(Cellname_subsection)
    fprintf(fid,'%s\r',['\input{components/',section_name,'/',Cellname_subsection{i},'}']); %����������� ���� �� ���� ������
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
        if strcmp(name_subsection,Cellname_subsection{1})
            ObjectAnalysis(InitialConditions,PATH,section_name,name_subsection);    
        end
    end
end



%% ������� worcspace �� ������
% clc;
% clear;
% close all;
end