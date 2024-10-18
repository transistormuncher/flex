import os
import pandas as pd
import sqlalchemy

from dotenv import load_dotenv

load_dotenv()

db_name = os.environ['POSTGRES_DB_NAME']
user = os.environ['POSTGRES_USER']
host = os.environ['POSTGRES_HOST']
port = os.environ['POSTGRES_PORT']
pw = os.environ['POSTGRES_PW']
db_engine = sqlalchemy.create_engine(f'postgresql+psycopg2://{user}:{pw}@{host}:{port}/{db_name}')
conn = db_engine.connect()

conn.execute(sqlalchemy.schema.CreateSchema("raw_data", if_not_exists=True))
conn.commit()

df_dict = {}
df_dict["asset"] = pd.read_csv("assets_base_data.csv", sep=";")
df_dict["imbalance_penalty"] = pd.read_csv("imbalance_penalty.csv", sep=";")
df_dict["market_index_price"] = pd.read_csv("market_index_price.csv", sep=";")
df_dict["measured"] = pd.read_csv("measured_20241013.csv", sep=";")
df_dict["trades"] = pd.read_json("trades.json")

df_list = []
for i in range(1, 5):
    df_list.append(pd.read_json(f"forecasts/a{i}.json"))
df_dict["forecasts"] = pd.concat(df_list).reset_index()

for key, df in df_dict.items():
    df.to_sql(name=key, con=conn, schema="raw_data", if_exists="replace", index=False)
