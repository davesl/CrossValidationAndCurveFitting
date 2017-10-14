function y = piecewiseLine2(x,a,b,c,d)
% PIECEWISELINE   A line made of two pieces
% that is not continuous.

y = zeros(size(x));

k=(a-c)/(d-b);

% This example includes a for-loop and if statement
% purely for example purposes.
for i = 1:length(x)
    if x(i) < k,
        y(i) = a + b.* x(i);
    else
        y(i) = c + d.* x(i);
    end
end
end