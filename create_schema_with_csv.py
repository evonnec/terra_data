#!/usr/bin/env python

import csv
import sys
import pandas as pd


input_file = 'loan.csv' #sys.argv[1] CR to-do: let these be arguments
output_file = 'schema_readin_csv.sql' #sys.argv[2]

#in case pandas and respective dataframes are scrapped, we can use csv library below to obtain headers
#determining datatypes to fill for schema would have to be handled separately.
with open(input_file, mode='r') as loan_input_file:
    csvreader = csv.reader(loan_input_file, delimiter=',')
    loan_headers = next(csvreader, None)

loan_df = pd.read_csv(input_file)
# the above complains that cols have mixed datatypes: 19,47,55,112,123,124,125,128,129,130,133,139,140,141

#error check to make sure there aren't duplicates in the file.
#there are other checks to ensure the data is reasonable that is not explored for this use case.
#checks to include for a larger project are whether the headers are all lower case, also no spaces in the header, etc.
if len(loan_df) - len(loan_df.drop_duplicates()) > 0:
    raise ValueError 


#write datatypes of pandas df to csv
#pandas gives us datatypes which is nice for this use case, however this is not failsafe from what I understand. 
#developing robust data cleaning likely to be better for prod usage.
loan_df.dtypes.to_csv('dtypes_output_file.csv', header=False)

#determining what distinct/unique types there are using pandas. 
loan_df.dtypes.unique()
#this returns: array([dtype('float64'), dtype('int64'), dtype('O')], dtype=object)

dtypes_file = 'dtypes_output_file.csv'

with open(dtypes_file, mode='r') as dtypes_input_file:
    csvreader = csv.reader(dtypes_input_file, delimiter=',')
    schema_list = []
    for row in csvreader: #if using csv library, loan_headers: 
        #convert to numeric
        if row[1] == "int64" or row[1] == "float64":
            schema_list.append(row[0] + " " + "numeric")
        #convert to text
        elif row[1] == "object" or row[1] = "O":
            schema_list.append(row[0] + " " + "text")


#initialize an empty string. perhaps find a better way to write this.
schema_list_string = ""

#convert the list to a large string
for field in schema_list:
    line = ",".join([field]) + ","
    schema_list_string += line

#table name ought to be an argument, not hardcoded. simplified here for this use case.
sql_schema = "CREATE TABLE raw_lending_club_loan_data (" + schema_list_string + ");"

#write to output .sql file
with open(output_file, mode='w') as csv_schema_output_file:
    csv_schema_output_file.write(sql_schema)

