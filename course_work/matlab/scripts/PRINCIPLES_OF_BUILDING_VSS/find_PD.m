 function [k,kor] =  find_PD(InitialConditions,PATH,section_name,file_name)
disp(['Обработка ',file_name]);
%% находит коэффициенты для системы с фазовой траекторие типа "седло" .
file_path=[PATH.Texcomponents,section_name,'\',file_name,'.tex']; % путь к файлу subsection
file_path = join(file_path);
fid = fopen(file_path,'w','l','UTF-8');
fprintf(fid,'%s\r','\subsection{Находим коэффициенты для системы с фазовой траекторией типа <<седло>>}');
%% начальные условия-------------------------------------------------------------------------change
T=InitialConditions.T;
K=InitialConditions.K;
h=InitialConditions.h;
d=InitialConditions.d;
syms p x k1 k2 ;

%% вывод ХП 
u=(k1+k2*p) 
disp('        (T^2*p^2+2*h*T*p+1)*x+K*u ');
D=(T^2*p^2+2*h*T*p+1)+K*u 
disp('           D/(x*T^2)');
D1=collect(D,p)

FIGS = sim_sist_linear_2_por(InitialConditions,PATH); %сохранение рисунка схемы
f(fid,['Одним из методов аналитического конструирования  СПС является метод фазового пространства. '...
        ]);
f(fid,['Поясним некоторые особенности фазового пространства линейных структур на примере уравнений ',...
    'второго порядка. Для анализа возьмем уравнения, описывающие изменение скорости в ранее ',...
    'рассмотренном управляемом объекте без учёта нелинейного элемента при условии, что в качестве управляющего устройства применяется пропорционально - дифференциальный регулятор .']);
f(fid,['То есть грубо говоря мы в схему на ',figref('sim_PD'),' вставляем дифференциатор на выходе колебательного звена и исключаем нелинейный элемент',...
    ' ,в связи с чем после преобразований получаем схему на ',figref(FIGS.names{1}),'.']); 
past_figures(fid,FIGS,1);%вставка одной фигуры
key1='sist_2_por1';
l(fid);
f(fid,['По этой СС составим уравнения',eqref(key1),'.']);
line1{1} = ['x&=X_{zad}-X & X&=\frac{',num2str(K),'\,z(u)}{Q(p)}'];
line1{2} = ['Q(p)&=\left(',num2str(T^2),'\,p^2+',num2str(2*h*T),'\,p+1\right)&Q(p)\,x&=Q(p)\,X_{zad}-',...
    num2str(K),'u'];
tex_aligned(fid,key1,line1);
key2='sist_2_por2';
fprintf(fid,'%s\r','Исследуем собственные свойства системы, т.е. считаем $X_{zad}=0$.',...
    ' Учтём, что мы имеем пропорционально-дифференциальный регулятор, т.е. $u\hm{=}k_1\,x\hm{+}k_2\,\frac{d\,x}{d\,t}$, получаем уравнение',eqref(key2),'.');
tex_eq(fid,key2,['Q(p)\,x=-', num2str(K),'\,(k_1\,x+k_2\,\frac{d\,x}{d\,t})']);
key3='sist_2_por3';
fprintf(fid,'%s\r',['Далее раскроем полином $Q(p)$ и получим уравнение \eqref{eq:',key3,'}.']);
line=['\left(',num2str(T^2),'\,p^2+',num2str(2*h*T),'\,p+1\right)\,x=-',num2str(K),'\,\left(k_1\,+k_2\,p\right)\,x'];                
tex_eq(fid,key3,line);
f(fid,['Отсюда ХП замкнутой системы ',eqref('HP_2_por'),'.']);
%tex_eq(fid,'HP_2_por',['D(p)=',num2str(T^2),'\,p^2+\left(',num2str(2*h*T),'+',num2str(K),'\,k_2\right)\,p+\,\left(1+',num2str(K),'\,k_1\right)']);
tex_eq(fid,'HP_2_por',['D(p)=',latex(D1)]);
f(fid,['Найдём приведенный ХП ',eqref('HP_2_por_upr'),'.']);
%tex_eq(fid,'HP_2_por_upr',['D(p)=\,p^2+\left(',num2str(2*h/T,3),'+',num2str(K/(T^2),3),'\,k_2\right)\,p+\,\left(',num2str(1/(T^2),3),'+',num2str(K/T^2,3),'\,k_1\right)']);
D=D/(T^2);
tex_eq(fid,'HP_2_por_upr',['D(p)=',latex(collect(D,p))]);
 roots=solve(D,p); % два решения 
 
 %% отображение корней
 l(fid);
 fprintf(fid,'%s\r','Найдём корни характеристического полинома:');
 fprintf(fid,'%s\r','\begin{equation}p_1=');
 fprintf(fid,'%s\r',latex(roots(1)));
 fprintf(fid,'%s\r','\end{equation}');
 fprintf(fid,'%s\r','\begin{equation}p_2=');
 fprintf(fid,'%s\r',latex(roots(2)));
 fprintf(fid,'%s\r','\end{equation}');
 %% расчет коэффициентов для приближения к требуемой траектории
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
disp("самый близкий к корню 1");
disp(num);
disp(Mroots(1,num));
disp(Mroots(2,num));
disp("coef:")
koef(1)=Mkoef(1,num);
koef(2)=Mkoef(2,num);
disp(Mkoef(1,num));
disp(Mkoef(2,num));
disp("самый близкий к корню 2");
num=find((Mroots(2,:)-1).^2==min((Mroots(2,:)-1).^2));
disp(num);
disp(Mroots(1,num));
disp(Mroots(2,num));
disp("coef:")
disp(Mkoef(1,num));
disp(Mkoef(2,num));
%% убрать
%  koef(1)=-83.430;
%  koef(2)=-117;
%%
k2value=koef(2); %----------------------------------------------------------------------------change
fprintf(fid,'%s','Пусть $k_2=');
fprintf(fid,'%.2f$\r',k2value);
 
% Cellk2=solve( [roots(2) > 0,roots(1) < 0] ,k1,'ReturnConditions', true);
% assignin('base','Cellk1',Cellk2);
% Cellk2=solve( [roots(2) > 0,roots(1) < 0] ,k2,'ReturnConditions', true);
% assignin('base','Cellk2',Cellk2); 
roots=subs( roots,k2,k2value);
 %% отображение корней
 fprintf(fid,'%s\r','. Корни характеристического полинома:');
 fprintf(fid,'%s\r','\begin{equation}p_1=');
 fprintf(fid,'%s\r',latex(vpa(expand(roots(1)),3)));
 fprintf(fid,'%s\r','\end{equation}');
 fprintf(fid,'%s\r','\begin{equation}p_2=');
 fprintf(fid,'%s\r',latex(vpa(expand(roots(2)),3)));
 fprintf(fid,'%s\r','\end{equation}');
 %assignin('base','roots',roots);
 %
  %% отображение условия 1
 Cellk1{1}=solve( roots(1) < 0 ,k1,'ReturnConditions', true);
 disp('for roots(1)<0 k1=');
 disp(vpa(Cellk1{1}.conditions,3));

 fprintf(fid,'%s\r','Пусть $k_1=k_1^x  $ --- искомый коэффициент.');
 
 fprintf(fid,'\r%s\r','Условие, при котором $p_1<0$ :');
 fprintf(fid,'%s\r','\begin{equation}');
 fprintf(fid,'k_1^%s\r',latex(vpa(Cellk1{1}.conditions,3)));
 fprintf(fid,'%s\r','\end{equation}');
   %% отображение условия 2
 Cellk1{2}=solve( roots(2) > 0 ,k1,'ReturnConditions', true);
 disp('for roots(2)>0 k1=');
 disp(vpa(Cellk1{2}.conditions,3));
  
 fprintf(fid,'%s\r','Условие, при котором $p_2>0$ :');
 fprintf(fid,'%s\r','\begin{equation}');
 fprintf(fid,'k_1^%s\r',latex(vpa(Cellk1{2}.conditions,3)));
 fprintf(fid,'%s\r','\end{equation}');

 k1value = koef(1);
%  k1value = double(solve((roots(1)+1),k1));
%  k1ziro1=solve(roots(1),k1); % значение, при котором число обращется в ноль
%  k1ziro2=solve(roots(2),k1); % значение, при котором число обращется в ноль
%  k1value=-39.31; 

 %% отображение коэфф. ПД
 fprintf(fid,'\r%s\r\r','Отображение коэффициентов ПД регулятора:');
 fprintf(fid,'%s','$k_1=');
 fprintf(fid,'%.4f$\r',k1value);
 fprintf(fid,'%s','$k_2=');
 fprintf(fid,'%.4f$\r',k2value);
 disp('k1=');
 disp(k1value);
 disp('k2=');
 disp(k2value);
 
roots=subs( roots,k1,k1value);
%% отображение корней
disp('roots(1):');
disp(double(roots(1)));
disp('roots(2):');
disp(double(roots(2)));
fprintf(fid,'\r%s\r\r','Корни характеристического полинома:');
fprintf(fid,'%s','$p_1=');
fprintf(fid,'%.4f$\r',double(roots(1)));
fprintf(fid,'%s','$p_2=');
fprintf(fid,'%.4f$\r',double(roots(2)));

%% Прямая S
fprintf(fid,'\r%s\r','Если начальные условия для свободной составляющей решения выбрать так, что коэффициент ');
fprintf(fid,'%s\r','при экспоненте со степенью, соответствующей положительному корню $p_2$ будет равен нулю, то ');
fprintf(fid,'%s\r','получим равенство $x_2=p_1 \, x_1$ или уравнение прямой в общем виде \eqref{eq:straight_S1_sym}');
fprintf(fid,'%s\r',',а для данного примера \eqref{eq:straight_S1}.');
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
f(fid,['Модель в Matlab Simulink на ',figref('sim_linear_2_por'),'. ']);
f(fid,['Исследуем движение фазовых координат во времени посредством ',...
'моделирования процессов в системе при отклонении системы от состояния',...
' равновесия. Фазовые траектории в системе на ',figref(FIGS.names{1}),'. ']);
f(fid,['В дополнение на ',figref(FIGS.names{2}),' указано изменение выходной переменной и её производной. ']);
past_figures(fid,FIGS,1);
l(fid);
f(fid,['Таким образом движение по траекториям, принадлежащим гиперплоскости устойчивых движений, то есть прямой',...
     ' $S$, будет вырожденным, так как сколь угодно малые возмущения могут отклонить точку от устойчивой траектории $S$. ',....
     'Эта прямая $S$ и является совокупностью устойчивых фазовых траекторий для неустойчивой системы второго порядка. ']);

fclose(fid);

%% обработка файла (замена \frac на \cfraq ) (делаем все дроби крупными)
fclose all; % необходимо для обработки файла , удаление и т.д.
replaceinfile('frac', 'cfrac',file_path,'-nobak');

%% очистка worcspace от мусора
% clc;
% clear;
% close all;
end



