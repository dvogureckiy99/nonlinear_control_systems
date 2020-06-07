function [C1, C2, alpha, betta , iter , time ] = choose_coeff(InitialConditions,mn) 
    %% начальные условия-------------------------------------------------------------------------change
    T=InitialConditions.T;
    K=InitialConditions.K;
    h=InitialConditions.h;
    d=InitialConditions.d;

    syms p Psi ;
    u=Psi ;
    disp('        (T^2*p^2+2*h*T*p+1)+K*u ');
    D=(T^2*p^3+2*h*T*p^2+p)+K*u ;
    disp('           D/(T^2)');
    D=collect(D,p);
    D=D/(T^2);
    D=collect(D,p);
    vpa(D,3)
    Dp=coeffs(D,p);

    a=double([0 Dp(2) Dp(3)]);
    b=double(Dp(1)/Psi)
    e=[-1 2*a(3) -(a(3)^2+a(2)) a(2)*a(3) ]/b ;

    % выбор праметров 
    mode = 'fast'; %----------------------------------------------------режим slow -- с комментариями fast --- без
    max_inter=10; %---------------------------------------------------------количество итераций максимальное
    %mn=[2,0.5]; %----------------------------------------------------change множитель у alpha и  betta соотв.
    near=0;
    far=1; %----------------------------------------------------------начало интервалов
    step=1; %-----------------------------------------------------------------------длинна интервала
    iter=1;
    IT=0;
    n=2;
    find=1;
    tic;
    switch mode
        case 'slow'
        while ((n>1)||(IT==0))
            %выбор C1
            fprintf('\r\r%s',['итерация номер ',num2str(iter)]);
           %if mod(iter,2)~=0
              near=far;
              far=far+step;
           %end
           %выбор случайного числа из интервала
           inter=[near far];
           fprintf('\rинтервал=[%f %f]\r',inter);
           C2=rand*(inter(2)-inter(1))+inter(1);
           %---------------------------------
           C1=C2^2-a(3)*C2+a(2);
           if ~(sign(C1)+1)
              fprintf('С1<0 --- условие устойичвости в скользящем режиме не выполнено завершаем итерацию '); 
              iter=iter+1;
              continue
           end
           f=e(1)*C2^3+e(2)*C2^2+e(3)*C2+e(4);

            alpha=f+abs(mn(1)*f);
            betta=f-abs(mn(2)*f);
           %проверка устойчивости
           psiv=(-C1*(C2-a(3)))/b;
           D1=subs(D,Psi,psiv);
           pv=double(solve(D1,p));
           n=0;
           for i=1:length(pv)
               if real(pv(i))>0
                n=n+1;
               end
           end
           if n>1
              fprintf('корни полинома с %u корнями с положительной вещественной частью. Условие устойичвости в скользящем режиме не выполнено \r',n);
           else
               fprintf('корни полинома с одним корнем с положительной вещественной частью. Условие устойичвости в скользящем режиме выполнено \r');
           end
           fprintf('%f%+fi\r', [real(pv), imag(pv)].');
           %---------------------------
           %проверка попадания изображающей точки на плоскои=сть скольжения
           psiv=alpha;
           D1=subs(D,Psi,psiv);
           pv=double(solve(D1,p));
           IT=1;

           for i=1:length(pv)
               %fprintf('real(pv)=%.4f\r',real(pv(i)));
               if pv(i)==real(pv(i))
                  if real(pv(i))>=0
                      IT=0;
                  end
               end
           end
           if IT
               fprintf('%s\r','Неотрицательные действительные корни отсутствуют. Условие попадания изображающей точки на плоскость скольжения выполнено '); 
           else
               fprintf('%s\r','Есть неотрицательные действительные корни. Условие попадания изображающей точки на плоскость скольжения не выполнено ');
           end
           fprintf('%f%+fi\r', [real(pv), imag(pv)].');
           %------------------------------------------------------------------
           fprintf('[C1 C2 alpha>f>betta]=[%f %f %f>%f>%f]',[C1,C2,alpha,f,betta]);
           if iter>max_inter, find=0; break,else, find=1; end
           iter=iter+1;
        end
        case 'fast'
        while ((n>1)||(IT==0))
            fprintf('\r%s',['итерация номер ',num2str(iter)]);
            %выбор C1
              near=far;
              far=far+step;
           %выбор случайного числа из интервала
           inter=[near far];
           C2=rand*(inter(2)-inter(1))+inter(1);
           %---------------------------------
           C1=C2^2-a(3)*C2+a(2);
           if ~(sign(C1)+1)
              iter=iter+1;
              continue
           end
           f=e(1)*C2^3+e(2)*C2^2+e(3)*C2+e(4);
            alpha=f+abs(mn(1)*f);
            betta=f-abs(mn(2)*f);
           %проверка устойчивости
           psiv=(-C1*(C2-a(3)))/b;
           D1=subs(D,Psi,psiv);
           pv=double(solve(D1,p));
           n=0;
           for i=1:length(pv)
               if real(pv(i))>0
                n=n+1;
               end
           end
           %---------------------------
           %проверка попадания изображающей точки на плоскои=сть скольжения
           psiv=alpha;
           D1=subs(D,Psi,psiv);
           pv=double(solve(D1,p));
           IT=1;

           for i=1:length(pv)
               %fprintf('real(pv)=%.4f\r',real(pv(i)));
               if pv(i)==real(pv(i))
                  if real(pv(i))>=0
                      IT=0;
                  end
               end
           end
           %------------------------------------------------------------------
           if iter>max_inter, find=0; break,else, find=1; end
           iter=iter+1;
        end
    end
    time=toc;
    
    %непонятная вещь, которую необходимо сделать, чтобы получить скольжение
    C2=C2*3;
    
    if find
        fprintf('\r\r%s',['Имеем устойчивое движение в скользящем режиме с попаданием изображающей точки на плоскость скольжения. Итераций = ',num2str(iter-1)]);
        %fprintf('\r%s\r', '     C1           C2           alpha             betta'); 
        fprintf(' \r[ C1=%f ; C2=%f ; alpha=%f ; betta=%f ] \r', C1 , C2, alpha,betta);
        fprintf('\r  время на выполнение программы %.0f sec',time);
        fprintf('\r');
        %param = [ C1,  C2, alpha, betta ]
    else
        fprintf('\r\r%s',['Параметры, удовлетворяющие условиям не найдены. Итераций = ',num2str(iter)]);
        fprintf('\r  время на выполнение программы %.0f sec',time);
        fprintf('\r');
    end

end
