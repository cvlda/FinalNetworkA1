
function legs = OperatedFlights(F, X, k)

i0 = sum([F(1:k-1).nL])+1;
in = sum([F(1:k).nL]);

legs = F(k).L'.*X(i0:in);

end