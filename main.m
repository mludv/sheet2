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
bar([a(sigma); b(mu)], 'stacked')
c-getC(a(sigma), b(mu))
sigma
mu
%% data1
%a=[8479, 4868, 3696, 2646, 169, 142];
%b=[11968, 5026, 1081, 1050, 691, 184];
%c=[8479, 4167, 2646, 1081, 881, 859, 701, 691, 184, 169, 142];
