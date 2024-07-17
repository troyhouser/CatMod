one_hot = function(features,feature_variants){
  output_list = list()
  for (i in 1:length(features)) {
    dim_vector = rep(0, feature_variants[i])
    dim_vector[ features[i] ] = 1
    output_list[[i]] = dim_vector
  }
  return(output_list)
}

dim_distance = function(stim_dim, cluster_dim) {
  difference = abs(stim_dim - cluster_dim)
  distance = sum(difference)/2
  return(distance)
}

cluster_activation = function(distances, lambdas, r) {
  numerator = sum( (lambdas^r) * exp(-lambdas*distances) )
  denominator = sum( (lambdas^r) )
  activation = numerator/denominator
  return(activation)
}

find_winning_cluster = function(activations) {
  winner_index = which(activations == max(activations))
  return(winner_index[1]) # take the first one in case there are ties
}

cluster_output = function(activations, beta) {
  winner = find_winning_cluster(activations)
  output = rep(0, length(activations))
  winning_output = ((activations[winner]^beta)/sum(activations^beta)) * activations[winner]
  output[winner] = winning_output
  return(output)
}

response_unit_output = function(cluster_outputs, weights){
  response_unit_outputs = cluster_outputs %*% weights
  return(response_unit_outputs)
}

response_probabilities = function( queried_unit_outputs, d){
  numerators = exp(d * queried_unit_outputs)
  denominator = sum(numerators)
  probabilities = numerators/denominator
  return(probabilities)
}

forward_pass = function(sustain,stimulus,queried_dimensions,present_dimensions,unsupervised=F){
  queried_indices = rep(list(NA),length(queried_dimensions))
  for(i in 1:length(queried_dimensions)){
    first_queried_index = ifelse(queried_dimensions[i] == 1, 1,sum(lengths(stimulus)[1:(queried_dimensions[i]-1)]) + 1)
    last_queried_index = sum(lengths(stimulus)[1:(queried_dimensions[i])])
    dimension_indices = first_queried_index:last_queried_index
    queried_indices[[i]] = dimension_indices
  }
  if(length(sustain$clusters)==0){
    if(unsupervised==T){
      return_list = list(Hout=NA,distances=NA,Hact=NA,winner_index=NA,Cout=NA)
      return(return_list)
    }
    probabilities = rep(NA,sum(lengths(stimulus)))
    for(i in 1:length(queried_dimensions)){
      dimension_probabilities = rep(1/lengths(stimulus[queried_dimensions[i]]),lengths(stimulus[queried_dimensions[i]]))
      probabilities[queried_indices[[i]]] = dimension_probabilities
    }
    return_list = list(probabilities=probabilities,Hout=NA,distances=NA,winner_index=NA,Cout=NA)
    return(return_list)
  }

  present_lambdas = sustain$lambdas[present_dimensions]
  activations = rep(NA,length(sustain$clusters))
  cluster_distances = matrix(nrow=length(sustain$clusters),ncol=length(stimulus))
  for(cluster_index in 1:length(sustain$clusters)){
    distances = rep(NA,length(stimulus))
    for(dimension_index in 1:length(stimulus)){
      distances[dimension_index] = dim_distance(stimulus[[dimension_index]],sustain$clusters[[cluster_index]][[dimension_index]])
    }
    cluster_distances[cluster_index,] = distances
    activations[cluster_index] = cluster_activation(distances[present_dimensions],present_lambdas,sustain$r)
  }

  winner_index = find_winning_cluster(activations)
  outputs = cluster_output(activations,sustain$beta)
  response_outputs = response_unit_output(outputs,sustain$weights)

  if(unsupervised==T){
    return_list = list( Hout = outputs[winner_index], distances = cluster_distances[winner_index,],Hact = activations[winner_index], winner_index=winner_index, Cout = response_outputs )
    return(return_list)
  }

  probabilities = rep(NA, sum(lengths(stimulus)))
  for (i in 1:length(queried_dimensions)) {
    queried_outputs = response_outputs[,queried_indices[[i]]]
    queried_probabilities = response_probabilities(queried_outputs, sustain$d)
    probabilities[queried_indices[[i]]] = queried_probabilities
  }
  return_list = list( probabilities = probabilities, Hout = outputs[winner_index], distances = cluster_distances[winner_index,], winner_index=winner_index, Cout = response_outputs )
  return(return_list)
}

adjust_cluster = function(cluster, stimulus, eta) {
  differences = mapply('-', stimulus, cluster, SIMPLIFY = FALSE)
  deltas = lapply(differences, '*', eta)
  new_cluster = mapply('+', cluster, deltas, SIMPLIFY = FALSE)
  return(new_cluster)
}

adjust_lambdas = function(lambdas, distances, eta) {
  new_lambdas = lambdas + (eta * exp(-lambdas*distances) * (1-lambdas*distances))
  return(new_lambdas)
}

adjust_weights = function(weights, feedback, response_unit_output, cluster_output, eta) {
  new_weights = weights + (eta * (feedback - response_unit_output) * cluster_output)
  return(new_weights)
}
humble_teacher = function(output, feedback) {
  adjusted_feedback = rep(NA, length(feedback))
  for(i in 1:length(feedback)){
    if (feedback[i] == 0) {
      adjusted_feedback[i] = min(output[i], 0)
    }
    else {
      adjusted_feedback[i] = max(output[i], 1)
    }
  }
  return(adjusted_feedback)
}

