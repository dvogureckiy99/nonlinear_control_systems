function tex_align(fid,Cellkey,Cellline) 
fprintf(fid,'%s\r',['    \begin{align} ']);
for i=1:length(Cellline)
fprintf(fid,'%s\r',['       ',Cellline{i},'\\ \label{eq:',Cellkey{i},'}']);    
end
fprintf(fid,'%s\r', '    \end{align}');
end
