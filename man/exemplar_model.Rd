\name{exemplar_model}
\alias{exemplar_model}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Exemplar Model of Categorization
}
\description{
Computes the negative log likelihood of responses assuming one used exemplar category representations to make their decisions. In other words, this function returns the inverse fit of the exemplar model predicted responses and the empirically observed responses (i.e., lower values indicate better fit).
}
\usage{
exemplar_model(pars)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{pars}{
Vector of parameter values of length equal to either the number of features in the stimuli plus 1 or plus 2. If it is plus 1, then we are not using the gamma parameter (see category_probabilities).
}
}
\details{
This function requires more inputs than just the pars variable. Do not attempt to run without 'exemplars' and 'stimuli' variables'. This function is meant to be run inside the run_models function, so it is not useful on its own.
}
\value{
Negative log-likelihood / fit of exemplar model.
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

% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory (show via RShowDoc("KEYWORDS")):
% \keyword{ ~kwd1 }
% \keyword{ ~kwd2 }
% Use only one keyword per line.
% For non-standard keywords, use \concept instead of \keyword:
% \concept{ ~cpt1 }
% \concept{ ~cpt2 }
% Use only one concept per line.
