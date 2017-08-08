# --------------------------------------------------------------------
# run_analysis.R
# --------------------------------------------------------------------

rm(list=ls())

library(dplyr)
library(reshape2)

# *****************************
# *** Process: Getting Data    
# *****************************

# 1. Download the data   
    zipfile <- "samsungdata.zip"
    extractfolder <- "UCI HAR Dataset"
    if(!file.exists(zipfile)) {
        fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        download.file(fileURL, zipfile, method="curl")
    }
    # Extract files from zip file
    # (check if folder contained in zip file is already extracted)
    if(!file.exists(extractfolder) &
       !file.exists("data") ) {
        unzip(zipfile)    
        file.rename(extractfolder,"data")
    }

# 2. Read the data     
    
    # Function to read files with data.table format using common parameters
    get.data <- function(filename, col.names) {
        require(data.table)
        output <- as.data.table(read.table(filename, 
                                           header=FALSE, 
                                           col.names = col.names))
        output
    }
    
    # Read data files
    features      <- get.data("./data/features.txt",        c("id.feat","feature"))
    activities    <- get.data("./data/activity_labels.txt", c("id.act","activity"))
    train.x       <- get.data("./data/train/X_train.txt")
    test.x        <- get.data("./data/test/X_test.txt")
    train.y       <- get.data("./data/train/Y_train.txt", c("id.act"))
    test.y        <- get.data("./data/test/Y_test.txt",   c("id.act"))
    train.subject <- get.data("./data/train/subject_train.txt", c("subject"))
    test.subject  <- get.data("./data/test/subject_test.txt",   c("subject"))

# *****************************    
# *** Process: Cleaning Data    
# *****************************    
# 1.Merges the training and the test sets to create one data set.
    
    # Merge training and test data
    data <- bind_rows(train.x, test.x)
    
    # Merge activities from training and test sets
    desc.activity <- bind_rows(train.y, test.y)
    desc.activity <- merge(desc.activity, activities, by = "id.act", all = TRUE)
    # Merge activities from training and test sets
    desc.subject  <- bind_rows(train.subject, test.subject)
    
# 2.Extracts only the measurements on the mean and standard deviation 
# for each measurement.
    # features whose names either end with "mean()" or "std()" are kept; the rest are dismissed.
    selected.vars <- grep("(mean|std)\\(\\)$", features$feature)
    selected.var.names <- grep("(mean|std)\\(\\)$", features$feature, value=TRUE)
    # Keep only the selected variables in the data set
    data <- subset(data, select=selected.vars)

# 3.Uses descriptive activity names to name the activities in the data set
    # Add descriptive variables (activity and subject) to the data set 
    data <- bind_cols(desc.activity, desc.subject, data)

# 4.Appropriately labels the data set with descriptive variable names.
    
    # Take the features data.table and make the following replacements:
    #   "t" found at the beginning --> "Time."
    #   "f" found at the beginning --> "Freq."
    #   "-" found --> "."
    #   "(" or ")" found --> deleted
    #  Column names for the data set include: 
    #       descriptive variable names (activity and subject) 
    #       and the corrected labels for features.
    names(data) <- c(names(desc.activity), names(desc.subject),
                     gsub("^t", "Time.",
                          gsub("^f", "Freq.",
                               gsub("\\-", ".",
                                    gsub("\\(|\\)", "", 
                                         selected.var.names)))))

# 5.From the data set in step 4, creates a second, independent tidy data set
#   with the average of each variable for each activity and each subject.
    
    # Copy the original data set into 'tidy.data'
    tidy.data <- data
    tidy.data$id.act <- NULL
    # All measurements (columns) are transposed into rows
    tidy.data <- melt(tidy.data, c("activity", "subject"))
    # Summarize data set to get the average for each measurement
    tidy.data <- dcast(tidy.data, activity + subject ~ variable, mean)
    # Summarized data is saved into a a file called `tidy_data.txt`
    write.table(tidy.data, 
                file = "tidy_data.txt", 
                row.names = FALSE,
                quote = FALSE)





