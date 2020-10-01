### A Pluto.jl notebook ###
# v0.11.14

using Markdown
using InteractiveUtils

# ╔═╡ 90332eae-0110-11eb-3c2c-21f97ebe588c
begin
	using DataFrames
	using Plots,StatsPlots, MCMCChains
	using Turing
	using Pipe
	using PlutoUI
	using StatsFuns
end

# ╔═╡ 4b0044c0-0383-11eb-335a-25a9ce6f48aa
md"# Bayesian analyisis of claims experience


A set of claims experience is developed using arbitrary (but to the model, unknown) assumptions. 

Using Turing.jl, a Hamiltonial Monte Carlo No U-Turn Sampler fits logistic regression to the data. 

Using the chains and esimating using fixed conditions, the parameters of interest (e.g.the factor of preferred vs standard risks) is dervied.

Questions to explore further: 

- Extending the anaylsis to include `band`
- How to derive the `band` factors where one is not a unit multiple? That is, the `:Pref` class multiple is derived assuming that the `:Std` factor is `1.0`. 
- abstracting the task of sampling from the posterior and deriving the multiples
- What is the meaning of the posterior sampled distirbuion? Is it sensitive to the number of samples (trials or binomial exposures)?
"

# ╔═╡ 69e7f360-0383-11eb-080e-8f8948f427e1


# ╔═╡ 70d72fe0-010f-11eb-1b1e-23d3e5857072
function gen_data(p,n)
	base_q = 0.001
	class = ifelse.(rand(n) .<0.4,:Pref,:Std)
	band = ifelse.(rand(n) .<0.7,:Low,:High)
	
	true_q = base_q .*
				ifelse.(class .== :Pref,0.9,1.0) .*
				ifelse.(class .== :Low, 1.25,.85)
	deaths = rand(n) .< true_q
	
	df = DataFrame(
		deaths=deaths,
		exposures=ones(n),
		class= class,
		class_i= (class .== :Pref) .+ 1,
		band= band,
		band_i= (band .== :Low) .+ 1
	)
end

# ╔═╡ 580f3520-0182-11eb-139c-0b5a09e170dd
n = 1_000_000

# ╔═╡ d7e7c1e0-02b8-11eb-1fef-737d7e0fd634
experience_data = gen_data(0.001,n)

# ╔═╡ 62060bc0-0110-11eb-0f89-3b73ad24e364
data = @pipe experience_data |>
			groupby(_,[:class,:class_i,:band,:band_i]) |>
			combine(_,:deaths=>sum => :deaths,:exposures=>sum =>:exposures)
		

# ╔═╡ 892e5940-0111-11eb-1baa-714a3ec52fec
@pipe groupby(data,:class) |>
		combine([:deaths,:exposures] => (d,e) -> (deaths = sum(d), exposures=sum(e),rate=sum(d) / sum(e)),_)

# ╔═╡ 20a0566e-0383-11eb-2732-75e7f91a8809


# ╔═╡ 7437b1be-0248-11eb-1ba6-6dc1355fa45d
sum(data.deaths)/sum(data.exposures)

# ╔═╡ 8797445e-0257-11eb-374f-753d05c6cc91
@model mortality2(data) = begin
	base_q = 0.002
	class ~ filldist(Normal(0,5),length(unique(data.class_i)))
# 	band ~ filldist(Normal(0,5),length(unique(data.band_i)))
	exp_factor ~  Normal(0,5)
	
		
	p = logistic.(base_q .* exp_factor .* class[data.class_i]) # .+ class[data.band_i]) 
	
	
	data[:,:deaths] .~ Binomial.(data[:,:exposures],p)
end

# ╔═╡ de0dbe1e-02b9-11eb-212e-35833c41b349
chain2 = sample(mortality2(data), NUTS(0.65), 3_000)

# ╔═╡ 246d7d60-02ba-11eb-3744-53d8e4e7a455
corner(chain2)

# ╔═╡ 56a82000-02bf-11eb-2343-a7d9365274c5
md"can recover the claims experience:"

# ╔═╡ 4e5e5630-02ba-11eb-3a48-3da44f7fe4a4
logistic(mode(chain2[Symbol("class[1]")])*mode(chain2[:exp_factor])*0.002),logistic(mode(chain2[Symbol("class[2]")])*mode(chain2[:exp_factor])*0.002)

# ╔═╡ 511b9da0-030b-11eb-3d9f-cf08484216c0
post_pred_std = rand.(Binomial.(10000,
	logistic.(chain2[Symbol("class[1]")] .* chain2[:exp_factor]*0.002)),1000)

# ╔═╡ a14a6050-0382-11eb-3229-ebbad8e9f91b
post_pred_pref = rand.(Binomial.(10000,
	logistic.(chain2[Symbol("class[2]")] .* chain2[:exp_factor]*0.002)),1000)

# ╔═╡ 4a299e60-0384-11eb-2974-33eb17d919b6
md"This shows the estimate for the `:Pref` factor. 

*Note: Uncertain about if the distribution is meaningul or just the point estimate?*"

# ╔═╡ ef254f30-030d-11eb-144d-8948cf860b55
density(mean.(post_pred_pref) ./ mean.(post_pred_std)  )

# ╔═╡ Cell order:
# ╟─4b0044c0-0383-11eb-335a-25a9ce6f48aa
# ╠═90332eae-0110-11eb-3c2c-21f97ebe588c
# ╠═69e7f360-0383-11eb-080e-8f8948f427e1
# ╠═70d72fe0-010f-11eb-1b1e-23d3e5857072
# ╠═d7e7c1e0-02b8-11eb-1fef-737d7e0fd634
# ╠═580f3520-0182-11eb-139c-0b5a09e170dd
# ╠═62060bc0-0110-11eb-0f89-3b73ad24e364
# ╠═892e5940-0111-11eb-1baa-714a3ec52fec
# ╠═20a0566e-0383-11eb-2732-75e7f91a8809
# ╠═7437b1be-0248-11eb-1ba6-6dc1355fa45d
# ╠═8797445e-0257-11eb-374f-753d05c6cc91
# ╠═de0dbe1e-02b9-11eb-212e-35833c41b349
# ╠═246d7d60-02ba-11eb-3744-53d8e4e7a455
# ╟─56a82000-02bf-11eb-2343-a7d9365274c5
# ╠═4e5e5630-02ba-11eb-3a48-3da44f7fe4a4
# ╠═511b9da0-030b-11eb-3d9f-cf08484216c0
# ╠═a14a6050-0382-11eb-3229-ebbad8e9f91b
# ╟─4a299e60-0384-11eb-2974-33eb17d919b6
# ╠═ef254f30-030d-11eb-144d-8948cf860b55
