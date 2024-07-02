weight_dim_dist = function(exp_dim_dist,attention_weights){
  N = dim(exp_dim_dist)[3]
  weighted_dist = array(dim = c(dim(exp_dim_dist)))
  for(i in 1:N){
    for(j in 1:nrow(exp_dim_dist)){
      weighted_dist[j,,i] = exp_dim_dist[j,,i] * attention_weights
    }
  }
  weighted_dist
}

