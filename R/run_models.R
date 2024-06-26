run_models = function(stimuli,prototypes,exemplars,resp,labels,inits){

  if(!require(Rsolnp)) install.packages("Rsolnp")

  files_sources = list.files("~/R")
  sapply(files_sources, source)

  if(length(inits) == (ncol(prototypes) + 2)){
    gamma_init = 1
    ub = c(20,rep(1,ncol(stimuli),gamma_init))
  }else{
    ub = c(20,rep(1,ncol(stimuli)))
  }

  prototype_fit = solnp(pars = inits,
                        fun = prototype_model,
                        eqfun = equality_constraint,
                        eqB = 1,
                        LB = rep(0,length(inits)),
                        UB = ub,
                        control = list(trace = 0))
  exemplar_fit = solnp(pars = inits,
                        fun = exemplar_model,
                        eqfun = equality_constraint,
                        eqB = 1,
                        LB = rep(0,length(inits)),
                        UB = ub,
                       control = list(trace = 0))
  if(length(inits) == (ncol(prototypes) + 2)){
    list(prototype_nll = min(prototype_fit$values),
         prototype_sensitivity = prototype_fit$pars[1],
         prototype_attention_weights = prototype_fit$pars[2:(ncol(prototypes)+1)],
         prototype_gamma = prototype_fit$pars[length(inits)],
         exemplar_fit = min(exemplar_fit$values),
         exemplar_sensitivity = exemplar_fit$pars[1],
         exemplar_attention_weights = exemplar_fit$pars[2:(ncol(prototypes)+1)],
         exemplar_gamma = exemplar_fit$pars[length(inits)])
  }else{
    list(prototype_nll = min(prototype_fit$values),
         prototype_sensitivity = prototype_fit$pars[1],
         prototype_attention_weights = prototype_fit$pars[2:(ncol(prototypes)+1)],
         exemplar_fit = min(exemplar_fit$values),
         exemplar_sensitivity = exemplar_fit$pars[1],
         exemplar_attention_weights = exemplar_fit$pars[2:(ncol(prototypes)+1)])
  }
}


