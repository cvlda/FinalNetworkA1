function PrintSolution1a(K,nK, fin, N)


% Table only non null f

j=0; % counter for fin
t = 1; % counter writing in table
for k=1:nK


np = length(K(k).P);

for i=1:np
    if fin(j+i)~=0
        lengthp = length(K(k).P(i).path);
        pathl = N{K(k).P(i).path(1)};
        for p=2:lengthp
            pathl = [pathl,', ',N{K(k).P(i).path(p)}];
        end
        Path{t}=pathl;
        Commodity(t) = k;
        f(t) = fin(j+i);
        t=t+1;
    end
end
j=j+np;
end




T = table(Commodity', Path', f');


writetable(T)


end