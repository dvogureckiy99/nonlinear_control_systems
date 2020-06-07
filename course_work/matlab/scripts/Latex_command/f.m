function f(fid,str)
%It just pasting a text string into latex document named by fid and line break
%записать инфу в файл и перенести на новую строку
fprintf(fid,'%s\r',str);
end
