function VSS_3_order(InitialConditions,PATH,path_subsection,name_subsection,section_name)
%%
disp(['Обработка --- subsection_name:"',name_subsection,'"']);
%% находит коэффициенты для системы с фазовой траекторие типа "седло" .
%% Создание файлов
file_path=[path_subsection ,name_subsection,'.tex'];
file_path = join(file_path);
fid = fopen(file_path,'w','l','UTF-8');
fprintf(fid,'%s\r','\subsection{Синтез управляющего устройства СПС третьего порядка без учета нелинейности}');
%% начальные условия-------------------------------------------------------------------------change
T=InitialConditions.T;
K=InitialConditions.K;
h=InitialConditions.h;
d=InitialConditions.d;
syms p Psi;


%% вывод ХП 
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
f(fid,['Выполним синтез СПС для  управляемого объекта третьего порядка с дифференциальными уравнениями, описывающими систему ',eqref(key),'.']);
line{1}=['p\,\left(',num2str(T^2),'\,p^2+',num2str(2*h*T),'\,p+1\right)\,x&=-',num2str(K),'\,u',...
                    '&&, \text{ если}|u|\le ',num2str(d)];
line{2}=['p\,\left(',num2str(T^2),'\,p^2+',num2str(2*h*T),'\,p+1\right)\,x&=-',num2str(K*d),...
                    '\,\mathrm{sign}\left(u\right)',...
                    '&&, \text{ если}|u|> ',num2str(d)];                
tex_aligned(fid,key,line,'sys');

l(fid);
f(fid,['Было установлено, что, система должна иметь замкнутую структуру, при этом в силу специфики объекта для обеспечения качественного управления эта структура должна быть переменной. На первом этапе аналитического конструирования не будем учитывать характер входных воздействий и ограничения вида насыщения, а синтезируем систему, обеспечивающую качественные показатели в свободном движении, причиной которых являются начальные возмущения - отклонения от какого-либо равновесного состояния. Основными требованиями к системе будем считать точность, характер переходного процесса, быстродействие. Конкретные значения этих показателей уточним в процессе синтеза системы.']);


f(fid,['Отсюда математическое описание системы в виде переменных состояния при $u\le',num2str(d),'$',eqref('ss_object_VSS'),'.']);
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
f(fid,'     Рассмотрим возможность положительного решения задачи синтеза при простейшей структуре СПС со скользящим движением, а именно, синтезируем СПС с управлением вида:');                
tex_eq(fid,'','u=\psi\,x_1');
fprintf(fid,'%s\r',['\begin{equation}\label{eq:','','}']);
               f(fid,     '\psi=');
              f(fid,      '    \left\{');
          f(fid,          '    \begin{aligned}');
f(fid,['&\alpha &&,\text{ если } x_1\,S>0 \\']);
fprintf(fid,'%s\r',['&\beta &&,\text{ если } x_1\,S<0 \\']);     
          f(fid,          '    \end{aligned}');    
              f(fid,      '    \right.');
            f(fid,        '\end{equation}');  
            l(fid);
f(fid,'Где $\alpha,\beta$ --- постоянные коэффициенты. ');
f(fid,' $S=x_3+c_2\,x_2+c_1\,x_1$ --- уравнение, задающее некоторую гиперплоскость, которая является при принятых выше соотношениях границей разрыва управляющего воздействия $u$.');
f(fid,'	Так как фактически структура системы определена, в результате синтеза необходимо определить параметры СПС, а именно, значения $\beta,\alpha,c_1,c_2$, обеспечивающие требуемые показатели качества разрабатываемой системы. ');

f(fid,['Отсюда приведенный ХП замкнутой системы :']);
tex_eq(fid,'',['D(p)=\,p^3+',num2str(2*h/T,4),'\,p^2+',num2str(1/T^2,4),'\,p+',num2str(K/T^2,4),'\,\psi']);
tex_eq(fid,'',['a_3=',num2str(a(3),4),',a_2=',num2str(a(2),4),',a_1=',num2str(a(1),4),',b=',num2str(b,4)]);

