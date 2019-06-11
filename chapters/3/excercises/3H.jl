using Distributions, Gadfly,StatsBase


# from https://github.com/rmcelreath/rethinking/blob/1def057174071beb212532d545bc2d8c559760a2/data/homeworkch3.R
birth1 = [1,0,0,0,1,1,0,1,0,1,0,0,1,1,0,1,1,0,0,0,1,0,0,0,1,0,
0,0,0,1,1,1,0,1,0,1,1,1,0,1,0,1,1,0,1,0,0,1,1,0,1,0,0,0,0,0,0,0,
1,1,0,1,0,0,1,0,0,0,1,0,0,1,1,1,1,0,1,0,1,1,1,1,1,0,0,1,0,1,1,0,
1,0,1,1,1,0,1,1,1,1]
birth2 = [0,1,0,1,0,1,1,1,0,0,1,1,1,1,1,0,0,1,1,1,0,0,1,1,1,0,
1,1,1,0,1,1,1,0,1,0,0,1,1,1,1,0,0,1,0,1,1,1,1,1,1,1,1,1,1,1,1,1,
1,1,1,0,1,1,0,1,1,0,1,1,1,0,0,0,0,0,0,1,0,0,0,1,1,0,0,1,0,0,1,1,
0,0,0,1,1,1,0,0,0,0]


#3H1
p_grid = collect(range(0,stop=1,length=1000))

prior = ones(length(p_grid))

likelihood = map((p) -> pdf(Binomial(200,p),sum(birth1) + sum(birth2)),p_grid)

posterior = prior .* likelihood

posterior = posterior ./ sum(posterior)

plot(x=p_grid,y=posterior,Geom.line)

argmax(posterior)/ length(posterior)

#3H2

samples = sample(p_grid,ProbabilityWeights(posterior),10^5,replace = true)

# don't know how to easily calculate HDPI in julia, but interval is very symmeteric, so 
# will just calculate central quantiles

quantile(samples,[0.25,0.75])
quantile(samples,[1- 0.89,0.89])
quantile(samples,[1- 0.97,0.97])

#3H3

w = map((p) -> rand(Binomial(200,p)), samples)

plot(x=w,Geom.histogram) # yes, this looks like 111 is smack dab in the middle

#3H4
sum(birth1)
w = map((p) -> rand(Binomial(100,p)), samples) 
plot(x=w,Geom.histogram) # the distribution looks slightly to the right of birth1 count

#3H5 

p_grid = collect(range(0,stop=1,length=1000))

prior = ones(length(p_grid))

likelihood = map((p) -> pdf(Binomial(200,p),sum(birth1 .== 0)),p_grid)

posterior = prior .* likelihood

posterior = posterior ./ sum(posterior)

plot(x=p_grid,y=posterior,Geom.line)

argmax(posterior)/ length(posterior)

samples = sample(p_grid,ProbabilityWeights(posterior),10^5,replace = true)

w = map((p) -> rand(Binomial(100,p)), samples)

sum(birth2[birth1 .==0]) #39
plot(x=w,Geom.histogram) #center is ~25, model is not a good fit