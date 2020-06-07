function tex_eq(fid,key,line)
fprintf(fid,'%s\r',['\begin{equation} \label{eq:',key,'}']);
fprintf(fid,'%s\r',line);
fprintf(fid,'%s\r','\end{equation}');
end