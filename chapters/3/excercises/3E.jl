using Distributions,StatsBase, Optim

n_grid = 10^4
p_grid = collect(range(0,stop=1,length=n_grid))

prior = ones(n_grid)

likelihood = map((p) -> pdf(Binomial(9,p),6),p_grid)

posterior = prior .* likelihood
posterior /= sum(posterior)

n_sample = 10^4
s =sample(p_grid,ProbabilityWeights(posterior),n_sample)

#3E1
sum(s .< 0.2) / n_sample 

#3E2
sum(s .> 0.8) / n_sample

#3E3
sum((s .< 0.8) .& (s .> 0.2)) / n_sample

#3E4
quantile(s,0.2)
quantile(s,0.8)

