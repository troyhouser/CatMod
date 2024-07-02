dim_dist = function(category_representations,stimuli){
  stimuli = as.matrix(stimuli)
  dist = array(dim = c(nrow(stimuli),ncol(stimuli),nrow(category_representations)))
  for(i in 1:nrow(stimuli)){
    for(j in 1:nrow(category_representations)){
      dist[i,,j] = abs(stimuli[i,] - category_representations[j,])
    }
  }
  dist
}
