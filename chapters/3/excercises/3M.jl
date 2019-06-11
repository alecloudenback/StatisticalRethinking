using Distributions, Gadfly, StatsBase


#3M1
p_grid = collect(range(0,stop=1,length=1000))

prior = ones(length(p_grid))

likelihood = (p) -> pdf(Binomial(9,p),6)

posterior = prior .* map(likelihood,p_grid)
posterior = posterior ./ sum(posterior)

plot(y=posterior, x=p_grid,Geom.line)


#3M2
# not sure easy way to do this without a more advanced stats package...

#3M3

samples = sample(p_grid,ProbabilityWeights(posterior),10^6,replace=true)

w = map((p) -> rand(Binomial(15,p)),samples)

sum(w .== 8) / length(w)

#3M4

w = map((p) -> rand(Binomial(9,p)),samples)

sum(w .== 6) / length(w)

#3M5
#3M5.1
p_grid = collect(range(0,stop=1,length=1000))

prior = [p > 0.5 ? 2 : 0 for p in p_grid]

likelihood = (p) -> pdf(Binomial(9,p),6)

posterior = prior .* map(likelihood,p_grid)
posterior = posterior ./ sum(posterior)

plot(y=posterior, x=p_grid,Geom.line)


#3M2
# not sure easy way to do this without a more advanced stats package...

#3M3

samples = sample(p_grid,ProbabilityWeights(posterior),10^6,replace=true)

w = map((p) -> rand(Binomial(15,p)),samples)

sum(w .== 8) / length(w)

#3M4

w = map((p) -> rand(Binomial(9,p)),samples)

sum(w .== 6) / length(w)