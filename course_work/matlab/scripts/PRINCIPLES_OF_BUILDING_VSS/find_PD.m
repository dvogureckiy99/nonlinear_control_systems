 function [k,kor] =  find_PD(InitialConditions,PATH,section_name,file_name)
disp(['��������� ',file_name]);
%% ������� ������������ ��� ������� � ������� ���������� ���� "�����" .
file_path=[PATH.Texcomponents,section_name,'\',file_name,'.tex']; % ���� � ����� subsection
file_path = join(file_path);
fid = fopen(file_path,'w','l','UTF-8');
fprintf(fid,'%s\r','\subsection{������� ������������ ��� ������� � ������� ����������� ���� <<�����>>}');
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
D1=collect(D,p)

FIGS = sim_sist_linear_2_por(InitialConditions,PATH); %���������� ������� �����
f(fid,['����� �� ������� �������������� ���������������  ��� �������� ����� �������� ������������. '...
        ]);
f(fid,['������� ��������� ����������� �������� ������������ �������� �������� �� ������� ��������� ',...
    '������� �������. ��� ������� ������� ���������, ����������� ��������� �������� � ����� ',...
    '������������� ����������� ������� ��� ����� ����������� �������� ��� �������, ��� � �������� ������������ ���������� ����������� ��������������� - ���������������� ��������� .']);
f(fid,['�� ���� ����� ������ �� � ����� �� ',figref('sim_PD'),' ��������� �������������� �� ������ �������������� ����� � ��������� ���������� �������',...
    ' ,� ����� � ��� ����� �������������� �������� ����� �� ',figref(FIGS.names{1}),'.']); 
past_figures(fid,FIGS,1);%������� ����� ������
key1='sist_2_por1';
l(fid);
f(fid,['�� ���� �� �������� ���������',eqref(key1),'.']);
line1{1} = ['x&=X_{zad}-X & X&=\frac{',num2str(K),'\,z(u)}{Q(p)}'];
line1{2} = ['Q(p)&=\left(',num2str(T^2),'\,p^2+',num2str(2*h*T),'\,p+1\right)&Q(p)\,x&=Q(p)\,X_{zad}-',...
    num2str(K),'u'];
tex_aligned(fid,key1,line1);
key2='sist_2_por2';
fprintf(fid,'%s\r','��������� ����������� �������� �������, �.�. ������� $X_{zad}=0$.',...
    ' ����, ��� �� ����� ���������������-���������������� ���������, �.�. $u\hm{=}k_1\,x\hm{+}k_2\,\frac{d\,x}{d\,t}$, �������� ���������',eqref(key2),'.');
tex_eq(fid,key2,['Q(p)\,x=-', num2str(K),'\,(k_1\,x+k_2\,\frac{d\,x}{d\,t})']);
key3='sist_2_por3';
fprintf(fid,'%s\r',['����� �������� ������� $Q(p)$ � ������� ��������� \eqref{eq:',key3,'}.']);
line=['\left(',num2str(T^2),'\,p^2+',num2str(2*h*T),'\,p+1\right)\,x=-',num2str(K),'\,\left(k_1\,+k_2\,p\right)\,x'];                
tex_eq(fid,key3,line);
f(fid,['������ �� ��������� ������� ',eqref('HP_2_por'),'.']);
%tex_eq(fid,'HP_2_por',['D(p)=',num2str(T^2),'\,p^2+\left(',num2str(2*h*T),'+',num2str(K),'\,k_2\right)\,p+\,\left(1+',num2str(K),'\,k_1\right)']);
tex_eq(fid,'HP_2_por',['D(p)=',latex(D1)]);
f(fid,['����� ����������� �� ',eqref('HP_2_por_upr'),'.']);
%tex_eq(fid,'HP_2_por_upr',['D(p)=\,p^2+\left(',num2str(2*h/T,3),'+',num2str(K/(T^2),3),'\,k_2\right)\,p+\,\left(',num2str(1/(T^2),3),'+',num2str(K/T^2,3),'\,k_1\right)']);
D=D/(T^2);
tex_eq(fid,'HP_2_por_upr',['D(p)=',latex(collect(D,p))]);
 roots=solve(D,p); % ��� ������� 
 
 %% ����������� ������
 l(fid);
 fprintf(fid,'%s\r','����� ����� ������������������� ��������:');
 fprintf(fid,'%s\r','\begin{equation}p_1=');
 fprintf(fid,'%s\r',latex(roots(1)));
 fprintf(fid,'%s\r','\end{equation}');
 fprintf(fid,'%s\r','\begin{equation}p_2=');
 fprintf(fid,'%s\r',latex(roots(2)));
 fprintf(fid,'%s\r','\end{equation}');
 %% ������ ������������� ��� ����������� � ��������� ����������
param{1}='k1';
param{2}='k2';
fun = sym_to_matlabFunction(param,(roots(1)+roots(2))^2)
x0=[1 1];
options = optimset('PlotFcns',@optimplotfval);
koef = fminunc(fun,x0,options) 
roots1=subs( roots,k1,koef(1));
roots1=subs( roots1,k2,koef(2));
roots1(1)=double(roots1(1));
roots1(2)=double(roots1(2));
if imag(roots1(1))==0 || imag(roots1(2))==0
    Mkoef(1,1)=koef(1);
    Mkoef(2,1)=koef(2);
    Mroots(1,1)=roots1(1);
    Mroots(2,1)=roots1(2);
end
iter=2;
MAX=100;
STEP=10;
Mkoef=[];
Mroots=[];
while 1%imag(roots1(1))~=0 || imag(roots1(2))~=0
    if x0(1)<MAX && x0(1)>=1
        r=rand*STEP;
        x0(1)=x0(1)+r;
        x0(2)=x0(2)-r;
    elseif x0(1)<=-MAX
        break
    elseif x0(1)>=MAX
        x0=[1 1];
        x0(1)=x0(1)-r;
        x0(2)=x0(2)+r;
    elseif x0(1)>-MAX && x0(1)<=1
        x0(1)=x0(1)-r;
        x0(2)=x0(2)+r;
    end
    koef = fminunc(fun,x0)%,options)

    roots1=subs( roots,k1,koef(1));
    roots1=subs( roots1,k2,koef(2));
    roots1(1)=double(roots1(1));
    roots1(2)=double(roots1(2));
    if imag(roots1(1))==0 || imag(roots1(2))==0
        Mkoef(1,iter)=koef(1);
        Mkoef(2,iter)=koef(2);
        Mroots(1,iter)=roots1(1);
        Mroots(2,iter)=roots1(2);
    end
    disp(double(roots1(1)));
    disp(double(roots1(2)));
    imr1=imag(roots1(1))
    imr2=imag(roots1(2))
    iter=iter+1
    x0
