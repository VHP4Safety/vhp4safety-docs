import json
import pandas as pd

df = pd.read_json("https://raw.githubusercontent.com/VHP4Safety/cloud/main/docs/service/decimer.json")
df.to_html('Services/decimer/meta.html')
print(df)