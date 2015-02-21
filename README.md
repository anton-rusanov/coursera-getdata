# 'Getting and Cleaning Data' Course Project

## About the script
There are two modes of running the script:
- In the default mode the script assumes you already have the dataset downloaded and extracted to folder 'UCI HAR Dataset'. 
- In the "convenience" mode the script will nicely download the dataset for you and extract that to the folder specified above.

Once the data is in 'UCI HAR Dataset' folder, the script does the following:
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## How to run the script
1. Download the [dataset] (https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)
2. Download [run_analysis.R] (https://raw.githubusercontent.com/anton-rusanov/coursera-getdata/master/run_analysis.R)
3a. DEFAULT MODE. Place the script to the folder that contains unzipped 'UCI HAR Dataset' folder (not inside).
3b. CONVENIENCE MODE. Place the script somewhere on your computer, it will download the dataset itself.
4. Open 'R Studio', set the working directory where run_analysis.R is placed, source the script, and run the analysis function. 
a. DEFAULT MODE. 
Type in console:
```
setwd("<path/to/directory/where/script/resides>")
source("run_analysis.R")
run_analysis()
```
b. CONVENIENCE MODE. 
Type in console:
```
setwd("<path/to/directory/where/script/resides>")
source("run_analysis.R")
run_analysis(download.data = TRUE)
```

The resulting file has name *tidyDataset.txt* and is placed in the folder where the script resides.
