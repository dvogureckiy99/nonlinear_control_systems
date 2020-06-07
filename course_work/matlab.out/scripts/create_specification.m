function create_specification(InitialConditions,PATH,section_name)
section_title = 'Аннотация' ;
%%
disp(['Обработка --- Chapter_name:"',section_name,'"']);
%% формирование пути к папке с chapter (или section)
path_subsection = [PATH.Texcomponents,section_name,'\']; %путь к папке главы(chapter),
% в которой будут храниться главы(section)или подглавы(subsection,если
% создаётся лабораторная или курсач)
%% Создание папки, содержащей главу
[status,msg]=mkdir(path_subsection);
%% формирование пути к  файлу с описанием разделов(section) главы( chapter) или подразделов разделов.
file_path=[path_subsection ,section_name,'.tex'];        %путь к файлу с описанием разделов(section) главы( chapter)
file_path = join(file_path);
fid = fopen(file_path,'w','l','UTF-8');                  
%% Заполнение главного Tex file
fprintf(fid,'%s\r',['\anonsection{',section_title,'}']);    %запись имени новой секции
fclose all; % необходимо для обработки файла , удаление и т.д.

%%Введение 
section_title = 'Введение' ;
%%
disp(['Обработка --- Chapter_name:"',section_name,'"']);
%% формирование пути к папке с chapter (или section)
path_subsection = [PATH.Texcomponents,section_name,'\']; %путь к папке главы(chapter),
% в которой будут храниться главы(section)или подглавы(subsection,если
% создаётся лабораторная или курсач)
%% Создание папки, содержащей главу
[status,msg]=mkdir(path_subsection);
%% формирование пути к  файлу с описанием разделов(section) главы( chapter) или подразделов разделов.
file_path=[path_subsection ,section_name,'.tex'];        %путь к файлу с описанием разделов(section) главы( chapter)
file_path = join(file_path);
fid = fopen(file_path,'w','l','UTF-8');                  
%% Заполнение главного Tex file
fprintf(fid,'%s\r',['\anonsection{',section_title,'}']);    %запись имени новой секции
fclose all; % необходимо для обработки файла , удаление и т.д.
%% очистка worcspace от мусора
% clc;
% clear;
% close all;
end
