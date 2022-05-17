import pandas as pd
import sys
file_name = './SortedHRVData.csv'
new_file_name = sys.argv[1] or 'random_data.csv'
df = pd.read_csv(file_name) # avoid header=None. 
shuffled_df = df.sample(frac=1)
shuffled_df.to_csv(new_file_name, index=False)
