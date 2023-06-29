install.packages('ergm')
library(ergm)
install.packages('statnet')
library(statnet)

#View(nodes_ergm)
#View(links_ergm)

#remove unnecessary automated column 
nodes_ergm$X <- NULL
nodes_ergm$verified.type <- NULL
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
lap_model <- ergm(snet ~ nodeofactor("verified.label") #incoming links for verification status
                  + nodeifactor("verified.label") #outgoing links for verification status
                  + nodeocov("X2") #adding topic weights as nodal covariates (used for continuous variables)
                  + nodeicov("X2")
                  + nodeocov("X4")
                  + nodeicov("X4")
                  + nodeocov("X13")
                  + nodeicov("X13")
                  + nodeocov("X26")
                  + nodeicov("X26")
                  + nodeocov("X54")
                  + nodeicov("X54")
                  + mutual
                  + edges
)


# lap_model <- ergm(snet ~ edges #connections 
#                   + mutual #reciprocity 
#                   + gwesp(0.2, fixed=T) #Transitive closure 
#                   + nodeicov("verified.type") #incoming links for verification status
#                   + nodeocov("verified.type") #outgoing links for verification status
#                   + nodecov("X2") #adding topic weights as nodal covariates (used for continuous variables)
#                   + nodecov("X4")
#                   + nodecov("X13")
#                   + nodecov("X26")
#                   + nodecov("X54")#,
#                   #control=control.ergm(MCMLE.maxit= 25)
# )

save(lap_model, file="Model.Rdata")
summary(lap_model)

#Finding the goodness of fit of this model
gof_1 <- gof(lap_model)
gof_1

#plotting the goodness of fit in a jpg file
jpeg("rplot.jpg")
plot(gof_1)
dev.off()
