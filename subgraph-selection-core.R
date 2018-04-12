# Core Subgraph selection algorithm
# Author: Hamed Sarvari
# Input:  1- Matrix of weighted tau correlation among different outlier score rankings. (Can be obtained by WeightedTau.py script)
#         2- Number of edges withheld while pruning the graph. Usually set to equal to number of nodes in graph
# Output:  Index of selected rankings
#################################################################################################
library(igraph)
library(Matrix)


Core_Subgraph_selection <- function(adj_file,num_selected_edges_graph){
  
  Adj_matrix = read.csv(adj_file,header=FALSE)
  Adj_matrix = (apply(as.matrix(Adj_matrix), 2, as.double))
  g5 = graph_from_adjacency_matrix(Adj_matrix,weighted=TRUE,  mode="undirected")
  g5=delete.edges(g5, which(E(g5)$weight >= 1.0))
  g5=delete.edges(g5, which(E(g5)$weight <= 0.0))
  g5=delete.edges(g5, which(E(g5)$weight < sort(E(g5)$weight,decreasing = TRUE)[num_selected_edges_graph]))
  subgraph.edges(g5,E(g5),delete.vertices = TRUE)
  coreness <- graph.coreness(g5) 
  maxCoreness <- max(coreness)
  verticesHavingMaxCoreness <- which(coreness == maxCoreness)
  kcore <- induced.subgraph(graph=g5,vids=verticesHavingMaxCoreness)
  ret<-V(kcore)
  return(strtoi(substr(ret$name,2,length(ret$name))))

  }


