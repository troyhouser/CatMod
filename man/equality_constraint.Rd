\name{equality_constraint}
\alias{equality_constraint}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Equality constraint for optimization
}
\description{
Constrains attention parameters to sum to 1, while optimizing parameters via augmentation with Lagrange multipliers.
}
\usage{
equality_constraint(x)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{x}{
Vector of parameters used in the prototype and exemplar models.
}
}
\details{
Not useful on its own. Used in conjunction with the Rsolnp::solnp function that optimizes parameters used in the categorization models.
}
\value{
Returns z value, which is simply the parameters input but with the attention elements constrained to sum to 1.
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

% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory (show via RShowDoc("KEYWORDS")):
% \keyword{ ~kwd1 }
% \keyword{ ~kwd2 }
% Use only one keyword per line.
% For non-standard keywords, use \concept instead of \keyword:
% \concept{ ~cpt1 }
% \concept{ ~cpt2 }
% Use only one concept per line.
