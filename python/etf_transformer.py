#!/usr/bin/env python
# coding: utf-8

# !pip install yahooquery

# In[148]:


import pandas as pd
import numpy as np
from scipy.spatial import distance
import csv

# Load data from separate CSV files
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


# Filter rows for stock_id 1 and stock_id 5
fund1 = merged_df[merged_df['id'] == 1].iloc[0, 1:]
fund5 = merged_df[merged_df['id'] == 4].iloc[0, 1:]

# Calculate Euclidean distance
dist = distance.euclidean(fund1[2:], fund5[2:])

print(dist)


# In[ ]:


# with open("ETF_list_truncated.csv", "r") as fr, open("out.csv", "w", newline='') as fw:
#     cr = csv.reader(fr, delimiter=";")
#     cw = csv.writer(fw, delimiter=";")
#     cw.writerow(next(cr))  # write title as-is
#     cw.writerows(reversed(list(cr)))
    
    


# In[155]:


etf_columns_df=etf_db_df.filter(['Symbol',
                                 'YTD Price Change',
                                 '3 Year',
                                 'Annual Dividend Yield %',
                                 'ESG Score Global Percentile (%)',
                                 ]
                                , axis=1)


etf_columns_df=etf_columns_df.rename(columns={'Symbol': 'ticker', 'Annual Dividend Yield %' : 'yield_db'})
etf_columns_df['YTD Price Change']=pd.to_numeric(etf_columns_df['YTD Price Change'].str.strip('%')) / 100
etf_columns_df['3 Year']=pd.to_numeric(etf_columns_df['3 Year'].str.strip('%')) / 100

etf_columns_df['yield_db']=pd.to_numeric(etf_columns_df['yield_db'].str.strip('%')) / 100
etf_columns_df['ESG Score Global Percentile (%)']=pd.to_numeric(etf_columns_df['ESG Score Global Percentile (%)'].str.strip('%')) / 100
etf_columns_df['ticker']=etf_columns_df['ticker'].astype('str')



etf_valid_rows = etf_columns_df.dropna()
etf_valid_rows = etf_valid_rows.reset_index()
print(etf_valid_rows)


# In[157]:


# Join both datasets


joined_etf = etf_valid_rows.merge(merged_df,left_on='ticker', right_on='symbol')
print(joined_etf)


# In[121]:

##TODO: Implement Euclidean distances calculation
# # Calculate Euclidean distances
# distances = []
# for idx, row in df.iterrows():
#     if row['ETF_ID'] != 1:  # Exclude the reference ETF
#         dist = distance.euclidean(reference_etf[['Column1', 'Column2']], row[['Column1', 'Column2']])
#         distances.append({'ETF_ID': row['ETF_ID'], 'Distance': dist})

# # Create a DataFrame from the distances
# dist_df = pd.DataFrame(distances)

# # Sort by distance in ascending order
# sorted_dist_df = dist_df.sort_values(by='Distance')

# # Get the top 5 results (lowest distances)
# top_5_results = sorted_dist_df.head(5)

