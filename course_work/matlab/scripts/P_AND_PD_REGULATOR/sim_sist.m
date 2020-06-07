function FIGS = sim_sist(InitialConditions,PATH)
%���������� ������� �����
name_system = 'sim_P';                 %��� �����

%��� � ���� ������� ����� ��� Latex
% �������� �����
figure_name = name_system;
figure_file_path=['images/',figure_name];%
figure_file_path = join(figure_file_path);
Cellfig_names{1} = figure_name ;
Cellfig_path{1}=figure_file_path;
Cellfig_description{1}='�� ��������� ������� � ���������������� �����������.';

handle = load_system(name_system); %�������� �����

% ���������� ������� �����
prints(name_system,PATH.images); %save to pdf and crop with dos

%�������� �������
save_system(handle);
close_system(handle);

FIGS.description = Cellfig_description;
FIGS.names=Cellfig_names;
FIGS.path=Cellfig_path;
end