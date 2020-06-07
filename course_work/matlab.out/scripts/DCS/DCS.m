function DCS(InitialConditions,PATH,path_subsection,name_subsection,section_name)
%%
disp(['Обработка --- subsection_name:"',name_subsection,'"']);
%% находит коэффициенты для системы с фазовой траекторие типа "седло" .
%% Создание файлов
file_path=[path_subsection ,name_subsection,'.tex'];
file_path = join(file_path);
fid = fopen(file_path,'w','l','UTF-8');
%f(fid,'\clearpage');
%fprintf(fid,'%s\r','\subsection{ШИМ}');
%%
%% начальные условия-------------------------------------------------------------------------change
T=InitialConditions.T;
K=InitialConditions.K;
h=InitialConditions.h;
d=InitialConditions.d;
%%
name_system = 'sim_final_VSS_PWM';
FIGS = save_system_fig(PATH,name_system,'Структурная схема нелинейной СПС с ШИМ. ');
f(fid,['Схема симулинк с добавлением ШИМ на  ',figref(FIGS.names{1}),'. ']);
        figure_name=FIGS.names{1};
        figure_path=FIGS.path{1};
        description=FIGS.description{1};
        width=1;
    fprintf(fid,'%s\r','\begin{sidewaysfigure}[!h]\centering');
    fprintf(fid,'%s','\includegraphics[width=');
    fprintf(fid,'%.1f',width);
    fprintf(fid,'%s','\linewidth]{');
    fprintf(fid,'%s}\r',figure_path);
    fprintf(fid,'%s\r',['\caption{',description,'}\label{fig:',figure_name,'}']);
    fprintf(fid,'%s\r','\end{sidewaysfigure}');

l(fid);
% count=4; %--------------------------------------------------------------------------------------------количество расчетов 8 max
% mn{1}=[2,2];%----------------------------------------------------change множитель у alpha и  betta соотв.  
% [C1, C2, alpha, betta, iter ,time ] = choose_coeff(InitialConditions,mn{1}) ;
alpha=47.084107;
beta=-35.313081;
C1=0.761702;
C2=11;
k1=3;
k2=200;
ds=1;
zad=[1 100];
param{1}=[alpha beta C1 C2 k1 k2 ds];
[FIGS,ST] = sim_VSS_final_DCS(PATH,InitialConditions,name_system,param,zad);
f(fid,['Исследуем движение фазовых координат во времени посредством ',...
'моделирования процессов в системе при отклонении системы от состояния',...
' равновесия. ']);
f(fid,['На ',figref(FIGS.names{2}),' указано изменение выходной переменной. ']);

past_figures(fid,FIGS,0.6);
f(fid,['Время переходного процесса при отклонении "в малом" согласно рисунку ',figref(FIGS.names{1}),' равно ',...
    num2str(ST(1),3),' сек.']);
f(fid,['Время переходного процесса при отклонении "в большом" согласно рисунку ',figref(FIGS.names{2}),' равно ',...
    num2str(ST(2),3),' сек.']);
f(fid,'В результате видим, что переходный процесс по прежнему удовлетворяет словиям задания.');
[FIGS] = sim_VSS_DCS(PATH,InitialConditions,name_system,param,zad);
past_figures(fid,FIGS,0.6);
l(fid);

%% обработка файла (замена \frac на \cfraq ) (делаем все дроби крупными)
fclose all; % необходимо для обработки файла , удаление и т.д.
replaceinfile('frac', 'cfrac',file_path,'-nobak');

%% очистка worcspace от мусора
% clc;
% clear;
% close all;
end



