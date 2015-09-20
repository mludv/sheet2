%% Test so getC works
a = [2, 9, 3];
b = [7, 1, 4, 2];
expected = [2, 5, 1, 3, 1, 2];
assert(all(getC(a,b) == expected));
%%


a=[8479, 4868, 3696, 2646, 169, 142];
b=[11968, 5026, 1081, 1050, 691, 184];

% energy function
c_real = sort(expected);
EnergyFunction = @(x) sum((c_real-x).^2./c_real);

% probability function
ProbFunction = @(deltaH, beta) exp(-beta*deltaH);

% initialize with random permutation
sigma = randperm(length(a));
my = randperm(length(b));

% make sure that we have the same number of elements as in c
while (length(getC(a(sigma), b(my))) ~= length(c_real)) 
    sigma =  randperm(length(a));
    my = randperm(length(b));
end

%
beta = linspace(0,1,100000);
H = EnergyFunction(sort(getC(a(sigma),b(my))));
%
for i= 1:length(beta)
    tmp_my = my;
    tmp_sigma = sigma;
    
    % Check if we already found the minimum
    if (H == 0)
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
    c = getC(a(tmp_sigma), b(tmp_my));
    
    % check so c has the correct length
    if (length(c) ~= length(c_real)) 
        continue;
    end
    
    % calculate next energy
    Hnext = EnergyFunction(c);
    
    
    % check if we accept the move
    if (Hnext < H || rand < ProbFunction(Hnext - H, beta(i)))
        H = Hnext
        sigma = tmp_sigma;
        my = tmp_my;
    end
end


%% data1
%a=[8479, 4868, 3696, 2646, 169, 142];
%b=[11968, 5026, 1081, 1050, 691, 184];
%c=[8479, 4167, 2646, 1081, 881, 859, 701, 691, 184, 169, 142];
