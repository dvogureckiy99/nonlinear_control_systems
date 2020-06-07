function [k,kor] =  find_PD_neust_focus(InitialConditions,PATH,section_name,file_name)
disp(['Обработка ',file_name]);
%% находит коэффициенты для системы с фазовой траекторие типа "фокус" .
file_path=[PATH.Texcomponents,section_name,'\',file_name,'.tex']; % путь к файлу subsection
file_path = join(file_path);
fid = fopen(file_path,'w','l','UTF-8');
f(fid,'\clearpage');
fprintf(fid,'%s\r','\subsection{Находим коэффициенты для системы с фазовой траекторией типа <<неустойчивый фокус>>}');
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
D=D/(T^2);
D=collect(D,p)


%FIGS = sim_sist_linear_2_por(InitialConditions,PATH); %сохранение рисунка схемы
f(fid,['. В качестве второй неустойчивой структуры примем структуру с фазовыми траекториями типа <<неустойчивый фокус>> ,',...
    'то есть, раскручивающиеся спирали. Для получения такой фазовой траектории необходимо, чтобы корни характеристического  ',...4
    'уравнения были комплексными сопряженными с положительными вещественными частями. Такую структуру можно получить за счёт ',...
    'соответствующего подбора коэффициентов в регуляторе. Приведенный ХП замкнутой системы ',eqref('HP_2_por_upr1'),'был получен ранее. '...
        ]);
tex_eq(fid,'HP_2_por_upr1',['D(p)=',latex(D)]);

 
  %% отображение корней
 l(fid);
%  fprintf(fid,'%s\r','Найдём корни характеристического полинома:');
%  fprintf(fid,'%s\r','\begin{equation}p_1=');
%  fprintf(fid,'%s\r',latex(roots(1)));
%  fprintf(fid,'%s\r','\end{equation}');
%  fprintf(fid,'%s\r','\begin{equation}p_2=');
%  fprintf(fid,'%s\r',latex(roots(2)));
%  fprintf(fid,'%s\r','\end{equation}');
Dp=coeffs(D,p);
b=Dp(2);
a=1;
c=Dp(1);
discr = b^2-4*a*c;
k1kr=solve(discr,k1);
k2kr=solve(Dp(2),k2);

key2='usl_ks';
f(fid,['Для того, чтобы корни имели положительные вещественные части, необходимо, чтобы $',latex(Dp(2)),'<0$, т.е. $k_2<',num2str(double(k2kr),3),'$ ',...
    '.Знак минус у $k_2$  говорит о том, что обратная связь по производной от отклонения должна быть положительной, ',...
    'что в свою очередь объясняется тем, что сам объект является асимптотически устойчивым.',...
    'Чтобы корни были комплексно-сопряженными необходимо выполнение ',eqref(key2)]);
 tex_eq(fid,key2,['k_1>',latex(k1kr)]);
 
 k2value=k2kr*2; %----------------------------------------------------------------------------change
fprintf(fid,'%s','Пусть $k_2=');
fprintf(fid,'%.2f$\r',k2value);

k1krvalue = double(subs(k1kr,k2,k2value));
mn=100;
k1value=k1krvalue*mn ;

fprintf(fid,'\r%s','Тогда соответственно получаем $k_1>',num2str(k1krvalue,3),'$ и рассчитываем коэффициент $k_1$ : ');
tex_eq(fid,'',['k_1=',num2str(mn),'\times',num2str(k1krvalue,3),'=',num2str(k1value,3)]);
 
 roots=solve(D,p); % два решения 
 roots=subs( roots,k1,k1value);
 roots=subs( roots,k2,k2value);
l(fid);
 fprintf(fid,'%s\r','Корни характеристического полинома:');
 fprintf(fid,'%s\r','\begin{equation}p_1=');
 fprintf(fid,'%s\r',num2str(double(roots(1)),3));
 fprintf(fid,'%s\r','\end{equation}');
 fprintf(fid,'%s\r','\begin{equation}p_2=');
 fprintf(fid,'%s\r',num2str(double(roots(2)),3));
 fprintf(fid,'%s\r','\end{equation}');

 k(1)=k1value;
k(2)=k2value; 
kor(1)=double(roots(1));
kor(2)=double(roots(2));
 
FIGS = sim_focus(PATH,InitialConditions,k,kor);
l(fid);
f(fid,['Схема будет иметь тот же вид, что и на ',figref('sim_linear_2_por'),'.']);
f(fid,['Исследуем движение фазовых координат во времени посредством ',...
'моделирования процессов в системе при отклонении системы от состояния',...
' равновесия. Фазовые траектории в системе на ',figref(FIGS.names{1}),'. ']);
f(fid,['В дополнение на ',figref(FIGS.names{2}),' указано изменение выходной переменной и её производной. ']);
past_figures(fid,FIGS,1);

fclose(fid);


%% обработка файла (замена \frac на \cfraq ) (делаем все дроби крупными)
fclose all; % необходимо для обработки файла , удаление и т.д.
replaceinfile('frac', 'cfrac',file_path,'-nobak');

%% очистка worcspace от мусора
% clc;
% clear;
% close all;
end
