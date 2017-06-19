library(gdata)
library(dplyr)
library(tidyr)
library(ggplot2)
library(stringr)
library(zipcode)
library(ggmap)


download.file(url = "https://data.mo.gov/api/views/fkt2-8smh/rows.csv?accessType=DOWNLOAD", destfile = "./Data/MOLiquor.csv", method = "auto", quiet = FALSE, mode = "w")
df1 <- read.csv(file = "./Data/MOLiquor.csv", header = TRUE, na.strings = c("NA", "NaN", ""))

#we use the zipcode dataset from the zipcode library for lat/long
data(zipcode)
df1$Zip.Code <- as.factor(df1$Zip.Code)

#shortening the zip codes to 5 digits
df1$Zip.Code <- strtrim(df1$Zip.Code, 5)

#renaming the zipcodes column to match df1
zipcode$Zip.Code <- zipcode$zip

#merging to add lat/long
df1 <- left_join(df1, zipcode, by = "Zip.Code")

#get a map of Missouri and add liquor wholesalers to it as red dots
rm(map)
map <-get_map(location= c(lon = -92.661665, lat = 38.949452), zoom=7, maptype = "terrain",
              source='google',color='color')
a <- ggmap(map) 
a +  geom_point(data=df1, aes(x=longitude, y=latitude), color="red")
