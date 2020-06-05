function past_figure(PATH,section_name,name_subsection,FIGS)
%������� ����������� ��������
disp('��������� past figure');
%% �������� ������
path_subsection = [PATH.Texcomponents,section_name,'\'];%���� � subsection files
file_path=[path_subsection ,name_subsection,'.tex'];
file_path = join(file_path);
fid = fopen(file_path,'w','l','UTF-8');
%% ������� ���� ��������
count_figs=length(FIGS.names);
    for i=1:count_figs
        figure_name=FIGS.names{i};
        figure_path=FIGS.path{i};
        description=FIGS.description{i};
        tex_past_figure(fid,figure_path,figure_name,description,0.7);
    end
fclose(fid); % ���������� ��� ��������� ����� , �������� � �.�.
end