update_sustain = function(sustain,stimulus,queried_dimensions,present_dimensions,trial_output,unsupervised=F){
  queried_indices = rep(list(NA),length(queried_dimensions))
  for(i in 1:length(queried_dimensions)) {
    first_queried_index = ifelse(queried_dimensions[i] == 1, 1, sum(lengths(stimulus)[1:(queried_dimensions[i]-1)]) + 1)
    last_queried_index = sum(lengths(stimulus)[1:(queried_dimensions[i])])
    dimension_indices = first_queried_index:last_queried_index
    queried_indices[[i]] = dimension_indices
  }
  form_new_cluster=FALSE
  if (length(sustain$clusters)==0) {
    form_new_cluster = TRUE
  }
  else {
    if (unsupervised==TRUE) {
      if (trial_output$Hact < sustain$tau) {
        form_new_cluster = TRUE
      }
    }
    else {
      accuracy = rep(NA, length(queried_dimensions))
      for(i in 1:length(accuracy)) {
        queried_probabilities = trial_output$probabilities[queried_indices[[i]]]
        queried_dimension = stimulus[[queried_dimensions[i]]]
        max_probability_index = which(queried_probabilities == max(queried_probabilities))[1]
        correct_index = which(queried_dimension == 1)
        accuracy[i] = ifelse(max_probability_index == correct_index, 1, 0)
      }
      if(any(accuracy == 0)) {
        form_new_cluster = TRUE
      }
    }
  }
  if (form_new_cluster) {
    sustain$clusters = c( sustain$clusters, list(stimulus))
    sustain$weights = as.matrix(rbind(sustain$weights, rep(0, sum(lengths(stimulus)))))
    trial_output = forward_pass(sustain, stimulus, queried_dimensions, present_dimensions, unsupervised=unsupervised)
  }
  sustain$clusters[[trial_output$winner_index]] = adjust_cluster(sustain$clusters[[trial_output$winner_index]], stimulus, sustain$eta)
  sustain$lambdas = adjust_lambdas(sustain$lambdas, trial_output$distances, sustain$eta)
  if (unsupervised) {
    queried_columns = 1:sum(lengths(stimulus))
  }
  queried_columns = unlist(queried_indices)
  feedback = humble_teacher(trial_output$Cout[queried_columns], unlist(stimulus[queried_dimensions]))
  sustain$weights[trial_output$winner_index, queried_columns] = adjust_weights(sustain$weights[trial_output$winner_index, queried_columns], feedback, trial_output$Cout[queried_columns], trial_output$Hout, sustain$eta)
  return(sustain)
}

get_likelihood = function(stimuli,responses,queried_dimensions,present_dimensions,sustain,return_sustain=T){
  likelihood = 0
  for(i in 1:length(stimuli)){
    trial_output = forward_pass(sustain,stimuli[[i]],queried_dimensions[[i]],present_dimensions[[i]],unsupervised = F)
    trial_responses = responses[[i]]
    queried_indices = rep(list(NA),length(queried_dimensions[[i]]))
    for(j in 1:length(queried_dimensions[[i]])){
      first_queried_index = ifelse(queried_dimensions[[i]][j] == 1, 1, sum(lengths(stimuli[[i]])[1:(queried_dimensions[[i]][j]-1)]) + 1)
      last_queried_index = sum(lengths(stimuli[[i]])[1:(queried_dimensions[[i]][j])])
      dimension_indices = first_queried_index:last_queried_index
      queried_indices[[j]]= dimension_indices
    }
    trial_likelihoods = rep(NA,length(queried_dimensions[[i]]))
    for(j in 1:length(trial_likelihoods)){
      queried_probabilities = trial_output$probabilities[queried_indices[[j]]]
      response_likelihood = queried_probabilities[trial_responses[j]]
      trial_likelihoods[j] =  -(log(response_likelihood))
    }
    full_likelihood = sum(trial_likelihoods)
    sustain = update_sustain(sustain,stimuli[[i]],queried_dimensions[[i]],present_dimensions[[i]],trial_output)
    likelihood = full_likelihood + likelihood
  }
  if(return_sustain){
    return(list(sustain,likelihood))
  }
  assign("sustain",sustain,envir=.GlobalEnv)
  return(likelihood)
}

optimizer = function(pars,stimuli,resp,queried_list,present_list){

  #for(i in 1:length(pars)){
  #  pars[i] = abs(pars[i])
  #  if(pars[i] > 30){
  #    pars[i] = 30 / (1+exp(-pars[i]))
  #  }
  #}

  sustain_start = list(r = pars[1],beta = pars[2], d = pars[3],eta = pars[4],
                      clusters = list(),
                      lambdas = rep(1,length(coded_stimuli[[1]])),
                      weights = NULL)
  full_likelihood = get_likelihood(stimuli,resp,queried_list,present_list,sustain_start,return_sustain = F)
  full_likelihood
}

