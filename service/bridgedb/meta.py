import json
import pandas as pd

df = pd.read_json("https://raw.githubusercontent.com/VHP4Safety/cloud/main/docs/service/bridgedb.json")
df.to_html('service/bridgedb/meta.html')
print(df)
