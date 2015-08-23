# This Script is part of the Getting and Cleaning Data Course Project
#
# The steps below follow exactly the order of the Course instructions
# to transform the raw Samsung dataset into a tidy dataset
#
# STEP 1:Merges the training and the test sets to create one data set.
#       
# First it's necessary to download the Samsung files to your working directory
# the Zip files are located in the web address below:
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
#
# After Unzipping them you need to load the datasets TEST and TRAIN into R:
#
#
test<-read.table("./UCI HAR Dataset/test/X_test.txt", header=FALSE, sep="", dec=".")
train<-read.table("./UCI HAR Dataset/train/X_train.txt", header=FALSE, sep="", dec=".")

# The previous commands loaded the raw datasets. To check if they have the same number
# (and names!) of variables you should run the following code: It should print TRUE !!

print(identical(names(test),names(train)))

# To merge the two raw dataset without mixing the order of the rows or columns
# we can bind them together via the rbind function. This way we can assure the 
# original datasets are preserved one on the top of the other:

complete<-rbind(test,train)

# The result is a complete dataset with 10299 rows and 561 columns. Step 1 done!
#
# STEP 2: Extracts only the measurements on the mean and standard deviation for
# each measurement
#
# Here we need to take a look to the "features.txt" file that came with the Samsung data.
# There we can see the names of the 561 variables provided and guess which are 
# computations related to mean() and sd() of the measurements. 
#
# The file "features.info.txt" explains how those varibles came to be. We can see
# that variables that end with mean() and std() (not sd()) are the ones we should
# extract from the dataset.
#
# So the first thing is to load "features.txt" into a vector "labels" in R:
labels<-read.table("./UCI HAR Dataset/features.txt", header=FALSE, sep="", dec=".")
#
# To obtain the indexes of the varibles names that contain mean() and std() we can
# use the fucntion grep. The funtion should be applied to the second column of "labels"

IndexMean<-grep("mean()", labels$V2)
IndexSd<-grep("std()", labels$V2)

# Then we should combine the 2 indexes into one final index containing all instances
# where mean() or std() appear. Sorting is desirable to keep the order of the
# columns we are going to extract from the "complete" dataset.

IndexFinal<-sort(c(IndexMean, IndexSd))

# Finally, to extract the variables we can use the argument complete[, IndexFinal]
# so that we keep all the rows but only select the columns present in the IndexFinal

completeMeanSd<-complete[, IndexFinal]

# The completeMeanSd now contains all measurements for the Mean() and sd() variables
# so STEP 2 completed!!

# STEP 3: Uses descriptive activity names to name the activities in the data set
#
# Now we should start labeling the activities to prepare for the Step 5 when it
# will be required to compute the averages for each activity and subject.
#
# The activities are in the archives "y_test" and "y_train" but they are encoded
# without the descriptions. The descriptions are present in the "activity_labels.txt"
# so we load the ativities into R in the same order as we did with the datasets, first 
# the TEST then TRAIN, combining the 2 of them by rows via rbind again to encopass the
# whole dataset.

y_test<-read.table("./UCI HAR Dataset/test/y_test.txt", header=FALSE, sep="", dec=".")
y_train<-read.table("./UCI HAR Dataset/train/y_train.txt", header=FALSE, sep="", dec=".")

activitiesID<-rbind(y_test,y_train)

# After storing the "activities" vector in order we can load the labels into R and join
# them with the respective activities via inner_join from the "dplyr" package. This way
# we make sure the order is preserved.

act_labels<-read.table("./UCI HAR dataset/activity_labels.txt", header=FALSE, sep="")

# To call the inner join function, first we should make sure the package "dplyr" is
# installed. The code bellow checks if that's the case and make sure it installs if
# it is not.

bug<-try(library(dplyr),silent = T)

if (class(bug)=="character") { 
        library(dplyr)
        } else {
        install.packages("dplyr")
        library(dplyr)
        }


activities<-inner_join(activitiesID,act_labels, by="V1")

# The new step is to load the activities label just created to the dataset itself
# we can do this simply by assigning a new variable completeMeanSd$activities
# which contains the second column of "activities" where labels were stored.

completeMeanSd$activities<-activities[,2]

# So Step 3 is completed ! The dataset contains a column of activities labeled!

#STEP 4: Appropriately labels the data set with descriptive variable names. 
#
# We already have the "labels" loaded into R but we need to select only those
# variable labels that are indexed by our "IndexFinal". We can create a new dataset
# with only those called "VarLabels"

VarLabels<-filter(labels,V1 %in% IndexFinal)

# But we should remember that the last column on the dataset is a new variable
# labeled "activities" so we should add those at the last position
# To apply those VarLabels to the dataset we use the colnames function:

names(completeMeanSd)<-VarLabels$V2
names(completeMeanSd)[80]<-"activities"

# Step 4 is completed !!
#
# STEP 5: From the data set in step 4, creates a second, independent tidy data set
# with the average of each variable for each activity and each subject.
#
# We haven't yet inserted the subjects into the dataset. So the first step is
# to load them into R and combine the subjects from TEST and TRAIN the same way we
# did before with other labels, that is BINDIND them by rows.
#

subject_test<-read.table("./UCI HAR Dataset/test/subject_test.txt")
subject_train<-read.table("./UCI HAR Dataset/train/subject_train.txt")

subjectID<-rbind(subject_test,subject_train)

# After obtaining a list with all the subjects in "subjecID" we should join them
# with the "completeMeanSd" dataset

completeMeanSd$subjectID<-subjectID$V1

# To reorder the columns and put subjects (column 81) and activities (column 80) 
#in the front:

completeMeanSd<-completeMeanSd[,c(81,80,1:79)]

# Now we have to group them by subjects AND activities to obtain the mean() of the
# measurements for each variable. The procedure can be seen in the HELP file of R
# just type "?summarise_each" to the console and follow the example given;


groups<-completeMeanSd %>% group_by(subjectID,activities)
tidy<-groups%>% summarise_each(funs(mean))

# But this tidy dataset has too many columns to read. A better way perhaps is to
# put all measurements into 1 column since we'll be looking only to the mean of
# each measurement for a particular subject and activity. We can do that with the
# "reshape2" package. The procedure below make sure you have it installed !

bug<-try(library(reshape2),silent = T)

if (class(bug)=="character") { 
        library(reshape2)
} else {
        install.packages("reshape2")
        library(reshape2)
}

#After calling the "reshapes2" package we can melt the measurements into one 
# column named "variable" and the results of the calculated means for each
# are stored in the "Mean Value" column:

tidyLong<-melt(tidy, id=c("subjectID","activities"))

names(tidyLong)[4]<-"Mean_Value"

# Finally we can export the tidyLong dataset to a TXT file

write.table(tidyLong,"./tidyLong.txt", row.name=FALSE)


# Step 5 completed !!!

print("All steps completed ! Check your working directory for the tidyLong file !!")
