using Distributions, StatsBase, Gadfly

#3.20
pdf(Binomial(2,0.7),0:2)

#3.21
rand(Binomial(2,0.7),1) 

#3.22
rand(Binomial(2,0.7),10) 

#3.23
dummy_w = rand(Binomial(2,0.7),10^5)
proportionmap(dummy_w)

#3.24
dummy_w = rand(Binomial(9,0.7),10^5)
plot(x=dummy_w,Geom.histogram)

#3.25

# from 3.2-3.3
n_grid = 1000
p_grid = collect(range(0,stop=1,length=n_grid))

prior = ones(n_grid)

likelihood = map((p) -> pdf(Binomial(9,p),6),p_grid)

posterior = likelihood .* prior

posterior = posterior / sum(posterior)

#posterior grid approximation
plot(x=p_grid,y=posterior,Geom.line)

### Sampling
n_sample = 1*10^5
s =sample(p_grid,ProbabilityWeights(posterior),n_sample)

w = map((p) -> rand(Binomial(9,p)),s)


# bonus comparative histograms
set_default_plot_size(21cm, 20cm)
vstack(
    plot(
        x=w,
        Geom.histogram(bincount=10, density=true),
        Guide.title("predictive distribution with parameter uncertainty")
        ),
    plot(x=rand(
        Binomial(9,argmax(posterior) / n_grid), # p = posterior mode estimate
        n_sample),
        Geom.histogram(bincount=10, density=true),
        Guide.title("predictive distribution only using posterior mode")
        )
    )
