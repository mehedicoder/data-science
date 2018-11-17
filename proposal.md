---
title: "Data Science Project Proposal"
output:
  html_document:
    keep_md: true
---
##Project Title: Streaming Topic Model and Visualization for Twitter.


###Supervisor: Uli Niemann, KMD Research Group, OVGU 

###The Team:

Rajatha Nagaraja Rao  | Mehedi Hasan | Daniel Bokelmann
------------- | ------------  | ------------
Email: rajatha1@st.ovgu.de    | md.hasan@st.ovgu.de | daniel.bokelmann@st.ovgu.de
MSc. Program: DKE  | MSc. Program: DKE  | MSc. Program: DKE

###Background and motivation:
The topic model approach has been used widely in the field of computer science focusing on web and text-mining in recent years. The goal of topic modeling is to automatically discover the topics from a collection of documents. When a corpus of documents is large, how can a single person understand what’s going on in a collection of millions of documents? This is an growingly common problem: navigating through an organization’s documents, emails, tweets from twitter, understanding a decade worth of newspapers, or characterizing a scientific field’s research. Researchers seek for an automated analysis and visualization techniques to produce a high-level overview of a large dataset. Topic models are a statistical framework that help users understand large document collections: not just to find individual documents but to understand the general themes present in the collection. In addition, topic models could be effectively applied to solve traditional problems in the fields of information retrieval, visualization, statistical inference, multilingual modeling, and linguistic understanding. Thus, topic models unlock large text collections for qualitative analysis.

Twitter is a popular micro-blogging service [Kwak et al., 2010], an important text analysis problem domain. In last few years, twitter has become a growingly popular platform for internet users. Users share ideas and opinions with each other, respond to recent events, share breaking news via twitter messages (tweets). Tweets consist of texts maximum 140 characters [Boyd et al., 2010]. Although tweets are too short, are useful because tweets are compact and fast, can potentially contain much information [Zhao et al., 2011]. In the past years, several studies has been conducted on Twitter from different perspectives. [Kwak et al., 2010] studied the topological characteristics of tweets in work settings and concluded that useful informal conversations among colleagues could be done more intuitively via tweets. [Sakaki et al., 2010] considered tweets as social sensors of realtime events, each Twitter user as a sensor and detected earthquake based on user’s tweet. [Asur and Huberman, 2010] demonstrated that the social media content can be analyzed to predict realworld outcomes. Author used the chatter from Twitter.com to forecast box-office revenues for movies. [Tumasjan et al., 2010] predicted the German federal election of the national parliament which took place on September 27th, 2009. [Khan et al., 2014] proposed a hybrid approach for determining the sentiment of each tweet. [Alvarez-Melis and Saveski, 2016] proposed a topic modeling approach for Twitter by grouping tweets together that occurs in the same user-to-user conversation; tweets and their replies were aggregated into a single document and the users who posted them are considered co-authors. [Soleymani et al., 2017] analyzed in response to advertisement videos to predict their purchase.

The Latent Dirichlet allocation (LDA) is a topic modeling technique, was proposed by [Blei et al., 2003], is an probabilistic generative model. LDA emphasizes on hidden (latent) topic structure(topics), per document topic distributions, and per topic word distributions. It represents each unit (e.g., a document) of a textual collection by an infinite mixture of probability over an underlying set of latent topics (concepts); each token (e.g., a word) of a document is associated with some of these latent topics. Nowadays, thereare a growing number of probabilistic models that are based on stat-of-the art LDA via combination with particular tasks; variations of LDA. [Rosen-Zvi et al., 2004] proposed the author-topic-model(ATM) which extends LDA to include authorship information, modelling the interests of authors.[Ramage et al., 2009] introduced Labeled-LDA for labeled social bookmarking websites data which is a topic model that constrains LDA by defining a one-to-one correspondence between LDA’s latent topics and user tags. [Zhao et al., 2011] published Twitter-LDA which is an abstraction of LDA to discover topics from short text. Nonetheless, LDA based topic models have initially been introduced in the text analysis community for unsupervised topic discovery in a corpus of docments, still serving as state of the art topic modelling technique. 

