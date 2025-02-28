#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#                                                                             ##
# TITLE                                                                       ##
# Script created yyyy-mm-dd                                                   ##
# Data source: NAME/ORG                                                       ##
# R code prepared by NAME                                                     ##
# Last updated yyyy-mm-dd                                                     ##
#                                                                             ##
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# SUMMARY:


# Required Files (check that script is loading latest version):
# FILE.csv

# Associated Scripts:
# FILE.R

# TO DO 

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# TABLE OF CONTENTS                                                         ####
#                                                                              +
# RECENT CHANGES TO SCRIPT                                                     +
# LOAD PACKAGES                                                                +
# READ IN AND PREPARE DATA                                                     +
# MANIPULATE DATA                                                              +
#                                                                              +
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# RECENT CHANGES TO SCRIPT                                                  ####
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# LOAD PACKAGES                                                             ####
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

library(torch)
library(dplyr)
library(modeldata)

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# READ IN AND PREPARE DATA                                                  ####
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

### ATTRIBUTES OF TENSORS

# create a tensor
t1 <- torch_tensor(1)
# print
t1
# ascertain properties
t1$dtype
t1$device
t1$shape

# change properties of the tensor
t2 <- t1$to(dtype = torch_int())
t2$dtype
t2 <- t1$to(device = "cuda")
t2$device

torch_device(type = 'cuda', index = 0)

# change dimension of the tensor without changing the value
t3 <- t1$view(c(1, 1))
t3$shape

# analogous to a one-element matrix
c(1)
matrix(1)


### CREATING TENSORS DE NOVO

# pass longer vectors to a tensor
torch_tensor(1:5)

# call as a 'float' object
torch_tensor(1:5, dtype = torch_float())

# create on GPU
torch_tensor(1:5, device = "cuda")

# multidimensional tensor by column
torch_tensor(matrix(1:9, ncol = 3))

# multidimensional tensor by row
torch_tensor(matrix(1:9, ncol = 3, byrow = TRUE))

# multidimensional array (builds from l to r)
torch_tensor(array(1:24, dim = c(4, 3, 2)))

# array slices the dimensions differently (builds from r to l)
array(1:24, dim = c(4, 3, 2))

# create 3x3 tensor with normally distributed values
torch_randn(3, 3)

# create 3x3 tensor with uniform dist between 0 and 1
torch_rand(3, 3)

# create tensors with all ones or zeros
torch_zeros(2, 5)
torch_ones(2, 2)

# create 5x5 identity matrix tensor
torch_eye(5)

# create 3x3 diagonal matrix
torch_diag(c(1, 2, 3))


### CREATING TENSORS FROM DATA

# use JohnsonJohnson dataset in base R
JohnsonJohnson

# reads into tensor by row
torch_tensor(JohnsonJohnson)

# use dplyr Orange dataset
glimpse(Orange)

# read into tensor?
torch_tensor(Orange)
# ERROR!

# you must read in as matrix, and ensure any factors are made numeric 
# (otherwise the whole thing will be read as strings)
orange_ <- Orange %>%
  mutate(Tree = as.numeric(Tree)) %>%
  as.matrix()
torch_tensor(orange_)

# create example dataset
# Example R dataset with various data types
sample_data <- data.frame(
  "Name" = c("Alice", "Bob", "Charlie", "Diana", "Eve", "Tina", "Sam", "Gaga"), 
  "Age" = c(25, 30, 28, 32, 27, 44, 63, 14), 
  "City" = c("New York", "Chicago", "Los Angeles", "Seattle", "San Francisco", "Seattle", "Seattle", "Houston"), 
  "Gender" = factor(c("Female", "Male", "Male", "Female", "Female", "NB", "NB", "NB")),
  "JoinedDate" = as.Date(c("1963-01-15", "2019-05-20", "2021-03-10", "2018-07-05", "2022-02-01", "2024-01-22", "2099-03-14", "2022-12-12")), 
  "Active" = c(TRUE, FALSE, TRUE, TRUE, FALSE, TRUE, TRUE, FALSE), 
  "Salary" = c(55000, 60000, 58000, 65000, 52000, 23452, 49991, 49999)
) 
glimpse(sample_data)

# how does torch handle date columns?
print(torch_tensor(sample_data$JoinedDate), n = 7)
# prints number of days since January 1, 1970

# what about character data?
print(torch_tensor(sample_data$City), n = 7)
# tensors CANNOT store strings, must be converted to numeric

# for direct conversions (each observation contains a single entity)
sample_data$City %>%
  factor() %>%
  as.numeric() %>%
  torch_tensor() %>%
  print(n = 7)

# NAs
torch_tensor(c(1, NA, 3))

# some functions can deal with the output, ex:
torch_nanquantile(torch_tensor(c(1, NA, 3)), q = 0.5)
# just removes the NaN

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# MANIPULATE DATA                                                           ####
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

### OPERATIONS ON TENSORS

t1 <- torch_tensor(c(1, 2))
t2 <- torch_tensor(c(3, 4))

# operations start with torch_
# these leave the original objects intact
torch_add(t1, t2)
# equivalently
t1$add(t2)

# to modify object in place
t1$add_(t2)
t1
# when underscore is appended to operation, object is modified in place

# dot product of two one-dimensional structures
t1 <- torch_tensor(1:3)
t2 <- torch_tensor(4:6)
t1$dot(t2)
(1*4) + (2*5) + (3*6)

# transposed tensors work the same
t1$t()$dot(t2)

# orientation of vector's doesn't matter
t3 <- torch_tensor(matrix(1:12, ncol = 3, byrow = FALSE))
t3
t1
t2
t3$matmul(t1)
((1*1) + (2*5) + (3*9)) 
((1*2) + (2*6) + (3*10))
((1*3) + (2*7) + (3*11))
((1*4) + (2*8) + (3*12))

############### SUBSECTION HERE

####
#<<<<<<<<<<<<<<<<<<<<<<<<<<END OF SCRIPT>>>>>>>>>>>>>>>>>>>>>>>>#

# SCRATCH PAD ####