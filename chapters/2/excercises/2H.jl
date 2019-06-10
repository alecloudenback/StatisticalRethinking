# 2H1 ################

# [single, twins]
a_prob = [0.9,0.1]
b_prob = [0.8,0.2]

prior = [1, 1] #equally likely [a,b]

likelihood = [a_prob[2],b_prob[2]]

posterior_pre = prior .* likelihood
posterior = posterior_pre ./ sum(posterior_pre)

sum(likelihood .* posterior) # likelihood of second birth being twins

# 2H2 ################

prior = [1, 1] #equally likely [a,b]

likelihood = [a_prob[2],b_prob[2]]

posterior_pre = prior .* likelihood
posterior = posterior_pre ./ sum(posterior_pre)

posterior[1] # likelihood of species a

# 2H3 ###############

prior = posterior

likelihood = [a_prob[1],b_prob[1]]

posterior_pre = prior .* likelihood
posterior = posterior_pre ./ sum(posterior_pre)

posterior[1] # likelihood of species a

final_birth_posterior = posterior


# 2H4 ###############

# test only

prior = [1,1]

likelihood = [0.8,0.35]

posterior_pre = prior .* likelihood
posterior = posterior_pre ./ sum(posterior_pre)

posterior[1]

# combine with data (ie prob 2 + 3)

prior = final_birth_posterior

likelihood = [0.8,0.35]

posterior_pre = prior .* likelihood
posterior = posterior_pre ./ sum(posterior_pre)

posterior[1]
