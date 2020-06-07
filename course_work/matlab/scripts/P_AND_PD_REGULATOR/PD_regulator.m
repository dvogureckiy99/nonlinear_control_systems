function [k1,k2,Settlingtime] = PD_regulator(InitialConditions,PATH,path_subsection,name_subsection,k1koef)
%%
disp(['��������� --- subsection_name:"',name_subsection,'"']);
%% ������� ������������ ��� ������� � ������� ���������� ���� "�����" .
%% �������� ������
file_path=[path_subsection ,name_subsection,'.tex'];
file_path = join(file_path);
fid = fopen(file_path,'w','l','UTF-8');
fprintf(fid,'%s\r','\subsection{������������ ������� ���������� � \\ ���������������-���������������� �����������} \label{title:PDR}');    
%% ��������� �������
T=InitialConditions.T;
K=InitialConditions.K;
h=InitialConditions.h;
d=InitialConditions.d; 
%% 1
FIGS = sim_sistPD(InitialConditions,PATH); %���������� ������� �����
key1='con_PD';
fprintf(fid,'%s\r','�������� �������',...
    '���������������� ��������� � ����������� �����  ��� ��������������� �������� ������� � ���������������-���������������� ����������� ',...
    '������������ ���������� $x$.'...
    );
past_figures(fid,FIGS,1);%������� ����� ������
f(fid,['�� �� ��������� ������� �� ',figref(FIGS.names{1}),' �������� ���������',eqref(key1),'.']);
line1{1} = ['x&=X_{zad}-X & X&=\frac{',num2str(K),'\,z(u)}{Q(p)}'];
line1{2} = ['Q(p)&=p\,\left(',num2str(T^2),'\,p^2+',num2str(2*h*T),'\,p+1\right)&Q(p)\,x&=Q(p)\,X_{zad}-',...
    num2str(K),'z(u)'];
tex_aligned(fid,key1,line1);
key2='con_PD1';
fprintf(fid,'%s\r','��������� ����������� �������� �������, �.�. ������� $X_{zad}=0$.',...
    ' ����, ��� �� ����� ���������������-���������������q ���������, �.�. $u\hm{=}k_1\,x\hm{+}k_2\,\frac{d\,x}{d\,t}$, �������� ���������',eqref(key2),'.');
tex_eq(fid,key2,['Q(p)\,x=-', num2str(K),'\,z(k_1\,x+k_2\,\frac{d\,x}{d\,t})']);
key3='con_PD2';
fprintf(fid,'%s\r',['����� �������� ������� $z(u)$ � ������� ������� \eqref{eq:',key3,'}.']);
line{1}=['p\,\left(',num2str(T^2),'\,p^2+',num2str(2*h*T),'\,p+1\right)\,x&=-',num2str(K),'\,\left(k_1\,+k_2\,p\right)\,x',...
                    '&&, \text{ ����}|u|\le ',num2str(d)];
line{2}=['p\,\left(',num2str(T^2),'\,p^2+',num2str(2*h*T),'\,p+1\right)\,x&=-',num2str(K*d),...
                    '\,\mathrm{sign}\left(u\right)',...
                    '&&, \text{ ����}|u|> ',num2str(d)];                
tex_aligned(fid,key3,line,'sys');
f(fid,['������ �� ��������� ������� ��� $u\le',num2str(d),'$',eqref('HP_PD'),'.']);
tex_eq(fid,'HP_PD',['D(p)=\left(',num2str(T^2),'\,p^3+',num2str(2*h*T),'\,p^2+p\,\left(1+',num2str(K),'\,k_2\right)+',num2str(K),'\,k_1\right)']);
f(fid,['��� $|u|>',num2str(d),'$ �������� �������� ����� ����������� � �������� � ��� ������������ ',...
    '���������� ������������ �������, ��� �������, ��� �� ��� ���� ������� ���������� �� �������� �����������. ',...
    '��� $|u|\le',num2str(d),'$ �������� ����������� �������� ���������������� ����������.']);
