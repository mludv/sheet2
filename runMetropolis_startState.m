function [ H, sigma, my, best_H, best_sigma, best_my ] = runMetropolis_startState( a, b, c, beta, sigma, my )
%RUNMETROPOLIS A version of metropolis where you can feed the initial state
% It also returns the best values of sigma and mu

% energy function
EnergyFunction = @(x) sum((c-x).^2./c);

c_cand = getC(a(sigma), b(my));

% make sure that we have the same number of elements as in c
assert(length(c_cand) == length(c))

tmax = length(beta);
H = zeros(tmax,1);
H(1) = EnergyFunction(getC(a(sigma),b(my)));

best_H = inf;
best_sigma = zeros(1, length(a));
best_my = zeros(1, length(a));

for i= 1:tmax-1
    tmp_my = my;
    tmp_sigma = sigma;
    
    % Update the saved best values
    if (best_H > H(i)) 
        best_H = H(i);
        best_sigma = sigma;
        best_my = my;
    end
    
    % Check if we already found the minimum
    if (H(i) == 0)
        break;
    end
    
    % change one element in either my or sigma, skipping elements 
    if randi(2) == 1    
        I = datasample(tmp_my, 2, 'Replace', false);
        tmp_my(I) = fliplr(tmp_my(I));
    else
        I = datasample(tmp_sigma, 2, 'Replace', false);
        tmp_sigma(I) = fliplr(tmp_sigma(I));
    end
    
    % calculate c
    c_cand = getC(a(tmp_sigma), b(tmp_my));
    
    % check so c has the correct length
    if (length(c_cand) ~= length(c)) 
        H(i+1) = H(i);
        continue;
    end
    
    % calculate next energy
    Hnext = EnergyFunction(c_cand);
    
    % check if we accept the move
    probAccept = exp(-(Hnext - H(i))*beta(i));
    if (Hnext < H(i) || rand < probAccept)
        H(i+1) = Hnext;
        sigma = tmp_sigma;
        my = tmp_my;
    else
        H(i+1)=H(i);
    end
end
end

