#!/usr/bin/env python
# coding: utf-8

# !pip install yahooquery

# In[148]:


import pandas as pd
import numpy as np
from scipy.spatial import distance
import csv
import sys

# Load data from separate CSV files

def main():
    general_details_df = pd.read_csv('etf_details.csv', sep=',')
    sector_weightings_df = pd.read_csv('sector_weightings.csv', sep=',')
    risk_statistics_df = pd.read_csv('risk_statistics.csv', sep=',')
    etf_db_df = pd.read_csv('ETFDB.csv', sep=',')

    # pivot_df = sector_weightings_df.reset_index()
    print(general_details_df)
    pivot_df = sector_weightings_df.pivot(index='stock_id', columns='name', values='percent')
    pivot_df.reset_index()
    # Reset index

    # Merge DataFrames using 'stock_id' as the key
    merged_df = general_details_df.merge(pivot_df, left_on='id', right_on='stock_id',how='inner')
    merged_df = merged_df.merge(risk_statistics_df, left_on='id', right_on='stock_id')
    # # Filter ETFs with low stock position (adjust the threshold as needed)
    # low_stock_threshold = 0.1
    # filtered_df = merged_df[merged_df['stockPosition'] < low_stock_threshold]

    # # Find the ETF with the highest yield among the filtered ETFs
    # selected_etf = filtered_df.loc[filtered_df['yield'].idxmax()]

    # # Extract and display the required information (id and YTD performance)
    # output_etf = selected_etf[['id', 'ytdReturn']]

    # Print the selected ETF

    merged_df = merged_df.drop_duplicates(subset=['id'])
    print(merged_df)
    print(merged_df.info())


    # The 

    # In[152]:


    merged_df = merged_df.drop(columns=['longSummary'])


    # In[154]:


    # # Filter rows for stock_id 1 and stock_id 5
    # fund1 = merged_df[merged_df['id'] == 1].iloc[0, 1:]
    # fund5 = merged_df[merged_df['id'] == 4].iloc[0, 1:]

    # # Calculate Euclidean distance
    # dist = distance.euclidean(fund1[2:], fund5[2:])

    # print(dist)


    # In[ ]:


    # with open("ETF_list_truncated.csv", "r") as fr, open("out.csv", "w", newline='') as fw:
    #     cr = csv.reader(fr, delimiter=";")
    #     cw = csv.writer(fw, delimiter=";")
    #     cw.writerow(next(cr))  # write title as-is
    #     cw.writerows(reversed(list(cr)))
        

    etf_columns_df=etf_db_df.filter(['Symbol',
                                    'YTD Price Change',
                                    '3 Year',
                                    'Annual Dividend Yield %',
                                    'ESG Score Global Percentile (%)',
                                    ]
                                    , axis=1)


    etf_columns_df=etf_columns_df.rename(columns={'Symbol': 'ticker', 'Annual Dividend Yield %' : 'yield_db', 'ESG Score Global Percentile (%)': 'esg_global_score'})
    etf_columns_df['YTD Price Change']=pd.to_numeric(etf_columns_df['YTD Price Change'].str.strip('%')) / 100
    etf_columns_df['3 Year']=pd.to_numeric(etf_columns_df['3 Year'].str.strip('%')) / 100

    etf_columns_df['yield_db']=pd.to_numeric(etf_columns_df['yield_db'].str.strip('%')) / 100
    etf_columns_df['esg_global_score']=pd.to_numeric(etf_columns_df['esg_global_score'].str.strip('%')) / 100
    etf_columns_df['ticker']=etf_columns_df['ticker'].astype('str')



    etf_valid_rows = etf_columns_df.dropna()
    etf_valid_rows = etf_valid_rows.reset_index()
    print(etf_valid_rows)


    # Join both datasets


    joined_etf = etf_valid_rows.merge(merged_df,left_on='ticker', right_on='symbol')
    joined_etf
    print(joined_etf)
    joined_etf.to_csv("ETFs_formatted.csv")


# Get the top 5 results (lowest distances)


# In[198]:


