 function ObjectAnalysis(InitialConditions,PATH,section_name,name_subsection)
 %% Создание файлов
path_subsection = [PATH.Texcomponents,section_name,'\'];%путь к subsection files
file_path=[path_subsection ,name_subsection,'.tex'];
file_path = join(file_path);
fid = fopen(file_path,'w','l','UTF-8');
%% 1
name='Исходные данные';
f(fid,['\subsection{',name,'}']);

%% начальные условия-------------------------------------------------------------------------change
T=InitialConditions.T;
K=InitialConditions.K;
h=InitialConditions.h;
d=InitialConditions.d;
s=InitialConditions.s;
e=InitialConditions.e;
L=InitialConditions.L;
g=InitialConditions.g;
process_num=InitialConditions.num_form_process;
process=InitialConditions.form_process{process_num};

key_cond="init_cond";
f(fid,[' Разработать управляющее устройство, обеспечивающее ']);
f(fid,['качественные показатели системы, указанные в ',tabref(key_cond),'.']);
f(fid,'Помимо этого характер переходного процесса должен быть ');
if process_num==1
    f(fid,[process,'ым']);
    init = [T K h d e L g];
    line{1}='$T$ & $K$ & $h$ & $d$ & $\epsilon_{max},\%$ & $L_{m\,max},db$ & $\gamma,^{\circ}$';
    for j=1:1
        line{j+1}=' $';
        for i=1:(length(init)-1)
        line{j+1}=strcat(line{j+1},[num2str(init(i),3),'$ & $']);
        end
        line{j+1}=strcat(line{j+1},[num2str(init(i+1),3),'$ ']);
    end
else
    f(fid,join([process,'им']));
    init = [T K h d s e L g];
    line{1}='$T$ & $K$ & $h$ & $d$ & $\sigma_{max},\%$ & $\epsilon_{max},\%$ & $L_{m\,max},db$ & $\gamma,^{\circ}$';
    for j=1:1
        line{j+1}=' $';
        for i=1:(length(init)-1)
        line{j+1}=strcat(line{j+1},[num2str(init(i),3),'$ & $']);
        end
        line{j+1}=strcat(line{j+1},[num2str(init(i+1),3),'$ ']);
    end
end
f(fid,', а время переходного процесса должно быть минимально возможным.');

tex_table(fid,'Условия задания',key_cond,line);
if process_num==1
    f(fid,['$\epsilon_{max},\%$ --- максимально допустимое отклонение выходной координаты в установившемся режиме;']);
    l(fid);
    f(fid,['$L_{m\,max},db$ --- запас устойчивости в "малом" по амплитуде;']);
    l(fid);
    f(fid,['$\gamma,^{\circ}$ --- запас устойчивости в "малом" по фазе.']);
else
    f(fid,['$\sigma_{max},\%$ --- показатель перерегулирования;']);
    l(fid);
    f(fid,['$\epsilon_{max},\%$ --- максимально допустимое отклонение выходной координаты в установившемся режиме;']);
    l(fid);
    f(fid,['$L_{m\,max},db$ --- запас устойчивости в "малом" по амплитуде;']);
    l(fid);
    f(fid,['$\gamma,^{\circ}$ --- запас устойчивости в "малом" по фазе.']);
end
%%
fprintf(fid,'%s\r','\subsection{Модель объекта в виде СС}');

%load_system
name_system = 'sim_object';   %----------------------------- ---------------------------------------------- %имя схемы

%имя фигуры
figure_name = name_system;
figure_file_path=['images/',figure_name];%,'-eps-converted-to'];
figure_file_path = join(figure_file_path);

%перекрестная ссылка
fprintf(fid,'%s\r',['Модель объекта в виде СС представлена на рис. \ref{fig:',figure_name,'}.']);

handle = load_system(name_system);
% Сохранение картинки схемы
prints(name_system,PATH.images); %save to pdf and crop with dos
%закрытие системы
save_system(handle);
close_system(handle);

%fprintf(fid,'%s\r','\begin{wrapfigure}{l}{\linewidth}');
fprintf(fid,'%s\r','\begin{figure}[!h]\centering');
fprintf(fid,'%s','\includegraphics[width=\linewidth]{');
fprintf(fid,'%s}\r',figure_file_path);
fprintf(fid,'%s\r',['\caption{Структурная схема управляемого объекта.}\label{fig:',figure_name,'}']);
fprintf(fid,'%s\r','\end{figure}');
%fprintf(fid,'%s\r','\end{wrapfigure}');
%% 2
fprintf(fid,'%s\r','\subsection{Модель объекта в виде дифференциального уравнения }');

%вставка формулы
%перекрестная ссылка
fprintf(fid,'%s\r',['Уравнение ', ...
                    '\eqref{eq:','dif_object_sym','} записано в символьном виде с параметрами, а ',...
                    '\eqref{eq:','dif_object','} записано с подстановкой значений параметров.']);
                
