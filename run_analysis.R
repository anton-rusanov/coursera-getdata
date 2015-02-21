run.analysis <- function(skip.download = FALSE) {
  print("Started")
  oldWorkingDirectory <- getwd()
  if(!file.exists("./coursera-getdata-anton-rusanov")) {
    dir.create("./coursera-getdata-anton-rusanov")
  }
  setwd("./coursera-getdata-anton-rusanov")
  print("Set working directory")
  if (!skip.download) {
    originalDatasetUrl <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    tempZipFile <- tempfile(pattern="UCI-HAR-Dataset", tmpdir = ".", fileext = ".zip")
    print("Created temp file " + tempZipFile)
    download.file(originalDatasetUrl, tempZipFile, method="curl")
    print("Downloaded ZIP")
    tryCatch(unzip(tempZipFile), error = function(e) "Failed to unzip data archive. Error: " + e, finally = unlink(tempZipFile))
    print("Unzipped archive")
  } 

  features <- read.table("UCI HAR Dataset/features.txt")
  meanStdFeatureIndices <- grep("-mean\\(\\)|-std\\(\\)", features$V2)
  meanStdFeatureNames<- grep("-mean\\(\\)|-std\\(\\)", features$V2, value = TRUE)
  print("Got feature indices")
  
  print("Reading test data...")
  dataTest <- read.table("UCI HAR Dataset/test/X_test.txt")
  print("Read test data")
  dataTrain <- read.table("UCI HAR Dataset/train/X_train.txt")
  print("Read training data")
  dataAll <- merge(dataTest, dataTrain, all=TRUE)
  print("Merged data")
  dataMeanStd <- dataAll[, meanStdFeatureIndices]
  colnames(dataMeanStd) <- meanStdFeatureNames
  cat("Mean and std feature counts: ", dim.data.frame(dataMeanStd), "\n")
  
  print("Reading labels")
  labelsTest <- read.table("UCI HAR Dataset/test/y_test.txt")
  labelsTrain <- read.table("UCI HAR Dataset/train/y_train.txt")
  cat("Label counts. test: ", dim.data.frame(labelsTest), " train: ", dim.data.frame(labelsTrain), "\n")
  labelsAll <- rbind(labelsTest, labelsTrain)
  cat("All label counts: ", dim.data.frame(labelsAll), "\n")
  print("Read and merged labels")
  
  activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
  labelsAll[, "activity_label"] = activityLabels[labelsAll$V1,c('V2')]
  
  subjectTest <- read.table("UCI HAR Dataset/test/subject_test.txt")
  subjectTrain <- read.table("UCI HAR Dataset/train/subject_train.txt")
  subjectAll <- rbind(subjectTest, subjectTrain)
  cat("Subject dimensions: ", dim.data.frame(subjectAll), "\n")
  
  dataLabels <- cbind(dataMeanStd, subjectAll, labelsAll$activity_label)
  cat("Labeled data dimensions: ", dim.data.frame(dataLabels), "\n")
  colnames(dataLabels) <- c(meanStdFeatureNames, "subject", "activity_label")
  print("Added readable activity label names")
  print(head(dataLabels, n = 1))
  
  moltenData = melt(dataLabels, id = c("subject", "activity_label"))
  tidyData <- dcast(moltenData, formula = ...  ~ variable, mean)
  write.table(tidyData, file = "./tidyDataset.txt")
  
  setwd(oldWorkingDirectory)
  print("Done")
}