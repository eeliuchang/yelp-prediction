Data Science Capstone - Recommendation System for Restaurants
========================================================
author: Chang Liu
date: Nov 18, 2015

Question of Interest
========================================================

Which restaurants in Arizona are recommended to female graduate students?

This question is of interest because it 
- provides a framework for recommending services for a special group of people
- offers insights into how to explore the data using collective filtering (finding the answer with collective intelligence from large audience) 
- serves as a basis for future recommendation system research


Methodology
========================================================
 To find the matching restaurants in Arizona, we use the following procedures to filter all the reviews for restaurants.
 
- cluster the reviewers into females and males from the user dataset thus find all the female users
- list all the restaurant features that females prefer from restaurant reviews
- look for and sort the restaurants in AZ which match most with the features females pay attention to in step two




Analysis and Results
========================================================

Here are histograms of stars for restaurants in AZ. We need to find the restaurants which have stars more than average score of the average in Arizona.

![plot of chunk unnamed-chunk-2](Data Science Capstone Deck-figure/unnamed-chunk-2-1.png) 

Answer
========================================================

The top restaurants female graduate students should go to are: 

* "Crackers & Co Cafe"
* "Cafe Monarch" 
* "Good Fellas Grill"
* "The Gladly"


We realize that these four restaurants are not too pricy nor too low quality. And most importantly, they offer good desserts, happy-hour as well as are suitable for friends hanging out. This is because when we were looking for the preferred features for females, we find that they are interested in restaurants which emphasize on "friends", "happy hour", "dessert". And these four recommended restaurants have the highest correlation with these words. 
