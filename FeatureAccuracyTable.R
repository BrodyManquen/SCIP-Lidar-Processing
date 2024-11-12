install.packages("easypackages")
library(easypackages)
# library packages. Easypackages should automatically install those that not installed on any device
libraries("here", "sf", "dplyr", "NLP")

# get local directory
here()
totalGPKG <- here("FeatureError\\data\\ErrorVectors.csv")
total_features <- read_csv(totalGPKG)

## clean feature classes for analysis
total_features$Type[total_features$Type=="AOI"]<-NA ## removing AOI: category was used for cautious field-checking, not true "classification"

total_features$Type[total_features$Type=="Enclosure"]<-"Wall" ## reclass Enclosure as Wall. Functionally same in lidar

#create "Other" class, add feature types
### skip this step if Other class not desired!
total_features$Type[total_features$Type=="Cave or Shelter"|total_features$Type=="Cistern"
                    |total_features$Type=="Mine"|total_features$Type=="Mound"|total_features$Type=="Path"
                    |total_features$Type=="Pit"|total_features$Type=="Quarry"|total_features$Type=="Road"
                    |total_features$Type=="Threshing Floor"] <- "Other"

# total counts by Type
total_counts <- count(total_features, Type)
# total counts by Island
isl_counts <- count(total_features, IslandCode)
# total counts by Success/Error
error_counts <- count(total_features, Type, Success_Er)
# total counts by Feature_ID
feat_count <- count(total_features, Feature_ID)

# Subsets of Error Counts by Feature Type
struct <- subset(error_counts, Type == "Structure")
wall <- subset(error_counts, Type == "Wall")
terrace <- subset(error_counts, Type == "Terrace")
other <- subset(error_counts, Type == "Other")

# Calculate TP, FP, FN & create Accuracy Table

acc_table <- total_features %>% group_by(Type) %>% count(Success_Er) %>%
  pivot_wider(names_from=Success_Er, values_from=n,values_fill=0)%>% ungroup() %>% na.omit() %>%
  mutate(Count=rowSums(across(where(is.numeric)))) %>%
  mutate(Accuracy=`True Positive`/Count, 
         Precision=`True Positive`/(`True Positive`+`False Positive`), 
         Recall=`True Positive`/(`True Positive`+`False Negative`))%>%
  mutate(F1=2*(Precision*Recall)/(Precision+Recall))

acc_table
# subset table with only feature types in the "Other" group
### skip the "Other" grouping above to get accuracy table with all feature types that compose Other
acc_table_other <- acc_table%>%filter(!Type=="Wall" & !Type== "Structure"&!Type== "Terrace")
acc_table_other