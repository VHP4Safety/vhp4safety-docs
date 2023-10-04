import json
import pandas as pd

df = pd.read_json("https://raw.githubusercontent.com/VHP4Safety/cloud/main/docs/service/sysrev.json")
df.to_html('Services/sysrev/meta.html')
print(df)