%% Test so getC works
a = [2, 9, 3];
b = [7, 1, 4, 2];
expected = [2, 5, 1, 3, 1, 2];
assert(all(getC(a,b) == sort(expected,'descend')));

%% Exercise 1a
a=[8479, 4868, 3696, 2646, 169, 142];
b=[11968, 5026, 1081, 1050, 691, 184];
c=[8479, 4167, 2646, 1081, 881, 859, 701, 691, 184, 169, 142];

%%
alpha = 0.00001;
beta = alpha*(1:1000);

tic
runs = 100;
success = zeros(runs, 1);
H = zeros(runs, length(beta));
sigma = zeros(runs, length(a));
mu = zeros(runs, length(b));
for i = 1:runs
    [H(i,:), sigma(i,:), mu(i,:)] = runMetropolis(a, b, c, beta);
    if all(c == getC(a(sigma(i,:)), b(mu(i,:))))
        success(i) = 1;
    end
end
toc

sum(success)

%% plot 1a
index = [81; 58; 69]; %randi(100,3,1);
l = length(beta);
plot(1:l, H(index(1),:), 1:l, H(index(2),:), 1:l, H(index(3),:));
H(index,end)

title('The current energy')
xlabel('Time step')
ylabel('Energy')
%% When the algorithm find H=0
algoStop = zeros(runs, 1);
for i=1:runs
    if find(H(i,:)==0,1)
        algoStop(i) = find(H(i,:)==0,1);
    end
end
mean(algoStop(algoStop ~= 0))

%% Make bar plots
index = 23; %64, 14, 23
aStack = a(sigma(index,:));
bStack = b(mu(index,:));
aStack = [aStack zeros(1, (length(c)-length(a)))];
bStack = [bStack zeros(1, (length(c)-length(b)))];
cStack = getC_unsorted(aStack, bStack);
subplot(1,3,1);
bar([aStack; cStack; bStack], 'stacked')
set(gca, 'XTickLabel', {'a', 'c','b'})
ylabel('Distance from edge')
xlabel('Fragment array')
title('H=0')

%% run data2
a=[9979, 9348, 8022, 4020, 2693, 1892, 1714, 1371, 510, 451];
b=[9492, 8453, 7749, 7365, 2292, 2180, 1023, 959, 278, 124, 85];
c=[7042, 5608, 5464, 4371, 3884, 3121, 1901, 1768, 1590, 959, 899, 707, 702, 510, 451, 412, 278, 124, 124, 85];
%%

alpha = 5*10^(-5);
beta = alpha*(1:200000);

runs = 550;
success = zeros(runs, 1);
H = zeros(runs, length(beta));
sigma = zeros(runs, length(a));
mu = zeros(runs, length(b));
tic
for i = 1:runs
    [H(i,:), sigma(i,:), mu(i,:)] = runMetropolis(a, b, c, beta);
    if all(c == getC(a(sigma(i,:)), b(mu(i,:))))
        success(i) = 1;
    end
end
toc

sum(success)

%% run data2 with feedback 

alpha = 10^(-6);
beta = alpha*(1:200000);

runs = 6;
success = zeros(runs, 1);
H = zeros(runs, length(beta));
sigma = zeros(runs, length(a));
mu = zeros(runs, length(b));

% create initial state
state_sigma = randperm(length(a));
state_mu = randperm(length(b));
c_cand = getC(a(state_sigma), b(state_mu));
% make sure that we have the same number of elements as in c
while (length(c_cand) ~= length(c)) 
    state_sigma =  randperm(length(a));
    state_mu = randperm(length(b));
end

% run the algorithm
bestH = inf;

tic
for i = 1:runs
    [H(i,:), sigma(i,:), mu(i,:), newBestH, new_state_sigma, new_state_mu] ...
        = runMetropolis_startState(a, b, c, beta, state_sigma, state_mu);
    
    % check if we found a new best energy, if that is the case, feed it to 
    % the next iteration
    if (newBestH < bestH)
        state_sigma = new_state_sigma;
        state_mu = new_state_mu;
        bestH = newBestH;
    end
    
    if all(c == getC(a(sigma(i,:)), b(mu(i,:))))
        success(i) = 1;
    end
end
toc

sum(success)
