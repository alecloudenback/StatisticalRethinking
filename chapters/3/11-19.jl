using Distributions,StatsBase, Gadfly

## 3.11 onwards

n = 1000
p_grid = collect(range(0,stop=1,length=n))

prior = ones(n)

likelihood = map((p) -> pdf(Binomial(3,p),3),p_grid)

posterior = likelihood .* prior

posterior = posterior / sum(posterior)

### Sampling
n_sample = 10000
s =sample(p_grid,ProbabilityWeights(posterior),n_sample)

quantile(s,[0.25, 0.75])

p_grid[argmax(posterior)] # MAP

mode(s),mean(s),median(s)

abs_loss = (x) -> sum(posterior .* abs.(x .- p_grid) ) # minimized at median
quad_loss = (x) -> sum(posterior .* (x .- p_grid) .^ 2 ) # minimized at mean

plot(
    layer(y=map(abs_loss, p_grid), x= p_grid,Geom.line), 
    layer(y=map(quad_loss, p_grid), x= p_grid,Geom.line)
    )