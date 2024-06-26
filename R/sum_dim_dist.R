sum_dim_dist = function(weighted_dim_dist){
  N = dim(weighted_dim_dist)[3]
  summed_dist = matrix(nrow = nrow(weighted_dim_dist),ncol = N)
  for(d in 1:N){
    if(nrow(weighted_dim_dist)>1){
      summed_dist[,d] = rowSums(weighted_dim_dist[,,d])
    }else{
      summed_dist[,d] = sum(weighted_dim_dist[,,d])
    }
  }
  summed_dist
}
