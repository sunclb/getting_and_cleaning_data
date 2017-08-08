# Getting and Cleaning Data - Assignment Week 4 - Course Project

The R script performs the following tasks:

Process: Getting Data
1. Download the dataset and unzip files into a folder called "data" 
   (both actions are done only if data was not already extracted before)
2. Read data from the files listed below:
* `features.txt`
* `activity_labels.txt`
* `train/X_train.txt`
* `test/X_test.txt`
* `train/Y_train.txt`
* `test/Y_test.txt`
* `train/subject_train.txt`
* `test/subject_test.txt`

Process: Cleaning Data
1. Merge training and test data sets, the ouput of this step are 3 objects:
*`data`: contains the merge of 'X_train.txt' and 'X_test.txt' 
*`desc.activity`: contains the merge of 'Y_train.txt' and 'Y_test.txt' and  joined to 'activity_labels.txt' to get activity names
*`desc.subject`: contains the merge of 'subject_train.txt' and 'subject_test.txt'

2. Keep only 'mean' and 'standard deviation' measurements in the data set. 
For this step, features whose names either end with "mean()" or "std()" are kept; the rest are dismissed.

3. Activity and subject data is added as descriptive variables in the data set. 

4. In this step, variable names are assigned to the data set. 
The source data for this is the data coming from 'features.txt' and some replacements are done as described below:
* `"t" found at the beginning --> "Time."`
* `"f" found at the beginning --> "Freq."`
* `"-" found --> "."`
* `"(" or ")" found --> deleted`
Column names for the data set include: descriptive variable names (activity and subject) and the corrected labels for features.

5. A tidy data set is created based on the data set obtained in the previous step. This task is performed in 2 steps:
a) all measurements (columns) are transposed into rows
b) the previous resulting data set is summarised to get the average for each measurement
Summarized data is saved into a a file called `tidy_data.txt`.
	