# This CodeBook detail the variables in the tidyLong dataset

The tidyLong dataset contains 4 columns.

## 1) subject_ID: This column contais the indexes of the 30 subjects that have participated in the experiment.

## 2) activities:  This columns contains the desriptions of the 6 activities each subject had to perform while wearing a Samsung SII smartphone in their waists. The activities are: ("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS","SITTING","STANDING","LAYING") 

## 3) variable: This column contains the different measurements taken from each activity the subjects engaged in. They represent readings from the cellphone sensors acellerometer and gyroscope. Since the Course Project required to 
enlist only the mean and standard deviation from the measurements, the total number drops from 561 initial to 79.

## 4) Mean_Value: This variable contains the average values from the measurements in the "variable" column. That is, each of those measurements were performed many times to each of the subjects and activities. In this column it is stored the average of those computations by each subject and activity.




