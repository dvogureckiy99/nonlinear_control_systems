function create_section2(InitialConditions,PATH,section_name)
%создаёт папки в папке components, содержащие разделы главы, и заполняет её
%необходимыми компонентами
% section_name ? имя главного Tex file chapter
% PATH ? структура с путями
% InitialConditions ? начальные условия
%Есть 3 типа файлов:
%1)обычный файл ? создаётся матлабом и включается в отчёт
%2)hole file ? Для создание включаемого пустого файла, который не будет изменяться, использовать файлы
%заглушки, создаваемые функцией make_hole. 
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%Необходимо обязательно имя заглушки начинать с "hole_"
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%3)support file ? Для создание невключаемого файла,в который будет записана информация, необходимая для последующей 
%корректировки и переноса в нужные включаемые файлы , использовать support(поддержки) файлы,
%Этот файл не включается в итоговый отчёт, но информация в нём изменяется
%при каждом запуске матлаб кода.
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%Необходимо обязательно имя файла начинать с "support_"
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
% Естественно, что включаемые файлы будут следовать в порядке , в которром вы задавали их имена в
% "Создание имен для включаемых файлов...", поэтому порядок их размещения важен.
section_title = 'Обоснование выбора структуры системы управления' ;
%% Создание имен для включаемых файлов в отчет (основных автоматически генерируемых файлов,заглушек) 
% и невключаемых в отчет (вспомогательные файлы).
Cellname_subsection{1} =  'hole_PR'; 
Cellname_subsection{2} =  'PR'; 
Cellname_subsection{3} =  'PDR';
Cellname_subsection{4} =  'hole_conclusion_PDR';
Cellname_subsection{5} =  'NE_influence';
Cellname_subsection{6} =  'hole_influence';
%%
disp(['Обработка --- Chapter_name:"',section_name,'"']);
%% формирование пути к папке с chapter (или section)
path_subsection = [PATH.Texcomponents,section_name,'\']; %путь к папке главы(chapter),
% в которой будут храниться главы(section)или подглавы(subsection,если
% создаётся лабораторная или курсач)
%% Создание папки, содержащей главу
mkdir(path_subsection);
%% формирование пути к  файлу с описанием разделов(section) главы( chapter) или подразделов разделов.
file_path=[path_subsection ,section_name,'.tex'];        %путь к файлу с описанием разделов(section) главы( chapter)
file_path = join(file_path);
fid = fopen(file_path,'w','l','UTF-8');                  
%% Заполнение главного Tex file
fprintf(fid,'%s\r',['\section{',section_title,'}']);    %запись имени новой секции
for i=1:length(Cellname_subsection)
    name_subsection = Cellname_subsection{i} ; %извлекаем имя из ячейки
    if (~strncmpi(name_subsection,'support_',8)) %проверка, что это не support файл , т.к. его включать не нужно 
    fprintf(fid,'%s\r',['\input{components/',section_name,'/',name_subsection,'}']); %прописываем пути ко всем файлам
    end
end
fclose all; % необходимо для обработки файла , удаление и т.д.

%% Непосредственное создание tex files
for i=1:length(Cellname_subsection)
    name_subsection = Cellname_subsection{i} ; %извлекаем имя из ячейки
    if strncmpi(name_subsection,'hole_',5) %нужно создать файл заглушку
        description = ['Hole number:', num2str(i)];
        make_hole(path_subsection,name_subsection,description); %создаём файл-заглушку для текста
    else
        %просто создаём нужные файлы (основные функции работы с матлаб)
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



%% очистка worcspace от мусора
% clc;
% clear;
% close all;
end