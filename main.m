%% Test so getC works
a = [2, 9, 3];
b = [7, 1, 4, 2];
expected = [2, 5, 1, 3, 1, 2];
assert(all(getC(a,b) == sort(expected,'descend')));
%%
a=[8479, 4868, 3696, 2646, 169, 142];
b=[11968, 5026, 1081, 1050, 691, 184];
c=[8479, 4167, 2646, 1081, 881, 859, 701, 691, 184, 169, 142];

alpha = 0.001;
beta = alpha*(1:1000);

[H, sigma, mu] = runMetropolis(a, b, c, beta);

H(end)
plot((1:length(H)), H);
xlim([0, tmax])
ylim([0 500])
%%


a=[8479, 4868, 3696, 2646, 169, 142];
b=[11968, 5026, 1081, 1050, 691, 184];
c=[8479, 4167, 2646, 1081, 881, 859, 701, 691, 184, 169, 142];
%%
alpha = 0.00001;
beta = alpha*(1:10000);

tic
success = zeros(100, 1);
for i = 1:100
    [H, sigma, mu] = runMetropolis(a, b, c, beta);
    if all(c == getC(a(sigma), b(mu)))
        success(i) = 1;
    end
end
toc

sum(success)
%%
a=[9979, 9348, 8022, 4020, 2693, 1892, 1714, 1371, 510, 451];
b=[9492, 8453, 7749, 7365, 2292, 2180, 1023, 959, 278, 124, 85];
c=[7042, 5608, 5464, 4371, 3884, 3121, 1901, 1768, 1590, 959, 899, 707, 702, 510, 451, 412, 278, 124, 124, 85];

alpha = 0.00001;
beta = alpha*(1:100000);

[H, sigma, mu] = runMetropolis(a, b, c, beta);

H(end)
plot((1:length(H)), H);
xlim([0, tmax])
ylim([0 500])
%%
bar([a(sigma); b(mu)], 'stacked')
c-getC(a(sigma), b(mu))
sigma
mu
%% data1
%a=[8479, 4868, 3696, 2646, 169, 142];
%b=[11968, 5026, 1081, 1050, 691, 184];
%c=[8479, 4167, 2646, 1081, 881, 859, 701, 691, 184, 169, 142];
