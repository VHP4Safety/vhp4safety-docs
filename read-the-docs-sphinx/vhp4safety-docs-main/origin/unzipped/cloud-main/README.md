# VHP4Safety Cloud

Repository to document the services on the VHP4Safety Cloud, see this [index](docs/index.md)
or the [online website](https://vhp4safety.github.io/cloud/).

## Adding new services

* copy the `docs/services/cdkdepict.md` file and adapt the content to the new service
  * update the content 
  * update [the Bioschemas metadata](https://bioschemas.org/profiles/ComputationalTool/1.0-RELEASE)
* add a new link to the `sitemap.xml` file
* add an item in `docs/index.md` (if included in our clooud)

After the page is online:

* test the Bioschemas annotation with https://validator.schema.org/

Example Bioschemas annotation:

```json
{
  "@context": "https://schema.org/",
  "@type": "SoftwareApplication",
  "http://purl.org/dc/terms/conformsTo": {
      "@type": "CreativeWork", "@id": "https://bioschemas.org/profiles/ComputationalTool/1.0-RELEASE"
  },
  "@id" : "https://vhp4safety.github.io/cloud/service/aopwiki",
  "name": "AOP-Wiki Snorql UI", 
  "description": "Graphical interface to an AOP-Wiki SPARQL endpoint.",
  "url": "https://aopwiki.cloud.vhp4safety.nl/"
}
```
