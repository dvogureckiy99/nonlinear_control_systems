function [k1,k2,Settlingtime] = PD_regulator(InitialConditions,PATH,path_subsection,name_subsection,k1koef)
%%
disp(['Обработка --- subsection_name:"',name_subsection,'"']);
%% находит коэффициенты для системы с фазовой траекторие типа "седло" .
%% Создание файлов
file_path=[path_subsection ,name_subsection,'.tex'];
file_path = join(file_path);
fid = fopen(file_path,'w','l','UTF-8');
fprintf(fid,'%s\r','\subsection{Исследование системы управления с \\ пропорционально-дифференциальным регулятором} \label{title:PDR}');    
%% начальные условия
T=InitialConditions.T;
K=InitialConditions.K;
h=InitialConditions.h;
d=InitialConditions.d; 
%% 1
FIGS = sim_sistPD(InitialConditions,PATH); %сохранение рисунка схемы
key1='con_PD';
fprintf(fid,'%s\r','Составим систему',...
    'дифференциальных уравнений в операторной форме  для математического описания системы с пропорционально-дифференциальным регулятором ',...
    'относительно отклонения $x$.'...
    );
past_figures(fid,FIGS,1);%вставка одной фигуры
f(fid,['По СС замкнутой системы на ',figref(FIGS.names{1}),' составим уравнения',eqref(key1),'.']);
line1{1} = ['x&=X_{zad}-X & X&=\frac{',num2str(K),'\,z(u)}{Q(p)}'];
line1{2} = ['Q(p)&=p\,\left(',num2str(T^2),'\,p^2+',num2str(2*h*T),'\,p+1\right)&Q(p)\,x&=Q(p)\,X_{zad}-',...
    num2str(K),'z(u)'];
tex_aligned(fid,key1,line1);
key2='con_PD1';
fprintf(fid,'%s\r','Исследуем собственные свойства системы, т.е. считаем $X_{zad}=0$.',...
    ' Учтём, что мы имеем пропорционально-дифференциальныq регулятор, т.е. $u\hm{=}k_1\,x\hm{+}k_2\,\frac{d\,x}{d\,t}$, получаем уравнение',eqref(key2),'.');
tex_eq(fid,key2,['Q(p)\,x=-', num2str(K),'\,z(k_1\,x+k_2\,\frac{d\,x}{d\,t})']);
key3='con_PD2';
fprintf(fid,'%s\r',['Далее раскроем функцию $z(u)$ и получим систему \eqref{eq:',key3,'}.']);
line{1}=['p\,\left(',num2str(T^2),'\,p^2+',num2str(2*h*T),'\,p+1\right)\,x&=-',num2str(K),'\,\left(k_1\,+k_2\,p\right)\,x',...
                    '&&, \text{ если}|u|\le ',num2str(d)];
line{2}=['p\,\left(',num2str(T^2),'\,p^2+',num2str(2*h*T),'\,p+1\right)\,x&=-',num2str(K*d),...
                    '\,\mathrm{sign}\left(u\right)',...
                    '&&, \text{ если}|u|> ',num2str(d)];                
tex_aligned(fid,key3,line,'sys');
f(fid,['Отсюда ХП замкнутой системы при $u\le',num2str(d),'$',eqref('HP_PD'),'.']);
tex_eq(fid,'HP_PD',['D(p)=\left(',num2str(T^2),'\,p^3+',num2str(2*h*T),'\,p^2+p\,\left(1+',num2str(K),'\,k_2\right)+',num2str(K),'\,k_1\right)']);
f(fid,['При $|u|>',num2str(d),'$ линейная обратная связь отсутствует и движение в ней определяется ',...
    'свойствами управляемого объекта, при условии, что на его вход подаётся постоянное по значению воздействие. ',...
    'При $|u|\le',num2str(d),'$ движение описывается линейным дифференциальным уравнением.']);
