%% Test so getC works
a = [2, 9, 3];
b = [7, 1, 4, 2];
expected = [2, 5, 1, 3, 1, 2];
assert(all(getC(a,b) == sort(expected,'descend')));
%%


a=[8479, 4868, 3696, 2646, 169, 142];
b=[11968, 5026, 1081, 1050, 691, 184];
c=[8479, 4167, 2646, 1081, 881, 859, 701, 691, 184, 169, 142];

% energy function
EnergyFunction = @(x) sum((c-x).^2./c);

% probability function[
ProbFunction = @(deltaH, beta) exp(-beta*deltaH);

% initialize with random permutation
sigma = randperm(length(a));
my = randperm(length(b));

c_cand = getC(a(sigma), b(my));

% make sure that we have the same number of elements as in c
while (length(c_cand) ~= length(c)) 
    sigma =  randperm(length(a));
    my = randperm(length(b));
end

tmax = 20000;
beta = 0.0001*(1:tmax);
H = zeros(tmax+1,1);
H(1) = EnergyFunction(getC(a(sigma),b(my)));
%
%
for i= 1:tmax
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
%%
H(end)
plot((1:length(H)), H);
xlim([0, tmax])
ylim([0 100])
%% data1
%a=[8479, 4868, 3696, 2646, 169, 142];
%b=[11968, 5026, 1081, 1050, 691, 184];
%c=[8479, 4167, 2646, 1081, 881, 859, 701, 691, 184, 169, 142];
