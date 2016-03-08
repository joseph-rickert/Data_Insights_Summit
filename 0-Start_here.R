# Start Here
# Microsoft Data Insights Summit
# Joseph Rickert
# March 22, 2016
# 
# R packages that must be installed to run the modules in this course
# 
# Module                              Packages to be installed
# 1-First_Look.R                      none
# 2-R_Basics.R                        none  
# 3-Reading_.csv_files.R              none
# 4-Working_with_SQL.R                RODBC, nycFlights13, dplyr
# 5-Data_Manipulation.R               dplyr, tidyr
# 6-a_R_viz.R                         car, lattice, ggplot2, dplyr, reshape2, pracma, xts, dygraphs
# 6-b_Regression.R                    dplyr, ggplot2, corrplot
# 6-c_Time_series.R                   dplyr, reshape2, xts, ggplot2
# 
# Installing all of the packages at once may take some time.
# Assuming you work through everything in order you may want to try this strategy:
# Before Module 4 run:
   install.packages(c("RODBC","nycFlights13","dplyr"))
# Before Module 5 run:
   install.packages("tidyr")
# Before Module 6-a run:
   install.packages(c("car","lattice","ggplot2","reshape2","pracma","xts","dygraphs"))
# Before Module 6-b run:
   install.packages(c("corrplot"))
   
# To install everything at once:  
install.packages(c("car","corrplot", "dygraphs","ggplot2","lattice",
                   "nycFlights13","pracma","reshape2","RODBC","xts",
                    "reshape2", "dplyr"))

# Otherwise install the packages you need for the particular module you want to run by copying the syntax above