library(gdata)
library(dplyr)
library(tidyr)
library(ggplot2)
library(stringr)
library(zipcode)
library(ggmap)

library(gdata)
library(dplyr)
library(tidyr)
library(ggplot2)
library(stringr)
library(zipcode)
library(ggmap)

#Two files involved. One for each class of dealer.
download.file(url = "https://data.mo.gov/api/views/fkt2-8smh/rows.csv?accessType=DOWNLOAD", destfile = "./Data/MOLiquor.csv", method = "auto", quiet = FALSE, mode = "w")
df1 <- read.csv(file = "./Data/MOLiquor.csv", header = TRUE, na.strings = c("NA", "NaN", ""))

download.file(url = "https://data.mo.gov/api/views/mmn5-wy78/rows.csv?accessType=DOWNLOAD", destfile = "./Data/MOLiquor2.csv", method = "auto", quiet = FALSE, mode = "w")
df2 <- read.csv(file = "./Data/MOLiquor2.csv", header = TRUE, na.strings = c("NA", "NaN", ""))

#Need to truncate the zipcodes provided in the downloads to 5 digits
df1$Zip.Code <- as.factor(df1$Zip.Code)
df2$Zip.Code <- as.factor(df2$Zip.Code)
df1$Zip.Code <- strtrim(df1$Zip.Code, 5)
df2$Zip.Code <- strtrim(df2$Zip.Code, 5)

#Use the zipcode dataset to match lat & long
data(zipcode)
zipcode$Zip.Code <- zipcode$zip
df1 <- left_join(df1, zipcode, by = "Zip.Code")
df2 <- filter(df2, state == "MO")
df2 <- left_join(df2, zipcode, by = "Zip.Code")

#Combine the two datasets
rm(df3)
df3 <- bind_rows(df1, df2) 
df3$Zip.Code <- as.factor(df3$Zip.Code)

#Use ggmap to pull a map of Missouri and then plot
rm(map)
map <-get_map(location= c(lon = -92.661665, lat = 38.949452), zoom=7, maptype = "terrain",
              source='google',color='color')
a <- ggmap(map) 
a +  geom_point(data=df3, aes(x=longitude, y=latitude), color="red")
