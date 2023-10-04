import json
import pandas as pd

df = pd.read_json("https://raw.githubusercontent.com/VHP4Safety/cloud/main/docs/service/wikibase.json")
df.to_html('Services/wikibase/meta.html')
print(df)