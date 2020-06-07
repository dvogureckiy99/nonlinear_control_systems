function str=sym_to_matlabFunction(param,sym)
%преобразует символьное выражение
%в тип matlabFunction
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%имена переменных хранятся в param 
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    str = char(sym);
    %парсинг
    str=replace(str,param{1},'x(1)');
    str=replace(str,param{2},'x(2)');
    str = str2func(['@(x) ',str]);
end
