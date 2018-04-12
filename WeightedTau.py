# Builds matrix of pairwise weighted kendall tau correlations for an ensemble of outlier score rankings
# https://docs.scipy.org/doc/scipy/reference/generated/scipy.stats.weightedtau.html
# Function Write_Wtau
# Input: 1- n*m matrix of outlier score rankings.(n data points and m ensemble components)
# Each column represents scores of one ensemble component - rows are different data points
#        2- Full address of output file e.g.:  '/home/user/out.csv'
# Writes a m*m matrix of pairwise weighted tau correlations

################################################################################################
import numpy as np
import csv
from scipy.stats import weightedtau


def Find_Wtau(Rankings, num_comps):
    size=Rankings.shape[1]
    AdjacencyM = np.zeros((size,size))
    combs = itertools.combinations(range(num_comps), 2)
    for comb in combs:
        weightedT = weightedtau(list(Rankings[:, comb[0]]), list(Rankings[:, comb[1]])).correlation
        AdjacencyM[comb[0],comb[1]] = weightedT
        AdjacencyM[comb[1],comb[0]] = weightedT
    return AdjacencyM

def Write_Wtau(input_file,output_file_add):
            All_Rankings = []
            with open(input_file) as csvfile:
                reader = csv.reader(csvfile, delimiter=',')
                for row in reader:
                    All_Rankings.append(row)
            All_Rankings = np.array(All_Rankings)
            All_Rankings = All_Rankings.astype(float)
            
            components_num =All_Rankings.shape[1]
            AdjacencyM = Find_Wtau(All_Rankings, components_num)
            np.savetxt(output_file_add, AdjacencyM, delimiter=",")
            
