
***CatMod***: An easy-to-use package for modeling categorization
================

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
(with gamma).   **_See the package documentation in R for concrete examples using code!_**
  
  

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

![](example_stimuli/Presentation1/Slide1.png)<!-- -->

Subjects learn categories by categorizing a set of exemplars through
trial and error:  
  
  **Category Exemplars:**  
![](example_stimuli/Presentation1/Slide2.png)<!-- -->

We see that most Category A exemplars are large, blue, dotted, and
square and that most Category B exemplars are small, red, striped, and
triangle. Thus, the average of the Category A exemplars is the Category
A prototype and the average of the Category B exemplars is the Category
B protoype.  

Now say, the subject sees an entirely novel stimulus:  
![](example_stimuli/0001.png)<!-- -->  
*What category does this stimulus belong to?*  

First, we assume that the subject compares the features of the novel
stimulus to the features of both prototypes, obtaining some idea of the
(absolute) discrepancy between features. The plot below tells us that
the novel stimulus has the same color, shape, and size as the color,
shape, and size of Category A’s prototype but the same pattern as
Category B’s prototype. (By arbitrarily denoting prototype A’s features
as 0s and prototype B’s features as 1s, we can easily compute the
difference between dimensions.)  
![](example_stimuli/dim_dist.png)<!-- -->

Next, we weight the distances by attention. We know attention is
capacity-limited and distributed across stimulus features unequally. For
illustration purposes, we show attention weighted distances with equal
attention to each feature, which shows the same information as the plot
above, just downscaled. The function of these weights is to effectively
*stretch* or *shrink* the stimulus space.  
![](example_stimuli/weighted_dim_dist.png)<!-- -->    
Consider the case where the subject mostly paid attention to the color
of the stimuli only. Allocating most attention to color serves to
enhance the discrepancy between color distance and the other feature
distance. In other words, this means that to an observer that allocated
attention as such, the color distance is perceived as larger, while the
other distances are effectively ignored.  
![](example_stimuli/weighted_dim_dist2.png)<!-- -->    
Next, (back to the original attention weights) we sum the feature
distances to obtain single measures of distance between the novel
stimulus and both prototypes.  
![](example_stimuli/stim_dist.png)<!-- -->    
Next, we compute the perceived similarity scores. Intuitively, these
will be negatively related to stimulus distance: If two stimuli are
physically distant/distinct, their similarity will be low. We also apply
the Shepard kernel to make perceived similarity a function of
exponential distance and scale it by a sensitivity parameter.  
![](example_stimuli/sims.png)<!-- -->    
Last but not least, we transform perceived similarities into
probabilities in order to obtain the *probability that the subject will
categorize the novel stimulus into either category.*  
![](example_stimuli/probs.png)<!-- -->  
  
  
The exemplar model goes through the exact same procedures but with one
added step: After obtaining the perceived similarities between the novel
stimulus and every exemplar (in this case, all 6 exemplars), then it
sums the perceived similarities within each category. Thus, the
perceived similarity for Category A is the sum of the perceived
similarity for exemplars 1-3 (left side of the image above).  
  
***Neural Network extension***   
================
This package also features a neural
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
![](example_stimuli/t1.png)<!-- -->

**Performance of RNN on Type 1 Problem for Individual (Simulated)
Subejcts**  
![](example_stimuli/t1_subs.png)<!-- -->

**Performance of RNN on Type 2 Problem**  
![](example_stimuli/t2.png)<!-- -->

**Performance of RNN on Type 4 Problem**  
![](example_stimuli/t4.png)<!-- -->

**Performance of RNN on Type 6 Problem**  
![](example_stimuli/t6.png)<!-- -->

Using RNNs to study category decisions and representations have not
received nearly as much attention as the more traditional category
models introduced above, though there is ample evidence that hidden
layers can capture more biologically plausible category representations,
i.e., more akin to what they may look like in networks of interconnected
neurons. The RNN used here provides a glimpse of this for it outputs a
correlation matrix that is the correlations between hidden layer unit
activations for each of the 8 stimuli. 
![](example_stimuli/hidden.png)<!-- -->    
We see that the category representations latent in the correlation
structure of the RNN’s hidden layer unit activations is not perfect but
it does fairly well at capturing the categories: This was trained on the
Type 1 Problem, so the first 4 stimuli belong to Category A and indeed
they are more correlated with each other than with stimuli 5-8, while
the last 4 stimuli belong to Category B and seem to be more correlated
with each other overall than with stimuli 1-4.  
  

