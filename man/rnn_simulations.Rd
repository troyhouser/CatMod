\name{rnn_simulations}
\alias{rnn_simulations}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
run categorization simulations with Recurrent Neural Network
}
\description{
Takes in various parameters (e.g., number of hidden units, learning rate, training blocks) to simulate the category learning process with a recurrent neural network to predict category decision making on canonical Six Problem stimulus sets.
}
\usage{
rnn_simulations(type,epochs,sim_subjects,learning_rate,n_hidden_units,plot,single_subjects,plot_text_size)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{type}{
How are the 8 training stimuli grouped into categories? Has to be 1-6
} \item{epochs}{
Number of training epochs
} \item{sim_subjects}{
Number of simulated subjects
} \item{learning_rate}{
Scalar to scale network weights during backpropagation of error
} \item{n_hidden_units}{
Number of neuron-like units in the hidden layer of the network
} \item{plot}{
Logical denoting whether user wants plots added to output or not
} \item{single_subjects}{
Logical denoting whether user wants the accuracy plot to be of single simulated subjects. If FALSE, default is group averaged accuracies across epochs.
} \item{plot_text_size}{
Size of axis labels in ggplot outputs
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
\item{plt }{ggplot of prediction accuracies of the RNN, either group averaged or displayed for each simulated subject}
\item{hidden_layer}{corrplot data of hidden layer activation similarities between stimuli}
\item{rnn_results}{list that includes raw prediction accuracies per subject per epoch and one group averaged matrix of hidden layer activations for each stimulus}
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
\references{
Shepard et al. (1961)
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
rnn_simulations(type = 1,
epochs = 20,
sim_subjects = 100,
learning_rate = 0.1,
n_hidden_units = 10,
plot = T,
single_subjects = F,
plot_text_size = 20)
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory (show via RShowDoc("KEYWORDS")):
% \keyword{ ~kwd1 }
% \keyword{ ~kwd2 }
% Use only one keyword per line.
% For non-standard keywords, use \concept instead of \keyword:
% \concept{ ~cpt1 }
% \concept{ ~cpt2 }
% Use only one concept per line.
