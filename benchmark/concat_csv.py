import pandas as pd
import os, argparse


def concatenate(input_dir, output_file):
    if output_file is None:
        output_file = f'{input_dir}/concatenated_output.csv'

    # concat data
    concatenated_data = pd.DataFrame()
    for filename in sorted(os.listdir(input_dir)):
        if filename != 'concatenated_output.csv' and filename.endswith('.csv'):
            file_path = os.path.join(input_dir, filename)
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

    # remove original index
    concatenated_data = concatenated_data.drop(concatenated_data.columns[0], axis=1)

    concatenated_data.to_csv(output_file)
    print(f'Concatenated data saved to {output_file}')


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="concatenate csv files")
    parser.add_argument("-i", "--input-dir", type=str, required=True)
    parser.add_argument("-o", "--output", type=str, default=None)

    args = parser.parse_args()
    concatenate(args.input_dir, args.output)
