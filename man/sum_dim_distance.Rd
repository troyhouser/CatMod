\name{sum_dim_distance}
\alias{sum_dim_distance}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
sum dimensional distances
}
\description{
Sum the (weighted, exponentiated) dimensional distances between category representations and test stimuli.
}
\usage{
sum_dim_distance(weighted_dim_dist)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{weighted_dim_dist}{
Weighted (exponentiated) dimensional distance matrix/array.
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
Returns a single value summarizing the distance between a test stimulus and a category representation. Thus, what is returned will be a matrix with rows equal to number of test stimuli and columns equal to number of category representations.
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
weighted_dim_dist = matrix(rnorm(100),10,10)
sum_dim_distance(weighted_dim_dist)

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
sum_dim_distance(weighted_dim_dist)
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory (show via RShowDoc("KEYWORDS")):
% \keyword{ ~kwd1 }
% \keyword{ ~kwd2 }
% Use only one keyword per line.
% For non-standard keywords, use \concept instead of \keyword:
% \concept{ ~cpt1 }
% \concept{ ~cpt2 }
% Use only one concept per line.
