function tex_enumerate(fid,Cellline)
fprintf(fid,'%s\r','\begin{enumerate}');
for i=1:length(Cellline)
    fprintf(fid,'%s\r','\item ');
    fprintf(fid,'%s\r',Cellline{i});
end
fprintf(fid,'%s\r','\end{enumerate}');
end