end
assignin('base','Mroots',Mroots)
assignin('base','Mkoef',Mkoef)
num=find((Mroots(1,:)+1).^2==min((Mroots(1,:)+1).^2));
disp("����� ������� � ����� 1");
disp(num);
disp(Mroots(1,num));
disp(Mroots(2,num));
disp("coef:")
koef(1)=Mkoef(1,num);
koef(2)=Mkoef(2,num);
disp(Mkoef(1,num));
disp(Mkoef(2,num));
disp("����� ������� � ����� 2");
num=find((Mroots(2,:)-1).^2==min((Mroots(2,:)-1).^2));
disp(num);
disp(Mroots(1,num));
disp(Mroots(2,num));
disp("coef:")
disp(Mkoef(1,num));
disp(Mkoef(2,num));
%% ������
%  koef(1)=-83.430;
%  koef(2)=-117;
%%
k2value=koef(2); %----------------------------------------------------------------------------change
fprintf(fid,'%s','����� $k_2=');
fprintf(fid,'%.2f$\r',k2value);
 
% Cellk2=solve( [roots(2) > 0,roots(1) < 0] ,k1,'ReturnConditions', true);
% assignin('base','Cellk1',Cellk2);
% Cellk2=solve( [roots(2) > 0,roots(1) < 0] ,k2,'ReturnConditions', true);
% assignin('base','Cellk2',Cellk2); 
roots=subs( roots,k2,k2value);
 %% ����������� ������
 fprintf(fid,'%s\r','. ����� ������������������� ��������:');
 fprintf(fid,'%s\r','\begin{equation}p_1=');
 fprintf(fid,'%s\r',latex(vpa(expand(roots(1)),3)));
 fprintf(fid,'%s\r','\end{equation}');
 fprintf(fid,'%s\r','\begin{equation}p_2=');
 fprintf(fid,'%s\r',latex(vpa(expand(roots(2)),3)));
 fprintf(fid,'%s\r','\end{equation}');
 %assignin('base','roots',roots);
 %
  %% ����������� ������� 1
 Cellk1{1}=solve( roots(1) < 0 ,k1,'ReturnConditions', true);
 disp('for roots(1)<0 k1=');
 disp(vpa(Cellk1{1}.conditions,3));

 fprintf(fid,'%s\r','����� $k_1=k_1^x  $ --- ������� �����������.');
 
 fprintf(fid,'\r%s\r','�������, ��� ������� $p_1<0$ :');
 fprintf(fid,'%s\r','\begin{equation}');
 fprintf(fid,'k_1^%s\r',latex(vpa(Cellk1{1}.conditions,3)));
 fprintf(fid,'%s\r','\end{equation}');
   %% ����������� ������� 2
 Cellk1{2}=solve( roots(2) > 0 ,k1,'ReturnConditions', true);
 disp('for roots(2)>0 k1=');
 disp(vpa(Cellk1{2}.conditions,3));
  
 fprintf(fid,'%s\r','�������, ��� ������� $p_2>0$ :');
 fprintf(fid,'%s\r','\begin{equation}');
 fprintf(fid,'k_1^%s\r',latex(vpa(Cellk1{2}.conditions,3)));
 fprintf(fid,'%s\r','\end{equation}');

 k1value = koef(1);