***A real example!***
_Now, I want to show you just how easy it is to run these models on real data with CatMod._
================

I will apply the prototype and exemplar models to individuals' data I personally collected in Dasa Zeithamova's [Brain & Memory Lab](https://cognem.uoregon.edu/). We used a traditional category learning paradigm, where participants were shown cartoon images and had to sort them into either Category A or Category B. They learned the category membership of these training stimuli via corrective feedback. There were a total of 8 training stimuli (exemplars), 4 per category. When averaging the exemplars within a category, we can construct prototypes. Later, participants were shown a mix of old and new stimuli and they had to select the stimulus' category, this time receiving no feedback.


![](example_stimuli/task_stimuli_figures.png)<!-- -->


We are going to apply the models to the categorization data, as provided in this package. Each file contains data from 1 unique subject. Each file has 17 columns (2 of these are ID columns, ignore the fact that there are 2!). Second column is called **distance** and it denotes the number of features that the stimulus has different from its respective prototype. **cat** is the category the stimulus belongs to and **num_cat** is simply its numerical format. **oldnew** tells us whether the stimulus is a training exemplar or a novel stimulus. All columns beginnging with a **d** are binary feature values (e.g., a 1/0 for d1 might mean yellow/gray). **resp** is the empirical response the subject made, **rt** is their response time, and **correct** is whether the response was correct (1) or incorrect (0). 



```{r}
# list out the files in the data folder
files = list.files("~/categorization/")

# empty matrix to store final processed data
CatModDat = matrix(nrow = length(files),ncol = 20)

# for every subject...
for(i in 1:length(files)){
  # read in subject i's data
  dat = read.csv(files[i])
  
  # what are the prototypes?
  prototypes = dplyr::distinct(dat[dat$distance==0,c(4,6:13)])
  prototypes = as.matrix(prototypes[order(prototypes$num_cat),-1])
  
  # what are the exemplars?
  exemplars = dplyr::distinct(dat[dat$oldnew=="old",c(4,6:13)])
  exemplars = as.matrix(exemplars[order(exemplars$num_cat),-1])
  
  # category labels for training stimuli
  traincat = rep(c("A","B"),each=4)
  
  # get rid of missing responses
  dat = dat[dat$resp != "None",]
  
  # categorization test stimuli
  stimuli = as.matrix(dat[,6:13])
  
  # responses coded as capital letters
  resp = LETTERS[as.numeric(dat$resp)]
  
  # fit the models
  results = run_models(stimuli = stimuli, prototypes = prototypes, exemplars = exemplars, resp = resp, traincat = traincat, inits = c(1,rep(1/ncol(stimuli),ncol(stimuli))))
  
  # store the results
  CatModDat[i,] = c(unlist(results))
}

CatModDat = as.data.frame(CatModDat)
colnames(CatModDat) = c("pfit","pSensitivity",paste0("pD",1:8),"efit","eSensitivity",paste0("eD",1:8))
```


That's it! In less than 20 lines of (actual) code, we read in the data for all subjects, optimized sensitivity and 8 attention parameters for both prototype and exemplar models and stored all the optimized parameters and model fits in a single wide dataframe that we can use to visualize these results. Moreover, all the heavy lifting for model fitting processes is accomplished with a single line of code using the _run_models_function.

We can visualize the model fits for both models:

![](example_stimuli/model_fits.png)<!-- -->


Overall, we can see that the prototype model fits the group averaged data the best, however, an important finding we found in this data that previous work from Dr. Zeithamova has shown, is that it is critical to analyze each individual. That is, just because the prototype model fit the group the best, it does not mean that every subject within the group used prototypes to categorize the novel stimuli. Some individuals are best fit by the exemplar model. To figure this out, one can use some form of monte carlo or gibbs sampling to construct a null distribution for both models for every subject, but this is beyond the scope of the current package.


We can also visualize the attention paid to each feature of the stimuli.

![](example_stimuli/attention_weights.png)<!-- -->


**Now, let's briefly give a more detailed description of the modeling process.**

Below are the same steps that we reviewed above with the four dimensional stimuli, but here I will try to illustrate the process of computations for the prototype model so that we can see some of the functions the _run_models_ function uses under the hood. 

This first image shows the first three steps of the prototype model: (1) compute dimensional distance, (2) exponentiate these distances, and (3) multiply by attention weights. Thus, if we have a matrix of stimuli that one sees during a categorization test, where each row represents a trial/8 dimensional stimulus, we simply compute the pairwise difference between each row and the category prototypes using:

```{r}
dim_dist = dim_dist(category_representations = prototypes,stimuli = stimuli)
```

For the exemplar model, we would simply substitute a matrix of exemplar representations for the prototypes.

Next, we exponentiate the (absolute) dimensional distances. In the case of binary features, we use city-block distance metric, where r = 1 and the distances do not actually change:

```{r}
exponentiated_dim_dist = exp_dim_dist(dim_dist = dim_dist, r = 1)
```

Then, we multiply each row of the exponentiated dimensional distance matrix by a vector of attention weights:

```{r}
weighted_dim_dist = weight_dim_dist(exp_dim_dist = exponentiated_dim_dist, attention_weights = rep(1/8,8))
```

In the image, turquoise colors denote larger distances and purple colors denote smaller distances.
![](example_stimuli/Slide1.png)<!-- -->


Next, we compute the row sums for both attention weighted distances to each prototype, obtaining total distances that each test stimulus is from either prototype.

```{r}
summed_dist = sum_dim_dist(weighted_dim_dist = weighted_dim_dist)
```

To transform these distances back to metric space, we raise the distances to power of 1/r. Again, for city-block distances, this does not change the distance values. For euclidean distances (r=2), we simply square root the distances.

```{r}
stim_dist = stimulus_distance(summed_dim_dist = summed_dist, r = 1)
```

Then, we can apply the Shepard kernel to these distances to obtain measures of perceived similarity:

```{r}
sims = perceived_similarity(stim_dist = stim_dist, sensitivity = 1)
```

![](example_stimuli/Slide2.png)<!-- -->

To finally transform similarities to probabilities of choosing the corresponding category label, we do:

```{r}
category_probabilities(perceived_sim = sims, gamma = 1)
```

Obtaining these likelihoods then enables optimization of the parameters through gradient descent on the log likelihood space.


***A mix between specific and general.***
================

As mentioned above, the reality of category representations is likely a blend of exemplar (i.e., specific) and prototype (i.e., general) representations. The Brain & Memory Lab has used monte carlo sampling to test the fit of prototype and exemplar models against a null distribution. If BOTH models fit better than chance, then this was taken as evidence that participants likely used a mixture of models. One can also use a traditional mixture model. In this case, a mixture model would calculate psychological similarity the same way both exemplar and prototype models do, and then compute the level of mixture with a mixing parameter: (w * exemplar-calculated-similarity) + ((1-w) * prototype-calculated-similarity). If w=1, then the subject only used exemplar representations. If w=0, the subject only used prototype representations. All values in between denote the level of mixing. 

Another successful method conceptualizes category representations as clusters, which is a very flexible method for recapitulating input structure. This model, developed by Love et al. (2004), is called Supervised and Unsupervised STratified Adaptive Incremental Network. This mouthful can be called SUSTAIN for short. 

SUSTAIN is much more computationally intensive (at least in the code in this package), and thus, I will not go over each function here. (_Also, I am still working on documentation pages for SUSTAIN modeling, so bear with me._) Anyways, I will briefly mention the steps that SUSTAIN employs to capture category learning. SUSTAIN can be used to assess generalization, which I will discuss below, but it is more applicable to the learning process of categories. If it is the first trial of a category learning experiment, the first stimulus will be a cluster. For all subsequent trials, the test stimulus will be compared to each cluster's centroid (ie, its mean position in multidimensional stimulus space). Activation of each cluster in response to a given stimulus is given by calculating similarity via the Shepard kernel. The winning cluster is selected by choosing the cluster with the highest activation (with incorporation of a lateral inhibition parameter). Then activation spreads from clusters to output units, whose values are then transformed into probabilities. If the winning cluster outputs a wrong response, a new cluster is recruited made up of the current test stimulus. Otherwise, the current test stimulus is added to the winning cluster. The winning cluster's centroid is updated with a Kohonen learning rule, attention weights are updated to minimize error, and weights are updated with backpropagation. 

The flexibility of SUSTAIN lies in its ability to group stimuli in as many possible combinations as there exists among the stimuli. For example, for 4 stimuli and 2 categories, SUSTAIN can group them as ([a],[bcd]), ([ab],[cd]),([abc],[d]),([bd],[ac]), etc. By modeling supervised and unsupervised category learning, SUSTAIN can additionally model category learning WITHOUT feedback. Everything is the same as the supervised version, however, new clusters are recruited if the psychological dissimilarity exceeds some threshold that is another paraemeter optimized.

Overall, we can imagine SUSTAIN as a model that uses multiple prototypes per category. For example, if one category composed of 4 stimuli was represented by 2 clusters, each cluster can be an average of two stimuli. Thus, it is not purely prototypical, where a category is depicted with a single prototype, but also not purely exemplar-y, where each individual exemplar is memorized. For example, the image below shows two clusters, one per category; however, the next image shows 8 clusters, four per category.

![](example_stimuli/clusters1.png)<!-- -->
![](example_stimuli/clusters2.png)<!-- -->

The data that needs to be fed to the SUSTAIN model function in the _CatMod_ package is quite different from the format of the data needed for prototype and exemplar models. The stimuli need to be in a list, where each list element is a vector representation of a stimulus shown during the list element's corresponding trial. There also needs to be a list or vector of the number of feature variants for each feature within the stimulus for each dimension. This makes the one-hot encoding much simpler. One-hot encoding can be done with the following:

```{r}
coded_stimuli = lapply(exemplars_list, one_hot, n_feature_variants)
```
where one_hot is a package function. The _one_hot_ function will return a list of one-hot encoded stimuli. Once you have your stimuli recoded, you will need a list of _present_dimensions_, ie the dimensions that will be used to calculate measures of distance and psychological similarity. Because SUSTAIN works best by treating category labels as another dimension, this step is necessary. You will also need a list of _queried_dimensions_ which is a list specifying for each stimulus what the dimension is that contains the category labels. You will also need a list of empirical responses, and, finally, a vector of parameter initializations. With all of that information, you can pass the _optimizer_ function from _CatMod_ to the base r's _optim_ function like so:

```{r}
exemplar1 = c(1,1,1,0,0,0,0,0,0) # example stimulus 1 from Category A
exemplar2 = c(1,0,0,1,1,0,0,0,0) # example stimulus 2 from Category A
exemplar3 = c(2,0,0,0,0,1,1,0,0) # example stimulus 1 from Category B
exemplar4 = c(2,0,0,0,0,0,0,1,1) # example stimulus 2 from Category B
stims = rbind(exemplar1,exemplar2,exemplar3,exemplar4) # bind example stimuli into a single dataframe
exemplars_list = rep(list(NA),nrow(stims))
for(i in 1:nrow(stims)) exemplars_list[[i]] = as.numeric(stims[i,])
resp = sample(1:2,4,replace = T) # fake responses
n_feature_variants = rep(2, ncol(stims)) # how many feature variants are there on each dimension of the stimuli ?
coded_stimuli = lapply(exemplars_list, one_hot, n_feature_variants) # one hot encoding
present_dimensions_test = rep(list(c(2:ncol(stims))), length(coded_stimuli)) # which features are we passing through to the model ?
queried_dimensions_test = rep(list(1), length(coded_stimuli)) # which dimension denote category asignment ?
responses_test = as.list(as.numeric(resp)) # make sure responses are numeric and in list format
model = optim(par = inits, fn = optimizer, stimuli = coded_stimuli, resp = responses_test, queried_list = queried_dimensions_test, present_list = present_dimensions_test, control = list(maxit=5000))
```
where **stims** is a matrix of stimuli with rows equal to number of stimuli and columns equal to the number of stimulus features, and **exemplars_list** is a list of length equal to number of stimuli, where each element is a vector representation of the stimulus.

If you want, you can also take a more detailed peak at the best fitting SUSTAIN model for each subject with _CatMod_'s _get_likelihood_ function:
```{r}
optimal_sustain = get_likelihood(stimuli = coded_stimuli, responses = responses_test, queried_dimensions = queried_dimensions_test, present_dimensions = present_dimensions_test, sustain = list(r = model$par[1], beta = model$par[2], d = model$par[3], eta = model$par[4], lambdas = rep(1,length(coded_stimuli[[1]])), weights = NULL, return_sustain = T))
```
