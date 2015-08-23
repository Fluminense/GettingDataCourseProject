##This README file details the steps taken to complete the Course Project of the Getting and Cleaning Data course

The Course Project requires the conclusion of 5 necessary steps to transform the raw data provided by the
link https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
into a tidy dataset.

The raw data is comprised of two sets of data (TEST and TRAIN) where each represent a different sample of subjects from study performing 6 diferent activities:
("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS","SITTING","STANDING","LAYING")
each of those activities generate multiple readings that are store/processed in different values (those correspond to the 561 columns of the raw dataset)

Both raw sets (TEST and TRAIN) came only with the measurements and the ZIP file contain separate files with the labels for the subjects and the activities performed.

The 5 steps required should get this raw data and generate a new dataset merging the TEST and TRAIN data, labeling the variables, activities and subjects, and calculate the mean for each measurement (which contains a mean() or sd() ) by subject and activity. So we should produce a smaller dataset averaging the multiples readings of the varibles which are contained in the raw data. The result is a tidy dataset with only one value per subject-activity pair for each of the variables.


