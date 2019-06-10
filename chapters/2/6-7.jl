# this has a little too much "automagic", but I think in this section of the
# book is trying to illustrate that there is another way to arrive at a similar
# estimate for the parameter (θ in this case)

using Turing
using StatsPlots, Distributions

# import MCMCChains because it has an unexported plots function to plot
# the sample results nicely
using MCMCChains

sample_scale = 1
k = 6 * sample_scale # k succeses
n = 9 * sample_scale # n trials

@model globe_toss(n,k) = begin
    θ ~ Beta(1,1) # prior
    k ~ Binomial(n,θ) # model
    return k, θ
end

c = sample(globe_toss(n,k),NUTS(2000,1000,0.65))

describe(c)

MCMCChains.plot(c[:θ]) # plot the sample iterated values
