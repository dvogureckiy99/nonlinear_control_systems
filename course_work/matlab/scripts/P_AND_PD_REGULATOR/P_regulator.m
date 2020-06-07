function k1=P_regulator(InitialConditions,PATH,path_subsection,name_subsection)
%%
disp(['��������� --- subsection_name:"',name_subsection,'"']);
%% ������� ������������ ��� ������� � ������� ���������� ���� "�����" .
%% �������� ������
file_path=[path_subsection ,name_subsection,'.tex'];
file_path = join(file_path);
fid = fopen(file_path,'w','l','UTF-8');
fprintf(fid,'%s\r','\subsection{������������ ������� � ���������������� �����������}\label{title:PR}');
%% ��������� �������
T=InitialConditions.T;
K=InitialConditions.K;
h=InitialConditions.h;
d=InitialConditions.d; 
%% 1
FIGS = sim_sist(InitialConditions,PATH); %���������� ������� �����
key1='control_sys';
fprintf(fid,'%s\r','�������� �������',...
    '���������������� ��������� � ����������� �����  ��� ��������������� �������� ������� � ���������������� ����������� ',...
    '������������ ���������� $x$.'...
    );
past_figures(fid,FIGS,1);%������� ����� ������
f(fid,['�� �� ��������� ������� �� ',figref(FIGS.names{1}),' �������� ���������',eqref(key1),'.']);
line1{1} = ['x&=X_{zad}-X & X&=\frac{',num2str(K),'\,z(u)}{Q(p)}'];
line1{2} = ['Q(p)&=p\,\left(',num2str(T^2),'\,p^2+',num2str(2*h*T),'\,p+1\right)&Q(p)\,x&=Q(p)\,X_{zad}-',...
    num2str(K),'z(u)'];
tex_aligned(fid,key1,line1);
key2='con_sys1';
fprintf(fid,'%s\r','��������� ����������� �������� �������, �.�. ������� $X_{zad}=0$.',...
    ' ����, ��� �� ����� ���������������� ���������, �.�. $u=k_1\,x$, �������� ���������',eqref(key2),'.');
tex_eq(fid,key2,['Q(p)\,x=-', num2str(K),'\,z(k_1\,x)']);
key3='con_sys2';
fprintf(fid,'%s\r',['����� �������� ������� $z(u)$ � ������� ������� \eqref{eq:',key3,'}.']);
line{1}=['p\,\left(',num2str(T^2),'\,p^2+',num2str(2*h*T),'\,p+1\right)\,x&=-',num2str(K),'\,k_1\,x',...
                    '&&, \text{ ����}|k_1\,x|\le ',num2str(d)];
line{2}=['p\,\left(',num2str(T^2),'\,p^2+',num2str(2*h*T),'\,p+1\right)\,x&=-',num2str(K*d),...
                    '\,\mathrm{sign}\left(k_1\,x\right)',...
                    '&&, \text{ ����}|k_1\,x|> ',num2str(d)];                
tex_aligned(fid,key3,line,'sys');
f(fid,['������ �� ��������� ������� ��� $k_1\,x\le',num2str(d),'$',eqref('key4'),'.']);
tex_eq(fid,'key4',['D(p)=\left(',num2str(T^2),'\,p^3+',num2str(2*h*T),'\,p^2+p+',num2str(K),'\,k_1\right)']);
f(fid,['��� $|k_1\,x|>',num2str(d),'$ �������� �������� ����� ����������� � �������� � ��� ������������ ',...
    '���������� ������������ �������, ��� �������, ��� �� ��� ���� ������� ���������� �� �������� �����������. ',...
    '��� $|k_1\,x|\le',num2str(d),'$ �������� ����������� �������� ���������������� ����������. �������������� ������� ����� ���� �������:']);
line{1}='��������������� �������� �������.';
line{2}=['���������������, ��������� �������� ������� ������ ��� $|k_1\,x|\hm{>}',num2str(d),'$.'];
tex_enumerate(fid,line);
l(fid);
f(fid,'����������� ����������� �������� �� �������� �������:');
l(fid);
f(fid,['$a_0=',num2str(T^2),',a_1=',num2str(2*h*T),',a_2=1,a_3=',num2str(K),'\,k_1$']);
tex_eq(fid,'key5','a_1\.a_2-a_0\,a_3\ge0');
syms k ;
M=2*h*T-T^2*K*k;
k=double(solve(M,k));
tex_eq(fid,'sys_ust',['0\le k_1\le ',num2str(k,3),' \text{ --- ��� ��������������� ������������.}']);
[FIGS,k1] = sim_sys(InitialConditions,PATH,k); %��������� ���������� ���������
f(fid,['$k_1=',num2str(k,3),'$ --- ������� ������������ �������������� ����. ']);
past_figures(fid,FIGS,1);%������� ����� ������
l(fid);
f(fid,['������ �� ������������ ���������� ��� ��������� ��������� $k$ ��� ���������� ������� �� ',figref(FIGS.names{1}),'.',...
    ' ��� ����� ��� ����������� �������� $k_1$ ���������� ������������ ���������. ',...
    '��� ���������� $k$ �������� ���������� ��������������� ���������� ������.'...
    '']);
l(fid);
f(fid,'��� ��������� �������������� ����� ��������� ����������� ��������, �� ��� ���� � �������������� �������.');
%% ��������� ����� (������ \frac �� \cfraq ) (������ ��� ����� ��������)
fclose all; % ���������� ��� ��������� ����� , �������� � �.�.
replaceinfile('frac', 'cfrac',file_path,'-nobak');

%% ������� worcspace �� ������
% clc;
% clear ;
% close all;
end