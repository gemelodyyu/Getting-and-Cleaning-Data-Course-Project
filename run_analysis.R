#Set working directory 
setwd("~/Desktop/To Do 2019/Coursera R/UCI HAR Dataset")


if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip",method="curl")
unzip(zipfile="./data/Dataset.zip",exdir="./data")
path <- file.path("./data" , "UCI HAR Dataset")
files<-list.files(path, recursive=TRUE)
files


#Create one R script called run_analysis.R that does the following:
##1. Merges the training and the test sets to create one data set.
###Read the Activity files
dataActivityTest  <- read.table(file.path(path, "test" , "Y_test.txt" ),header = FALSE)
dataActivityTrain <- read.table(file.path(path, "train", "Y_train.txt"),header = FALSE)
###Read the Subject files
dataSubjectTrain <- read.table(file.path(path, "train", "subject_train.txt"),header = FALSE)
dataSubjectTest  <- read.table(file.path(path, "test" , "subject_test.txt"),header = FALSE)
###Read Fearures files
dataFeaturesTest  <- read.table(file.path(path, "test" , "X_test.txt" ),header = FALSE)
dataFeaturesTrain <- read.table(file.path(path, "train", "X_train.txt"),header = FALSE)

dataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
dataActivity<- rbind(dataActivityTrain, dataActivityTest)
dataFeatures<- rbind(dataFeaturesTrain, dataFeaturesTest)

names(dataSubject)<-c("subject")
names(dataActivity)<- c("activity")
dataFeaturesNames <- read.table(file.path(path, "features.txt"),head=FALSE)
names(dataFeatures)<- dataFeaturesNames$V2

dataCombine <- cbind(dataSubject, dataActivity)
Data <- cbind(dataFeatures, dataCombine)


##2. Extracts only the measurements on the mean and standard deviation for each measurement.
subdataFeaturesNames<-dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]

selectedNames<-c(as.character(subdataFeaturesNames), "subject", "activity" )
Data<-subset(Data,select=selectedNames)




##3. Uses descriptive activity names to name the activities in the data set
library(plyr)

activityLabels <- read.table(file.path(path, "activity_labels.txt"),header = FALSE)
head(Data$activity,30)


##4. Appropriately labels the data set with descriptive variable names.
names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))

#5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
tidydata<-aggregate(. ~subject + activity, Data, mean)
tidydata<-tidydata[order(tidydata$subject,tidydata$activity),]
write.table(tidydata, file = "tidydata.txt",row.name=FALSE)



