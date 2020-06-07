function make_hole(path_subsection,name_subsection,description)
%Создаёт заглушки. Что это?
%Это файлы с текстом( выводы, описание чего-либо), который потом
%редактируется в latex. Т.е. создаются они один раз, далее только
%редактируются вручную.
%Для чего это сделано?
%Чтобы было удобнее дописывать текст непосредственно в latex ,
%Который не будет впоследствии меняться при новых компиляциях matlab
%
%Для записи простого текста, который не будет изменяться использовать файлы
%заглушки, создаваемые функцией make_hole.
%
%Естественно, что текст заглушек
%будет следовать в порядке , в которром вы создавали заглушки в
% "Создание имен файлов и заглушек", поэтому порядок их размещения важен
%
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%Необходимо обязательно имя заглушки начинать с "hole_"
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%
%Итак функция создает пустой .tex файл в нужной директории, который потом
%заполняется вручную. Проверяет создан ли файл, если да, то не пересоздаёт,
%т.е. ничего не делает.

file_path=[path_subsection,name_subsection,'.tex'];
file_path = join(file_path);
    if exist(file_path,'file')
        disp('yes');
    else
        disp('no');
        fid = fopen(file_path,'w','l','UTF-8');
        %создание простой структуры
        fprintf(fid,'%s\r','%--------------------------HOLE-------------------------------');
        fprintf(fid,'%s\r','% Что это?');
        fprintf(fid,'%s\r','% Это файл с простым текстом( выводы, описание чего-либо), который редактируются вручную.');
        if nargin > 2 %добавить описание к файлу
        fprintf(fid,'%s\r','% Описание (для чего файл):');
        fprintf(fid,'%s\r',['% ',description]);
        end
        fclose all; % необходимо для обработки файла , удаление и т.д.
    end
end
