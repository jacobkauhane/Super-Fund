#Prepare data for geocoding

library(data.table)
library(tidyverse)

Sales<-fread("RPSaleCSV.csv")
House_Attributes<-fread("ResBldgCSV.csv")

Sales$ID<-paste0(Sales$Major,Sales$Minor)  #create ID variables
House_Attributes$ID<-paste0(House_Attributes$Major,House_Attributes$Minor)

Sales1<-Sales[SaleInstrument %in% c(2,4) & !(ID %in%  c("0","00","000"))] #subset for warranty and special warranty deeds

data1<-merge.data.table(Sales1,House_Attributes,by="ID")  #merge by ID

data1$BathroomsTotal<-data1$BathFullCount+0.75*data1$Bath3qtrCount+0.5*data1$BathHalfCount
data1$Fireplace<-if_else(sum(data1$FpMultiStory,data1$FpSingleStory,data1$FpFreestanding,data1$FpAdditional)>0,1,0)
data1$Deck<-if_else(data1$SqFtDeck>0,1,0)

Housing_Data<-data1[,.(SalePrice,
                       DocumentDate,
                       Address,
                       BuildingNumber,
                       Fraction,
                       DirectionPrefix,
                       StreetName,
                       StreetType,
                       DirectionSuffix,
                       ZipCode,
                       Stories,
                       SqFtTotLiving,
                       Bedrooms,
                       BathroomsTotal,
                       YrBuilt,
                       Condition,
                       Fireplace,
                       Deck)]
fwrite(Housing_Data,"01Housing_Data.csv")
