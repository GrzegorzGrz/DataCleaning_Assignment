
library(dplyr)

#1. Merge the training and the test sets to create one data set

  #a. Load Data
unzip(zipfile = "getdata_projectfiles_UCI HAR Dataset.zip")
file_names_test <- list.files("UCI HAR Dataset/test/", pattern = ".txt")
file_names_train <- list.files("UCI HAR Dataset/train/", pattern = ".txt")
datasets_names <- c("subject", "X", "y")
test_data_temp <- list()
train_data_temp <- list()

for (i in file_names_test) {
  
  test_data_temp[[i]] <- read.delim(paste("UCI HAR Dataset/test/", i, sep = ""), 
                          header = FALSE, sep = "", dec = ".")
}
test_data <- data.frame(test_data_temp)
names(test_data) <- datasets_names

for (i in file_names_train) {
  
  train_data_temp[[i]] <- read.delim(paste("UCI HAR Dataset/train/", i, sep = ""), 
                               header = FALSE, sep = "", dec = ".")
}
train_data <- data.frame(train_data_temp)
names(train_data) <- datasets_names

data_merged <- rbind(test_data, train_data)

#4 Appropriately labels the data set with descriptive variable names.

features <- read.delim(paste("UCI HAR Dataset/features.txt", sep = "/"), header = FALSE, sep = "", dec = ".")
data_merged_names <- c("subject", features$V2, "activity")
names(data_merged) <- data_merged_names

#2. Extract only the measurements on the mean and standard deviation for each measurement
data_merged_filtered <- select(data_merged, subject, activity, grep("*-mean\\(\\)*|*-std\\(\\)*", features$V2, value=TRUE))

#3 Uses descriptive activity names to name the activities in the data set
#a. Read activity labels 
act_labels <- read.delim(paste("UCI HAR Dataset/activity_labels.txt", sep="/"), header = FALSE, sep = "", dec = ".")
#b. Replace numbers with activity labels
data_merged_filtered <- merge(data_merged_filtered, act_labels, by.x = "activity", by.y = 1, all.x = TRUE)
data_merged_filtered <- subset(data_merged_filtered, select = -1)
colnames(data_merged_filtered)[68] <- c("activity")


# 5 creates a second, independent tidy data set with the average of each variable for each activity and each subject.

data_tidy_final <- data_merged_filtered %>% group_by(subject, activity) %>% summarise_all(mean)

# Final file
write.table(data_tidy_final, file = "data_tidy.txt", row.name=FALSE) 
