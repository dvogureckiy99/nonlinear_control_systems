function VSS_no_steady_degenerate_motion(InitialConditions,PATH,path_subsection,name_subsection,k,p)
%%
disp(['Обработка --- subsection_name:"',name_subsection,'"']);
%% находит коэффициенты для системы с фазовой траекторие типа "седло" .
%% Создание файлов
file_path=[path_subsection ,name_subsection,'.tex'];
file_path = join(file_path);
fid = fopen(file_path,'w','l','UTF-8');
f(fid,'\clearpage');
fprintf(fid,'%s\r','\subsection{Система с переменной структурой без устойчивого вырожденного движения} \label{title:VSS_no_SDM}');    
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
%%
f(fid,['Другой способ построения системы с переменной структурой целесообразно использовать в случае, если фазовое ',...
    'пространство  для каждой из фиксированных структур не содержит гиперплоскостей с устойчивым вырожденным движением. ',...
    'За счёт <<сшивания>> в определенной последовательности участков из неустойчивых траекторий удается получить устойчивое ',...
    'движение для любых начальных условий.']);
l(fid);
f(fid,['В качестве примера рассмотрим случай, когда в нашем распоряжении имеются две линейные',...
    ' структуры с незатухающими колебаниями, то есть,  находящиеся на границе устойчивости. Уравнения движения в этих системах одно и то же:']);
key1='HP_centr';
tex_eq(fid,key1,'\frac{d^2\,x}{d\,t^2}+\omega_0^2\,x=0');
f(fid,'При разных значениях   фазовые траектории систем  будут иметь вид эллипсов с разными полуосями. Характеристический полином имеет вид:');
tex_eq(fid,key1,['D(p)=',latex(D)]);

f(fid,'Для получения фазовой траектории типа эллипс необходимо выполнение двух условий:');
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
fprintf(fid,'%s','Пусть $k_1=');
fprintf(fid,'%.4f$\r',k1value(1));
f(fid,'Тогда характеристический полином имеет вид:');
key3='elips1';
D1=subs(D,k1,k1value(1));
D1=collect(D1,p);
Dp=coeffs(D1,p);
w2(1)=double(Dp(1));
tex_eq(fid,key3,['D(p)=',latex(vpa(D1,4))]);
fprintf(fid,'%s','Пусть $k_1=');
fprintf(fid,'%.4f$\r',k1value(2));
f(fid,'Тогда характеристический полином имеет вид:');
key4='elips2';
D2=subs(D,k1,k1value(2));
D2=collect(D2,p);
Dp=coeffs(D2,p);
w2(2)=double(Dp(1));
tex_eq(fid,key4,['D(p)=',latex(vpa(D2,4))]);

f(fid,['Схема будет иметь тот же вид, что и на ',figref('sim_linear_2_por'),'.']);
FIGS = sim_center(PATH,InitialConditions,k1value,k2value,w2);
f(fid,['Исследуем движение фазовых координат во времени посредством ',...
'моделирования процессов в системе при отклонении системы от состояния',...
' равновесия. Фазовые траектории в системе на ',figref(FIGS.names{1}),'. ']);
f(fid,['В дополнение на ',figref(FIGS.names{2}),' указано изменение выходной переменной и её производной. ']);
past_figures(fid,FIGS,1);

name_system = 'sim_VSS_no_steady_degenerate_motion';
FIGS = save_system_fig(PATH,name_system,'Структурная схема системы с переменной структурой без устойчивого вырожденного движения');

l(fid);
f(fid,['Переключение с одной структуры на другую будет происходить при пересечении фазовой траекторией координатных осей. Аналитический закон переключения структур запишется следующим образом:   ' ]);
key5='usl_VSS_center';
line{1}=['&k_1=',num2str(k1value(2),3),'&&,k_2=',num2str(k2value(2),3),'&&,\text{ если }sign(x_1 \cdot x_2)>0'];
line{2}=['&k_1=',num2str(k1value(1),3),'&&,k_2=',num2str(k2value(1),3),'&&,\text{ если }sign(x_1 \cdot x_2)<0'];
tex_aligned(fid,key5,line,'sis');
l(fid);
f(fid,['Структурная схема системы с переменной структурой без устойчивого вырожденного движения на ',...
figref(FIGS.names{1}),'.']);
past_figures(fid,FIGS,1);

FIGS = sim_no_steady_degenerate_motion(PATH,InitialConditions,k1value,k2value,name_system);
l(fid);
f(fid,['Исследуем движение фазовых координат во времени посредством ',...
'моделирования процессов в системе при отклонении системы от состояния',...
' равновесия. Фазовые траектории в системе на ',figref(FIGS.names{1}),'. ']);
f(fid,['В дополнение на ',figref(FIGS.names{2}),' указано изменение выходной переменной и её производной. ']);
past_figures(fid,FIGS,1);

%% обработка файла (замена \frac на \cfraq ) (делаем все дроби крупными)
fclose all; % необходимо для обработки файла , удаление и т.д.
replaceinfile('frac', 'cfrac',file_path,'-nobak');

%% очистка worcspace от мусора
% clc;
% clear ;
% close all;

end
