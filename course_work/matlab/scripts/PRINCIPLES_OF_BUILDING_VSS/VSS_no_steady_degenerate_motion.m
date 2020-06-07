function VSS_no_steady_degenerate_motion(InitialConditions,PATH,path_subsection,name_subsection,k,p)
%%
disp(['��������� --- subsection_name:"',name_subsection,'"']);
%% ������� ������������ ��� ������� � ������� ���������� ���� "�����" .
%% �������� ������
file_path=[path_subsection ,name_subsection,'.tex'];
file_path = join(file_path);
fid = fopen(file_path,'w','l','UTF-8');
f(fid,'\clearpage');
fprintf(fid,'%s\r','\subsection{������� � ���������� ���������� ��� ����������� ������������ ��������} \label{title:VSS_no_SDM}');    
%% ��������� �������-------------------------------------------------------------------------change
T=InitialConditions.T;
K=InitialConditions.K;
h=InitialConditions.h;
d=InitialConditions.d;
syms p x k1 k2 ;
%% ����� �� 
u=(k1+k2*p) 
disp('        (T^2*p^2+2*h*T*p+1)*x+K*u ');
D=(T^2*p^2+2*h*T*p+1)+K*u 
disp('           D/(x*T^2)');
D=D/(T^2);
D=collect(D,p)
%%
f(fid,['������ ������ ���������� ������� � ���������� ���������� ������������� ������������ � ������, ���� ������� ',...
    '������������  ��� ������ �� ������������� �������� �� �������� ��������������� � ���������� ����������� ���������. ',...
    '�� ���� <<��������>> � ������������ ������������������ �������� �� ������������ ���������� ������� �������� ���������� ',...
    '�������� ��� ����� ��������� �������.']);
l(fid);
f(fid,['� �������� ������� ���������� ������, ����� � ����� ������������ ������� ��� ��������',...
    ' ��������� � ������������� �����������, �� ����,  ����������� �� ������� ������������. ��������� �������� � ���� �������� ���� � �� ��:']);
key1='HP_centr';
tex_eq(fid,key1,'\frac{d^2\,x}{d\,t^2}+\omega_0^2\,x=0');
f(fid,'��� ������ ���������   ������� ���������� ������  ����� ����� ��� �������� � ������� ���������. ������������������ ������� ����� ���:');
tex_eq(fid,key1,['D(p)=',latex(D)]);

f(fid,'��� ��������� ������� ���������� ���� ������ ���������� ���������� ���� �������:');
Dp=coeffs(D,p);
k1kr=solve(Dp(1),k1);
k2kr=solve(Dp(2),k2);
line{1}=[latex(Dp(1)),'&>0'];
line{2}=[latex(Dp(2)),'&=0'];
key21='usl_centr1';
tex_aligned(fid,key21,line,'sis');
tex_eq(fid,'',['\Downarrow']);
line{1}=['k_1&>',num2str(double(k1kr),3)];
line{2}=['k_2&=',num2str(double(k2kr),3)];
key22='usl_centr2';
tex_aligned(fid,key22,line,'sis');


mn=[0.5 10];           %----------------------------------------------------------------------------change
 k1value(1)=double(k1kr)-double(k1kr)*mn(1); 
 k1value(2)=double(k1kr)-double(k1kr)*mn(2);
 k2value(1)=double(k2kr);
 k2value(2)=double(k2kr);
D=subs(D,k2,k2value(1));
fprintf(fid,'%s','����� $k_1=');
fprintf(fid,'%.4f$\r',k1value(1));
f(fid,'����� ������������������ ������� ����� ���:');
key3='elips1';
D1=subs(D,k1,k1value(1));
D1=collect(D1,p);
Dp=coeffs(D1,p);
w2(1)=double(Dp(1));
tex_eq(fid,key3,['D(p)=',latex(vpa(D1,4))]);
fprintf(fid,'%s','����� $k_1=');
fprintf(fid,'%.4f$\r',k1value(2));
f(fid,'����� ������������������ ������� ����� ���:');
key4='elips2';
D2=subs(D,k1,k1value(2));
D2=collect(D2,p);
Dp=coeffs(D2,p);
w2(2)=double(Dp(1));
tex_eq(fid,key4,['D(p)=',latex(vpa(D2,4))]);

f(fid,['����� ����� ����� ��� �� ���, ��� � �� ',figref('sim_linear_2_por'),'.']);
FIGS = sim_center(PATH,InitialConditions,k1value,k2value,w2);
f(fid,['��������� �������� ������� ��������� �� ������� ����������� ',...
'������������� ��������� � ������� ��� ���������� ������� �� ���������',...
' ����������. ������� ���������� � ������� �� ',figref(FIGS.names{1}),'. ']);
f(fid,['� ���������� �� ',figref(FIGS.names{2}),' ������� ��������� �������� ���������� � � �����������. ']);
past_figures(fid,FIGS,1);

name_system = 'sim_VSS_no_steady_degenerate_motion';
FIGS = save_system_fig(PATH,name_system,'����������� ����� ������� � ���������� ���������� ��� ����������� ������������ ��������');

l(fid);
f(fid,['������������ � ����� ��������� �� ������ ����� ����������� ��� ����������� ������� ����������� ������������ ����. ������������� ����� ������������ �������� ��������� ��������� �������:   ' ]);
key5='usl_VSS_center';
line{1}=['&k_1=',num2str(k1value(2),3),'&&,k_2=',num2str(k2value(2),3),'&&,\text{ ���� }sign(x_1 \cdot x_2)>0'];
line{2}=['&k_1=',num2str(k1value(1),3),'&&,k_2=',num2str(k2value(1),3),'&&,\text{ ���� }sign(x_1 \cdot x_2)<0'];
tex_aligned(fid,key5,line,'sis');
l(fid);
f(fid,['����������� ����� ������� � ���������� ���������� ��� ����������� ������������ �������� �� ',...
figref(FIGS.names{1}),'.']);
past_figures(fid,FIGS,1);

FIGS = sim_no_steady_degenerate_motion(PATH,InitialConditions,k1value,k2value,name_system);
l(fid);
f(fid,['��������� �������� ������� ��������� �� ������� ����������� ',...
'������������� ��������� � ������� ��� ���������� ������� �� ���������',...
' ����������. ������� ���������� � ������� �� ',figref(FIGS.names{1}),'. ']);
f(fid,['� ���������� �� ',figref(FIGS.names{2}),' ������� ��������� �������� ���������� � � �����������. ']);
past_figures(fid,FIGS,1);

%% ��������� ����� (������ \frac �� \cfraq ) (������ ��� ����� ��������)
fclose all; % ���������� ��� ��������� ����� , �������� � �.�.
replaceinfile('frac', 'cfrac',file_path,'-nobak');

%% ������� worcspace �� ������
% clc;
% clear ;
% close all;

end