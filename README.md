# ml
This project inmplements a tree bagger algorithm to solve the Kaggle Challenge in class 4721 Columbia University. 

#main_sript.m 
  the script that implements the algorithm. MATLAB 
    loads the data 
    pre-treats the data 
    call a cross validation function
    predict the labels and write two files: 
    out_analisys.csv: cross validation results
    now.csv: with the predicted label for the quiz
                
#f2_map.m      
  creates a feature map order 2 for a given numeric dataset

#fix_2.m
  scales the variables

#create_dumm.m 
  creates dummy variables for given categorical variable

#cross_val.m   
  implements a cross validation training using the treebagger classifier. 
  (see doc http://www.mathworks.com/help/stats/treebagger.html)
