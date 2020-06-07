function tex_aligned(fid,key,Cellline,sys) 
%������� 4 �������� ��� ������� �������� ������
fprintf(fid,'%s\r',['\begin{equation}']);
if nargin > 3 %����� ������� ���������
fprintf(fid,'%s\r','    \left\{');   
end
fprintf(fid,'%s\r',['    \begin{aligned} \label{eq:',key,'}']);
for i=1:length(Cellline)
fprintf(fid,'%s\r',['       ',Cellline{i},'\\']);    
end
fprintf(fid,'%s\r', '    \end{aligned}');
if nargin > 3 %����� ������� ���������
fprintf(fid,'%s\r','    \right.');   
end
fprintf(fid,'%s\r','\end{equation}');
end