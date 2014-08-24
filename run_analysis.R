#
#Download data
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, "ProjectFile2.zip")


#Unzip and read data
unzip("ProjectFile2.zip")

   subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
         X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
         y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
    
  subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
        X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
        y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")

activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")

      features  <- read.table("./UCI HAR Dataset/features.txt")


#Read column labels 
headers <- features[,2]


#Assign names from headers to test and training data
names(X_test)  <- headers
names(X_train) <- headers


#Select columns with mean and standard deviation calculations
        mean_and_std <- grepl("mean\\(\\)|std\\(\\)", headers)
 X_test_mean_and_std <- X_test[,mean_and_std]
X_train_mean_and_std <- X_train[,mean_and_std]


#Merge all test and train rows
      subject_all <- rbind(subject_test, subject_train)
            X_all <- rbind(X_test_mean_and_std, X_train_mean_and_std)
            y_all <- rbind(y_test, y_train)
           merged <- cbind(subject_all, y_all, X_all)

#Rename column 1 and 2
names(merged)[1] <- "SubjectID"
names(merged)[2] <- "Activity"


#Aggregate by subjectid and activity
agg <- aggregate(. ~ SubjectID + Activity, data=merged, FUN = mean)


#Give activities better names
agg$Activity <- factor(agg$Activity, labels=activity_labels[,2])


#Write tidy output to text file
write.table(agg, file="./TidyFile.txt", sep="\t", row.names=FALSE)

