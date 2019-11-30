# importing the four files required. TSV files required sep=\t
advertiserData <- read.csv("C:/Users/John/Documents/TransformDate/transform_date_sample_data/advertiser.csv", header = TRUE)
campaignData <- read.csv("C:/Users/John/Documents/TransformDate/transform_date_sample_data/campaigns.csv", header = TRUE)
clicksData <- read.table("C:/Users/John/Documents/TransformDate/transform_date_sample_data/clicks.tsv", sep = '\t', header = TRUE)
impressionsData <- read.table("C:/Users/John/Documents/TransformDate/transform_date_sample_data/impressions.tsv", sep = '\t', header = TRUE)

# creating new column for the datetime objects to be stored in, no timezone specified yet
clicksData$joined_date <- as.POSIXct(paste(clicksData$date, clicksData$time), format="%d/%m/%Y %H:%M:%S")

# specifying that datetime objects in the same row as pacific timezones are in America/Los_Angeles timezone
clicksData[clicksData$timezone=="Pacific time",]$joined_date <- as.POSIXct(paste(clicksData[clicksData$timezone=="Pacific time",]$joined_date), tz = "America/Los_Angeles")

# same as previous line just for eastern times
clicksData[clicksData$timezone=="Eastern time",]$joined_date <- as.POSIXct(paste(clicksData[clicksData$timezone=="Eastern time",]$joined_date), tz = "America/New_York")

# now that the different timezones are specified we can use as.posixt on the whole column specifying UTC timezone
clicksData$joined_date <- as.POSIXct(clicksData$joined_date, tz="UTC", format="%d/%m/%Y %H:%M:%S")

# same as previous four lines except this time for impressions data
impressionsData$joined_date <- as.POSIXct(paste(impressionsData$date, impressionsData$time), format="%d/%m/%Y %H:%M:%S")
impressionsData[impressionsData$timezone=="Pacific time",]$joined_date <- as.POSIXct(paste(impressionsData[impressionsData$timezone=="Pacific time",]$joined_date), tz = "America/Los_Angeles")
impressionsData[impressionsData$timezone=="Eastern time",]$joined_date <- as.POSIXct(paste(impressionsData[impressionsData$timezone=="Eastern time",]$joined_date), tz = "America/New_York")
impressionsData$joined_date <- as.POSIXct(impressionsData$joined_date, tz="UTC", format="%d/%m/%Y %H:%M:%S")

# merging advertiser and campaign data as the only column advertiser data shares with other DF's is advertiser_id in campaign data
adAndCam <- merge(advertiserData, campaignData, by="advertiser_id")
colnames(adAndCam)[colnames(adAndCam)=="name.x"] <- "advertiser_name"
colnames(adAndCam)[colnames(adAndCam)=="name.y"] <- "campaign_name"

# using the new adAndCam df we can merge with the clicks df and impressions df which have the transformed dates.
clicks_processed <- merge(clicksData, adAndCam, by="campaign_id")
impressions_processed <- merge(impressionsData, adAndCam, by="campaign_id")

# writing both new processed df to csv files
write.csv(clicks_processed, file = "clicks_processed.csv", row.names = FALSE)
write.csv(impressions_processed, file = "impressions_processed.csv", row.names = FALSE)
