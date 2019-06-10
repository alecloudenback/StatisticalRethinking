using Distributions
using Gadfly

# Chapter 2, code 2-5

"""
`n` is the number of grid points
`prior` is the initial distirbution assumed
`p_grid` is the range for which your model operates
`likelihood_function is the model you are testing for each point in the grid`
"""
function plot_grid_approx(n,prior,p_grid,likelihood_function)

    # computer likelihood at each value in the grid
    likelihood = [likelihood_function(p) for p in p_grid]

    # compute product of likelihood and prior
    unstandardized_posterior = prior .* likelihood

    #standardize the posterior to sum to 1
    posterior = unstandardized_posterior ./ sum(unstandardized_posterior)

    plot(x=p_grid,y=posterior,Geom.line)

end


n = 20
p_grid = range(0,stop=1,length=n)
prior = ones(n)

likelihood = (p) -> pdf(Binomial(9,p),6)

plot_grid_approx(n,prior,p_grid,likelihood)

plot_grid_approx(n,[x > 0.5 for x in p_grid],p_grid,likelihood)

plot_grid_approx(n,[exp( -5*abs( p - 0.5 ) ) for p in p_grid],p_grid,likelihood)