# example_data = {'3 Year': 0.07,
#                 'yield_db': 0.025,
#                 'ytdReturn': 0.08,
#                 'energy': 0.0,
#                 'financial_services': 0.50 ,
#                 'healthcare': 0.18,
#                 'industrials': 0.1,
#                 'realestate': 0.12,
#                 'technology': 0.02,
#                 'utilities': 0.08,
#                 'meanAnnualReturn': 0.07,
#                 'standardDeviation': 0.22}


    example_data= joined_etf.loc[joined_etf['ticker'] == 'EMXF']
    print(example_data)

    # vector_df=pd.DataFrame([example_data])
    results = calcDistances(get_vector_from_answers(answers), joined_etf)
    print(results)
    results.to_csv("distances_sorted.csv")


# In[ ]:




# In[ ]:

### NOT TESTED
def get_sector_weightings(selected_sectors):
       # Determine the number of selected sectors
    num_selected_sectors = len(selected_sectors)

    # Calculate the weight for each selected sector
    sector_weight = 0.2 if num_selected_sectors > 0 else 0.0

    # Update the weights for selected sectors
    for sector in selected_sectors:
        sector_weights[sector] = sector_weight

    # Create a new dictionary with non-zero weights
    non_zero_weights = {sector: weight for sector, weight in selected_sectors.items() if weight != 0.0}

    return non_zero_weights

def get_vector_from_answers(answers):
    
     question_to_column_mapping = {
        'primary_goal': 'yield',
        'age': 'technology',
        'investment-horizon': 'standardDeviation',
         'finance-risk': 'standardDeviation',
         'expected-return': '3 Year',
         'sustainability': 'esg_global_score',
         'decision-making': ,
         '20-percent-loss': ,
         'proficiency': ,
     }
        #TODO: Make this more sophisticated
    question_value_mappings = {
        'primary_goal': {'A': 0.014, 'B': 0.02, 'C': 0.0304, 'D': 0.05},
        'age': {'A': 0.3, 'B': 0.15, 'C': 0.09, 'D': 0.02},
        'finance-risk': {'A': 17.13, 'B': 19.5, 'C': 22.3, 'D': 26},
        'expected-return': {'A': 0.04, 'B': 0.06, 'C': 0.08, 'D': 0.11},
        'sustainability': {'A': 0.86, 'B': 0.75, 'C': 0.60, 'D': 0.55}
        # Define mappings for other questions here
    }
    
    sector_weightings=get_sector_weightings(answers['sectors'])
    
    
    for question_tag, answer in answers.items():
        column_name = question_to_column_mapping.get(question_tag)
        if column_name is not 'sectors':
            value_mapping = question_value_mappings.get(question_tag)
            value = value_mapping.get(answer) if value_mapping else None
            if value is not None:
                vector_df[column_name] = value
        else:
            for sector,value in answer.items():
                vector_df[sector] = value
    
    
    return vector_df

#Calculate euclidian distances
def calcDistances(input_df,reference_df):
    
    distances = []
    for idx, row in reference_df.iterrows():
              # Exclude the reference ETF
        dist = distance.euclidean(input_df[['3 Year', 'yield_db', 'ytdReturn', 'energy', ''
                                            'financial_services', 'healthcare', 'industrials',
                                            'realestate', 'technology', 'utilities', 'meanAnnualReturn', 'standardDeviation']], 
                                  row[['3 Year', 'yield_db', 'ytdReturn', 'energy',
                                        'financial_services', 'healthcare', 'industrials',
                                        'realestate', 'technology', 'utilities', 'meanAnnualReturn', 'standardDeviation']])
        distances.append({'ETF_ID': row['ticker'], 'Distance': dist})

# Create a DataFrame from the distances
    dist_df = pd.DataFrame(distances)

# Sort by distance in ascending order
    sorted_dist_df = dist_df.sort_values(by='Distance')
    return sorted_dist_df


#Read from stdin to get answers
### NOT TESTED
def read_from_stdin:
    answers = {}
    for column in columns:
        answer = input()
        answers[column] = answer

# Append the answers as a new row to the DataFrame
    
    return answers