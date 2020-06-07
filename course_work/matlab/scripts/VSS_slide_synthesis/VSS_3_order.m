function VSS_3_order(InitialConditions,PATH,path_subsection,name_subsection,section_name)
%%
disp(['��������� --- subsection_name:"',name_subsection,'"']);
%% ������� ������������ ��� ������� � ������� ���������� ���� "�����" .
%% �������� ������
file_path=[path_subsection ,name_subsection,'.tex'];
file_path = join(file_path);
fid = fopen(file_path,'w','l','UTF-8');
fprintf(fid,'%s\r','\subsection{������ ������������ ���������� ��� �������� ������� ��� ����� ������������}');
%% ��������� �������-------------------------------------------------------------------------change
T=InitialConditions.T;
K=InitialConditions.K;
h=InitialConditions.h;
d=InitialConditions.d;
syms p Psi;


%% ����� �� 
u=Psi ;
D=(T^2*p^3+2*h*T*p^2+p)+K*u ;
D=collect(D,p);
D=D/(T^2);
D=collect(D,p);
Dp=coeffs(D,p);


 a=double([0 Dp(2) Dp(3)]);
 b=double(Dp(1)/Psi);
 e=[-1 2*a(3) -(a(3)^2+a(2)) a(2)*a(3) ]/b ;
 
key='con_sys_VSS';
f(fid,['�������� ������ ��� ���  ������������ ������� �������� ������� � ����������������� �����������, ������������ ������� ',eqref(key),'.']);
line{1}=['p\,\left(',num2str(T^2),'\,p^2+',num2str(2*h*T),'\,p+1\right)\,x&=-',num2str(K),'\,u',...
                    '&&, \text{ ����}|u|\le ',num2str(d)];
line{2}=['p\,\left(',num2str(T^2),'\,p^2+',num2str(2*h*T),'\,p+1\right)\,x&=-',num2str(K*d),...
                    '\,\mathrm{sign}\left(u\right)',...
                    '&&, \text{ ����}|u|> ',num2str(d)];                
tex_aligned(fid,key,line,'sys');

l(fid);
f(fid,['���� �����������, ���, ������� ������ ����� ��������� ���������, ��� ���� � ���� ��������� ������� ��� ����������� ������������� ���������� ��� ��������� ������ ���� ����������. �� ������ ����� �������������� ��������������� �� ����� ��������� �������� ������� ����������� � ����������� ���� ���������, � ����������� �������, �������������� ������������ ���������� � ��������� ��������, �������� ������� �������� ��������� ���������� - ���������� �� ������-���� ������������ ���������. ��������� ������������ � ������� ����� ������� ��������, �������� ����������� ��������, ��������������. ���������� �������� ���� ����������� ������� � �������� ������� �������.']);


f(fid,['������ �������������� �������� ������� � ���� ���������� ��������� ��� $u\le',num2str(d),'$',eqref('ss_object_VSS'),'.']);
fprintf(fid,'%s\r',['\begin{equation}\label{eq:','ss_object_VSS','}',...
                    '    \left\{',...
                    '    \begin{aligned}',...
                    'x_1&=x , \\ \frac{d\,x_1}{d\,t}&=x_2 ,\\ \frac{d\,x_2}{d\,t}&=x_3,\\',...
                    '\frac{d\,x_3}{d\,t}&=-',...
                    ]);
fprintf(fid,'%.4f\r',1/T^2);
fprintf(fid,'%s\r',['\,x_2-']);
fprintf(fid,'%.4f\r',2*h/T);
fprintf(fid,'%s\r',['\,x_3-']);
fprintf(fid,'%.4f\r',K/T^2);
fprintf(fid,'%s\r',['\,',...
                    'u',...
                    '    \end{aligned}',...     
                    '    \right.',...
                    '\end{equation}']);  
                
                l(fid);
f(fid,'     ���������� ����������� �������������� ������� ������ ������� ��� ���������� ��������� ��� �� ���������� ���������, � ������, ����������� ��� � ����������� ����:');                
tex_eq(fid,'','u=\psi\,x_1');
fprintf(fid,'%s\r',['\begin{equation}\label{eq:','','}']);
               f(fid,     '\psi=');
              f(fid,      '    \left\{');
          f(fid,          '    \begin{aligned}');
f(fid,['&\alpha &&,\text{ ���� } x_1\,S>0 \\']);
fprintf(fid,'%s\r',['&\beta &&,\text{ ���� } x_1\,S<0 \\']);     
          f(fid,          '    \end{aligned}');    
              f(fid,      '    \right.');
            f(fid,        '\end{equation}');  
            l(fid);
