import json
import pandas as pd

df = pd.read_json("https://raw.githubusercontent.com/VHP4Safety/cloud/main/docs/service/aopwiki.json")
df.to_html('Services/aopwiki/meta.html')
print(df)