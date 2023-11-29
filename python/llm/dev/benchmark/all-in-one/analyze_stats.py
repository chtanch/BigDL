import os
import pandas as pd
from glob import glob

# Define the directory where CSV files are located
csv_dir = '.idea/single-cheenhau-test-20231024' # Replace with the path to your CSV files

# Define the output CSV file
output_csv = f'{csv_dir}/statistics.csv'

# Get all CSV files in directory
csv_files = glob(os.path.join(csv_dir, 'transformer*.csv'))
if not csv_files:
    raise ValueError('No CSV files found in the directory')

# List to store all dataframes for later concatenation
dfs = []
for file in csv_files:
    df = pd.read_csv(file)
    df = df[['model', 'input/output tokens', '1st token avg latency (ms)', '2+ avg latency (ms/token)', 'low_bit']]
    dfs.append(df)

# Concatenate dataframes vertically
combined_df = pd.concat(dfs)

# Group by 'model' and 'input/output tokens'
grouped = combined_df.groupby(['model', 'input/output tokens', 'low_bit'])
metrics = grouped.agg(['max','min','mean'])

diff_t1 = (metrics.iloc[:,0] - metrics.iloc[:,1]) / metrics.iloc[:,0] * 100
diff_t1 = diff_t1.rename('t1_diff_percent')
diff_t2 = (metrics.iloc[:,3] - metrics.iloc[:,4]) / metrics.iloc[:,3] * 100
diff_t2 = diff_t2.rename('t2_diff_percent')
max_t1 = (metrics.iloc[:,0]).rename('t1_max')
min_t1 = (metrics.iloc[:,1]).rename('t1_min')
max_t2 = (metrics.iloc[:,3]).rename('t2_max')
min_t2 = (metrics.iloc[:,4]).rename('t2_min')

output = pd.concat([min_t1, max_t1, diff_t1, min_t2, max_t2, diff_t2],axis=1)

from natsort import natsort_keygen
output = output.sort_values(by=['model', 'input/output tokens'], 
                                                  key=natsort_keygen())
# Save to CSV
output.to_csv(output_csv, float_format="%.3f")
print(f'Output saved to {output_csv}')