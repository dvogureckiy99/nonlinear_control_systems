function [PATH,report_path] = create_folders(root_folder)
report_path =        [root_folder,'report.tex'] ;%���� � ��������� ����� ���������� ������
PATH.images        = [root_folder,'images\']    ; %����� � ����������
PATH.Texcomponents = [root_folder,'components\'] ; %��� ��� Latex
%PATH.Simulinkmodel =
%% �������� �����
[status,msg]= mkdir(PATH.images);
[status,msg]= mkdir(PATH.Texcomponents);
end