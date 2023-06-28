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
lap_model <- ergm(snet ~ edges #connections 
                  + mutual #reciprocity 
                  + gwesp(0.2, fixed=T) #Transitive closure 
                  + nodeicov("verified.type") #incoming links for verification status
                  + nodeocov("verified.type") #outgoing links for verification status
                  + nodecov("X2") #adding topic weights as nodal covariates (used for continuous variables)
                  + nodecov("X4")
                  + nodecov("X13")
                  + nodecov("X26")
                  + nodecov("X54")#,
                  #control=control.ergm(MCMLE.maxit= 25)
)

summary(lap_model)

#Finding the goodness of fit of this model
gof_1 <- gof(lap_model)
gof_1

#plotting the goodness of fit in a jpg file
jpeg("rplot.jpg")
plot(gof_1)
dev.off()