l(fid);
f(fid,'Итак должны соблюдаться 3 условия:');
fprintf(fid,'%s\r','\begin{enumerate}');
    fprintf(fid,'%s\r','\item ');
    fprintf(fid,'%s\r',['Условия существования  скользящего режима для системы 3-ого порядка  имеют вид:']);
    line{1}='b\,\alpha&>c_1\,(a_3-c_2)';
    line{2}='b\,\beta&<c_1\,(a_3-c_2)';
    line{3}='\frac{c_1-a_2}{c_2}&=c_2-a_3';
    tex_aligned(fid,'',line);
    f(fid,'Или эквивалентная форма:');
    line{1}='&\alpha>f(c_2)>\beta';
    line{2}='&\text{Где } f(c_2)=e_1\,c_2^3+e_2\,c_2^2+e_3\,c_2+e_4';
    line{3}='&e_1=-\frac{1}{b}, e_2=\frac{2\,a_3}{b}, e_3=\frac{-(a_3^2+a_2)}{b}, e_4=\frac{a_2\,a_3}{b}';
    line{4}=['&e_1=',num2str(e(1),3),', e_2=',num2str(e(2),3),', e_3=',num2str(e(3),3),', e_4=',num2str(e(4),3)];
    tex_aligned(fid,'',line);
    fprintf(fid,'%s\r','\item ');
    key1='HP_VSS';
    key2='VSS_steady';
    fprintf(fid,'%s\r',['Условие обеспечения устойчивости движения в скользящем режиме: ХП системы ',eqref(key1),' должен иметь не более 1-ого корня с положительной вещественной частью. Формулировка имеет вид ',eqref(key2),'.']);
    clear line;
    line{1}=['D(p)&=\,p^3+a_3\,p^2+a_2\,p+b\,\psi='];
    line{2}=['&=\,p^3+',num2str(2*h/T,4),'\,p^2+',num2str(1/T^2,4),'\,p+',num2str(K/T^2,4),'\,\psi'];
    line{3}=['\psi&=\frac{-c_1(c_2-a_3)}{b}'];
    tex_aligned(fid,key1,line);
    tex_eq(fid,key2,'Re(p_i)>0 \text{ только для одного } i\in(1,2,3)');
    f(fid,'\item');
    key3='HP1_VSS';
    key4='VSS_hit_the_plane';
    fprintf(fid,'%s\r',['Условия для попадания изображающей точки на плоскость скольжения --- в ХП ',eqref(key3),' неотрицательные действительные корни отсутствуют, т.е. отсутствуют экспоненты с положительной степенью. Формулировка имеет вид ',eqref(key4),'.']);
    tex_eq(fid,key3,['D(p)=\,p^3+',num2str(2*h/T,4),'\,p^2+',num2str(1/T^2,4),'\,p+',num2str(K/T^2,4),'\,\alpha']);
    tex_eq(fid,key4,'\forall i=\overline{1,3}:\left(p_i=Re(p_i)\text{ и }Re(p_i)\ge0\right) \text{ --- не выполняются.}');
fprintf(fid,'%s\r','\end{enumerate}');
% l(fid);
% f(fid,['']);
% f(fid,['']);
% f(fid,['']);

l(fid);
f(fid,'Алгоритм расчёта праметров в m-file matlab:') ;
fprintf(fid,'%s\r',['\input{components/',section_name,'/hole_Parameter_Calculation_Algorithm','}']);


fprintf(fid,'\r\r%s',['В результате расчёта имеем устойчивое движение в скользящем режиме с попаданием изображающей точки на плоскость скольжения.']);
f(fid,'Запустим алгоритм несколько раз с разными параметрами расчёта:');
count=4; %--------------------------------------------------------------------------------------------количество расчетов 8 max
mn{1}=[2,2];%----------------------------------------------------change множитель у alpha и  betta соотв.
mn{2}=[2,0.5];
mn{3}=[4,0.1]; 
mn{4}=[4,2];
for j=1:count       
        [C1, C2, alpha, betta, iter ,time ] = choose_coeff(InitialConditions,mn{1}) ;
        param{j}= [C1, C2, alpha, betta, iter ,time ];
        l(fid);
        f(fid,['Расчёт номер:',num2str(j)])
        %fprintf('\r%s\r', '     C1           C2           alpha             betta'); 
        l(fid);
        l(fid);
        f(fid,['  Итераций $= ',num2str(iter-1),' [ C_1=',num2str(C1,3),' ; C_2=',num2str(C2,3),' ; \alpha=',num2str(alpha,3),' ; \beta=',num2str(betta,3),' ]$']);
        fprintf(fid,'\r  Время на выполнение программы $%.0f$ сек.',time);
        fprintf(fid,'\r');
