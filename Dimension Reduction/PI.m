function [vec,value]=PI(x,A,it)
for a = 1:10
    xn = A*x;
    [l,i] =  max(abs(xn));
    l = xn(i);
    x = xn/l;
    %fprintf('n = %4d lambda = %g x = %g %g %g \n', a, l, x');
end
vec = x;
value = l;
end
