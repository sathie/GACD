---
title: "GACD Course Project ReadMe"
author: "Sarah Thiesen""
date: "25.10.2015"
output:
  html_document:
    keep_md: yes
---

# Read Me

How to run the script:
* Have the Samsung data in your working directory (unzipped)
* Make sure dplyr and tidyr are installed
* Run run_analysis.R
* The script creates a table called "merged" that contains the merged data, and a table called "summarized"" that contains the tidy data

How the script works
1. The script first loads dplyr and tidyr
2. It then loads features.txt and activity_labels.txt for later use
3. It creates a read function that reads subject data, X and Y and binds them together with the activity labels from step 2
4. The function from step 3 is applied to both the test data and the training data
5. A logical called meanstd is created that contains information on which variables contain the words "mean" or "std"
6. The variables in "features" are renamed
7. Test data and training data are merged
8. The new column names from step 6 are used on the merged dataset
9. The logical from step 5 is used to select only variables that contain "mean" or "std"
10. Variables with names that contain "meanFreq" are dropped
11. The merged data is grouped by subject and activity. The data is then summarized in a new table called "summarized"
12. Data that isn't needed anymore is removed
13. The tidy (summarized) dataset is displayed