#########################################################################################
## Download the data zip file and unzip
#########################################################################################
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "UCI_HAR_Dataset.zip")

## Unzip the downloaded file
unzip("UCI_HAR_Dataset.zip")

#########################################################################################
## Read the data files
#########################################################################################
## Activity Labels
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", header = FALSE)
names(activity_labels) <- c('Activity', 'Activity_Description')
activity_labels

## Features
features <- read.table("UCI HAR Dataset/features.txt", header = FALSE)
head(features)

nrow(features)

## Read the Train X data
train_x <- read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE)

head(train_x)

## Total Number of Columns in X
ncol(train_x)

## Total rows in X
nrow(train_x)

## Read the Train Y data
train_y <- read.table("UCI HAR Dataset/train/y_train.txt", header = FALSE)

head(train_y)

## Number of rows in the y train
nrow(train_y)

## Subjects_train data
train_subject <- read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE)
print(nrow(train_subject))

head(train_subject)

## Read the Test X dataset
test_x <- read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE)

head(test_x)

dim(test_x)

## Read the Test Y dataset
test_y <- read.table("UCI HAR Dataset/test/y_test.txt", header = FALSE)

head(test_y)

dim(test_y)

## Read the subjects_test dataset
test_subject <- read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE)
nrow(test_subject)

head(test_subject)

#########################################################################################
## Rename the columns for train_x and test_x
#########################################################################################
## Train set
names(train_x) <- features[,"V2"]
head(train_x)

## Test set
names(test_x) <- features[,"V2"]
head(test_x)

#########################################################################################
## Create a variable that will let us know if the data is from train set or test set
#########################################################################################
## Train set
train_x["SampleType"] <- "Train"
## Test set
test_x["SampleType"] <- "Test"

#########################################################################################
## change the column name for Lables before merging with X training matrix
#########################################################################################
## Train set
names(train_y) <- c('Label')
head(train_y)

## Test set
names(test_y) <- c('Label')
head(test_y)

#########################################################################################
## Add the labels to the Train set and Test set from train_y and test_y, respectively
#########################################################################################
## Train set
train <- cbind(train_x, train_y)
head(train)

## Test set
test <- cbind(test_x, test_y)
head(test)

#########################################################################################
## Add the Subjects to the Train set and Test set
#########################################################################################
## Train set
names(train_subject) <- c('Subject')
head(train_subject)

train_with_subjects <- cbind(train, train_subject)
head(train_with_subjects)

## Test set
names(test_subject) <- c('Subject')
head(test_subject)

test_with_subjects <- cbind(test, test_subject)
head(test_with_subjects)

#########################################################################################
## Step 1: Merge the two tables together using rbind
#########################################################################################
final_DF <- rbind(train_with_subjects, test_with_subjects)
head(final_DF)

# Dimension of the X matrix after combining the training data and the testing data
dim(final_DF)

#########################################################################################
## Step 2: Column indexes for Mean and STD columns
#########################################################################################
## The following gives the column indexes whose names contain "mean" or "std"
grep("mean|std", names(final_DF))

## the following gives the list of column names that contain "mean" or "std"
names(final_DF)[ grep("mean|std", names(final_DF)) ]

## Finally, the following gives the matrix that contains means and standard deviations
means_and_std <- final_DF[, names(final_DF)[ grep("mean|std", names(final_DF)) ]]
head(means_and_std)

#########################################################################################
## Step 3: Add the Descriptive Activity labels to the dataset - First Tidy dataset
#########################################################################################
final_DF_Label_Desc <- merge(final_DF, activity_labels, by.x = "Label", by.y = "Activity", all.x = TRUE)
head(final_DF_Label_Desc)

dim(final_DF_Label_Desc)

#########################################################################################
## Step 4: Appropriately labels the data set with descriptive variable names
#########################################################################################

## This step was done along with step 1. Variable names were assigned descriptive names 
## while merging the training set and test set together.

#########################################################################################
## Step 5: From the data set in step 4, creates a second, independent tidy data set with
## the average of each variable for each activity and each subject
#########################################################################################

library(dplyr)

final_DF_Label_Desc1 <- subset(final_DF_Label_Desc, select = -c(SampleType, Label))

Tidy_DF_Summary <- final_DF_Label_Desc1 %>% group_by(Activity_Description, Subject) %>% summarise_each(mean)

## Second Tidy dataset that will be submitted
Tidy_DF_Summary

dim(Tidy_DF_Summary)

#########################################################################################
## Step 6: Save the Final Tidy Dataset
#########################################################################################
write.table(Tidy_DF_Summary, "Human_Activity_Recognition_with_Smartphones.txt", sep = "\t", row.names = FALSE)