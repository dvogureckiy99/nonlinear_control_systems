function [w,A,FIGS] = find_param(PATH,InitialConditions,k)
%находит амплитуду и частоту колеьаний

    %имя и путь графика для Latex
    % фазовые траектории
    figure_name = 'relay_find_param';%имя графика
    figure_file_path=['images/',figure_name];% путь к графику
    figure_file_path = join(figure_file_path);
    FIGS.names{1} = figure_name ;
    FIGS.path{1}=figure_file_path;
    FIGS.description{1}=' . Определение параметров автоколебательного режима методом гармонического баланса.';
    
    Cellfig{1} = figure('Units', 'normalized', 'OuterPosition', [0 0 1 1],'PaperOrientation','Landscape');
    Cellfigparam{1}{1}='k-';
    Cellfigparam{1}{2}=2;
%% начальные условия-------------------------------------------------------------------------change
T=InitialConditions.T;
K=InitialConditions.K;
h=InitialConditions.h;
d=InitialConditions.d;
%% вывод ХП 
syms p w real;
u= k(1) + k(2)*p ;
den=(T^2*p^3+2*h*T*p^2+p) ;
W=K*u/den;
W1=-1/W
W1=subs(W1,p,1i*w)
re=simplify(real(W1))
im=simplify(imag(W1))
fprintf('%s',['-\frac{1}{W(j*w)}=',latex(re),latex(im),'\,j']);
%% solve
syms w ;
assume(w > 0);
w = double(solve(im,w))
syms A;
Wne=4/(pi*A)*(sqrt(1-(d/A)^2));
A = double(solve(Wne-double(subs(re,'w',w)),A))
%% graphic
step=w/100;
wz=0:step:w;
rele=double(subs(re,'w',wz));
imle=double(subs(im,'w',wz));

hold on,grid on
plot(rele,imle,Cellfigparam{1}{1},'LineWidth',Cellfigparam{1}{2});
xlabel('Re'),ylabel('Im')

step=(min(A)-d)/100;
Az=d:step:min(A)+step;
rene=double(subs(Wne,'A',Az));
imne=zeros(length(rene));
plot(rene,imne,Cellfigparam{1}{1},'LineWidth',Cellfigparam{1}{2});

prints(FIGS.names{1},PATH.images,Cellfig{1}); %save to pdf and crop with dos
close(Cellfig{1}); %закрываем , чтобы не засорять память
    
end
