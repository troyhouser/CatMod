\name{forward_pass}
\alias{forward_pass}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
simulate one trial in category learning paradigm
}
\description{
passes stimulus presentation through functions calculating psychological similarity between stimulus and clusters, then through a layer of weights to obtain probabilities of responding to corresponding category labels
}
\usage{
forward_pass(sustain,queried_dimensions,present_dimensions,unsupervised)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{sustain}{
initial sustain model parameters and weights
} \item{queried_dimensions}{
which dimensions are representing category assignment of each stimulus
} \item{present_dimensions}{
which dimensions are being used to calculate psychological similarity
} \item{unsupervised}{
is category learning supervised or unsupervised?
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
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
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.

## The function is currently defined as
function (x)
{
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory (show via RShowDoc("KEYWORDS")):
% \keyword{ ~kwd1 }
% \keyword{ ~kwd2 }
% Use only one keyword per line.
% For non-standard keywords, use \concept instead of \keyword:
% \concept{ ~cpt1 }
% \concept{ ~cpt2 }
% Use only one concept per line.
