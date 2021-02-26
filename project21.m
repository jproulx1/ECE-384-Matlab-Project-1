%% Joshua Proulx, Kaitlyn Hartm, and Christopher Gravelle -- Matlab Project 1
format compact, clc, clear, close all

% Number of bits being transmitted through channel
numBits = [5e3 10e3 20e3 50e3 100e3 500e3 1e6 5e6];

% Given probabilites
Pr_0r0s = 0.975;
Pr_1r1s = [Pr_0r0s 0.9579];
Pr_1r0s = 0.025;
Pr_0r1s = [Pr_1r0s 0.0421];
Pr_0s = [0.512 0.5213];
Pr_1s = [0.488 0.4787];

%% Theoretical Probability Calculations

% Pr[0s|0r] = (Pr[0r|0s]*Pr[0s]) / (Pr[0r|0s]*Pr[0s] + Pr[0r|1s]*Pr[1s])
TheorPr_0s0r = (Pr_0r0s.*Pr_0s) ./ (Pr_0r0s.*Pr_0s + Pr_0r1s.*Pr_1s);

% Pr[1s|1r] = (Pr[1r|1s]*Pr[1s]) / (Pr[1r|1s]*Pr[1s] + Pr[1r|0s]*Pr[0s])
TheorPr_1s1r = (Pr_1r1s.*Pr_1s) ./ (Pr_1r1s.*Pr_1s + Pr_1r0s.*Pr_0s);

% Pr[error] = Pr[1s]*Pr[0r|1s] + Pr[0s]*Pr[1r|0s]
TheorPr_error = Pr_1s.*Pr_0r1s + Pr_0s.*Pr_1r0s;

%% Apply binary channel and Compute Probability Estimates

% - Outtermost for-loop iterates over different length bit sequences
% - middle for-loop performs 2 iterations for symmetric and non-symmetric
% channels
% - innermost for-loop iterates through the transmitted bits and applies
% channel properties

for k = 1:length(numBits)
    for j = 1:2
        % X ia random vector being transmitted over the channel
        X = rand(1,numBits(k)) < Pr_1s(j);
        % Y is vector of ones to be filled with the received bit stream
        Y=ones(1,numBits(k));

        % X2=rand(1,100000)<0.4787;
        % Y2=ones(1,100000);


        % Counting number of 0r when 0s
        zeroCount = 0;
        % counting number of 1r when 1s
        oneCount = 0;

        for i=1:numBits(k)
            % if the transmitted bit is a 0
            if X(i)== 0
                % 0 sent flips to 1 received with Pr[1r|0s]
                Y(i)= X(i) + (rand(1) < Pr_1r0s);
            % if the transmitted bit is a 1
            elseif X(i) == 1
                % 1 sent flips to 0 received with Pr[0r|1s]
                Y(i) = X(i) * (rand(1) < Pr_1r1s(j));
            end
            if (X(i) == 1) && (Y(i) == 1)
                % number of 1's sent AND received
                oneCount = oneCount + 1;
            elseif (X(i) == 0) && (Y(i) == 0)
                % number of 0's sent AND received
                zeroCount = zeroCount + 1;
            end
        end

        % Compute Probability Estimates

        % Number of times a 0 is sent AND received over number of times 0 is
        % received
        Pr_0s0r(k,j) = zeroCount / length(Y(Y==0));

        % Number of times a 1 is sent AND received over the number of times 1 is
        % received
        Pr_1s1r(k,j) = oneCount / length(Y(Y==1));

        % Complement of success
        % 1 - [(number of times 0 sent AND received + number of times 1 sent AND
        % received) / nummber of bits transmitted]
        Pr_error(k,j) = 1-((zeroCount+oneCount)/numBits(k));
        clear X Y;
    end
end