import json
import pandas as pd

df = pd.read_json("https://raw.githubusercontent.com/VHP4Safety/cloud/main/docs/service/txg_mapr.json")
df.to_html('service/txg_mapr/meta.html')
print(df)
