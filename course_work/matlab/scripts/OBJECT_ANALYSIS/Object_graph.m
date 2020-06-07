function Settlingtime = Object_graph(x,y,x1,y1,tout,PATH,name_system)
% строит графики и возвращает вектор с временнем регулирования
%% Интерпретатот текста, по умолчанию, latex
  set(0,'DefaultTextInterpreter', 'none');

% %не нужно, т.к. шрифт автоматически настраивается латехом
 set(0,'DefaultAxesFontSize',14,'DefaultAxesFontName','Times New Roman');%шрифт
 set(0,'DefaultTextFontSize',14,'DefaultTextFontName','Times New Roman'); %

%fig = myfigures(17,20);
fig=figure('Units', 'normalized', 'OuterPosition', [0 0 1 1],'PaperOrientation','Landscape');

ST=0.05;RT = [ 0 1 ] ;
S(1)=stepinfo(y,tout,'SettlingTimeThreshold',ST,'RiseTimeLimits',RT);
S(2)=stepinfo(y1,tout,'SettlingTimeThreshold',ST,'RiseTimeLimits',RT);
Settlingtime = S(1).SettlingTime ;
subplot(1,2,1);
%------------координаты линии времени регулирования линию
for i=1:length(y1)
    Set(i)=S(1).SettlingTime;
end
Step = y1(length(y1))/(length(y1));
Ymax(1) = 0;
for i=2:length(y1)
    Ymax(i)=Step+Ymax(i-1);
end
for i=1:length(y1)
    y1settl(i)=0.95*y1(length(y1));
end
for i=1:length(y1)
    ysettl(i)=0.95*y(length(y));
end
for i=1:length(y1)
    ymax(i)=y(length(y));
end
for i=1:length(y1)
    y1max(i)=y1(length(y));
end
%------------------------
Cellp{1}=plot(tout,y,'black-',tout,y1,'black--',Set,Ymax,'black--',...
    tout,y1settl,'black--',tout,ysettl,'black--',...
    tout,y1max,'black--',tout,ymax,'black--');grid on, title('ПХ по скорости')

xlabel('$t$,sec','Interpreter','latex','FontSize',14),ylabel('$$y(X)=\frac{d\,X}{d\,t}$$','Interpreter','latex','FontSize',14)
legend( ['ПХ по скорости с нелинейным элементом' ]...
    ,['ПХ по скорости без нелинейного элемента'],...
    'Location','southoutside','Box','off' )  
%settl
txt = ['$$ t_{p}$$'];   
text(S(1).SettlingTime,-6*Step,txt,'Interpreter','latex');
txt = ['$$y_{max}$$'];   
text((tout(length(tout)))/16,(y(length(y))-4*Step),txt,'Interpreter','latex');
txt = ['$$y_{1max}$$'];   
text((tout(length(tout)))/16,(y1(length(y))-4*Step),txt,'Interpreter','latex');
txt = ['0.95$$\cdot y_{max}$$'];   
text((tout(length(tout)))/16,(0.95*y(length(y))-6*Step),txt,'Interpreter','latex');
txt = ['0.95$$\cdot y_{1max}$$'];   
text((tout(length(tout)))/16,(0.95*y1(length(y))-6*Step),txt,'Interpreter','latex');

subplot(1,2,2);
Cellp{2}=plot(tout,x,'black-',tout,x1,'black--',Set,Ymax,'black--');grid on,title('ПХ по выходу')
xlabel('$$t\mbox{,sec}$$','Interpreter','latex','FontSize',14),ylabel('$$X$$','Interpreter','latex','FontSize',14)
legend('ПХ по выходу с нелинейным элементом','ПХ по выходу без нелинейного элемента'...
    ,'Location','southoutside','Box','off')

for a=1:2
   p = Cellp{a};
   p(1).LineWidth = 2;
   p(2).LineWidth = 2;
end

p = Cellp{1};
p(3).LineWidth = 1;
p(4).LineWidth = 1;
p(5).LineWidth = 1;
p(6).LineWidth = 1;
p(7).LineWidth = 1;

prints(name_system,PATH.images); %save to pdf and crop with dos  

close(fig); %закрываем , чтобы не засорять память

%open ([PATH.images,name_system,'.pdf']);

end 
