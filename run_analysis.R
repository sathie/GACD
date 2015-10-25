#Load dplyr and tidyr
library(dplyr)
library(tidyr)

#Read features
features <- read.table("./UCI HAR Dataset/features.txt")
features <- features[,2]

#Read activity names
activity <- read.table("./UCI HAR Dataset/activity_labels.txt", col.names = c("V1", "Activity"))
activity[2] <- c("Walking", "Walking upstairs", "Walking downstairs", "Sitting", "Standing", "Laying")  #Better activity names


#Read data function
readfun <- function(file1, file2, file3) {
        subject <- read.table(file1, col.names = "Subject")     #Read subject data
        X <- read.table(file2, col.names = features, colClasses = "numeric")            #Read X
        Y <- read.table(file3, col.names = "V1") %>%            #Read Y
                inner_join(activity, by = "V1")  %>%            #Join Y and activity
                select(Activity)                                #Select only activity column
        cbind(subject, Y, X) %>%                                #Bind tables together
                tbl_df
}

#Apply read data function to test and training datasets
testData <- readfun("./UCI HAR Dataset/test/subject_test.txt", "./UCI HAR Dataset/test/X_test.txt", "./UCI HAR Dataset/test/y_test.txt")
trainingData <- readfun("./UCI HAR Dataset/train/subject_train.txt", "./UCI HAR Dataset/train/X_train.txt", "./UCI HAR Dataset/train/y_train.txt")

#Determine which features contain mean or std
mean <- grepl("mean", features)                                 #Determine which feature names contain "mean"
std <- grepl("std", features)                                   #Determine which feature names contain "std"
meanstd <- as.logical(mean + std)                               #Add mean and std from the previous two steps
meanstd <- c(TRUE, TRUE, meanstd)                               #Add 2x TRUE to keep columns "Subject" and "Activity" later
rm(mean); rm(std)                                               #Remove data that isn't needed anymore

#Rename variables
features <- gsub("^t", "Time", features)
features <- gsub("^f", "Frequency", features)
features <- gsub("mean", "Mean", features)
features <- gsub("std", "Standard Deviation", features)
features <- gsub("()", "", features)
features <- gsub("-", " - ", features)
features <- gsub("Body", " Body", features)
features <- gsub("Acc", " Acceleration", features)
features <- gsub("Jerk", " Jerk", features)
features <- gsub("Gyro", " Gyro", features)
features <- gsub("Gravity", " Gravity", features)
features <- gsub("Mag", " Mag", features)
features <- gsub("\\()", "", features)
        

merged <- rbind(testData, trainingData)                         #Merge datasets
colnames(merged) <- c("Subject", "Activity", features)          #Give columns better names
merged <- merged[, meanstd]                                     #Select only columns that contain "mean" or "standard deviation"
merged <- select(merged, -contains("meanFreq"))                 #Drop columns that contain "meanFreq"

summarized <- group_by(merged, Subject, Activity) %>%           #Group by Subject and Activity
        summarise_each(funs(mean))                              #Summarize
rm(testData); rm(trainingData); rm(activity); rm(meanstd); rm(features)  #Remove data that isn't needed anymore
View(summarized)