# Cull Subgraph selection algorithm
# Author: Hamed Sarvari
# Input: 1- Adjacency matrix of weighted tau correlation among different outlier score rankings
#        2- Number of edges withheld while pruning the graph. Usually set equal to the number of nodes in graph.
#        3- Drop rate: percentage of nodes to discard. Usually set to 20 percent of number of the nodes.
# Output: Index of selected rankings
#################################################################################################
library(igraph)
library(Matrix)

Cull_Subgraph_selection <- function(num_selected_edges_graph,adj_file,drop_rate=0.2){
  
  Adj_matrix = read.csv(adj_file,header=FALSE, sep=",")
  Adj_matrix = (apply(as.matrix(Adj_matrix), 2, as.double))
  g5 = graph_from_adjacency_matrix(Adj_matrix,weighted=TRUE,  mode="undirected")
  g5=delete.edges(g5, which(E(g5)$weight >= 1.0))
  g5=delete.edges(g5, which(E(g5)$weight <= 0.0))
  node_weights=strength(g5)
  node_order=sort.int(node_weights,decreasing = TRUE,index.return = TRUE)$ix
  num_drop_vertices=drop_rate*length(V(g5))
  nodes_kept<-node_order[1:(length(node_order)-num_drop_vertices)]
  return(nodes_kept)
  }
