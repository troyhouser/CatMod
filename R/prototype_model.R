prototype_model = function(pars){
  sensitivity = pars[1]
  if(length(pars) == (ncol(prototypes) + 1)){
    attention_weights = pars[2:(length(pars))]
    gamma = 1
  }else if(length(pars) == (ncol(prototypes) + 2)){
    attention_weights = pars[2:(length(pars)-1)]
    gamma = pars[length(pars)]
  }

  if(length(unique(c(prototypes))) != 2){
    r = 2
  }else{
    r = 1
  }

  n_cat = nrow(prototypes)
  categories = LETTERS[1:n_cat]
  dim_dist = dim_dist(prototypes,stimuli)
  exp_dim_dist = exp_dim_dist(dim_dist,r)
  weighted_dim_dist = weight_dim_dist(exp_dim_dist,attention_weights)
  summed_dist = sum_dim_dist(weighted_dim_dist)
  stim_dist = stimulus_distance(summed_dist,r)
  perceived_sim = perceived_similarity(stim_dist,sensitivity)
  probabilities = category_probabilities(perceived_sim,gamma)

  lik = 0
  for(i in 1:n_cat){
    lik = lik + probabilities[,i] * (resp == categories[i])
  }
  lik[lik==0] = .Machine$double.xmin
  sum(-log(lik),na.rm=T)
}
