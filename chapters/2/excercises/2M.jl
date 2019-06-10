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

# 2M1.1
n = 20
p_grid = range(0,stop=1,length=n)
prior = ones(n)

likelihood = (p) -> pdf(Binomial(3,p),3)

plot_grid_approx(n,prior,p_grid,likelihood)

# 2M1.2
likelihood = (p) -> pdf(Binomial(4,p),3)

plot_grid_approx(n,prior,p_grid,likelihood)

# 2M1.3
likelihood = (p) -> pdf(Binomial(7,p),5)

plot_grid_approx(n,prior,p_grid,likelihood)

# 2M2 #################
prior = [x > 0.5 ? 1 : 0 for x in p_grid] / sum([x > 0.5 ? 1 : 0 for x in p_grid])

likelihood = (p) -> pdf(Binomial(3,p),3)

plot_grid_approx(n,prior,p_grid,likelihood)

# 2M1.2
likelihood = (p) -> pdf(Binomial(4,p),3)

plot_grid_approx(n,prior,p_grid,likelihood)

# 2M1.3
likelihood = (p) -> pdf(Binomial(7,p),5)

plot_grid_approx(n,prior,p_grid,likelihood)

# 2M3 ##################
p_land_given_earth = 0.30
p_land_given_mars = 1.0

prob_earth_given_land = (p_land_given_earth * 0.5) /
    mean([p_land_given_earth, p_land_given_mars])

# 2M4 ##################

# [ww,wb,bb]
prior = [1,1,1]
likelihood = [0,1,2]

posterior = prior .* likelihood / sum(likelihood)

posterior[3]  # probability of BB card

# 2M5 ##################

# [ww,wb,bb,bb]
prior = [1,1,1,1]
likelihood = [0,1,2,2]

posterior = prior .* likelihood / sum(likelihood)

posterior[3] + posterior[4]   # probability of BB card

# 2M6 ##################

# [ww,wb,bb]
prior = [1,1,1]

#relative chance of black *  relative likelihood of pulling card
likelihood = [0 * 3,1 * 2 , 2 * 1]

posterior = prior .* likelihood / sum(likelihood)

posterior[3]   # probability of BB card

# 2M6 ##################
# [ww,wb,bb]
prior = [1,1,1]

# ways for first card to be black * ways for second card to be white
likelihood = [0 * 1, 1 * 2, 2 * 3]

posterior = prior .* likelihood / sum(likelihood)

posterior[3]   # probability of BB card
