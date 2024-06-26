sum_similarities = function(perceived_sim,labels,categories){
  sims = matrix(nrow = nrow(perceived_sim),ncol = length(categories))
  for(i in 1:length(categories)){
    sims[,i] = rowSums(perceived_sim[,which(labels == categories[i])])
  }
  sims
}
