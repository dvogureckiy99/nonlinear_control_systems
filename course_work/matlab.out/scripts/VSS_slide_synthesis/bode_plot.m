function [FIGS,marg]=bode_plot(PATH,InitialConditions,param)

 set(0,'DefaultAxesFontSize',14,'DefaultAxesFontName','Times New Roman');%шрифт
     set(0,'DefaultTextFontSize',14,'DefaultTextFontName','Times New Roman'); %
 
T=InitialConditions.T;
K=InitialConditions.K;
h=InitialConditions.h;
    
    %имя и путь графика для Latex
    figure_name = ['Bode_diagram_alpha'];%имя графика
    figure_file_path=['images/',figure_name];% путь к графику
    figure_file_path = join(figure_file_path);
    FIGS.names{1} = figure_name ;
    FIGS.path{1}=figure_file_path;
    FIGS.description{1}=' Логарифмические частотные характеристики разомкнутой системы с $\alpha$';
    
    figure_name = ['Bode_diagram_beta'];%имя графика
    figure_file_path=['images/',figure_name];% путь к графику
    figure_file_path = join(figure_file_path);
    FIGS.names{2} = figure_name ;
    FIGS.path{2}=figure_file_path;
    FIGS.description{2}=' Логарифмические частотные характеристики разомкнутой системы с $\beta$';
    
    a=param(3);
    b=param(4);
    
    wl = tf([K],[T^2 2*h*T 1 0]);
    w{1} = a*wl;
    w{2} = b*wl;
    Cellfig{1} = figure('Units', 'normalized', 'OuterPosition', [0 0 1 1],'PaperOrientation','Landscape');
    Cellfig{2} = figure('Units', 'normalized', 'OuterPosition', [0 0 1 1],'PaperOrientation','Landscape');
    
    
    for i=1:2
        figure(Cellfig{i});%target figure
        margin(w{i});
        [Gm,Pm,~,Wcp] = margin(w{i}) ;
        marg{i}=[20*log10(Gm),Pm,Wcp];
    end
    
    prints(FIGS.names{1},PATH.images,Cellfig{1}); %save to pdf and crop with dos
    prints(FIGS.names{2},PATH.images,Cellfig{2}); %save to pdf and crop with dos
    close(Cellfig{1}); %закрываем , чтобы не засорять память
    close(Cellfig{2}); %закрываем , чтобы не засорять память
end
