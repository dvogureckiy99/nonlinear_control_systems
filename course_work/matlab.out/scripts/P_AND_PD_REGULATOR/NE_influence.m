function NE_influence(InitialConditions,PATH,path_subsection,name_subsection,k1,k2,Settlingtime)
%%
disp(['Обработка --- subsection_name:"',name_subsection,'"']);
%% находит коэффициенты для системы с фазовой траекторие типа "седло" .
%% Создание файлов
file_path=[path_subsection ,name_subsection,'.tex'];
file_path = join(file_path);
fid = fopen(file_path,'w','l','UTF-8');
fprintf(fid,'%s\r','\subsection{Оценка влияния нелинейного элемента на свойства линейной системы}');    
%% 1
f(fid,'Для исследования влияния НЭ нужно рассмотреть 2 системы: с НЭ и без него.');
f(fid,['Структурная схема системы будет соответствовать СС на ',figref('sim_PD'),' с наличием НЭ и и без него.']);
f(fid,['Из результатов предыдущего моделирования выберем коэффиценты $k_1=',num2str(k1),',k_2=',num2str(k2,3),'$. ']);
[FIGS] = sim_sysNE(InitialConditions,PATH,k1,k2,Settlingtime); %симуляция переменных состояния
f(fid,[' Графики изменения выходной переменной $X$ для системы с НЭ и без него на ',figref(FIGS.names{1}),' ']);
f(fid,'при подаче на вход ЕСФ');
past_figures(fid,FIGS,1);%вставка одной фигуры
l(fid);
end
