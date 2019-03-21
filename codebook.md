# Codebook for Getting and Cleaning Data project

## Source Data
* http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 
* Specific data sets: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

## Summary of data
### Key details
* 30 individual subjects
* 6 activities
* multiple observations for each subject and activity
* 561-feature vector of different measurements taken for each individual performing each activity (see attribute information below)
* Each of these measurements in the data that was used was really the mean or standard deviation of the raw sampling by the accelerometer and gyroscope

### From the University of California Irvine website:
Data Set Information:

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

Check the README.txt file for further details about this dataset. 

A video of the experiment including an example of the 6 recorded activities with one of the participants can be seen in the following link: [Web Link]

An updated version of this dataset can be found at [Web Link]. It includes labels of postural transitions between activities and also the full raw inertial signals instead of the ones pre-processed into windows. 

Attribute Information:
For each record in the dataset it is provided: 
- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration. 
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment. 

## Data transformation
* Data was first downloaded to my computer
* Training data ("train_x") and testing data ("test_x") contain the observations (561 data points plus the activity code)
* These were combined with "subject_train" and "subject_test" to get the subject ID for each record
* The activity code was translated to English (e.g., WALKING) using the "activity_label" file
* Column headings from the "features" file were applied. These are the attributes being measured in that column (e.g., fBodyAcc-mean()-X)
* Per the assignment, only features related to mean and standard deviation were kept (as well as the activity and subject ID)
* Test and train data set were combined (with a data_source variable created to identify the original source)
* This data was then transformed into a tidy data set (described below)

## Tidy data
* output: "har_final"
* 339,867 records
* 6 columns: 
  1. subject_id (1-30)
  2. activity (STANDING, WALKING, etc.)
  3. data_source (train or test)
  4. measure (e.g. fBodyAcc-mean()-X) 
  5. mean: each attribute (e.g., fBodyAcc-...-X) had two components (mean and std). These were split into two columns (mean and std).
  6. std

## Final data
* "har_means"
* Per the assignment, the tidy data was then summarized by subject_id, activity, and measurment resulting in a table wtih 5.940 observations and 5 columns:
  1. subject_id (1-30)
  2. activity (STANDING, WALKING, etc.)
  3. measure (e.g. fBodyAcc-mean()-X) 
  4. The mean of the mean of the measurements
  5. the mean of the std of the measurements
