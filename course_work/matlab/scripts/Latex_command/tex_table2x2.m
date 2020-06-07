function tex_table2x2(fid,title,key,a11,a12,a21,a22)
fprintf(fid,'\r%s\r','\begin{table}[!h] \centering');
fprintf(fid,'    %s\r',['\caption{',title ,'} \label{tab:',key,'}']);
fprintf(fid,'    %s\r','\begin{tabular}{|c|c|}');
fprintf(fid,'        %s\r','\hline');
fprintf(fid,'        %s\r',[a11,' & ',a12,' \\ \hline']);
fprintf(fid,'        %s\r',[a21,' & ',a22,' \\ \hline']);
fprintf(fid,'    %s\r','\end{tabular}');
fprintf(fid,'%s\r','\end{table}');
end