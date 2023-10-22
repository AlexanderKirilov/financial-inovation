#!/usr/bin/env python
# coding: utf-8

import pandas as pd
import numpy as np
from scipy.spatial import distance
import csv
import json
import sys
def dumpTopFive(distance_df):
    top_five=distance_df.head()
    json_string = top_five.to_json(orient="values")
    print(json_string)

def main():
    # Read the ETF data into a DataFrame
    joined_etf = pd.read_csv("ETFs_formatted.csv", sep=",")

    try:
        input_data = sys.stdin.read()
        answers = json.loads(input_data)
    except:
        print('Error reading from stdin')
        return None

    # vector_df=pd.DataFrame([example_data])
    results = calcDistances(get_vector_from_answers(answers), joined_etf)
    dumpTopFive(results)
    results.to_csv("distances_sorted.csv")

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
        'primary-goal': 'yield',
        'age': 'technology',
        'investment-horizon': 'standardDeviation',
        'finance-risk': 'standardDeviation',
        'expected-return': '3 Year',
        'sustainability': 'esg_global_score'
    }

    # Define mappings for other questions here
    question_value_mappings = {
        'primary-goal': {'A': 0.014, 'B': 0.02, 'C': 0.0304, 'D': 0.05},
        'age': {'A': 0.3, 'B': 0.15, 'C': 0.09, 'D': 0.02},
        'finance-risk': {'A': 17.13, 'B': 19.5, 'C': 22.3, 'D': 26},
        'expected-return': {'A': 0.04, 'B': 0.06, 'C': 0.08, 'D': 0.11},
        'sustainability': {'A': 0.86, 'B': 0.75, 'C': 0.60, 'D': 0.55},
    }

    #TODO: ADD sectors PARAM
    # sector_weightings=get_sector_weightings(answers['sectors'])

    vector_df = pd.DataFrame(columns=['yield', 'technology','standardDeviation','3 Year','esg_global_score'])
    for item in answers:
        question_tag = item['question_tag']
        answer = item['answer']

        column_name = question_to_column_mapping.get(question_tag)
        if column_name != 'sectors':
            value_mapping = question_value_mappings.get(question_tag)
            if value_mapping is None:
                continue
            value = value_mapping.get(answer)
            if value is not None:
                vector_df[column_name] = [value]
        else:
            for sector,value in answer.items():
                vector_df[sector] = [value]

    return vector_df


#Calculate euclidian distances
def calcDistances(input_df,reference_df):
    
    distances = []
    for idx, row in reference_df.iterrows():
        # Exclude the reference ETF
        dist = distance.euclidean(input_df.loc[0], row[['yield', 'technology','standardDeviation','3 Year','esg_global_score']])
        distances.append({'ETF_ID': row['ticker'], 'Distance': dist})

    # Create a DataFrame from the distances
    dist_df = pd.DataFrame(distances)

    # Sort by distance in ascending order
    sorted_dist_df = dist_df.sort_values(by='Distance')
    return sorted_dist_df

if __name__ == '__main__':
    main()

