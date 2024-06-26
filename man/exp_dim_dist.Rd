\name{exp_dim_dist}
\alias{exp_dim_dist}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
exponentiate dimension distances
}
\description{
Raise dimension distances between test stimuli and category representations to power of r.
}
\usage{
exp_dim_dist(dim_dist,r)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{dim_dist}{
A matrix or array of dimension-by-dimension distances between test stimuli and category representations.
}\item{r}{
The power to raise the distances to. When r = 1, the distances are city-block metric and when r = 2, the distances are euclidean metric.
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
The input dim_dist variable exponentiated to power of r.
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
exp_dim_dist(dim_dist,r = 1)
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory (show via RShowDoc("KEYWORDS")):
% \keyword{ ~kwd1 }
% \keyword{ ~kwd2 }
% Use only one keyword per line.
% For non-standard keywords, use \concept instead of \keyword:
% \concept{ ~cpt1 }
% \concept{ ~cpt2 }
% Use only one concept per line.
