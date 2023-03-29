#! /usr/bin/env Rscript
set.seed(0)

env <- Sys.getenv(c("storage","projects"))
sto <- env[1]
proj <- env[2]
insurance_dir <- file.path(proj,"econometrics/big/insurance_project")
raw_state_data <- file.path(insurance_dir,"state_level.dta")

# Bring in the .dta file
library(haven)
library(dplyr)
states <- read_dta(raw_state_data)

# Remove columns with missingvariables and make index the state label
states <- data.frame(states[,colSums(is.na(states))==0],row.names=1)
xstates <- scale(subset(states,select=-c(stategroup)))

# Final variabels kept (had to delete everything with a missing value)
colnames(xstates)

# K means 4 clusters
grpStates <- kmeans(xstates,centers=4,nstart=10)

# Could probably find some other interesting plots but here are two
plot(states[,"state_hbd_hc"],states[,"state_depression"])
text(states[,"state_hbd_hc"],states[,"state_depression"],labels=rownames(xstates),col=rainbow(4)[grpStates$cluster])

plot(states[,"state_babycopay"],states[,"state_diabetescopay"])
text(states[,"state_babycopay"],states[,"state_diabetescopay"],labels=rownames(xstates),col=rainbow(4)[grpStates$cluster])


# Add cluster column to original state data
states$cluster <- grpStates$cluster

# Merge with map data
region <- rownames(states)
rownames(states) <- NULL
states <- cbind(region,states)

library(ggplot2)
library(maps)
library(dplyr)

geodata <- map_data("state")
statesmerged <- inner_join(geodata,states,by="region")

# Create Factor Map
clusterpath <- file.path(insurance_dir,"clusters.png")
png(clusterpath)
plot <- ggplot()
map <- plot + geom_polygon(data=statesmerged,
													 aes(x=long,y=lat,group=group,fill=as.factor(cluster)),
															 color="white")
map <- map + scale_fill_brewer(name="clusters",type="seq",palette="Reds")
map
dev.off()