l(fid);
f(fid,'Определение предельного значения по критерию Гурвица:');
l(fid);
f(fid,['$a_0=',num2str(T^2),',a_1=',num2str(2*h*T),',a_2=1+',num2str(K),'\,k_2,a_3=',num2str(K),'\,k_1$']);
tex_eq(fid,'key5','a_1\.a_2-a_0\,a_3\ge0'); 
syms k1 k2 ;
M=2*h*T*(1+K*k2)-K*T^2*k1;
k2=solve(M,k2);
tex_eq(fid,'sys_ust_PD',['k_2\ge',latex(k2),' \text{ --- для асимптотической устойчивости.}']);
tex_eq(fid,'as_ust_PD',['k_{2\text{г.у.}}(k_1)=',latex(k2),'\text{ --- граница устойчивости.} ']);
[FIGS, k1v, k2v, mult,Settlingtime,index_min_S] = sim_sysPD(InitialConditions,PATH,k1koef,k2); %симуляция переменных состояния
l(fid);
f(fid,['Оценим ПХ регулируемой переменной при различных значениях $k_1,k_2$ для устойчивых режимов на ',figref(FIGS.names{1}),'. ']);
key4='k1k2PD';
key5='k1k2PDcalc';
f(fid,[' Несколько значений записаны в ',tabref(key4),', а алгоритм их расчёта записан в ',tabref(key5),'.']);
line{1}=['$k_1$ '];
for i=1:length(k1v)
line{1}=strcat(line{1},['& $',num2str(k1v(i),2),'$']);
end
line{2}=['$k_2$ '];
for i=1:length(k2v)
line{2}=strcat(line{2},['& $k_{2\text{г.у.}}(',num2str(k1v(i),2),')\cdot',num2str(mult(i)),'$']);
end
tex_table(fid,'Алгоритм расчёта значений $k_1,k_2$',key5,line);
line{1}=['$k_1$ '];
for i=1:length(k1v)
line{1}=strcat(line{1},['& $',num2str(k1v(i),2),'$']);
end
line{2}=['$k_2$ '];
for i=1:length(k2v)
line{2}=strcat(line{2},['& $',num2str(k2v(i),3),'$']);
end
tex_table(fid,'Различные значения $k_1,k_2$',key4,line);

f(fid,['По графику видно, что для устойчивых режимов движения можно подбирать коэффициенты так, чтобы увеличить быстродействие системы,',...
    'однако существенно изменить его невозможно. Уже при $k_1=',num2str(k1v(index_min_S),2),'$ время регулирования уменьшается незначительно и составляет примерно ',...
    '$',num2str(Settlingtime,2),'$ сек, ',...
    'хотя и этот результат намного лучше, чем время регулирования, полученное c пропорциональным регулятором в пункте \ref{title:PR}.'... 
 ' При анализе табл.\ref{tab:k1k2PDcalc} и рис.\ref{fig:PD_sys},',...
 'видно, что с ростом множителя при $k_{2\text{г.у.}}(k_1)$ ,т.е. с ростом $k_2$, колебательность уменьшается.',...
 ' Таким образом $k_1$ --- коэффициент пропорционального',...
 'звена, влияет на скорость нарастания выходной величины, а $k_2$ --- коэффициент дифференцирующего звена, влияет на колебательность системы.']);
% 'Например колебания при',...
%'$k_{2\text{г.у.}}(100)\cdot10$ заметно меньше, чем при $k_{2\text{г.у.}}(100)\cdot15$.
past_figures(fid,FIGS,1);%вставка одной фигуры
%% обработка файла (замена \frac на \cfraq ) (делаем все дроби крупными)
fclose all; % необходимо для обработки файла , удаление и т.д.
replaceinfile('frac', 'cfrac',file_path,'-nobak');

k1=k1v(index_min_S);
k2=k2v(index_min_S);
%% очистка worcspace от мусора
% clc;
% clear ;
% close all;
end