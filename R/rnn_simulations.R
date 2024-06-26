rnn_simulations = function(type,epochs,sim_subjects,learning_rate,n_hidden_units,plot = T,single_subjects = F,plot_text_size = plot_text_size){

  if(!require(ggplot2)) install.packages("ggplot2")
  if(!require(corrplot)) install.packages("corrplot")
  if(!require(ggpubr)) install.packages("ggpubr")
  rnn_results = cat_rnn(type = type,epochs = epochs,sim_subjects = sim_subjects,learning_rate = learning_rate, n_hidden_units = n_hidden_units)
  rnn_df = data.frame(accuracy = c(rnn_results$prediction_accuracy),
                       epoch = rep(1:epochs,each = sim_subjects),
                       subject = rep(1:sim_subjects,epochs))
  if(plot){
    if(!single_subjects){
      p1 = ggplot(rnn_df,aes(x = epoch,y = accuracy)) +
        geom_smooth(stat="summary")+
        theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),text = element_text(size=plot_text_size),
              panel.background = element_blank(), axis.line = element_line(colour = "black"),
              legend.position = "None")+
        labs(caption = paste0("n=",sim_subjects,"\nlr=",learning_rate,"\nnHiddenUnits=",n_hidden_units))
    }
    if(single_subjects){
      p1 = ggplot(rnn_df,aes(x = epoch,y = accuracy,col=factor(subject))) +
        geom_smooth(se=F)+
        theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),text = element_text(size=plot_text_size),
              panel.background = element_blank(), axis.line = element_line(colour = "black"),
              legend.position = "None")+
        labs(caption = paste0("n=",sim_subjects,"\nlr=",learning_rate,"\nnHiddenUnits=",n_hidden_units,"\nproblemType",type))
    }
  }
  row.names(rnn_results$hidden_layer_activations) = paste0("stimulus",1:nrow(rnn_results$hidden_layer_activations))
  list(plt = p1,
       hidden_layer = corrplot(cor(t(rnn_results$hidden_layer_activations)),method = "color"),
       rnn_results = rnn_results)
}

