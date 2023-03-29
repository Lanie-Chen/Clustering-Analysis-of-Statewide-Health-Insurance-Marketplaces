#! /usr/bin/env Rscript
env <- Sys.getenv(c("storage","projects"))
sto <- env[1]
proj <- env[2]
insurance_dir <- file.path(proj,"econometrics/big/insurance_project")
raw_state_data <- file.path(insurance_dir,"state_level.dta")

# Bring in the .dta file
library(haven)
states <- read_dta(raw_state_data)


# Prep for maps
library(ggplot2)
library(maps)
library(dplyr)

geodata <- map_data("state")
states <- rename(states,region=statecode)
states$region <- tolower(states$region)
statesmerged <- inner_join(geodata,states,by="region")

# Map of total policies per state
plot <- ggplot()
map <- plot + geom_polygon(data=statesmerged,
													 aes(x=long,y=lat,group=group,fill=st_policycount),
													 color="white",linewidth=.2)

map <- map + scale_fill_continuous(name="Total Policies Offered",
															 low="lightblue", high="darkblue", na.value="grey50")
map

# Diabetes Map
diabetes <- plot + geom_polygon(data=statesmerged,
													 aes(x=long,y=lat,group=group,fill=state_diabetes),
													 color="white",linewidth=.2)

diabetes <- diabetes + scale_fill_continuous(name="Probability",
															 low="lightblue", high="darkblue", na.value="grey50") +
															 labs(title="Probability Diabetes Prevention Program Offered ")

diabetes


# Having a Baby Copay
babycopay <- plot + geom_polygon(data=statesmerged,
													 aes(x=long,y=lat,group=group,fill=state_babycopay),
													 color="white",linewidth=.2)

babycopay <- babycopay + scale_fill_continuous(name="Copay",
															 low="lightblue", high="darkblue", na.value="grey50") +
															 labs(title="Average Copay for Having a Baby")

babycopay

# Having a Baby Coinsurance
babycoin <- plot + geom_polygon(data=statesmerged,
													 aes(x=long,y=lat,group=group,fill=state_babycoin),
													 color="white",linewidth=.2)

babycoin <- babycoin + scale_fill_continuous(name="Coinsurance",
															 low="lightblue", high="darkblue", na.value="grey50") +
															 labs(title="Average Coinsurance for Having a Baby")

babycoin

# Having a Baby Deductible
babydeduct <- plot + geom_polygon(data=statesmerged,
													 aes(x=long,y=lat,group=group,fill=state_babydeduct),
													 color="white",linewidth=.2)

babydeduct <- babydeduct + scale_fill_continuous(name="Deductible",
															 low="lightblue", high="darkblue", na.value="grey50") +
															 labs(title="Average Deductible for Having a Baby")

babydeduct

# Having a Baby Limit
babylim <- plot + geom_polygon(data=statesmerged,
													 aes(x=long,y=lat,group=group,fill=state_babylim),
													 color="white",linewidth=.2)

babylim <- babylim + scale_fill_continuous(name="Limit",
															 low="lightblue", high="darkblue", na.value="grey50") +
															 labs(title="Average Limit for Having a Baby")

babylim

# Differences in copays
# Having a Baby Copay
babycopay

# Simple Bone Fracture Copay
fraccopay <- plot + geom_polygon(data=statesmerged,
													 aes(x=long,y=lat,group=group,fill=state_fraccopay),
													 color="white",linewidth=.2)

fraccopay <- fraccopay + scale_fill_continuous(name="Copay",
															 low="lightblue", high="darkblue", na.value="grey50") +
															 labs(title="Average Copay for Having a Simple Bone Fracture")

fraccopay

# Diabetes Copay
diabetescopay <- plot + geom_polygon(data=statesmerged,
													 aes(x=long,y=lat,group=group,fill=state_diabetescopay),
													 color="white",linewidth=.2)

diabetescopay <- diabetescopay + scale_fill_continuous(name="Copay",
															 low="lightblue", high="darkblue", na.value="grey50") +
															 labs(title="Average Copay for Having Diabetes")

diabetescopay
