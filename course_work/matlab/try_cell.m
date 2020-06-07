clc
clear

% syms x y
% eq = [1.1 > x+y > 0.9, -1.1 < x^2 + y < -0.9 ];
% [solx, params, conds] = solve(eq, x, 'ReturnConditions', true)
% SolutionCorrect = subs(eq, x, solx)
% assume(conds)
% isAlways(SolutionCorrect)


options = optimset('PlotFcns',@optimplotfval);
x0=[5 5];
syms x y
%fun1=@(x)(x(1)+x(1)^2+2*x(2))^2;
r1 = x+x^2+2*y;
r2 = r1^2;
r = r1 + r2;
param{1}='x';
param{2}='y';
fun = sym_to_matlabFunction(param,r1^2);

    
%fun=matlabFunction(r, 'vars', [x y])
% [x ,y] = meshgrid(-15:15,-80:1:10);
% z=abs(x+x.^2+2.*y);
% surf(x,y,z);
% shading interp

k1 = fminunc(fun,x0,options) 
%k1 = fminsearch(fun,[x0(1),x0(2)],options) 
%k1 = solve([conds, params > 5], params)
%k1 = solve([conds, params > 5], params)
%subs(solx, params, k1)
%[solx1, params1, conds1] = solve([eq, x > -5, x < 5], x, 'ReturnConditions', true)
fun(k1)
% function out=fun(z)
%     out= [z(1)+z(2)-1,...
%         z(1)-z(2)+1];
% end