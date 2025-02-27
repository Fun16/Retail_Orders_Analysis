# -*- coding: utf-8 -*-


import kaggle

!kaggle datasets download ankitbansal06/retail-orders -f orders.csv

#extract file from zip file
import zipfile
zip_ref = zipfile.ZipFile('orders.csv.zip')
zip_ref.extractall() # extract file to dir
zip_ref.close() # close file

import pandas as pd

# Read CSV file and handle missing values
df = pd.read_csv('orders.csv', na_values=['Not Available', 'unknown'])

# Get unique ship modes
df['Ship Mode'].unique()

df

#rename columns names ..make them lower case and replace space with underscore

df.columns=df.columns.str.lower()
df.columns=df.columns.str.replace(' ','_')
df.head(5)

#derive new columns discount , sale price and profit
df['discount']=df['list_price']*df['discount_percent']*.01
df['sale_price']= df['list_price']-df['discount']
df['profit']=df['sale_price']-df['cost_price']
df

#convert order date from object data type to datetime
df['order_date']=pd.to_datetime(df['order_date'],format="%Y-%m-%d")

#drop cost price list price and discount percent columns
df.drop(columns=['list_price','cost_price','discount_percent'],inplace=True)

# Load the data into SQL Server using the replace option
import sqlalchemy as sal

# Fix the connection string
engine = sal.create_engine(r'mssql://MISIANI-PC\MSSQLSERVER01/master?driver=ODBC+DRIVER+17+FOR+SQL+SERVER')

# Connect to the database
conn = engine.connect()

#load the data into sql server using append option
df.to_sql('orders', con=conn , index=False, if_exists = 'append')

