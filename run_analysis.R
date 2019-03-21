#1 Load needed libraries
library(dplyr, tidyr)

#2. Set working directory, download zip file & unzip file
#unzips to C:\Users\Eric\Desktop\coursera\3. Getting and Cleaning Data\Course Project\UCI HAR Dataset
setwd("C:/Users/Eric/Desktop/coursera/3. Getting and Cleaning Data/Course Project")
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL, destfile="HAR.zip")
unzip("HAR.zip")

#3. Read and prepare files with column names and labels
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt") #translates acivities (1-6)
features <- read.table("UCI HAR Dataset/features.txt") #column names for x tables
feature_names <- as.character(pull(features, V2)) #put features into a vector
keep <- grepl("mean|std", feature_names) & !grepl("Freq", feature_names) #list of columns to keep

#4. preparte train data
#read raw files
train_x <- read.table("UCI HAR Dataset/train/X_train.txt") #observations
train_y <- read.table("UCI HAR Dataset/train/y_train.txt") #rows correspond to x file. 1-6. Id type of activity
train_subject <- read.table("UCI HAR Dataset/train/subject_train.txt") #rows correspond to x file. 1-30. Id person

#get column names and select columns
names(train_x) <- feature_names #apply feature names to column headers
train_x <- train_x[, keep] #select mean and std columns
train_x <- mutate(train_x, data_source = "train") #add data source id

#add activity and subject id
names(train_y) <- c("activity_code")
names(train_subject) <- c("subject_id")
train_data <- tbl_df(cbind(train_subject, train_y, train_x))

#5. preparte test data (same as prepare train data code)
#read raw files
test_x <- read.table("UCI HAR Dataset/test/X_test.txt") #observations
test_y <- read.table("UCI HAR Dataset/test/y_test.txt") #rows correspond to x file. 1-6. Id type of activity
test_subject <- read.table("UCI HAR Dataset/test/subject_test.txt") #rows correspond to x file. 1-30. Id person

#get column names and select columns
names(test_x) <- feature_names #apply feature names to column headers
test_x <- test_x[, keep] #select mean and std columns
test_x <- mutate(test_x, data_source = "test") #add data source id

#add activity and subject id
names(test_y) <- c("activity_code")
names(test_subject) <- c("subject_id")
test_data <- tbl_df(cbind(test_subject, test_y, test_x))

#6. combine test and train
har_data <- rbind(train_data,test_data)
#convert activity code to english
har_data2 <- left_join(har_data, activity_labels, by = c("activity_code" = "V1"))
har_data3 <- har_data2 %>%
        rename(activity = V2) %>%
        select(-activity_code)
#make separate tidy data for mean and std measures        
mean_keep <- har_data3 %>%
        select(subject_id, activity, data_source, contains("mean()")) %>%
        gather(measure, mean, contains("mean()"))
std_keep <- har_data3 %>%
        select(subject_id, activity, data_source, contains("std()")) %>%
        gather(measure, std, contains("std()"))
#combine mean and std tidy data to data set with 1 observations per subject-activity-measure
har_final <- cbind(mean_keep,std_keep[,5])

#7. Summarize: get mean for each observation
har_means <- har_final %>%
        group_by(subject_id, activity, measure) %>%
        summarize(mean_of_means=mean(mean),
                  mean_of_stds=mean(std))