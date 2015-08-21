library(dplyr)
setwd("./data/proj3/UCI HAR Dataset/")

#Read the txt files from test folder in R
x.test <- read.csv("./test/X_test.txt", sep = "", header = FALSE)
y.test <- read.csv("./test/y_test.txt", sep = "", header =  FALSE)
subject.test <- read.csv("./test/subject_test.txt", sep = "", header = FALSE)

#Merge the test folder files 

test_folder <- data.frame(subject.test, y.test, x.test)

#Repeat the exact same steps for files in the train folder

x.train <- read.csv("./train/X_train.txt", sep="", header=FALSE)
y.train <- read.csv("./train/y_train.txt", sep="", header=FALSE)
subject.train <- read.csv("./train/subject_train.txt", sep="", header=FALSE)

train_folder <- data.frame(subject.train,y.train,x.train)

#Bind the two datasets
raw.data <- rbind(train_folder,test_folder)

#Read the labels 

features <- read.csv("features.txt", sep = "", header = FALSE)
#conversion of V2 column to a vector

column.names <- as.vector(features[,2])

#replace labels as column nmes to raw_data

colnames(raw.data) <- c("subject_id", "activity_labels", column.names)

#Extracts only the measurements on the mean and standard deviation for each measurement.
raw.data <- select(raw.data, contains("subject"), contains("label"), contains("mean"), contains("std"), -contains("freq"), -contains("angle"))

#Uses descriptive activity names to name the activities in the data set
activity.labels <- read.csv("./activity_labels.txt", sep="", header=FALSE)
raw.data$activity_labels <- as.character(activity.labels[match(raw.data$activity_labels, activity.labels$V1), 'V2'])

#Cleaning up duplicates and unwanted characters in the colnames
setNames(raw.data, colnames(raw.data), gsub("\\(\\)", "", colnames(raw.data)))
setNames(raw.data, colnames(raw.data), gsub("-", "_", colnames(raw.data)))
setNames(raw.data, colnames(raw.data), gsub("BodyBody", "Body", colnames(raw.data)))

# Group the running data by subject and activity, then
# calculate the mean of every measurement.
raw.data.summary <- raw.data %>%
group_by(subject_id, activity_labels) %>%
summarise_each(funs(mean))

# Write raw.data to file
write.table(raw.data.summary, file="raw_data_summary.txt", row.name=FALSE)

