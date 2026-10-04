# AOP-Wiki API Tutorial
---
**Author:** Marvin Martens

The AOP-Wiki API provides a programmatic way to access data from AOP-Wiki, a repository that documents and stores Adverse Outcome Pathways (AOPs), which are structured ways to represent biological events leading to adverse health effects. The API is a REST API over the AOP-Wiki RDF data: you send plain HTTP GET requests and receive JSON or CSV.

This tutorial covers how to interact with the AOP-Wiki API using the Swagger interface, CURL commands, and programming languages like Python and R. By the end of this guide, you should be able to retrieve specific data from AOP-Wiki, such as information about key events, molecular initiating events, or entire AOPs.

## The Swagger interface
*Accessible through [aopwiki.rdf.bigcat-bioinformatics.org/api/docs](https://aopwiki.rdf.bigcat-bioinformatics.org/api/docs)*

The AOP-Wiki API comes with a Swagger interface that lets you explore and test the endpoints in the web browser. It is a good starting point for seeing which endpoints and parameters exist. Open an endpoint, press **"Try it out"**, fill in any parameters and press **"Execute"**. Swagger then shows the corresponding CURL command, the request URL and the response body.

The endpoints are grouped by entity: AOPs (`/v1/aops`), key events (`/v1/key-events`), key event relationships (`/v1/kers`), molecular initiating events (`/v1/mies`), adverse outcomes (`/v1/aos`), stressors, chemicals and genes, plus a free-text search (`/v1/search`). Most entities also have related-data endpoints, for example `/v1/aops/{aop_id}/key-events` or `/v1/chemicals/{cas}/aops`.

## Requests and responses

Every list endpoint returns JSON with three parts: `data` (the results), `meta` (the total number of results, the `limit` and `offset` used, and the dataset version) and `links` (URLs for the next and previous pages). By default you get 100 results per request; use `limit` (up to 1000) and `offset` to page through larger sets. Add `format=csv` to any request to get CSV instead.

The data is refreshed weekly from the AOP-Wiki XML release. The `X-Dataset-Version` response header and `meta.dataset_version` tell you which release you are looking at.

## External access to the API

The API can be called from any HTTP client. CURL is a command-line tool for transferring data over HTTP, and the same requests can be made from coding environments such as Python and R. Below are examples of the most basic call, which retrieves all AOPs with their ID and title, using CURL, Python and R.

### Using CURL
```bash
curl "https://aopwiki.rdf.bigcat-bioinformatics.org/api/v1/aops?limit=1000&format=csv"
```

### Using the API in Python
Python's **requests** library makes it simple to interact with REST APIs. Below is an example of how to use Python to make a GET request to the AOP-Wiki API.

```python
import requests

url = "https://aopwiki.rdf.bigcat-bioinformatics.org/api/v1/aops"
response = requests.get(url, params={"limit": 1000})

if response.status_code == 200:
    result = response.json()
    print(f"{result['meta']['total']} AOPs")
    for aop in result["data"][:5]:
        print(aop["id"], aop["title"])
else:
    print(f"Failed to retrieve data: {response.status_code}")
```

### Using the API in R
R users can use the **httr** package to interact with the AOP-Wiki API.
```R
library(httr)

url <- "https://aopwiki.rdf.bigcat-bioinformatics.org/api/v1/aops"

response <- GET(url, query = list(limit = 1000))

if (status_code(response) == 200) {
  result <- content(response, "parsed")
  print(result$meta$total)
  print(sapply(result$data, function(aop) aop$title)[1:5])
} else {
  print(paste("Failed to retrieve data:", status_code(response)))
}
```

### Earlier query URLs
The API replaces an earlier grlc-based version. Its query URLs, such as `/api-git/marvinm2/AOPWikiQueries/get-all-aops`, still work under the new address (`https://aopwiki.rdf.bigcat-bioinformatics.org/api/api-git/marvinm2/AOPWikiQueries/get-all-aops`), but they are deprecated. New code should use the `/v1/` endpoints.

## Conclusion
This tutorial has provided a brief introduction to using the AOP-Wiki API through the Swagger interface, CURL, Python and R. For any suggestions, requests, bugs, or questions, feel free to file an issue at [github.com/marvinm2/AOP-Wiki-API/issues](https://github.com/marvinm2/AOP-Wiki-API/issues).
