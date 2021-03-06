
######
import pandas as pd
import glob
import os

LIST = config['list']

print(f"your are using this list {LIST}")

df = pd.read_csv(f'{LIST}')
split_df = df['original_file_name'].str.split('\\.', expand=True)
split_df.columns=['original_file_name','2']
samples_df = df.drop(columns=['original_file_name'])
df = pd.merge(split_df['original_file_name'],samples_df, how="left", left_index=True, right_index=True)
samples_df = df.set_index('original_file_name', drop=False)

NAMES = list(samples_df['original_file_name'])
NAMES = [os.path.splitext(name)[0] for name in NAMES]

IMAGES = expand("Images/{image}.jpg", image=NAMES)

rule download_image:
    output:'Images/{image}.jpg'
    params: download_link = lambda wildcards: samples_df.loc[wildcards.image, "path"]
    shell: 'wget -O {output} {params.download_link}'