end        
 name_system=     'sim_VSS_P';
 FIGS = save_system_fig(PATH,name_system,'Структурная схема СПС 3 порядка со скользящим режимом.');

l(fid);
f(fid,['Модель в Matlab Simulink на ',figref(FIGS.names{1}),'. ']);
past_figures(fid,FIGS,1);

[FIGS,Settlingtime] = sim_VSS_PR(PATH,InitialConditions,name_system,param);
f(fid,['Исследуем движение фазовых координат во времени посредством ',...
'моделирования процессов в системе при отклонении системы от состояния',...
' равновесия. Фазовые траектории в системе на ',figref(FIGS.names{1}),'. ']);
f(fid,['В дополнение на ',figref(FIGS.names{2}),' указано изменение выходной переменной и её производной, а на ',figref(FIGS.names{3}),' указано изменение фазовых координат для всех переменных состояния. ']);
key5='tab_VSS_3';
f(fid,['В ',tabref(key5),' отобразим время регулирования при разных значениях параметров']);
title='Сравнение результатов';
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
f(fid,['Полученные характеристики позволяют сравнить качественные показатели СПС и обычной линейной системы. Из переходных характеристик СПС следует, что переходный процесс имеет апериодический характер, при этом время переходного процесса меньше, чем в линейной системе. Изменяя параметры СПС, можно влиять на качественные показатели системы. Однако для таких изменений необходимо определить пределы изменения параметров, руководствуясь условиями устойчивости и условиями попадания изображающей точки на плоскость скольжения.']);
f(fid,'Чем больше $\alpha$, тем быстрее заканчивается переходный процесс,');

l(fid);
[Val,best]=min(Settlingtime);
[FIGS,marg]=bode_plot(PATH,InitialConditions,param{best});
f(fid,['Определим запас устойчивости системы <<в малом>> по амплитуде и фазе, построив логарифмические частотные характеристики для разомкнутой системы с $\alpha=',num2str(param{best}(3),3),'$ на ',figref(FIGS.names{1}),' и $\beta=',num2str(param{best}(4),3),'$ на ',figref(FIGS.names{2}),'. ']);

tex_eq(fid,'',['W=\frac{',num2str(K),'\,\psi}{p\,\left(',num2str(T^2),'\,p^2+',num2str(2*h*T),'\,p+1\right)}']);

past_figures(fid,FIGS,1);
clear line;
f(fid,'Таким образом, в результате синтеза СПС со скользящим режимом без учета нелинейного элемента мы получили систему, обладающую характеристиками, соответствующими техническому заданию, а именно:'); 
line{1}=['Для $\alpha$ запас устойчивости <<в малом>> по амплитуде $',num2str(marg{1}(1),3),'<$ 20 дБ, по фазе $',num2str(marg{1}(2),3),'< 60°$, $\omega_{cp}=',num2str(marg{1}(3),3),'$. '];
line{2}=['Для $\beta$ запас устойчивости <<в малом>> по амплитуде $',num2str(marg{2}(1),3),'\ge$ 20 дБ, по фазе $',num2str(marg{2}(2),3),'\ge 60°$, $\omega_{cp}=',num2str(marg{2}(3),3),'$. '];
tex_enumerate(fid,line);


%% обработка файла (замена \frac на \cfraq ) (делаем все дроби крупными)
fclose all; % необходимо для обработки файла , удаление и т.д.
replaceinfile('frac', 'cfrac',file_path,'-nobak');

%% очистка worcspace от мусора
% clc;
% clear;
% close all;
end