l(fid);
f(fid,'����������� ����������� �������� �� �������� �������:');
l(fid);
f(fid,['$a_0=',num2str(T^2),',a_1=',num2str(2*h*T),',a_2=1+',num2str(K),'\,k_2,a_3=',num2str(K),'\,k_1$']);
tex_eq(fid,'key5','a_1\.a_2-a_0\,a_3\ge0'); 
syms k1 k2 ;
M=2*h*T*(1+K*k2)-K*T^2*k1;
k2=solve(M,k2);
tex_eq(fid,'sys_ust_PD',['k_2\ge',latex(k2),' \text{ --- ��� ��������������� ������������.}']);
tex_eq(fid,'as_ust_PD',['k_{2\text{�.�.}}(k_1)=',latex(k2),'\text{ --- ������� ������������.} ']);
[FIGS, k1v, k2v, mult,Settlingtime,index_min_S] = sim_sysPD(InitialConditions,PATH,k1koef,k2); %��������� ���������� ���������
l(fid);
f(fid,['������ �� ������������ ���������� ��� ��������� ��������� $k_1,k_2$ ��� ���������� ������� �� ',figref(FIGS.names{1}),'. ']);
key4='k1k2PD';
key5='k1k2PDcalc';
f(fid,[' ��������� �������� �������� � ',tabref(key4),', � �������� �� ������� ������� � ',tabref(key5),'.']);
line{1}=['$k_1$ '];
for i=1:length(k1v)
line{1}=strcat(line{1},['& $',num2str(k1v(i),2),'$']);
end
line{2}=['$k_2$ '];
for i=1:length(k2v)
line{2}=strcat(line{2},['& $k_{2\text{�.�.}}(',num2str(k1v(i),2),')\cdot',num2str(mult(i)),'$']);
end
tex_table(fid,'�������� ������� �������� $k_1,k_2$',key5,line);
line{1}=['$k_1$ '];
for i=1:length(k1v)
line{1}=strcat(line{1},['& $',num2str(k1v(i),2),'$']);
end
line{2}=['$k_2$ '];
for i=1:length(k2v)
line{2}=strcat(line{2},['& $',num2str(k2v(i),3),'$']);
end
tex_table(fid,'��������� �������� $k_1,k_2$',key4,line);

f(fid,['�� ������� �����, ��� ��� ���������� ������� �������� ����� ��������� ������������ ���, ����� ��������� �������������� �������,',...
    '������ ����������� �������� ��� ����������. ��� ��� $k_1=',num2str(k1v(index_min_S),2),'$ ����� ������������� ����������� ������������� � ���������� �������� ',...
    '$',num2str(Settlingtime,2),'$ ���, ',...
    '���� � ���� ��������� ������� �����, ��� ����� �������������, ���������� c ���������������� ����������� � ������ \ref{title:PR}.'... 
 ' ��� ������� ����.\ref{tab:k1k2PDcalc} � ���.\ref{fig:PD_sys},',...
 '�����, ��� � ������ ��������� ��� $k_{2\text{�.�.}}(k_1)$ ,�.�. � ������ $k_2$, ��������������� �����������.',...
 ' ����� ������� $k_1$ --- ����������� �����������������',...
 '�����, ������ �� �������� ���������� �������� ��������, � $k_2$ --- ����������� ����������������� �����, ������ �� ��������������� �������.']);
% '�������� ��������� ���',...
%'$k_{2\text{�.�.}}(100)\cdot10$ ������� ������, ��� ��� $k_{2\text{�.�.}}(100)\cdot15$.
past_figures(fid,FIGS,1);%������� ����� ������
%% ��������� ����� (������ \frac �� \cfraq ) (������ ��� ����� ��������)
fclose all; % ���������� ��� ��������� ����� , �������� � �.�.
replaceinfile('frac', 'cfrac',file_path,'-nobak');

k1=k1v(index_min_S);
k2=k2v(index_min_S);
%% ������� worcspace �� ������
% clc;
% clear ;
% close all;
end