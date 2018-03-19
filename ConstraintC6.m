function [AC6,bC6] = ConstraintC6(dv, recap, it, capacity, delta, num_flights)

numdv=length(dv(:,1)); 
AC6 = zeros(num_flights,numdv);

for i=1:numdv
    
    i_recap = dv(i,1);
    itp = recap(i_recap,1)+1;
    itr = recap(i_recap,2)+1;
    b = recap(i_recap,3);
    
    AC6(:,i) = -(delta(:,itp)-b*delta(:,itr));
end

    bC6 = -(delta*it(:,2)-capacity);
end

    
    
    