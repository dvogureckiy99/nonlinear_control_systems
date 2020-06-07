  function create_section5(InitialConditions,PATH,section_name)
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
section_title = '������ ���������� ��� ��� ������� ����������� �� ������������ ���������' ;
%% �������� ���� ������ � ��������
Cellname_subsection{1} =  'relay_system'; 
 Cellname_subsection{2} =  'final_VSS';
% Cellname_subsection{3} =  'VSS_steady_degenerate_motion'; 
% Cellname_subsection{4} =  'VSS_no_steady_degenerate_motion'; 
% Cellname_subsection{5} =  'VSS_sliding_mode';
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
        if strcmp(name_subsection,Cellname_subsection{1})
           %relay_system(InitialConditions,PATH,path_subsection,name_subsection,section_name);    %
        end
        if strcmp(name_subsection,Cellname_subsection{2})
           final_VSS(InitialConditions,PATH,path_subsection,name_subsection,section_name);    %
        end
    end
end



%% ������� worcspace �� ������
% clc;
% clear;
% close all;
end