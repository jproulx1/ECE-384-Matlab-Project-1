X=rand(1,100000)<0.488;
Y=ones(1,100000);
X2=rand(1,100000)<0.4787;
Y2=ones(1,100000);

zeroCount2 = 0;
zeroCount = 0;
% Counting number of 0r when 0s
oneCount2 = 0;
oneCount = 0;
% counting number of 1r when 1s
for i=1:100000
    if X2(i)==0
        Y2(i)= X2(i) + rand(1)<0.025;
    elseif X2(i) == 1
        Y2(i) = X2(i)*(rand(1)<0.9579);
    end
    
    if (X2(i) == 1) && (Y2(i) == 1)
        oneCount2 = oneCount2 + 1;
    elseif (X2(i) == 0) && (Y2(i) == 0)
        zeroCount2 = zeroCount2 + 1;
    end
end
for i=1:100000
    if X(i)==0
        Y(i)= X(i) + rand(1)<0.025;
    elseif X(i) == 1
        Y(i) = X(i)*(rand(1)<0.975);
    end
    if (X(i) == 1) && (Y(i) == 1)
        oneCount = oneCount + 1;
    elseif (X(i) == 0) && (Y(i) == 0)
        zeroCount = zeroCount + 1;
    end
end

X1 = sum(X(X==1));
X0 = length(X(X==0));

Y1 = sum(Y(Y==1));
Y0 = length(Y(Y==0));

X21 = sum(X2(X2==1));
X20 = length(X2(X2==0));

Y21 = sum(Y2(Y2==1));
Y20 = length(Y2(Y2==0));

%Pr[error] = Pr[0r|1s]*Pr[1s] + Pr[1r|0s]*Pr[0s]

Perror = 1-(zeroCount+oneCount)/100000;
P0s0r = zeroCount/Y0;
P1s1r = oneCount/Y1;

Perror2 = 1-(zeroCount2+oneCount2)/100000;
P0s0r2 = zeroCount2/Y20;
P1s1r2 = oneCount2/Y21;
