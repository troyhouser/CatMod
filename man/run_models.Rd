\name{run_models}
\alias{run_models}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Fit prototype and exemplar models
}
\description{
Fits prototype and exemplar models by optimizing parameters to best predict category decisions.
}
\usage{
run_models(stimuli,prototypes,exemplars,resp,labels,inits)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{stimuli}{
Matrix of vectorized stimulus representations used in the test phase.
} \item{prototypes}{
Matrix of prototypes for each category.
} \item{exemplars}{
Matrix of training stimuli/exemplars.
} \item{resp}{
Vector of category responses. Responses need to be capitalized letters, starting with A.
} \item{labels}{
Category labels for the training stimuli/exemplars.
} \item{inits}{
Parameter initializations to be optimized.
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
\item{prototype_nll }{Negative log-likelihood or fit of prototype model to the data}
\item{prototype_sensitivity }{Optimized sensitivity parameter from prototype model}
\item{prototype_attention_weights }{Optimized attention weight parameters from prototype model}
\item{exemplar_nll }{Negative log-likelihood or fit of exemplar model to the data}
\item{exemplar_sensitivity }{Optimized sensitivity parameter from exemplar model}
\item{exemplar_attention_weights }{Optimized attention weight parameters from exemplar model}

\item{gamma }{If gamma is used, this function will also return optimized gamma parameters for both models}
}
\references{
%% ~put references to the literature/web site here ~
}
\author{
troy houser
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
prototypeA = c(0,0,0,0,0)
prototypeB = c(1,1,1,1,1)
prototypes = rbind(prototypeA,prototypeB)

exemplar1 = c(0,1,1,1,0)
exemplar2 = c(1,0,1,0,1)
exemplar3 = c(1,0,0,0,1)
exemplar4 = c(0,1,0,1,0)
exemplars = rbind(exemplar1,exemplar2,exemplar3,exemplar4)

test_stim1 = c(1,0,1,1,1)
test_stim2 = c(1,1,0,1,1)
test_stim3 = c(0,1,1,1,1)
test_stim4 = c(0,1,0,0,0)
test_stim5 = c(0,0,1,0,0)
test_stim6 = c(1,0,0,0,0)
stimuli = rbind(test_stim1,test_stim2,test_stim3,test_stim4,test_stim5,test_stim6)

resp = sample(c("A","B"),6,replace=T)
labels = rep(c("A","B"),each=2)

inits = c(1,rep(1/ncol(stimuli),ncol(stimuli)))

run_models(stimuli,prototypes,exemplars,resp,labels,inits)
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory (show via RShowDoc("KEYWORDS")):
% \keyword{ ~kwd1 }
% \keyword{ ~kwd2 }
% Use only one keyword per line.
% For non-standard keywords, use \concept instead of \keyword:
% \concept{ ~cpt1 }
% \concept{ ~cpt2 }
% Use only one concept per line.
