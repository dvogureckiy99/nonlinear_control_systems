function graph_variable_structure1(x,y,t,PATH,figure_name)
%������ ������
 set(0,'DefaultAxesFontSize',14,'DefaultAxesFontName','Times New Roman');%�����
 set(0,'DefaultTextFontSize',14,'DefaultTextFontName','Times New Roman'); %
 
fig=figure('Units', 'normalized', 'OuterPosition', [0 0 1 1],'PaperOrientation','Landscape');
 
p(1)=plot(x,y,'black-');grid on
xlabel('x'),ylabel('y(x)=dx/dt')
% legend( ['�� �� �������� � ���������� ���������' ]...
%     'Location','southoutside','Box','off' ) 

p(1).LineWidth = 2;

prints(figure_name,PATH.images); %save to pdf and crop with dos 
close(fig); %��������� , ����� �� �������� ������
%open ([PATH.images,figure_name,'.pdf']);

end