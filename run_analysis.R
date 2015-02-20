## this script gets the original UCI HAR Dataset (set the dir to `data_dir`)
## and creates tidy dataset that is:
## 1. merges train and test datasets
## 2. select only mean and std columns
## 3. replaces activityid with caption
## 4. names the columns
## 5. calculates mean for every activity & subject

library(dplyr)

# change wd
old_wd <- getwd()
data_dir <- '/home/vlado/data_science_coursera/getdata/project/UCI HAR Dataset'
setwd(data_dir)

# dataset dimensions - to speedup reading
n_rows_train = 7352
n_rows_test = 2947
n_features = 561

# load features
features <- read.table('features.txt', stringsAsFactors=F)[,2]
features_i <- grep('-mean\\(|-std\\(', features)               # indeces
features_c <- features[features_i]                             # captions

# load activity labels
activity <- read.table('activity_labels.txt', stringsAsFactors=F)

# load train data
train <- read.table('train/X_train.txt', nrows=n_rows_train, colClasses=rep('numeric',n_features))
train <- train[,features_i]             # filter cols / POINT2
colnames(train) <- features_c           # POINT4
train[,'activity'] <- read.table('train/y_train.txt', nrows=n_rows, colClasses=c('integer'))
train[,'subject'] <- read.table('train/subject_train.txt', nrows=n_rows, colClasses=c('integer'))

# load test data
test <- read.table('test/X_test.txt', nrows=n_rows_test, colClasses=rep('numeric',n_features))
test <- test[,features_i]             # filter cols / POINT2
colnames(test) <- features_c          # POINT4
test[,'activity'] <- read.table('test/y_test.txt', nrows=n_rows, colClasses=c('integer'))
test[,'subject'] <- read.table('test/subject_test.txt', nrows=n_rows, colClasses=c('integer'))

# merge tables / POINT1
tidy <- rbind(train, test)

# replace activityid with caption / POINT3
activity_c <- factor(tidy$activity, level=activity[[1]], labels=activity[[2]])
tidy <- mutate(tidy, activity=activity_c)

# create small table / POINT5
tiny <- tidy %>% group_by(activity, subject) %>% summarise_each(funs(mean))

# restore old wd
setwd(old_wd)

# write the result
write.table(tiny, file="UCI HAR tiny tidy.txt", row.name=FALSE)