%  k1value = double(solve((roots(1)+1),k1));
%  k1ziro1=solve(roots(1),k1); % ��������, ��� ������� ����� ��������� � ����
%  k1ziro2=solve(roots(2),k1); % ��������, ��� ������� ����� ��������� � ����
%  k1value=-39.31; 

 %% ����������� �����. ��
 fprintf(fid,'\r%s\r\r','����������� ������������� �� ����������:');
 fprintf(fid,'%s','$k_1=');
 fprintf(fid,'%.4f$\r',k1value);
 fprintf(fid,'%s','$k_2=');
 fprintf(fid,'%.4f$\r',k2value);
 disp('k1=');
 disp(k1value);
 disp('k2=');
 disp(k2value);
 
roots=subs( roots,k1,k1value);
%% ����������� ������
disp('roots(1):');
disp(double(roots(1)));
disp('roots(2):');
disp(double(roots(2)));
fprintf(fid,'\r%s\r\r','����� ������������������� ��������:');
fprintf(fid,'%s','$p_1=');
fprintf(fid,'%.4f$\r',double(roots(1)));
fprintf(fid,'%s','$p_2=');
fprintf(fid,'%.4f$\r',double(roots(2)));

%% ������ S
fprintf(fid,'\r%s\r','���� ��������� ������� ��� ��������� ������������ ������� ������� ���, ��� ����������� ');
fprintf(fid,'%s\r','��� ���������� �� ��������, ��������������� �������������� ����� $p_2$ ����� ����� ����, �� ');
fprintf(fid,'%s\r','������� ��������� $x_2=p_1 \, x_1$ ��� ��������� ������ � ����� ���� \eqref{eq:straight_S1_sym}');
fprintf(fid,'%s\r',',� ��� ������� ������� \eqref{eq:straight_S1}.');
fprintf(fid,'%s\r','\begin{align}');
      fprintf(fid,'%s\r','S&=x_2-p_1\,x_1=0 \label{eq:straight_S1_sym} \\');
       fprintf(fid,'%s\r','S&=x_2+');
       if (abs(double(roots(1)))==1)
           fprintf(fid,'%s=0\r','x_1');
       else
     fprintf(fid,'%.2fx_1=0\r',double(abs(roots(1))));
       end
     fprintf(fid,'%s\r','\label{eq:straight_S1}  ');
 fprintf(fid,'%s\r','\end{align}');

k(1)=k1value;
k(2)=k2value;
kor(1)=double(roots(1));
kor(2)=double(roots(2));
FIGS = sim_sedlo(PATH,InitialConditions,k,kor);%-------------------------------------------------------------------sim sedlo
l(fid);
f(fid,['������ � Matlab Simulink �� ',figref('sim_linear_2_por'),'. ']);
f(fid,['��������� �������� ������� ��������� �� ������� ����������� ',...
'������������� ��������� � ������� ��� ���������� ������� �� ���������',...
' ����������. ������� ���������� � ������� �� ',figref(FIGS.names{1}),'. ']);
f(fid,['� ���������� �� ',figref(FIGS.names{2}),' ������� ��������� �������� ���������� � � �����������. ']);
past_figures(fid,FIGS,1);
l(fid);
f(fid,['����� ������� �������� �� �����������, ������������� �������������� ���������� ��������, �� ���� ������',...
     ' $S$, ����� �����������, ��� ��� ����� ������ ����� ���������� ����� ��������� ����� �� ���������� ���������� $S$. ',....
     '��� ������ $S$ � �������� ������������� ���������� ������� ���������� ��� ������������ ������� ������� �������. ']);

fclose(fid);

%% ��������� ����� (������ \frac �� \cfraq ) (������ ��� ����� ��������)
fclose all; % ���������� ��� ��������� ����� , �������� � �.�.
replaceinfile('frac', 'cfrac',file_path,'-nobak');

%% ������� worcspace �� ������
% clc;
% clear;
% close all;
end



