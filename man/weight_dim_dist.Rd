\name{weight_dim_dist}
\alias{weight_dim_dist}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Weight dimension distances with attention.
}
\description{
Weights of length equal to number of stimulus features are scalars that denote the amount of attention allocated to corresponding feature.
}
\usage{
weight_dim_dist(exp_dim_dist,attention_weights)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{exp_dim_dist}{
Exponentiated dimensional distance matrix/array.
} \item{attention_weights}{
Vector of attention weights of length equal to number of features in stimuli/number of columns in exp_dim_dist variable.
}
}
\details{
Assuming attention is capacity-limited, one can limit the summation of attention weights to 1. With zero a priori predictions about how attention is distributed across stimulus features, one can then set each attention weight to (1 / no. of features). This can also serve as initial parameters if optimizing the attention weights via the data.
}
\value{
Returns input variable ([exponentiated] dimensional distance) weighted by attention.
}
\references{
%% ~put references to the literature/web site here ~
}
\author{
%%  ~~who you are~~
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
exp_dim_dist = matrix(rnorm(100),10,10)
attention_weights = rep(1/ncol(exp_dim_dist),ncol(exp_dim_dist))
weight_dim_dist(exp_dim_dist,attention_weights)

dim_dist = matrix(rnorm(100),10,10)
exp_dim_dist(dim_dist,r = 2)
prototypeA = c(0,0,0)
prototypeB = c(1,1,1)
category_representations = rbind(prototypeA,prototypeB)
test_stim1 = c(1,0,1)
test_stim2 = c(1,1,0)
test_stim3 = c(0,1,1)
test_stim4 = c(0,1,0)
test_stim5 = c(0,0,1)
test_stim6 = c(1,0,0)
stimuli = rbind(test_stim1,test_stim2,test_stim3,test_stim4,test_stim5,test_stim6)
dim_dist = dim_dist(category_representations,stimuli)
exp_dim_dist = exp_dim_dist(dim_dist,r = 1)
weight_dim_dist(exp_dim_dist,rep(1/ncol(exp_dim_dist),ncol(exp_dim_dist)))
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory (show via RShowDoc("KEYWORDS")):
% \keyword{ ~kwd1 }
% \keyword{ ~kwd2 }
% Use only one keyword per line.
% For non-standard keywords, use \concept instead of \keyword:
% \concept{ ~cpt1 }
% \concept{ ~cpt2 }
% Use only one concept per line.
