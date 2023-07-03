install.packages('ergm')
library(ergm)
install.packages('statnet')
library(statnet)

#View(nodes_ergm)
#View(links_ergm)

#remove unnecessary automated column 
nodes_ergm$X <- NULL
head(nodes_ergm)

links_ergm$X <- NULL
head(links_ergm)

snet <- network(links_ergm, vertex.attr = nodes_ergm, matrix.type = "edgelist", loops=F, multiple=F, ignore.eval = F)
snet


# A simple model that includes just the edge (density) parameter:
#1 
lap_model <- ergm(snet ~ edges)
summary(lap_model)

#2
lap_model <- ergm(snet ~ edges + mutual)  
summary(lap_model)

#3 using all of the features 
# N.B.: The average topic weights here have to be 1 or 0. As in, if the user is in the top 90th percentile of those 
# discussing topic X, then you will tag them as TopicX = 1;  otherwise, TopicX = 0. This will allow us to specify 
# which of the topics get people to get more edges in this network. 
lap_model <- ergm(snet ~ nodeocov("verified")
                  + nodeicov("verified")
                  + nodeocov("topic2")
                  + nodeicov("topic2")
                  + nodeocov("topic4")
                  + nodeicov("topic4")
                  + nodeocov("topic13")
                  + nodeicov("topic13")
                  + nodeocov("topic26")
                  + nodeicov("topic26")
                  + nodeocov("topic54")
                  + nodeicov("topic54")
                  + edges 
                  + mutual
)

#save(lap_model, file="Model.Rdata")
summary(lap_model)

#Finding the goodness of fit of this model
gof_1 <- gof(lap_model)
gof_1

#plotting the goodness of fit in a jpg file
plot(gof_1)
