##Getting and Cleaning Data Course Project

library(dplyr)
library(data.table)

#Download the dataset
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
featureNames <- read.table("UCI HAR Dataset/features.txt", col.names = c("n", "functions"))

#Read training data
subjectTrain <- read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE)
activityTrain <- read.table("UCI HAR Dataset/test/y_test.txt", header = FALSE)
featuresTrain <- read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE)

#Read test data
subjectTest <- read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE)
activityTest <- read.table("UCI HAR Dataset/test/y_test.txt", header = FALSE)
featuresTest <- read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE)

#Part 1 - Merge training and test datasets
subject <- rbind(subjectTrain, subjectTest)
activity <- rbind(activityTrain, activityTest)
features <- rbind(featuresTrain, featuresTest)

#Name the columns
colnames(features) <- t(featureNames[2])

#Merge the data
colnames(activity) <- "Activity"
colnames(subject) <- "Subject"
completeData <- cbind(features, activity, subject)

#Part 2 - Extract only the measurements on the mean and standard deviation for each measurement 
TidyData <- completeData %>% select(subject, code, contains("mean"), contains("std"))

#Part 3 - Uses descriptive activity names to name the activities in the data set
TidyData$code <- activityLabels[TidyData$code, 2]

#Part 4 - Appropriately labels the data set with descriptive variable names
names(TidyData)[2] = "activity"
names(TidyData) <- gsub("Acc", "Accelerometer", names(TidyData))
names(TidyData) <- gsub("Gyro", "Gyroscope", names(TidyData))
names(TidyData) <- gsub("BodyBody", "Body", names(TidyData))
names(TidyData) <- gsub("Mag", "Magnitude", names(TidyData))
names(TidyData) <- gsub("^t", "Time", names(TidyData))
names(TidyData) <- gsub("^f", "Frequency", names(TidyData))
names(TidyData) <- gsub("tBody", "TimeBody", names(TidyData))
names(TidyData) <- gsub("-mean()", "Mean", names(TidyData), ignore.case = TRUE)
names(TidyData) <- gsub("-std()", "STD", names(TidyData), ignore.case = TRUE)
names(TidyData) <- gsub("-freq()", "Frequency", names(TidyData), ignore.case = TRUE)
names(TidyData) <- gsub("angle", "Angle", names(TidyData))
names(TidyData) <- gsub("gravity", "Gravity", names(TidyData))

#Part 5 - From the data set in step 4, creates a second, independent tidy data 
##set with the average of each variable for each activity and each subject
FinalData <- TidyData %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))
write.table(FinalData, "FinalData.txt", row.name=FALSE)