fprintf(fid,'%s\r',['\begin{equation}\label{eq:','dif_object_sym','}',...
                    '    \left\{',...
                    '    \begin{aligned}',...
                    'p\,\left(T^2\,p^2+2\,h\,T\,p+1\right)\,x&=K\,u&&, \text{ если}|u|\le d\\',...
                    'p\,\left(T^2\,p^2+2\,h\,T\,p+1\right)\,x&=K\,d\,\mathrm{sign}\left(u\right)&&, \text{ если}|u|>d',...
                    '    \end{aligned}',...     
                    '    \right.',...
                    '\end{equation}']); 

%% начальные условия-------------------------------------------------------------------------change
T=InitialConditions.T;
K=InitialConditions.K;
h=InitialConditions.h;
d=InitialConditions.d; 
%%
fprintf(fid,'%s\r',['\begin{equation}\label{eq:','dif_object','}',...
                    '    \left\{',...
                    '    \begin{aligned}',...
                    'p\,\left(',num2str(T^2),'\,p^2+',num2str(2*h*T),'\,p+1\right)\,x&=',num2str(K),'u',...
                    '&&, \text{ если}|u|\le ',num2str(d),'\\',...
                    'p\,\left(',num2str(T^2),'\,p^2+',num2str(2*h*T),'\,p+1\right)\,x&=',num2str(K*d),...
                    '\mathrm{sign}\left(u\right)',...
                    '&&, \text{ если}|u|> ',num2str(d),...
                    '    \end{aligned}',...     
                    '    \right.',...
                    '\end{equation}']);     
%%3
fprintf(fid,'%s\r','\subsection{Модель управляемого объекта в пространстве состояний }');
%вставка формулы
%перекрестная ссылка
fprintf(fid,'%s\r',['Уравнение ', ...
                    '\eqref{eq:','ss_object','} записано с подстановкой значений параметров.']);
                
fprintf(fid,'%s\r',['\begin{equation}\label{eq:','ss_object','}',...
                    '    \left\{',...
                    '    \begin{aligned}',...
                    'x_1&=x , \\ \frac{d\,x_1}{d\,t}&=x_2 ,\\ \frac{d\,x_2}{d\,t}&=x_3,\\',...
                    '\frac{d\,x_3}{d\,t}&=',...
                    '    \left\{',...
                    '    \begin{aligned}',...
                    '-&']);
fprintf(fid,'%.4f\r',1/T^2);
fprintf(fid,'%s\r',['\,x_2-']);
fprintf(fid,'%.4f\r',2*h/T);
fprintf(fid,'%s\r',['\,x_3+']);
fprintf(fid,'%.4f\r',K/T^2);
fprintf(fid,'%s\r',['\,',...
                    'u',...
                    '&&, \text{ если}|u|\le ']);
fprintf(fid,'%.1f\r',d);
fprintf(fid,'%s\r','\\-&');
fprintf(fid,'%.4f\r',1/T^2);
fprintf(fid,'%s\r',['\,x_2-']);
fprintf(fid,'%.4f\r',2*h/T);
fprintf(fid,'%s\r',['\,x_3+']);
fprintf(fid,'%.4f\r',K*d/T^2);
fprintf(fid,'%s\r',['\,',...
                    '\mathrm{sign}\left(u\right)',...
                    '&&, \text{ если}|u|> ']);
fprintf(fid,'%.1f\r',d);
fprintf(fid,'%s\r',['    \end{aligned}',...     
                    '    \right.',...
                    '    \end{aligned}',...     
                    '    \right.',...
                    '\end{equation}']);  
%% Simulink model
name_system = 'sim_object_analysis';        %имя схемы
figure_name = strrep(name_system,'sim_','');%имя графика

fprintf(fid,'%s\r','\subsection{Исследование системы подачей на вход типового воздействия}');
fprintf(fid,'%s\r','Найдём переходную характеристику $h(t)$.');
fprintf(fid,'%s\r','На вход подаём ЕСФ $u=1(t)$');
%перекрестная ссылка
fprintf(fid,'%s\r',['Модель системы в simulink ', ...
                    'представлена на рис. \ref{fig:',name_system,'}.']);
fprintf(fid,'%s\r',['Переходная характеристика объекта по выходной координате и её скорости ', ...
                    'представлена на рис. \ref{fig:',figure_name,'}.']);
fprintf(fid,'%s\r',['Здесь $x,y,x_1,y_1$ --- это соответственно ',...
                    'выходная координата системы с нелинейным элементом, ', ...
                    'скорость изменения выходной координаты системы с нелинейным элементом, ', ...
                    'выходная координата системы без нелинейного элемента, ', ...
                    'скорость изменения выходной координаты без нелинейного элемента.']); 
              
