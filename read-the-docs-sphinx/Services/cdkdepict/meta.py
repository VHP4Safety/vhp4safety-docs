import json
import pandas as pd

df = pd.read_json("https://raw.githubusercontent.com/VHP4Safety/cloud/main/docs/service/cdkdepict.json")
df.to_html('Services/cdkdepict/meta.html')
print(df)