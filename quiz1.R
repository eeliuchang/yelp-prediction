setwd("C:/Users/chliu/Documents/R Workplace/yelp_dataset_challenge_academic_dataset/yelp_dataset_challenge_academic_dataset/")
library(rjson)
review_file <- "yelp_academic_dataset_review.json"
#review_data <- fromJSON(file=review_file, method = "C", unexpected.escape = "error" )
#review_df <- do.call("rbind", review_data)
#review_data[1:10]
#length(review_data)
lines <-  readLines(review_file)
lines_10 <- lines[1:10]
lines <- lines[1:10000]
review_data <- lapply(X=lines, fromJSON)
length(lines)
lines[100]
review_5_stars <- 0
for (i in 1:length(lines)){
  if (review_data[[i]]$stars == 5){
    review_5_stars <- review_5_stars + 1
  }
}
review_5_stars/length(lines)

text <- ""
for (i in 1:100){
  flag1 <- review_data[[i]]$business_id %in% res_id
  flag2 <- review_data[[i]]$user_id %in% female_id
  if (flag1 && flag2){
    text <- cat(text, review_data[[i]]$review)
  }
}

text <- ""
sum <- 0 
review_num<- list()
for (i in 1:length(lines)){
  flag1 <- review_data[[i]]$business_id %in% res_id
  flag2 <- review_data[[i]]$user_id %in% female_id
  if (flag1 && flag2){
    sum <- sum+1
    review_num[sum] <- i
  }
}

for (i in 1:sum){
  write(x=review_data[[review_num[[i]]]]$text,file="reviews",ncolumns = if(is.character(x)) 1 else 5,
        append = TRUE, sep = " ")
}
review_text <- paste(readLines("reviews"),collapse = " ")
library(tm)
review_source <- VectorSource(review_text)
corpus <- Corpus(review_source)
corpus <- tm_map(corpus, content_transformer(tolower))
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, stripWhitespace)
corpus <- tm_map(corpus, removeWords, stopwords("english"))
dtm <- DocumentTermMatrix(corpus)
dtm2 <- as.matrix(dtm)
frequency <- colSums(dtm2)
frequency <- sort(frequency, decreasing=TRUE)
head(frequency)
library(wordcloud)
words <- names(frequency)
wordcloud(words[1:50], frequency[1:50])


#df <- data.frame(matrix(unlist(review_data), nrow=length(lines_10), byrow=T))
#aggregate(df,by=list(x1),FUN=sum, na.rm=TRUE)
business_no <- rep(1,7985)
business_file <- "yelp_academic_dataset_business.json"
b_lines <-  readLines(business_file)
length(b_lines)
business_data <- lapply(X=b_lines, fromJSON)
sum <- 0

key <- 1
az_res_id <- list()
az_res_star <- list()
az_res_price <- list()
for (i in 1:length(b_lines)){
  if (business_data[[i]]$state == "AZ" && 
      sum(grepl("Restaurants",business_data[[i]]$categories))>0){
    sum <- sum+1
    business_no[key] <- i
    az_res_id[[key]]<- business_data[i]$business_id
    az_res_star[[key]] <- business_data[[i]]$stars
    az_res_price[[key]] <- business_data[[i]]$attributes$'Price Range'
    key <- key+1
  }
}
hist(unlist(az_res_star))
hist(unlist(az_res_price))
#There are 7985 restaurants in AZ
sum <- 0
text <- ""
res_id <- list()
for (i in 1:length(b_lines)){
  if (sum(grepl("Restaurants",business_data[[i]]$categories))>0){
    sum <- sum+1
    res_id[sum] <- business_data[[i]]$business_id
  }
}# 21892 restaurants all together

# Now get all the potential female reviews from restaurants 
key <- 1
res_all_text <- list()
female_id <- list()
words <- c('salad','vegetable','chia seeds','juice','frozen yogurt','cupcake','healthy','lettuce','grilled
cheese sandwich','latte','edamane','avocado roll','plantain','chinese','japanese','thai','vietnames','korean','mexican','middle eastern','indian',
'atmosphere','friendly','table','female','vegetarian','pinkberry','daughter','son','clean','sushi','curly','style','highlight','cookies')

for(i in 1:length(lines))
{
    sum <- 0
    for (j in 1: length(words)){
      sum <- sum + (grepl(words[j],review_data[[1]]$text))
    }
    if(sum >=1){
      female_id[key] <- review_data[[i]]$user_id
      key <- key+1  
    }
}

female_id
#  if(review_data[[i]]$business_id %in% res_id){



#business_data[[6]]$attributes$`Wi-Fi`
sum_wifi <- 0 
free_wifi <- 0 
for (i in 1:length(b_lines)){
  if (!is.null(business_data[[i]]$attributes$`Wi-Fi`)){
    sum_wifi <- sum_wifi + 1
    if(business_data[[i]]$attributes$`Wi-Fi` == "free"){
      free_wifi <- free_wifi +1
    }
  }
}
sum_b <-0
for (i in 1:length(b_lines)){
  if (business_data[[i]]$state == "CA"){
    sum_b <- sum_b+1
  }
}

free_wifi/sum_wifi

tip_file <- "yelp_academic_dataset_tip.json"
tip_lines <-  readLines(tip_file)
length(tip_lines)


user_file <- "yelp_academic_dataset_user.json"
lines <-  readLines(user_file)
user_data <- lapply(X=lines, fromJSON)
#366715 users on file
# names <- paste(readLines("yob2014.txt"), collapse=" ")
female_id <- list()
key <- 1
female_names <- read.table("yob2014_f.txt",sep=",",header = FALSE)
male_names <- read.table("yob2014_m.txt",sep=",",header = FALSE)
for (i in 1:length(lines)){
  flag_female <- user_data[[i]]$name %in% female_names[,1]
  flag_female_count <- female_names[which(user_data[[i]]$name==female_names[,1]),3]
  flag_male <- user_data[[i]]$name %in% male_names[,1]
  flag_male_count <- male_names[which(user_data[[i]]$name ==male_names[,1]),3]
  flag = (flag_female && !flag_male ) || (flag_female_count > flag_male_count)
  if (!is.na(flag) && flag == TRUE){
    female_id[key] <- user_data[[i]]$user_id
    key <- key+1
  }
}

for (i in 1:length(lines)){
  #print(i)
  if (!is.null(user_data[[i]]$compliments$funny) && user_data[[i]]$compliments$funny > 10000){
     print(user_data[[i]]$name)
 }
}
# dt1 <- rbind(list(user_data_10[[1]]$compliments$funny,user_data_10[[1]]$fans))
# for (i in 2:length(lines)) {
#   #print(i)
#   if (!is.null(user_data[[i]]$compliments$funny) &&
#       !is.null(user_data[[i]]$fans) &&
#       user_data[[i]]$compliments$funny > 1 && 
#       user_data[[i]]$fans > 1){
#         dt1 <- rbind(dt1, list(user_data[[i]]$compliments$funny,user_data[[i]]$fans))
#   }
# }
sum <- 0
for (i in 1:length(lines)) {
    #print(i)
    if ((is.null(user_data[[i]]$fans) || user_data[[i]]$fans <= 1) &&
        (is.null(user_data[[i]]$compliments$funny) ||
        user_data[[i]]$compliments$funny <= 1 )){
          sum <- sum+1
    }
  }