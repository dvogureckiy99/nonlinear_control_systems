clc
clear
close all
%% начальные условия-------------------------------------------------------------------------change
T=29;
K=19;
h=4;
d=0.5;
a=47;
b=-35;
C1=0.76;
C2=11;
k1=3;
k2=40;
ds=1;
x0=-10;
y0=0;
z0=0;
name_system = 'mod1';
handle = load_system(name_system); %загрузка схемы
set_param(handle ,'SolverPrmCheckMsg','warning'...
    ,'SolverResetMethod','robust','Solver','ode113','SolverType','Fixed-step',...
    'SaveFormat','Array','SaveOutput','off','ReturnWorkspaceOutputs','off');
[t,~,x,y,z] = sim(name_system);
assignin('base','x',x);
assignin('base','y',y);
assignin('base','z',z);
Cellfigparam{1}{1}='k-';
Cellfigparam{1}{2}=2;
Cellfig{1} = figure('Units', 'normalized', 'OuterPosition', [0 0 1 1],'PaperOrientation','Landscape');
Cellfig{2} = figure('Units', 'normalized', 'OuterPosition', [0 0 1 1],'PaperOrientation','Landscape');
Cellfig{3} = figure('Units', 'normalized', 'OuterPosition', [0 0 1 1],'PaperOrientation','Landscape');
Cellfig{4} = figure('Units', 'normalized', 'OuterPosition', [0 0 1 1],'PaperOrientation','Landscape');
Cellfig{5} = figure('Units', 'normalized', 'OuterPosition', [0 0 1 1],'PaperOrientation','Landscape');

figure(Cellfig{1});%target figure
plot(x,y,Cellfigparam{1}{1},'LineWidth',Cellfigparam{1}{2});grid on, hold on
leg2{1} =['$x_0=',num2str(x(1),3),',y_0=',num2str(y(1),3),',z_0=',num2str(z(1),3),'$'] ;
legend(leg2,'Interpreter','latex','Location','southoutside');
xlabel('$$x$$','Interpreter','latex'),ylabel('$$y(x)=\frac{d\,x}{d\,t}$$','Interpreter','latex');
plot(x(1),y(1),'kx','MarkerFaceColor','k','MarkerSize',10);grid on, hold on

figure(Cellfig{2});%target figure
subplot(3,1,1);
plot(t,z,Cellfigparam{1}{1},'LineWidth',Cellfigparam{1}{2});grid on,hold on ;  
xlabel('$$t$$,sec','Interpreter','latex'),ylabel('$$z(x)=\frac{d^2\,x}{d\,t^2}$$','Interpreter','latex')
subplot(3,1,2);
plot(t,y,Cellfigparam{1}{1},'LineWidth',Cellfigparam{1}{2});grid on,hold on ;
xlabel('$$t$$,sec','Interpreter','latex'),ylabel('$$y(x)=\frac{d\,x}{d\,t}$$','Interpreter','latex')
subplot(3,1,3);
plot(t,x,Cellfigparam{1}{1},'LineWidth',Cellfigparam{1}{2});grid on,hold on ;  
xlabel('$$t$$,sec','Interpreter','latex'),ylabel('$$x$$','Interpreter','latex')

figure(Cellfig{3});%target figure
plot3(x,y,z,Cellfigparam{1}{1},'LineWidth',Cellfigparam{1}{2});grid on,hold on ;
plot3(x(1),y(1),z(1),'kx','MarkerFaceColor','k','MarkerSize',10);grid on, hold on
xlabel('$$x$$','Interpreter','latex'),ylabel('$$y(x)=\frac{d\,x}{d\,t}$$','Interpreter','latex'),zlabel('$$z(x)=\frac{d^2\,x}{d\,t^2}$$','Interpreter','latex')

x0=-100;
[t,~,x,y,z] = sim(name_system);
assignin('base','x',x);
assignin('base','y',y);
assignin('base','z',z);
figure(Cellfig{4});%target figure
plot(x,y,Cellfigparam{1}{1},'LineWidth',Cellfigparam{1}{2});grid on, hold on
leg2{1} =['$x_0=',num2str(x(1),3),',y_0=',num2str(y(1),3),',z_0=',num2str(z(1),3),'$'] ;
legend(leg2,'Interpreter','latex','Location','southoutside');
xlabel('$$x$$','Interpreter','latex'),ylabel('$$y(x)=\frac{d\,x}{d\,t}$$','Interpreter','latex');
plot(x(1),y(1),'kx','MarkerFaceColor','k','MarkerSize',10);grid on, hold on

figure(Cellfig{5});%target figure
subplot(3,1,1);
plot(t,z,Cellfigparam{1}{1},'LineWidth',Cellfigparam{1}{2});grid on,hold on ;  
xlabel('$$t$$,sec','Interpreter','latex'),ylabel('$$z(x)=\frac{d^2\,x}{d\,t^2}$$','Interpreter','latex')
subplot(3,1,2);
plot(t,y,Cellfigparam{1}{1},'LineWidth',Cellfigparam{1}{2});grid on,hold on ;
xlabel('$$t$$,sec','Interpreter','latex'),ylabel('$$y(x)=\frac{d\,x}{d\,t}$$','Interpreter','latex')
subplot(3,1,3);
plot(t,x,Cellfigparam{1}{1},'LineWidth',Cellfigparam{1}{2});grid on,hold on ;  
xlabel('$$t$$,sec','Interpreter','latex'),ylabel('$$x$$','Interpreter','latex')