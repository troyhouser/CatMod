
[catmod.md](https://github.com/user-attachments/files/15993098/catmod.md)***CatMod***: An easy-to-use package for modeling categorization
================

<style type="text/css">
  body{
  font-size: 12pt;
}
</style>

*CatMod* is an R package that infers the category representations people
rely on when making category decisions, or generalizing category
knowledge to never-before-seen exemplars.

**To install:**

``` r
devtools::install_github("troyhouser/CatMod")
```

*Note:* If you are receiving an internal server error when trying to
access help pages, restarting R should resolve this!

***Needed for easiest use of package:*** (1) a matrix/dataframe of
exemplars where each row is a vector representation of an exemplar, (2)
a matrix/dataframe of prototypes where each row is a vector
representation of a prototype, (3) a matrix/dataframe of test stimuli
that the models can predict how a person will categorize. Again, each
row is a vector representation of the stimulus. (4) a vector of
empirical responses a person made in response to the test stimuli.
Responses need to be capital letter representations of the categories,
beginning with “A”. (5) a vector of category exemplar labels, denoting
which category each exemplar belongs to. (6) Lastly, a vector of initial
parameter settings for the prototype and exemplar models. This vector
has to be of length equal to *number of stimulus dimensions + 1* or
*number of stimulus dimensions + 2*. There is a weight for each
dimension that gets optimized, plus a similarity sensitivity parameter,
and (optional) a gamma parameter akin to temperature in the classic
softmax choice rule. For example, in the four dimensional stimuli below,
one needs a vector of initial parameters of length 5 (no gamma) or 6
(with gamma).  
  
  

***What is CatMod about?*** THe package features 3 models, two of which
represent the extremes of possible category representations. The
exemplar model is the Generalized Context Model (GCM), made famous by
Robert Nosofsky (1987), who extended Medin & Schaffer’s (1978) Context
Model. The exemplar model assumes that people memorize experienced
exemplars of categories and that these memorized instances constitute
the category. For example, your category representation of ‘birds’ is
constituted by every bird you have ever encountered, or can recall.  

The prototype model is the multiplicative prototype model of Smith &
Minda (1998), which uses the same formulation as GCM to compute
similarity. Both models rely on what some have called the Shepard
kernel, after Roger Shepard’s *Universal Law of Generalization* that
says that perceived similarity is an exponential function of physical
distance between stimuli. The only difference is that the prototype
model assumes that categories are represented by their prototypes, which
are the average, or central tendency, abstracted across all exemplars of
the category.  

So, the exemplar model assumes that people represent categories as a
conglomerate of experienced stimuli and the prototype model assumes that
people represent categories as an abstracted summary across experienced
stimuli. This distinction is an active research topic in neuroscience;
however, here our main focus is: *Given a novel stimulus, how do we know
which category it belongs to?*  

***Why study categorization?*** This is an interesting question (the
question at the end of the last paragraph) that has been debated for a
long, long time under various guises. It is also paramount to our
everyday lives because generalization is ubiquitous. When we visit a new
grocery store, we are able to find the milk efficiently because we
generalize previously acquired knowledge of the layouts of grocery
stores. When we go out to eat, we can expect the server to take our
drink order first, then the main entree, and perhaps finally dessert.
When we step into a dangerous neighborhood that we had never been in
before, we know to act cautiously. How is it, that we can act
appropriately and adaptively in situations with which we have no direct
experience? Roger Shepard pioneered the formal treatment of this problem
and concluded that it is because of similarity to previous experiences.
We infer that the milk will be in a similar relative location as to the
milks we have found in previously visited grocery stores. We know a
neighborhood is dangerous if we have been in a similar-looking
neighborhood that turned out to be dangerous. Though this is widely
accepted, we still do not know what these novel experiences are being
compared to: are they being compared to prototypes or exemplars? Though
the truth is likely somewhere in between, it is useful to compare the
predictions from the extremes.  

***Procedures for categorization modeling*** The exemplar and prototype
models both follow similar procedures, so we will discuss them in tandem
for brevity. Remember, we are interested in behavioral evidence of
generalization via prototypes or exemplars. Therefore, we are skipping
the category learning process for now (this is discussed more below when
introducing the recurrent neural network) and jumping right into
generalization to novel stimuli.  

Say, we run an experiment, training subjects to categorize binary
four-dimensional stimuli into either Category A or Category B. The four
dimensions are (1) **shape**, (2) **size**, (3) **color**, and (4)
**pattern**. The shape dimension is either square or triangle. The size
dimension is either large or small. The color dimension is either blue
or red. The pattern dimension is either dots or stripes. Say the
Category A prototype is a large, blue, dotted square. This makes the
Category B prototype a small, red, striped, triangle.

![](catmod_files/figure-gfm/unnamed-chunk-3-1.png)<!-- -->

Subjects learn categories by categorizing a set of exemplars through
trial and error:  
  
  **Category Exemplars:**  
![](catmod_files/figure-gfm/unnamed-chunk-4-1.png)<!-- -->

  We see that most Category A exemplars are large, blue, dotted, and
square and that most Category B exemplars are small, red, striped, and
triangle. Thus, the average of the Category A exemplars is the Category
A prototype and the average of the Category B exemplars is the Category
B protoype.  

Now say, the subject sees an entirely novel stimulus:  
![](catmod_files/figure-gfm/unnamed-chunk-5-1.png)<!-- -->  
*What category does this stimulus belong to?*  

  First, we assume that the subject compares the features of the novel
stimulus to the features of both prototypes, obtaining some idea of the
(absolute) discrepancy between features. The plot below tells us that
the novel stimulus has the same color, shape, and size as the color,
shape, and size of Category A’s prototype but the same pattern as
Category B’s prototype. (By arbitrarily denoting prototype A’s features
as 0s and prototype B’s features as 1s, we can easily compute the
difference between dimensions.)  
![](catmod_files/figure-gfm/unnamed-chunk-6-1.png)<!-- -->

  Next, we weight the distances by attention. We know attention is
capacity-limited and distributed across stimulus features unequally. For
illustration purposes, we show attention weighted distances with equal
attention to each feature, which shows the same information as the plot
above, just downscaled. The function of these weights is to effectively
*stretch* or *shrink* the stimulus space.  
![](catmod_files/figure-gfm/unnamed-chunk-7-1.png)<!-- -->    
Consider the case where the subject mostly paid attention to the color
of the stimuli only. Allocating most attention to color serves to
enhance the discrepancy between color distance and the other feature
distance. In other words, this means that to an observer that allocated
attention as such, the color distance is perceived as larger, while the
other distances are effectively ignored.  
![](catmod_files/figure-gfm/unnamed-chunk-8-1.png)<!-- -->    
Next, (back to the original attention weights) we sum the feature
distances to obtain single measures of distance between the novel
stimulus and both prototypes.  
![](catmod_files/figure-gfm/unnamed-chunk-9-1.png)<!-- -->    
Next, we compute the perceived similarity scores. Intuitively, these
will be negatively related to stimulus distance: If two stimuli are
physically distant/distinct, their similarity will be low. We also apply
the Shepard kernel to make perceived similarity a function of
exponential distance and scale it by a sensitivity parameter.  
![](catmod_files/figure-gfm/unnamed-chunk-10-1.png)<!-- -->    
Last but not least, we transform perceived similarities into
probabilities in order to obtain the *probability that the subject will
categorize the novel stimulus into either category.*  
![](catmod_files/figure-gfm/unnamed-chunk-11-1.png)<!-- -->  
  
  
The exemplar model goes through the exact same procedures but with one
added step: After obtaining the perceived similarities between the novel
stimulus and every exemplar (in this case, all 6 exemplars), then it
sums the perceived similarities within each category. Thus, the
perceived similarity for Category A is the sum of the perceived
similarity for exemplars 1-3 (left side of the image above).  
  
***Neural Network extension***   This package also features a neural
network model of category learning. Here, we train a recurrent neural
network (RNN) to learn the seminal Six Problems made famous by Shepard
et al. (1961). The Six Problems feature category learning of 8 binary
three-dimensional stimuli that differ in their category assignments
depending on which problem we are dealing with. They were made to be
increasingly difficult, with the Type 1 problem being assigned to
respective categories only depending on one relevant dimension (e.g.,
size). Thus, all small stimuli were in Category A and all large stimuli
were in Category B. The other dimensions (e.g., color and shape) did not
matter. Type 6 requires memorization of all stimuli. The order of
difficulty has been consistently found to adhere to the following order:
type 1 \< type 2 \< type 3-5 \< type 6.  

``` r
type = 1
epochs = 200
sim_subjects = 50
learning_rate = 0.1
n_hidden_units = 50
plot = T
single_subjects = F
plot_text_size = 20
rnn = rnn_simulations(type = type,epochs = epochs, sim_subjects = sim_subjects, learning_rate = learning_rate, n_hidden_units = n_hidden_units, plot = plot, single_subjects = single_subjects, plot_text_size = plot_text_size)
```

**Performance of RNN on Type 1 Problem**  
![](catmod_files/figure-gfm/unnamed-chunk-13-1.png)<!-- -->

**Performance of RNN on Type 1 Problem for Individual (Simulated)
Subejcts**  
![](catmod_files/figure-gfm/unnamed-chunk-15-1.png)<!-- -->

**Performance of RNN on Type 2 Problem**  
![](catmod_files/figure-gfm/unnamed-chunk-17-1.png)<!-- -->

**Performance of RNN on Type 4 Problem**  
![](catmod_files/figure-gfm/unnamed-chunk-19-1.png)<!-- -->

**Performance of RNN on Type 6 Problem**  
![](catmod_files/figure-gfm/unnamed-chunk-21-1.png)<!-- -->

  Using RNNs to study category decisions and representations have not
received nearly as much attention as the more traditional category
models introduced above, though there is ample evidence that hidden
layers can capture more biologically plausible category representations,
i.e., more akin to what they may look like in networks of interconnected
neurons. The RNN used here provides a glimpse of this for it outputs a
correlation matrix that is the correlations between hidden layer unit
activations for each of the 8 stimuli. 
![](catmod_files/figure-gfm/unnamed-chunk-22-1.png)<!-- -->    
We see that the category representations latent in the correlation
structure of the RNN’s hidden layer unit activations is not perfect but
it does fairly well at capturing the categories: This was trained on the
Type 1 Problem, so the first 4 stimuli belong to Category A and indeed
they are more correlated with each other than with stimuli 5-8, while
the last 4 stimuli belong to Category B and seem to be more correlated
with each other overall than with stimuli 1-4.  
  

