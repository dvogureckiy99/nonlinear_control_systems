function str=sym_to_matlabFunction(param,sym)
%����������� ���������� ���������
%� ��� matlabFunction
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%����� ���������� �������� � param 
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    str = char(sym);
    %�������
    str=replace(str,param{1},'x(1)');
    str=replace(str,param{2},'x(2)');
    str = str2func(['@(x) ',str]);
end