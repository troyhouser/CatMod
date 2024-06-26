\name{stimulus_distance}
\alias{stimulus_distance}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Calculate stimulus distance between test stimuli and category representations
}
\description{
Raises summed, weighted, expoentiated dimensional distances to power of (1/r) to return the distance value to correct metric space. For example, if r=2, this function is the same as square-rooting the summed distances to turn values into euclidean space.
}
\usage{
stimulus_distance(summed_dim_dist,r)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{summed_dim_dist}{
Vector or matrix of summed distances between test stimuli and category representations.
} \item{r}{
Inverse power to exponentiate summed dimensional distances by.
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
Returns a vector or matrix of final stimulus distances between all test stimuli and category representations.
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
summed_dim_dist = rnorm(100)
stimulus_distance(summed_dim_dist,r = 2)

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
weighted_dim_dist = weight_dim_dist(exp_dim_dist,rep(1/ncol(exp_dim_dist),ncol(exp_dim_dist)))
summed_dim_dist = sum_dim_distance(weighted_dim_dist)
stimulus_distance(summed_dim_dist,r = 1)
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory (show via RShowDoc("KEYWORDS")):
% \keyword{ ~kwd1 }
% \keyword{ ~kwd2 }
% Use only one keyword per line.
% For non-standard keywords, use \concept instead of \keyword:
% \concept{ ~cpt1 }
% \concept{ ~cpt2 }
% Use only one concept per line.
