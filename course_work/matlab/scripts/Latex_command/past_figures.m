function past_figures(fid,FIGS,width)
%вставка необходимых рисунков в tex файл
disp('Обработка past figures');
%% вставка всех картинок
count_figs=length(FIGS.names);
    for i=1:count_figs
        figure_name=FIGS.names{i};
        figure_path=FIGS.path{i};
        description=FIGS.description{i};
        if length(width)>1
            tex_past_figure(fid,figure_path,figure_name,description,width(i));
        else
            tex_past_figure(fid,figure_path,figure_name,description,width);
        end
    end
end