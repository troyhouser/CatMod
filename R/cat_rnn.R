cat_rnn = function(type,epochs = 100, sim_subjects = 20, learning_rate = .1, n_hidden_units = 10){
  stimuli = matrix(c(1,1,1,
                     1,1,0,
                     1,0,1,
                     1,0,0,
                     0,0,0,
                     0,0,1,
                     0,1,0,
                     0,1,1),ncol=3,byrow=T)
  if(type == 1){
    labels = c("A","A","A","A","B","B","B","B")
  }else if(type == 2){
    labels = c("A","B","A","A","B","A","B","B")
  }else if(type == 3){
    labels = c("A","A","B","B","B","A","B","A")
  }else if(type == 4){
    labels = c("A","A","B","A","B","B","B","A")
  }else if(type == 5){
    labels = c("A","A","B","B","B","B","A","A")
  }else if(type == 6){
    labels = c("A","A","B","A","B","B","A","B")
  }else{
    stop("type has to be 1-6 !")
  }
  labels = match(labels,LETTERS) - 1
  labels[labels==0] = -1
  sigmoid = function(x) 1/(1+exp(-x))
  sigmoid_deriv = function(x) x * (1-x)

  preds = matrix(nrow = sim_subjects, ncol = epochs)

  for(b in 1:sim_subjects){
  input_layer_units = ncol(stimuli)
  output_units = 1
  input_to_hidden_weights = matrix(rnorm(input_layer_units * n_hidden_units), nrow = input_layer_units, ncol = n_hidden_units)
  input_to_hidden_bias = runif(n_hidden_units)
  input_to_hidden_bias_temp = rep(input_to_hidden_bias,nrow(stimuli))
  hidden_bias = matrix(input_to_hidden_bias_temp,nrow = nrow(stimuli),byrow = F)
  hidden_to_output_weights = matrix(rnorm(n_hidden_units*output_units), nrow = n_hidden_units, ncol = output_units)
  output_bias = runif(output_units)
  output_bias_temp = rep(output_bias,nrow(stimuli))
  output_bias = matrix(output_bias_temp,nrow = nrow(stimuli), byrow = F)

  hidden_layer_activations_across_time = array(dim=c(nrow(stimuli),n_hidden_units,epochs))
  hidden_layer = matrix(0,nrow = nrow(stimuli),ncol = n_hidden_units)
    for(i in 1:epochs){
      hidden_layer_input = stimuli %*% (input_to_hidden_weights+sqrt(.Machine$double.eps))
      hidden_layer_input = hidden_layer_input + hidden_bias
      hidden_layer_activations = sigmoid(hidden_layer_input)
      hidden_layer_activations_across_time[,,i] = hidden_layer_activations
      output_layer_input = hidden_layer_activations %*% hidden_to_output_weights
      output_layer_input = output_layer_input + output_bias
      output = sigmoid(output_layer_input)
      preds[b,i] = mean(ifelse(output<.5,-1,1) == labels)

      error = labels - output
      slope_output_layer = sigmoid_deriv(output)
      slope_hidden_layer = sigmoid_deriv(hidden_layer_activations)
      output_d = error * slope_output_layer
      error_at_hidden_layer = output_d %*% t(hidden_to_output_weights)
      hidden_layer_d = error_at_hidden_layer * slope_hidden_layer
      hidden_to_output_weights = hidden_to_output_weights + (t(hidden_layer_activations) %*% output_d) * learning_rate
      output_bias = output_bias + output_d * learning_rate
      input_to_hidden_weights = input_to_hidden_weights + (t(stimuli) %*% hidden_layer_d) * learning_rate
      input_to_hidden_bias = input_to_hidden_bias + colSums(hidden_layer_d) * learning_rate
    }
  hidden_layer = (hidden_layer + apply(hidden_layer_activations_across_time,c(1,2),mean))/2
  }
  list(prediction_accuracy = preds,
       hidden_layer_activations = hidden_layer)
}

