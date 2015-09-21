function [ H, sigma, my ] = runMetropolis( a, b, c, beta )
%RUNMETROPOLIS Summary of this function goes here
%   Detailed explanation goes here

% energy function
EnergyFunction = @(x) sum((c-x).^2./c);

% initialize with random permutation
sigma = randperm(length(a));
my = randperm(length(b));

c_cand = getC(a(sigma), b(my));

% make sure that we have the same number of elements as in c
while (length(c_cand) ~= length(c)) 
    sigma =  randperm(length(a));
    my = randperm(length(b));
end

tmax = length(beta);
H = zeros(tmax,1);
H(1) = EnergyFunction(getC(a(sigma),b(my)));


for i= 1:tmax-1
    tmp_my = my;
    tmp_sigma = sigma;
    
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

