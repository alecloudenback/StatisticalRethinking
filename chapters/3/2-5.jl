using Distributions,StatsBase, Gadfly

n = 1000
p_grid = collect(range(0,stop=1,length=n))

prior = ones(n)

likelihood = map((p) -> pdf(Binomial(9,p),6),p_grid)

posterior = likelihood .* prior

posterior = posterior / sum(posterior)

#posterior grid approximation
plot(x=p_grid,y=posterior,Geom.line)

### Sampling
n_sample = 10000
s =sample(p_grid,ProbabilityWeights(posterior),n_sample)


# density plot
plot(x=s,Geom.density)

sum(posterior[p_grid .< 0.5])
sum(s .< 0.5) /n_sample
sum((s .> 0.5) .& (s .< 0.75 ) ) /n_sample

quantile(s,[0.1, 0.9])

