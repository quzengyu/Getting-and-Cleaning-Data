## Peer Assessments /Getting and Cleaning Data Course Project

# Merges the training and the test sets to create one data set.

X_train <- read.table("train/X_train.txt", colClasses = "numeric", header = F)
y_train <- scan("train/y_train.txt", what = "numeric")
subject_train <- scan('train/subject_train.txt', what = "numeric")

X_test <- read.table("test/X_test.txt", colClasses = "numeric", header = F)
y_test <- scan("test/y_test.txt", what = "numeric")
subject_test <- scan('test/subject_test.txt', what = "numeric")

X <- rbind(X_train, X_test)
y <- c(y_train, y_test)
subject <- c(subject_train, subject_test)
completeset <- data.frame(X, activity = y, subject = subject)

# Extracts only the measurements on the mean and standard deviation for each measurement. 

features <- read.table("features.txt", colClasses = "character", header = F)
mean_index <- grep("mean",features[, 2])
std_index <- grep("std", features[, 2])
index <- union(mean_index, std_index)
subfeatures <- features[index, 2]
subX <- X[ , index]
subdata <- data.frame(subX, activity = y, subject = subject)
names(subdata)[1:length(index)] <- subfeatures 

# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names. 

activity_labels = read.table("activity_labels.txt", colClasses="character")
library(plyr)
subdata$activity = mapvalues(y, from = activity_labels[, 1], to = activity_labels[, 2])

# creates a second, independent tidy data set 
# with the average of each variable for each activity and each subject.

res <- aggregate(. ~ subject + activity, subdata, mean)
write.table(res, "output.txt", row.names=F)
