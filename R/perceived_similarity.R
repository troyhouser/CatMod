perceived_similarity = function(stim_dist,sensitivity){
  exp(-sensitivity * stim_dist)
}