f(fid,'��� $\alpha,\beta$ --- ���������� ������������. ');
f(fid,' $S=x_3+c_2\,x_2+c_1\,x_1$ --- ���������, �������� ��������� ��������������, ������� �������� ��� �������� ���� ������������ �������� ������� ������������ ����������� $u$.');
f(fid,'	��� ��� ���������� ��������� ������� ����������, � ���������� ������� ���������� ���������� ��������� ���, � ������, �������� $\beta,\alpha,c_1,c_2$, �������������� ��������� ���������� �������� ��������������� �������. ');

f(fid,['������ ����������� �� ��������� ������� :']);
tex_eq(fid,'',['D(p)=\,p^3+',num2str(2*h/T,4),'\,p^2+',num2str(1/T^2,4),'\,p+',num2str(K/T^2,4),'\,\psi']);
tex_eq(fid,'',['a_3=',num2str(a(3),4),',a_2=',num2str(a(2),4),',a_1=',num2str(a(1),4),',b=',num2str(b,4)]);

l(fid);
f(fid,'���� ������ ����������� 3 �������:');
fprintf(fid,'%s\r','\begin{enumerate}');
    fprintf(fid,'%s\r','\item ');
    fprintf(fid,'%s\r',['������� �������������  ����������� ������ ��� ������� 3-��� �������  ����� ���:']);
    line{1}='b\,\alpha&>c_1\,(a_3-c_2)';
    line{2}='b\,\beta&<c_1\,(a_3-c_2)';
    line{3}='\frac{c_1-a_2}{c_2}&=c_2-a_3';
    tex_aligned(fid,'',line);
    f(fid,'��� ������������� �����:');
    line{1}='&\alpha>f(c_2)>\beta';
    line{2}='&\text{��� } f(c_2)=e_1\,c_2^3+e_2\,c_2^2+e_3\,c_2+e_4';
    line{3}='&e_1=-\frac{1}{b}, e_2=\frac{2\,a_3}{b}, e_3=\frac{-(a_3^2+a_2)}{b}, e_4=\frac{a_2\,a_3}{b}';
    line{4}=['&e_1=',num2str(e(1),3),', e_2=',num2str(e(2),3),', e_3=',num2str(e(3),3),', e_4=',num2str(e(4),3)];
    tex_aligned(fid,'',line);
    fprintf(fid,'%s\r','\item ');
    key1='HP_VSS';
    key2='VSS_steady';
    fprintf(fid,'%s\r',['������� ����������� ������������ �������� � ���������� ������: �� ������� ',eqref(key1),' ������ ����� �� ����� 1-��� ����� � ������������� ������������ ������. ������������ ����� ��� ',eqref(key2),'.']);
    clear line;
    line{1}=['D(p)&=\,p^3+a_3\,p^2+a_2\,p+b\,\psi='];
    line{2}=['&=\,p^3+',num2str(2*h/T,4),'\,p^2+',num2str(1/T^2,4),'\,p+',num2str(K/T^2,4),'\,\psi'];
    line{3}=['\psi&=\frac{-c_1(c_2-a_3)}{b}'];
    tex_aligned(fid,key1,line);
    tex_eq(fid,key2,'Re(p_i)>0 \text{ ������ ��� ������ } i\in(1,2,3)');
    f(fid,'\item');
    key3='HP1_VSS';
    key4='VSS_hit_the_plane';
    fprintf(fid,'%s\r',['������� ��� ��������� ������������ ����� �� ��������� ���������� --- � �� ',eqref(key3),' ��������������� �������������� ����� �����������, �.�. ����������� ���������� � ������������� ��������. ������������ ����� ��� ',eqref(key4),'.']);
    tex_eq(fid,key3,['D(p)=\,p^3+',num2str(2*h/T,4),'\,p^2+',num2str(1/T^2,4),'\,p+',num2str(K/T^2,4),'\,\alpha']);
    tex_eq(fid,key4,'\forall i=\overline{1,3}:\left(p_i=Re(p_i)\text{ � }Re(p_i)\ge0\right) \text{ --- �� �����������.}');
fprintf(fid,'%s\r','\end{enumerate}');
% l(fid);
% f(fid,['']);
% f(fid,['']);
% f(fid,['']);

l(fid);
f(fid,'�������� ������� ��������� � m-file matlab:') ;
fprintf(fid,'%s\r',['\input{components/',section_name,'/hole_Parameter_Calculation_Algorithm','}']);