###Objectives:
 1. Learn about how to extract data from Twitter in realtime.
 2. Develop a streamimg pipeline to get data from Twitter.
 3. Getting familiar with LDA to infer topics out of large Tweet collection.
 4. Provide an intuitive visualization of the inferred topics for endusers.
 5. Getting familiar with Topic model libraries/packages implemented in R.
 6. Building a prototypical application from the aforementioned modules

###Datasets:
 As we want to do topic modelling for very recent dataset collected from Twitter.com, we will write a twitter streamer using R to stream tweets. Once we have the twitter streamer working, we will stream tweets based on a number of keywords i.e. 'berlinwall','angelamerkel','union' etc. to get a dataset of appropriate size.
 
###Design Overview:

This is a short overview of the projected design. It is worth mentioning that after initialization of the topic model more tweets will be continously sourced through the 'Streaming Pipeline' and thus be use for learning the topic model online. 
<!-- 1. Extraction of Tweets (Streamer)  -->
<!-- 2. Preprocessing/transformation and grouping of raw data  (Wrangling) -->
<!-- 3. Cleaning data -->
<!-- 4. Latent Dirichlet Allocation (LDA) algorithm (Modeling) -->
<!-- 5. Evaluation of generated topics by defined quality metrics (Explore;optional) -->
<!-- 6. Verification&Validation -->
<!-- 7. Visualizing the topics, i.e. as 2-dimensional topic maps. -->

<center>

