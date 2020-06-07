function final_VSS(InitialConditions,PATH,path_subsection,name_subsection,section_name)
%%
disp(['Обработка --- subsection_name:"',name_subsection,'"']);
%% находит коэффициенты для системы с фазовой траекторие типа "седло" .
%% Создание файлов
file_path=[path_subsection ,name_subsection,'.tex'];
file_path = join(file_path);
fid = fopen(file_path,'w','l','UTF-8');
f(fid,'\clearpage');
fprintf(fid,'%s\r','\subsection{Исследование свойств спроектированной нелинейной СПС}');
%%
%% начальные условия-------------------------------------------------------------------------change
T=InitialConditions.T;
K=InitialConditions.K;
h=InitialConditions.h;
d=InitialConditions.d;
%%
name_system = 'sim_final_VSS';
FIGS = save_system_fig(PATH,name_system,'Структурная схема нелинейной СПС.');
f(fid,['На первом этапе нами была синтезирована СПС без учета нелинейности с линией скольжения  $S_1$, проходящей через начало координат. Затем для синтеза СПС с нелинейным элементом (НЭ) мы синтезировали релейную систему для больших отклонений с линией переключения $S_2=10x_1+6x_2+d$, где значение d определяет координаты точки пересечения линий $S_1$ и $S_2$. Значение $d$ определяет характер процесса в СПС на завершающей стадии движения. Для получения требуемого вида процесса и улучшения показателей системы коэффициенты усиления были скорректированы. Структурная схема для моделирования представлена на  ',figref(FIGS.names{1}),'. ']);
past_figures(fid,FIGS,1);

l(fid);
% count=4; %--------------------------------------------------------------------------------------------количество расчетов 8 max
% mn{1}=[2,2];%----------------------------------------------------change множитель у alpha и  betta соотв.  
% [C1, C2, alpha, betta, iter ,time ] = choose_coeff(InitialConditions,mn{1}) ;
alpha=14;
beta=-200;
C1=50;
C2=227.25;
k1=2;
k2=43.1;
ds=1;
sw1=1;
param{1}=[alpha beta C1 C2 k1 k2 ds sw1];
[FIGS,Settlingtime,init] = sim_VSS_final(PATH,InitialConditions,name_system,param);
f(fid,['Исследуем движение фазовых координат во времени посредством ',...
'моделирования процессов в системе при отклонении системы от состояния',...
' равновесия. Фазовые траектории в системе на ',figref(FIGS.names{1}),'. ']);
f(fid,['В дополнение на ',figref(FIGS.names{2}),' указано изменение выходной переменной и её производной, а на ',figref(FIGS.names{3}),' указано изменение фазовых координат для всех переменных состояния. ']);

key5='tab_settlinhtime_VSS_final';
f(fid,['В ',tabref(key5),' отобразим время регулирования при разных значениях параметров']);
title='Сравнение результатов';
line{1}=['zad & отклонение & $\alpha$ & $\beta$ & $C_1$ & $C_2$ & $k_1$ & $k_2$ & $ds$ & $sw1$ & $t_p$'];
for j=1:length(Settlingtime)
    line{j+1}=['$',num2str(init(1,j)),'$ & '];
        mas=abs(init(1,:));
        if abs(init(1,j))==min(mas)
            line{j+1}=strcat(line{j+1},'в малом');
        elseif abs(init(1,j))==max(mas)
            line{j+1}=strcat(line{j+1},'в большом');
        end
    line{j+1}=strcat(line{j+1},'& $');
    for i=1:length(param{1})
    line{j+1}=strcat(line{j+1},[num2str(param{1}(i),3),'$ & $']);
    end
    line{j+1}=strcat(line{j+1},[num2str(Settlingtime(j),3),'$ ']);
end

tex_table(fid,title,key5,line);
width = [0.7 1 0.6 0.7 1];
past_figures(fid,FIGS,width);

l(fid);
f(fid,'Точность поддержания выходной координаты в установившимся режиме составила $\epsilon=0$ – что удовлетворяет заданным требованиям точности $\epsilon\le',num2str(InitialConditions.e,3),'$.');
%f(fid,'Перерегулирование равно .');
%% обработка файла (замена \frac на \cfraq ) (делаем все дроби крупными)
fclose all; % необходимо для обработки файла , удаление и т.д.
replaceinfile('frac', 'cfrac',file_path,'-nobak');

%% очистка worcspace от мусора
% clc;
% clear;
% close all;
end



