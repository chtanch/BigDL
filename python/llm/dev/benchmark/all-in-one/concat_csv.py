import pandas as pd
import os

input_directory = '.idea/single-cheenhau-perf-mpt-7b'
output_file = f'{input_directory}/concatenated_output.csv'

# concat data
concatenated_data = pd.DataFrame()
for filename in os.listdir(input_directory):
    if filename.startswith('transformer_int4_gpu-results'):
        file_path = os.path.join(input_directory, filename)
        data = pd.read_csv(file_path)
        concatenated_data = pd.concat([concatenated_data, data], ignore_index=True)

# detect and remove duplicates
duplicates = concatenated_data[concatenated_data.duplicated(subset=['model', 'input/output tokens'], keep='first')]
if duplicates.empty:
    print('No duplicates detected')
else:
    print("The following rows are duplicates:")
    print(duplicates)

# concatenated_data.drop_duplicates(subset=['model', 'input/output tokens'], keep='first', inplace=True)

from natsort import natsort_keygen
concatenated_data = concatenated_data.sort_values(by=['model', 'input/output tokens'], 
                                                  key=natsort_keygen())

concatenated_data.to_csv(output_file)
print(f'Concatenated data saved to {output_file}')
