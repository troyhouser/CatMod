\name{category_probabilities}
\alias{category_probabilities}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Compute probability of choosing each category label.
}
\description{
Turns perceived similarities into probabilities of making each possible category decision.
}
\usage{
category_probabilities(x)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{perceived_sim}{
Perceived similarities between test stimuli and category representations.
} \item{gamma}{
Parameter that indexes how determined one's category decisions are by perceived similarity. Default is 1, which means responses are not influenced by this parameter. Low values make responses more random and high values make responses correspond always to category with highest perceived similarity (similar to an argmax choice rule).
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
Matrix of probabilities, with rows equal to number of test stimuli and columns equal to number of categories. Thus, each row is the distribution of probabilities one will choose the category denoted by the corresponding column and sums to 1.
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
exp_dim_dist = exp_dim_dist(dim_dist,r = 1)
weighted_dim_dist = weight_dim_dist(exp_dim_dist,rep(1/ncol(exp_dim_dist),ncol(exp_dim_dist)))
summed_dim_dist = sum_dim_distance(weighted_dim_dist)
stim_dist = stimulus_distance(summed_dim_dist,r = 1)
perceived_sim = perceived_similarity(stim_dist, sensitivity = 1)
category_probabilities(perceived_sim)
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory (show via RShowDoc("KEYWORDS")):
% \keyword{ ~kwd1 }
% \keyword{ ~kwd2 }
% Use only one keyword per line.
% For non-standard keywords, use \concept instead of \keyword:
% \concept{ ~cpt1 }
% \concept{ ~cpt2 }
% Use only one concept per line.
