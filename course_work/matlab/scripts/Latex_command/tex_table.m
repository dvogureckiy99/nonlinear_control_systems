function tex_table(fid,title,key,line)
fprintf(fid,'\r%s\r','\begin{table}[!h] \centering');
fprintf(fid,'    %s\r',['\caption{',title ,'} \label{tab:',key,'}']);
fprintf(fid,'    %s','\begin{tabular}{|');
column=length(strfind(line{1},'&'));
for i=1:(column+1)
fprintf(fid,'%s','c|');
end
fprintf(fid,'%s\r','}');
fprintf(fid,'        %s\r','\hline');
for i=1:length(line)
fprintf(fid,'        %s\r',[line{i},' \\ \hline']);
end
fprintf(fid,'    %s\r','\end{tabular}');
fprintf(fid,'%s\r','\end{table}');
end