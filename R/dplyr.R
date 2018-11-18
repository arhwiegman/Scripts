# dplyr - data frame plyr
require(dplyr)
# __OUTPUT__ %>%

#Prelims
library(dplyr)
library(TeachingDemos)
char2seed("Aunt Marge")
HarryPotter <- read.csv("HarryPotter.csv")

#setwd(parent.dir())

glimpse(HarryPotter)

#filter out based on values
output<- HarryPotter %>%
  filter(Last.Name=="Weasly")
print(output)

#
HarryPotter %>%
  filter(Last.Name=="Weasly",BirthYear>=1980)

#random sample
#sample_n # number of data
#sample_frac # random sample of fraction of data

sample_frac(HarryPotter, size=0.1,replace=FALSE)

# sample_n
output <- HarryPotter %>%
  filter(Blood_Status=="HalfBlood",Sex=="Female")
print(output)
 
sample_n(output,size=2,replace=FALSE)

# Sort Data
HarryPotter %>% 
  filter(Blood_Status=="HalfBlood",Sex=="Female") %>%
  arrange(Last.Name,First.Name) #sort by lastname then first name

# Select Columns by Name
HarryPotter %>% 
  select(First.Name, House)

HarryPotter %>% 
  select(First.Name, House) %>%
  head

# select all columns expect a specific one
HarryPotter %>% 
  select(-Sex) %>%
  head(8)

# select everything between two columns 
HarryPotter %>% 
  select(Last.Name:House) %>%
  head
  head(8)
  
# select helper functions
# 'ends_with' 
HarryPotter %>%
  select(ends_with("Name")) %>%
  head  

# regular expression
HarryPotter %>%
  select(matches("\\."))%>%
  head

# create a new variable
# mutate and transmute

# add new columns from other columns
output <- HarryPotter %>%
  mutate(Name=paste(First.Name,"_",Last.Name), Age=(2018-BirthYear))
         
# add a new column called "Age"
HarryPotter %>%
  transmute(Name=paste(First.Name,"_",Last.Name))
# returns only the transmuted columns

# summarise the data
# summarise create summary stats for a given col, or cols, in data frame
# split, apply, bind POWERFUL
# group_by: group/split the data

# split by house
# take the average height of people in those houses
# find the max hieght
# provide the total number of obs. for a particular house
HarryPotter %>% 
  group_by(House) %>%
  summarise(avg_height=mean(Height),
            tallest=max(Height),
            total_ppl=n()) %>% # returns a tibble
  as.data.frame() #convert back to dataframe

HarryPotter %>%
  select(Sex,Blood_Status,Height) %>%
  filter(Sex=="Male",Blood_Status=="PureBlood") %>%
  filter(Height > 67, Height < 72) %>%
  arrange(desc(Height))
         