<!-- ![](https://gitlab.com/mehedicoder/datasciencer/blob/master/Architecture_Diagram.PNG) -->
![](Architecture_Diagram_3.png)

</center>
###Source Code Repository and list of R packages: 
####Project repository: https://gitlab.com/mehedicoder/datasciencer/
(1) rtweet for pipeline.
(2) httpuv for authentication.
(3) topicmodels for LDA implementation in R [Grun et al., (2011)].
(4) ggplot2 and/or shiny and/or LDAvis for visualization.

###Time plan:

Due date | Deliverables | Key Personnel | Reviewers
------------- | ------------ | ------------ | ------------
23-11-2018 | Building streaming component |	Mehedi |	Daniel, Rajatha
23-11-2018 | Pre-processing and analysis of twitter data |	Rajatha |	Daniel, Mehedi
30-11-2018 |	Define metrics |	Daniel |	Mehedi, Rajatha
07-12-2018 |	Manual calculation of topics on test data	| Rajatha	| Daniel, Mehedi
07-12-2018	| Estimation and refinement of parameters	| Daniel	| Rajatha, Mehedi
14-12-2018	| Collection of results	| Rajatha	| Daniel, Mehedi
21-12-2018	| Initial setup of website & screencast	| Daniel	| Mehedi, Rajatha
28-12-2018	| Application of LDA and analysis of results	| Mehedi | Daniel, Rajatha
04-01-2019	| Visualization	| Rajatha	| Daniel, Mehedi
11-01-2019 | Wrap-up / Handing in project | Daniel | Mehedi, Rajatha 
18-01-2019 | Final presentation | Rajatha	| Daniel, Mehedi

 

<!-- 1. Data Collection & Preprocessing (due 23.11.18) -->
<!--   * Set up Twitter credentials -> Dev-account -->
<!--   * Building streaming component -->
<!--   * Analysing raw data -> Streamer will extract tweets in JSON format -->
<!--   * Writting a preprocessing routine of JSON-data extracted by the streamer -->
<!-- 2. Explorative Data Analysis finished (due 14.12.18) -->
<!--   * Defining metric for measuring quality of generated topics -->
<!--   * Manually calculating topic on preprocessed input data (tiny dataset, one keyword, one topic) as 1st testset -->
<!--   * Estimate and Refine Parameters:  -->
<!--     * Duration of streaming, upper boundary of number of Tweets -->
<!--     * Number of keywords -->
<!--     * Number of topics -->
<!--     * Dirichlet Priors: alpha and Beta -->
<!-- 3. Modeling, Website & Screencast finished (due 11.01.18) -->
<!--   * Applying LDA on whole corpus and streams as well to build the model -->
<!--   * Collect and Analyze the results -->
<!--   * Evaluate the model -->
<!--   * Visualize the generated topics -->
<!--   * Setting up website -->
<!-- 4. Final Presentation (due 18.01.18/25.01.18) -->

 
###References:
[Kwak et al., 2010] Kwak, H., Lee, C., Park, H., and Moon, S. (2010). What is Twitter, a SocialNetwork or a News Media? InProceedings of the 19th International Conference on World WideWeb, WWW ’10, pages 591–600, New York, NY, USA. ACM.

[Boyd et al., 2010] Boyd, D., Golder, S., and Lotan, G. (2010). Tweet, Tweet, Retweet: Conver-sational Aspects of Retweeting on Twitter. In2010 43rd Hawaii International Conference onSystem Sciences, pages 1–10.

[Zhao et al., 2011] Zhao, W. X., Jiang, J., Weng, J., He, J., Lim, E.-P., Yan, H., and Li, X.(2011). Comparing Twitter and Traditional Media Using Topic Models. In Clough, P., Foley,C., Gurrin, C., Jones, G. J. F., Kraaij, W., Lee, H., and Mudoch, V., editors,Advances inInformation Retrieval, pages 338–349, Berlin, Heidelberg. Springer Berlin Heidelberg.

[Rosen-Zvi et al., 2004] Rosen-Zvi, M., Griffiths, T., Steyvers, M., and Smyth, P. (2004).  TheAuthor-topic Model for Authors and Documents.  InProceedings of the 20th Conference onUncertainty in Artificial Intelligence, UAI ’04, pages 487–494, Arlington, Virginia, United States.AUAI Press.

[Sakaki et al., 2010] Sakaki, T., Okazaki, M., and Matsuo, Y. (2010). Earthquake Shakes TwitterUsers: Real-time Event Detection by Social Sensors. InProceedings of the 19th InternationalConference on World Wide Web, WWW ’10, pages 851–860, New York, NY, USA. ACM.

[Asur and Huberman, 2010] Asur, S. and Huberman, B. A. (2010). Predicting the Future withSocial Media. InProceedings of the 2010 IEEE/WIC/ACM International Conference on WebIntelligence and Intelligent Agent Technology - Volume 01, WI-IAT ’10, pages 492–499, Wash-ington, DC, USA. IEEE Computer Society.

[Tumasjan et al., 2010] Tumasjan, A., Sprenger, T. O., Sandner, P. G., and Welpe, I. M. (2010).Predicting Elections with Twitter: What 140 Characters Reveal about Political Sentiment. InICWSM.

[Khan et al., 2014] Khan, F. H., Bashir, S., and Qamar, U. (2014). TOM: Twitter opinion miningframework using hybrid classification scheme.Decision Support Systems, 57:245–257.

[Alvarez-Melis and Saveski, 2016] Alvarez-Melis, D. and Saveski, M. (2016). Topic Modeling inTwitter: Aggregating Tweets by Conversations. InICWSM.

[Soleymani et al., 2017] Soleymani, M., Schuller, B., and Chang, S.-F. (2017).  Guest editorial:Multimodal sentiment analysis and mining in the wild.Image and Vision Computing, 65:1–2.

[Blei et al., 2003] Blei, D. M., Ng, A. Y., and Jordan, M. I. (2003). Latent Dirichlet Allocation.J. Mach. Learn. Res., 3:993–1022.

[Ramage et al., 2009] Ramage, D., Hall, D., Nallapati, R., and Manning, C. D. (2009). LabeledLDA: A Supervised Topic Model for Credit Attribution in Multi-labeled Corpora. InProceedingsof the 2009 Conference on Empirical Methods in Natural Language Processing: Volume 1 -Volume 1, EMNLP ’09, pages 248–256, Stroudsburg, PA, USA. Association for ComputationalLinguistics.

[Grun et al., (2011)] topicmodels: An R package for ﬁtting topic models. Journal of Statistical Software, 40(13). 
