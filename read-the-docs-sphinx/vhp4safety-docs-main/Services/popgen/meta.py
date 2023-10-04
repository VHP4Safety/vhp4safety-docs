import json
import pandas as pd

df = pd.read_json("https://raw.githubusercontent.com/VHP4Safety/cloud/main/docs/service/popgen.json")
df.to_html('Services/popgen/meta.html')
print(df)