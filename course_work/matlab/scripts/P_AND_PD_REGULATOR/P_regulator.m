function k1=P_regulator(InitialConditions,PATH,path_subsection,name_subsection)
%%
disp(['Обработка --- subsection_name:"',name_subsection,'"']);
%% находит коэффициенты для системы с фазовой траекторие типа "седло" .
%% Создание файлов
file_path=[path_subsection ,name_subsection,'.tex'];
file_path = join(file_path);
fid = fopen(file_path,'w','l','UTF-8');
fprintf(fid,'%s\r','\subsection{Исследование системы с пропорциональным регулятором}\label{title:PR}');
%% начальные условия
T=InitialConditions.T;
K=InitialConditions.K;
h=InitialConditions.h;
d=InitialConditions.d; 
%% 1
FIGS = sim_sist(InitialConditions,PATH); %сохранение рисунка схемы
key1='control_sys';
fprintf(fid,'%s\r','Составим систему',...
    'дифференциальных уравнений в операторной форме  для математического описания системы с пропорциональным регулятором ',...
    'относительно отклонения $x$.'...
    );
past_figures(fid,FIGS,1);%вставка одной фигуры
f(fid,['По СС замкнутой системы на ',figref(FIGS.names{1}),' составим уравнения',eqref(key1),'.']);
line1{1} = ['x&=X_{zad}-X & X&=\frac{',num2str(K),'\,z(u)}{Q(p)}'];
line1{2} = ['Q(p)&=p\,\left(',num2str(T^2),'\,p^2+',num2str(2*h*T),'\,p+1\right)&Q(p)\,x&=Q(p)\,X_{zad}-',...
    num2str(K),'z(u)'];
tex_aligned(fid,key1,line1);
key2='con_sys1';
fprintf(fid,'%s\r','Исследуем собственные свойства системы, т.е. считаем $X_{zad}=0$.',...
    ' Учтём, что мы имеем пропорциональный регулятор, т.е. $u=k_1\,x$, получаем уравнение',eqref(key2),'.');
tex_eq(fid,key2,['Q(p)\,x=-', num2str(K),'\,z(k_1\,x)']);
key3='con_sys2';
fprintf(fid,'%s\r',['Далее раскроем функцию $z(u)$ и получим систему \eqref{eq:',key3,'}.']);
line{1}=['p\,\left(',num2str(T^2),'\,p^2+',num2str(2*h*T),'\,p+1\right)\,x&=-',num2str(K),'\,k_1\,x',...
                    '&&, \text{ если}|k_1\,x|\le ',num2str(d)];
line{2}=['p\,\left(',num2str(T^2),'\,p^2+',num2str(2*h*T),'\,p+1\right)\,x&=-',num2str(K*d),...
                    '\,\mathrm{sign}\left(k_1\,x\right)',...
                    '&&, \text{ если}|k_1\,x|> ',num2str(d)];                
tex_aligned(fid,key3,line,'sys');
f(fid,['Отсюда ХП замкнутой системы при $k_1\,x\le',num2str(d),'$',eqref('key4'),'.']);
tex_eq(fid,'key4',['D(p)=\left(',num2str(T^2),'\,p^3+',num2str(2*h*T),'\,p^2+p+',num2str(K),'\,k_1\right)']);
f(fid,['При $|k_1\,x|>',num2str(d),'$ линейная обратная связь отсутствует и движение в ней определяется ',...
    'свойствами управляемого объекта, при условии, что на его вход подаётся постоянное по значению воздействие. ',...
    'При $|k_1\,x|\le',num2str(d),'$ движение описывается линейным дифференциальным уравнением. Неустойчивость системы может быть вызвана:']);
line{1}='Неустойчивостью линейной системы.';
line{2}=['Неустойчивостью, вызванной релейным режимом работы при $|k_1\,x|\hm{>}',num2str(d),'$.'];
tex_enumerate(fid,line);
l(fid);
f(fid,'Определение предельного значения по критерию Гурвица:');
l(fid);
f(fid,['$a_0=',num2str(T^2),',a_1=',num2str(2*h*T),',a_2=1,a_3=',num2str(K),'\,k_1$']);
tex_eq(fid,'key5','a_1\.a_2-a_0\,a_3\ge0');
syms k ;
M=2*h*T-T^2*K*k;
k=double(solve(M,k));
tex_eq(fid,'sys_ust',['0\le k_1\le ',num2str(k,3),' \text{ --- для асимптотической устойчивости.}']);
[FIGS,k1] = sim_sys(InitialConditions,PATH,k); %симуляция переменных состояния
f(fid,['$k_1=',num2str(k,3),'$ --- граница устойчивости колебательного типа. ']);
past_figures(fid,FIGS,1);%вставка одной фигуры
l(fid);
f(fid,['Оценим ПХ регулируемой переменной при различных значениях $k$ для устойчивых режимов на ',figref(FIGS.names{1}),'.',...
    ' Как видим при критическом значении $k_1$ появляются незатухающие колебания. ',...
    'При уменьшении $k$ значение показателя колебательности становится меньше.'...
    '']);
l(fid);
f(fid,'Для повышения быстродействия нужно увеличить коэффициент передачи, но это ведёт к неустойчивости системы.');
%% обработка файла (замена \frac на \cfraq ) (делаем все дроби крупными)
fclose all; % необходимо для обработки файла , удаление и т.д.
replaceinfile('frac', 'cfrac',file_path,'-nobak');

%% очистка worcspace от мусора
% clc;
% clear ;
% close all;
end