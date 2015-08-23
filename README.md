##This README file details the steps taken to complete the Course Project of the Getting and Cleaning Data course

The Course Project requires the conclusion of 5 necessary steps to transform the raw data provided by the
link https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
into a tidy dataset.

The raw data is comprised of two sets of data (TEST and TRAIN) where each represent a different sample of subjects from study performing 6 diferent activities:
("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS","SITTING","STANDING","LAYING")
each of those activities generate multiple readings that are store/processed in different values (those correspond to the 561 columns of the raw dataset)

Both raw sets (TEST and TRAIN) came only with the measurements unlabeled. The original ZIP file contain separate files with the labels for the subjects and the activities performed.

The 5 steps required should get this raw data and generate a new dataset merging the TEST and TRAIN data, labeling the variables, activities and subjects, and calculate the mean for each measurement (which contains a mean() or sd() ) by subject and activity. So we should produce a smaller dataset averaging the multiples readings of the varibles which are contained in the raw data. The result is a tidy dataset with only one value per subject-activity pair for each of the variables.

The Script "run_analysis.R" contains all the code to perform the STEPS described below!

### STEP 1: Merges the training and the test sets to create one data set.

First it's necessary to download the ZIP files to your working directory.
The Zip files are located in the web address below: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

After Unzipping the files you need to load the datasets TEST and TRAIN into R and merge them. 
To merge the two raw dataset without mixing the order of the rows or columns
we can bind them together via the rbind function. This way we can assure the 
original datasets are preserved one on the top of the other.

The result is a complete dataset with 10299 rows and 561 columns. Step 1 done!

### STEP 2: Extracts only the measurements on the mean and standard deviation for each measurement

 Here we need to take a look to the "features.txt" file that came with the ZIP data.
 There we can see the names of the 561 variables provided and guess which are 
 computations related to mean() and sd() of the measurements. 

 The file "features.info.txt" explains how those varibles came to be. We can see
 that variables that end with mean() and std() (not sd()) are the ones we should
 extract from the dataset.
 
 So the first thing is to load "features.txt" into a vector "labels" in R.

To obtain the indexes of the varibles names that contain mean() and std() we can
use the function grep. The funtion should be applied to the second column of "labels".

Then we should combine the 2 indexes into one final index containing all instances
where mean() or std() appear. Sorting is desirable to keep the order of the
columns we are going to extract from the "complete" dataset.

Finally, to extract the variables we can use the argument complete[, IndexFinal]
so that we keep all the rows but only select the columns present in the IndexFinal


The completeMeanSd now contains all measurements for the Mean() and sd() variables
so STEP 2 completed!!

### STEP 3: Uses descriptive activity names to name the activities in the data set.

Now we should start labeling the activities to prepare for the Step 5 when it
will be required to compute the averages for each activity and subject.

The activities are in the archives "y_test" and "y_train" but they are encoded
without the descriptions. The descriptions are present in the "activity_labels.txt"
so we load the ativities into R in the same order as we did with the datasets, first 
the TEST then TRAIN, combining the 2 of them by rows via rbind again to encopass the
whole dataset.

After storing the "activities" vector in order we can load the labels into R and join
them with the respective activities via inner_join from the "dplyr" package. This way
we make sure the order is preserved.

To call the inner join function, first we should make sure the package "dplyr" is
installed. The code bellow checks if that's the case and make sure it installs if
it is not.

The new step is to load the activities label just created to the dataset itself
we can do this simply by assigning a new variable completeMeanSd$activities
which contains the second column of "activities" where labels were stored.

So Step 3 is completed ! The dataset contains a column of activities labeled!

### STEP 4: Appropriately labels the data set with descriptive variable names. 

We already have the "labels" loaded into R but we need to select only those
variable labels that are indexed by our "IndexFinal". We can create a new dataset
with only those called "VarLabels".

But we should remember that the last column on the dataset is a new variable
labeled "activities" so we should add those at the last position
To apply those VarLabels to the dataset we use the colnames function:

Step 4 is completed !!

### STEP 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

We haven't yet inserted the subjects into the dataset. So the first step is
to load them into R and combine the subjects from TEST and TRAIN the same way we
did before with other labels, that is binding them by rows.

After obtaining a list with all the subjects in "subjecID" we should join them
with the "completeMeanSd" dataset

To reorder the columns and put subjects (column 81) and activities (column 80) 
in the front:

Now we have to group them by subjects AND activities to obtain the mean() of the
measurements for each variable. The procedure can be seen in the HELP file of R
just type "?summarise_each" to the console and follow the example given;


But this tidy dataset has too many columns to read. A better way perhaps is to
put all measurements into 1 column since we'll be looking only to the mean of
each measurement for a particular subject and activity. We can do that with the
"reshape2" package. The procedure below make sure you have it installed !

After calling the "reshapes2" package we can melt the measurements into one 
column named "variable" and the results of the calculated means for each
are stored in the "Mean Value" column:

Finally we can export the tidyLong dataset to a TXT file

Step 5 completed !!!

### All the steps described here are include as commentaries in the "run_analysis.R" script to facilitate the review of the code itsef !!


