function FIGS = sim_sist(InitialConditions,PATH)
%сохранение рисунка схемы
name_system = 'sim_P';                 %имя схемы

%имя и путь рисунка схемы для Latex
% картинка схемы
figure_name = name_system;
figure_file_path=['images/',figure_name];%
figure_file_path = join(figure_file_path);
Cellfig_names{1} = figure_name ;
Cellfig_path{1}=figure_file_path;
Cellfig_description{1}='СС замкнутой системы с пропорциональным регулятором.';

handle = load_system(name_system); %загрузка схемы

% Сохранение рисунка схемы
prints(name_system,PATH.images); %save to pdf and crop with dos

%закрытие системы
save_system(handle);
close_system(handle);

FIGS.description = Cellfig_description;
FIGS.names=Cellfig_names;
FIGS.path=Cellfig_path;
end
