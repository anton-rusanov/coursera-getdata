run.analysis <- function(download.data = FALSE) {
  print("Started")
  # Maybe download and unzip the archive.
  if (download.data) {
    originalDatasetUrl <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    tempZipFile <- tempfile(pattern="UCI-HAR-Dataset", tmpdir = ".", fileext = ".zip")
    print("Created temp file")
    download.file(originalDatasetUrl, tempZipFile, method="curl")
    print("Downloaded ZIP")
    tryCatch(unzip(tempZipFile), error = function(e) "Failed to unzip data archive. Error: " + e, finally = unlink(tempZipFile))
    print("Unzipped archive")
  } 
  
  # Extract only the measurements on the mean and standard deviation for each measurement. 
  features <- read.table("UCI HAR Dataset/features.txt")
  meanStdFeatureIndices <- grep("-mean\\(\\)|-std\\(\\)", features$V2)
  meanStdFeatureNames<- grep("-mean\\(\\)|-std\\(\\)", features$V2, value = TRUE)
  print("Got -mean() and -std() features' indices and names")
  
  # Merge the variables from training and the test sets to create one data set.
  print("Reading test data...")
  dataTest <- read.table("UCI HAR Dataset/test/X_test.txt")
  print("Read test data")
  dataTrain <- read.table("UCI HAR Dataset/train/X_train.txt")
  print("Read training data")
  dataMerged <- merge(dataTest, dataTrain, all=TRUE)
  print("Merged data")
  dataMeanAndStd <- dataMerged[, meanStdFeatureIndices]
  
  # Merge the labels from training and the test sets to create one data set.
  print("Reading labels...")
  labelsTest <- read.table("UCI HAR Dataset/test/y_test.txt")
  labelsTrain <- read.table("UCI HAR Dataset/train/y_train.txt")
  labelsMerged <- rbind(labelsTest, labelsTrain)
  print("Read and merged labels")
  
  # Use descriptive activity names to name the activities in the data set.
  activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
  labelsMerged[, "prettyLabel"] = activityLabels[labelsMerged$V1,c('V2')]
  print("Added pretty names to labels")
  
  # Merge the subjects from training and the test sets to create one data set.
  subjectTest <- read.table("UCI HAR Dataset/test/subject_test.txt")
  subjectTrain <- read.table("UCI HAR Dataset/train/subject_train.txt")
  subjectMerged <- rbind(subjectTest, subjectTrain)
  print("Read and merged subjects")
  
  # Merge mean and standard deviation columns, subjects and descriptive names for labels in one dataset.
  dataLabels <- cbind(dataMeanAndStd, subjectMerged, labelsMerged$prettyLabel)
  colnames(dataLabels) <- c(meanStdFeatureNames, "subject", "activity_label")
  print("Set readable column names")
 
  # From the data set above, create a second, independent tidy data set with the average of each variable 
  # for each activity and each subject.
  meltedData = melt(dataLabels, id = c("subject", "activity_label"))
  tidyData <- dcast(meltedData, formula = ...  ~ variable, mean)
  print("Calculated means")
  write.table(tidyData, file = "tidyDataset.txt")
  print("Done")
}
