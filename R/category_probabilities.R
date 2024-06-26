category_probabilities = function(perceived_sim,gamma = 1){
  probs = matrix(nrow = nrow(perceived_sim),ncol = ncol(perceived_sim))
  for(i in 1:nrow(perceived_sim)){
    for(j in 1:ncol(perceived_sim)){
      probs[i,j] = (perceived_sim[i,j]^gamma) / (sum(perceived_sim[i,]^gamma))
    }
  }
  probs
}
