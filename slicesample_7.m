function [x_out] =  slicesample_7(x,siz,N,x0,y,ind_2,ind_34,kid)
x_out  = zeros(siz,N);
w=x0;
for ii = 1:N
    L  = x0; 
    R  = x0; 
    x1 = x0;
    % Update one dimension at a time
    for d = 1:siz 
        yy = LogPost7(x,x0,y,ind_2,ind_34,kid) + log(rand(1));
        L(d) = x0(d) - rand(1)*w(d);
        R(d) = L(d) + w(d);
        % Increae the interval
        j = floor(N*rand(1)); 
        k = (N-1)-j;          
        while yy < LogPost7(x,L,y,ind_2,ind_34,kid) && j>0
            % Extend the lower limit L
            L(d) = L(d) - w(d);
            j = j -1;
        end
        while yy < LogPost7(x,R,y,ind_2,ind_34,kid) && k>0
            % Extend the uppr limit L
            R(d) = R(d) + w(d);
            k = k -1;
        end
        while 1
            % Select a random number form the interval
            x1(d) = L(d) + rand(1)*(R(d)-L(d));
            if yy <= LogPost7(x,x1,y,ind_2,ind_34,kid)
                x0(d) = x1(d);
                break
            elseif x1(d)<=x0(d)
                L(d) = x1(d);
            else %x1(d)>x0(d)
                R(d) = x1(d);
            end
        end
    end
    x_out(:,ii) = x1;
end

end