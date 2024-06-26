\name{dim_dist}
\alias{dim_dist}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
compute dimension distance
}
\description{
Computes raw difference between category representations (e.g., exemplars, prototypes) and test stimuli
}
\usage{
dim_dist(category_representations,stimuli)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{category_representations}{
A matrix of vector representations of categories, where each row is a representation.
} \item{stimuli}{
A matrix of vector representations of test stimuli.
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
A single array with dimensions of rows = number of test stimuli, columns = number of dimensions/features all stimuli are made of, and matrices (3rd dim) = number of category representations. Thus, the returned array is filled with the absolute difference (distance) for each dimension between each test stimulus and each category representation. For example, in the example provided, the first matrix in the returned array is the dimensional distance between each stimulus and prototypeA.
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

dim_dist(category_representations,stimuli)
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory (show via RShowDoc("KEYWORDS")):
% \keyword{ ~kwd1 }
% \keyword{ ~kwd2 }
% Use only one keyword per line.
% For non-standard keywords, use \concept instead of \keyword:
% \concept{ ~cpt1 }
% \concept{ ~cpt2 }
% Use only one concept per line.