fprintf(fid,'\r\r%s',['� ���������� ������� ����� ���������� �������� � ���������� ������ � ���������� ������������ ����� �� ��������� ����������.']);
f(fid,'�������� �������� ��������� ��� � ������� ����������� �������:');
count=4; %--------------------------------------------------------------------------------------------���������� �������� 8 max
mn{1}=[2,2];%----------------------------------------------------change ��������� � alpha �  betta �����.
mn{2}=[2,0.5];
mn{3}=[4,0.1]; 
mn{4}=[4,2];
for j=1:count       
        [C1, C2, alpha, betta, iter ,time ] = choose_coeff(InitialConditions,mn{1}) ;
        param{j}= [C1, C2, alpha, betta, iter ,time ];
        l(fid);
        f(fid,['������ �����:',num2str(j)])
        %fprintf('\r%s\r', '     C1           C2           alpha             betta'); 
        l(fid);
        l(fid);
        f(fid,['  �������� $= ',num2str(iter-1),' [ C_1=',num2str(C1,3),' ; C_2=',num2str(C2,3),' ; \alpha=',num2str(alpha,3),' ; \beta=',num2str(betta,3),' ]$']);
        fprintf(fid,'\r  ����� �� ���������� ��������� $%.0f$ ���.',time);
        fprintf(fid,'\r');
end        
 name_system=     'sim_VSS_P';
 FIGS = save_system_fig(PATH,name_system,'����������� ����� ��� 3 ������� �� ���������� �������.');

l(fid);
f(fid,['������ � Matlab Simulink �� ',figref(FIGS.names{1}),'. ']);
past_figures(fid,FIGS,1);

[FIGS,Settlingtime] = sim_VSS_PR(PATH,InitialConditions,name_system,param);
f(fid,['��������� �������� ������� ��������� �� ������� ����������� ',...
'������������� ��������� � ������� ��� ���������� ������� �� ���������',...
' ����������. ������� ���������� � ������� �� ',figref(FIGS.names{1}),'. ']);
f(fid,['� ���������� �� ',figref(FIGS.names{2}),' ������� ��������� �������� ���������� � � �����������, � �� ',figref(FIGS.names{3}),' ������� ��������� ������� ��������� ��� ���� ���������� ���������. ']);
key5='tab_VSS_3';
f(fid,['� ',tabref(key5),' ��������� ����� ������������� ��� ������ ��������� ����������']);
title='��������� �����������';
line{1}=['$C_1$ & $C_2$ & $\alpha$ & $\beta$ & $t_p$'];
for j=1:length(param)
    line{j+1}=' $';
    for i=1:4
    line{j+1}=strcat(line{j+1},[num2str(param{j}(i),3),'$ & $']);
    end
    line{j+1}=strcat(line{j+1},[num2str(Settlingtime(j),3),'$ ']);
end

tex_table(fid,title,key5,line);
past_figures(fid,FIGS,1);
l(fid);
f(fid,['���������� �������������� ��������� �������� ������������ ���������� ��� � ������� �������� �������. �� ���������� ������������� ��� �������, ��� ���������� ������� ����� �������������� ��������, ��� ���� ����� ����������� �������� ������, ��� � �������� �������. ������� ��������� ���, ����� ������ �� ������������ ���������� �������. ������ ��� ����� ��������� ���������� ���������� ������� ��������� ����������, �������������� ��������� ������������ � ��������� ��������� ������������ ����� �� ��������� ����������.']);
f(fid,'��� ������ $\alpha$, ��� ������� ������������� ���������� �������,');

l(fid);
[Val,best]=min(Settlingtime);
[FIGS,marg]=bode_plot(PATH,InitialConditions,param{best});
f(fid,['��������� ����� ������������ ������� <<� �����>> �� ��������� � ����, �������� ��������������� ��������� �������������� ��� ����������� ������� � $\alpha=',num2str(param{best}(3),3),'$ �� ',figref(FIGS.names{1}),' � $\beta=',num2str(param{best}(4),3),'$ �� ',figref(FIGS.names{2}),'. ']);

tex_eq(fid,'',['W=\frac{',num2str(K),'\,\psi}{p\,\left(',num2str(T^2),'\,p^2+',num2str(2*h*T),'\,p+1\right)}']);

past_figures(fid,FIGS,1);
clear line;
f(fid,'����� �������, � ���������� ������� ��� �� ���������� ������� ��� ����� ����������� �������� �� �������� �������, ���������� ����������������, ���������������� ������������ �������, � ������:'); 
line{1}=['��� $\alpha$ ����� ������������ <<� �����>> �� ��������� $',num2str(marg{1}(1),3),'<$ 20 ��, �� ���� $',num2str(marg{1}(2),3),'< 60�$, $\omega_{cp}=',num2str(marg{1}(3),3),'$. '];
line{2}=['��� $\beta$ ����� ������������ <<� �����>> �� ��������� $',num2str(marg{2}(1),3),'\ge$ 20 ��, �� ���� $',num2str(marg{2}(2),3),'\ge 60�$, $\omega_{cp}=',num2str(marg{2}(3),3),'$. '];
tex_enumerate(fid,line);


%% ��������� ����� (������ \frac �� \cfraq ) (������ ��� ����� ��������)
fclose all; % ���������� ��� ��������� ����� , �������� � �.�.
replaceinfile('frac', 'cfrac',file_path,'-nobak');

%% ������� worcspace �� ������
% clc;
% clear;
% close all;
end