%перенос переменных в основную базу переменных
assignin('base','T',T);
assignin('base','K',K);
assignin('base','h',h);
assignin('base','d',d);

%load_system
handle = load_system(name_system);
%open_system('D:\education\6_sem\nonlinear_control_systems\kursach\matlab\models\object_anal.slx');
assignin('base','end_time',5000);%------------------------------------------------------------------время симуляции1
set_param(handle,'StopTime','end_time' ,'SolverPrmCheckMsg','warning'...
    ,'SolverResetMethod','robust','Solver','ode23','SolverType','Variable-step','InitialStep','10^-1');   

%проходим вхолостую определяя максимальное время регулирования для
%дальнейшей пересимуляции с правильным стоп таймом
%возвращает сигналы в массиве b в порядке согласно номерам портов
[t,s,x,y,x1,y1] = sim(name_system);
assignin('base','y',y);
assignin('base','y1',y1);
assignin('base','t',t);
ST=0.05;RT = [ 0 1 ] ;
S(1)=stepinfo(y,t,'SettlingTimeThreshold',ST,'RiseTimeLimits',RT);
S(2)=stepinfo(y1,t,'SettlingTimeThreshold',ST,'RiseTimeLimits',RT);
end_time = max([S(1).SettlingTime,S(2).SettlingTime]) ; 
assignin('base','end_time',ceil((end_time*2)/500)*500);%------------------------------------------------------------------время симуляции1
set_param(handle,'StopTime','end_time' );

%возвращает сигналы в массиве b в порядке согласно номерам портов
[t,s,x,y,x1,y1] = sim(name_system);
assignin('base','x',x);
assignin('base','y',y);
assignin('base','x1',x1);
assignin('base','y1',y1);
assignin('base','t',t);

% Сохранение картинки схемы
prints(name_system,PATH.images); %save to pdf and crop with dos
%закрытие системы
save_system(handle);
close_system(handle);

%отображение схемы в latex
%fprintf(fid,'%s\r','\begin{wrapfigure}{l}{\linewidth}');
fprintf(fid,'%s\r','\begin{figure}[!h]\centering');
fprintf(fid,'%s','\includegraphics[width=\linewidth]{');
fprintf(fid,'%s}\r',['images/',name_system]);
fprintf(fid,'%s\r',['\caption{Модель системы в simulink.}\label{fig:',name_system,'}']);
fprintf(fid,'%s\r','\end{figure}');
%fprintf(fid,'%s\r','\end{wrapfigure}');
%% График
figure_file_path=['images/',figure_name];%,'-eps-converted-to'];
figure_file_path = join(figure_file_path);

S = Object_graph(x,y,x1,y1,t,PATH,figure_name); % время регулирования

%fprintf(fid,'%s\r','\begin{wrapfigure}{l}{\linewidth}');
fprintf(fid,'%s\r','\begin{figure}[!h]\centering');
fprintf(fid,'%s','\includegraphics[width=\linewidth]{');
fprintf(fid,'%s}\r',figure_file_path);
fprintf(fid,'%s\r',['\caption{Переходная характеристика объекта по выходной координате и её скорости.}\label{fig:',figure_name,'}']);
fprintf(fid,'%s\r','\end{figure}');
%fprintf(fid,'%s\r','\end{wrapfigure}');

%% Выводы по графику
%запись времени регулирования
fprintf(fid,'\r%s\r',['При подаче на вход ступенчатого воздействия выходная координата ',... 
    'теоретически неограниченно возрастает, скорость её изменения также растет, но её рост постепенно замедляется ',...
    'и приходит к установившемуся значению за $t_p=']);
fprintf(fid,'%.0f$\r',S);
key='steady_speed';
fprintf(fid,'%s\r',['секунд. Установившиеся значения скорости указаны в таблице \ref{tab:',key,'}.']);
tex_table2x2(fid,'Установившиеся значения скорости',key,'С НЭ','Без НЭ',num2str(y(length(y)),3),num2str(y1(length(y1)),3));
fprintf(fid,'%s\r',['Заметим также, что эти значения соостветствуют коэффициентам усиления системы с НЭ и без НЭ.']);
fprintf(fid,'\r%s\r',[...
'При этом у системы с нелинейным элементом мгновенные значения выхода и скорости меньше , чем у системы без нелинейного элемента, ' ,...
'потому что НЭ в объектк управления типа <<насыщения>> ограничивает максимальное значение сигнала, подаваемого на следующие за ним линейные звенья.',...
]);
%% обработка файла (замена \frac на \cfraq ) (делаем все дроби крупными)
fclose all; % необходимо для обработки файла , удаление и т.д.
replaceinfile('frac', 'cfrac',file_path,'-nobak');

%% очистка worcspace от мусора
% clc;
% clear ;
% close all;
end