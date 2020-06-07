function  VSS_sliding_mode(InitialConditions,PATH,path_subsection,name_subsection,k,p)
%%
disp(['Обработка --- subsection_name:"',name_subsection,'"']);
%% .
%% Создание файлов
file_path=[path_subsection ,name_subsection,'.tex'];
file_path = join(file_path);
fid = fopen(file_path,'w','l','UTF-8');
f(fid,'\clearpage');
fprintf(fid,'%s\r','\subsection{Система с переменной структурой  со скользящим режимом движения} \label{title:VSS_SDM}');    

name_system = 'sim_VSS_steady_degenerate_motion';
f(fid,'Наиболее рациональной считается идея синтеза систем с переменной структурой с искусственным вырожденным движением. Сущность этого подхода заключается в следующем. Как и прежде считается, что имеется несколько линейных структур, не обязательно  устойчивых, из которых синтезируется система с переменной структурой. В фазовом пространстве искусственно задается  некоторая  гиперплоскость S, движение в которой обладает желаемыми свойствами, причем траектории, лежащие  в этой плоскости, не принадлежат ни одной из линейных структур. Последовательность изменения структур должна быть выбираема такой, чтобы изображающая  точка при любых начальных условиях всегда попадала на эту плоскость, а затем двигалась (скользила) по ней. Тогда с момента попадания  на эту гиперплоскость в системе будет существовать искусственное вырожденное движение, которое можно наделить рядом полезных свойств, не принадлежащих ни одной из фиксированных структур. ');
key1='straight_sliding';
l(fid);
mn=2;
f(fid,['Для рассмотренной ранее СПС с устойчивым вырожденным движением, которое определяется уравнением ',eqref('straight_S1'),' введем на фазовой плоскости линию скольжения ',eqref(key1),'. Все остальные параметры управляющего устройства  оставим без изменений.']);
f(fid,[' Угол наклона у линии скольжения меньше угла наклона сепаратрисы седловой траектории с отрицательным наклоном в ',num2str(mn),' раз. Если сделать угол наклона больше, то скольжения наблюдаться не будет.']);
tau = p{1}(1)/mn; 
line{1}='S&=x_2-\tau\,x_1=0';
line{2}=['S&=x_2+',num2str(abs(tau),1),'\,x_1=0'];
tex_aligned(fid,key1,line);

l(fid);
f(fid,['Структурная схема системы с переменной структурой со скользящим режимом движения имеет тот же вид, что и на ',...
figref('sim_VSS_steady_degenerate_motion'),', только в переменную p блока Gain вставляем значение угла наклона у линии скольжения.']);

FIGS = sim_sliding_mode(PATH,InitialConditions,k,p,tau,name_system);
l(fid);
f(fid,['Исследуем движение фазовых координат во времени посредством ',...
'моделирования процессов в системе при отклонении системы от состояния',...
' равновесия. Фазовые траектории в системе на ',figref(FIGS.names{1}),'. ']);
f(fid,['В дополнение на ',figref(FIGS.names{2}),' указано изменение выходной переменной и её производной. ']);
past_figures(fid,FIGS,1);
l(fid);
f(fid,'Видно, что СПС дают существенно лучшие показатели по сравнению с линейными системами регулирования. Как видно из полученных графиков в СПС без вырожденного устойчивого движения и в СПС с вырожденным устойчивым движением существуют колебания, а в СПС со скользящим режимом колебания отсутствуют. Изменяя целенаправленно параметры СПС, можно влиять на качественные показатели системы. '); 
l(fid);         
f(fid,'Таким образом, подводя итоги, можем отметить, что СПС может быть построена по одному из трех рассмотренных выше принципов. В большинстве случаев предпочтение отдается системам со скользящим режимом в силу их специфических свойств.'...
);
%% обработка файла (замена \frac на \cfraq ) (делаем все дроби крупными)
fclose all; % необходимо для обработки файла , удаление и т.д.
replaceinfile('frac', 'cfrac',file_path,'-nobak');

%% очистка worcspace от мусора
% clc;
% clear ;
% close all;

end