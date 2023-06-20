Information about chemicals
===========================

This tutorial explains how to use a few of the VHP4Safety services to aggregate information
about a chemical of interest.

Let's start with the compound with the name "aflatoxin B1".

Name to Structure
-----------------

The first task we have is to establish a chemical identity of what we mean with
"aflatoxin B1". That is, what is the chemical structure. This common task is the
starting point of most cheminformatics workflows: the resolve the chemical
structure from a chemical name. That is, a name to structure conversion.

There are many solutions available, including the main chemical compounds databases
like PubChem and ChemSpider. Because we want to use a common VHP4Safety language (a controlled vocabulary or
`glossary`_), we can also use a VHP4Safety solution for this task.

.. _glossary: https://glossary.vhp4safety.nl/

For this, we have set up a service to link specific chemical structures to
names and external databases, the VHP4Safety Wikibase.

Step 1
^^^^^^

Visit `the compound wiki`_ and use the search box to find
"aflatoxin B1". The `resulting page`_ should look something like this:

.. _the compound wiki: https://compoundcloud.wikibase.cloud/
.. _resulting page : https://compoundcloud.wikibase.cloud/wiki/Item:Q1


.. image:: ./Q1.png
   :alt: screenshot of aflatoxin B1 in the compound wiki

Step 2
^^^^^^

On this page we can find chemical information and links to other database.
Information we can find include:

* the SMILES: a line notation to describe the chemical structure (using a chemical graph approach)
* the mass
* the InChI and InChIKey: the global, unique identifier of this compound

Write down the SMILES, which we are going to use in the next section.

Second, we find external identifiers and links to resources with more information
about this compound. For example, for this compound we find a link to the
ToxBank Wiki (doi:`10.1002/minf.201200114`_) where the SEURAT-1 cluster projects collected information
about compounds in their discussion to reach their Gold Compound collection.

.. _10.1002/minf.201200114: https://doi.org/10.1002/minf.201200114

Other information we can find:

* the Wikidata Q identifier: a link to Wikidata
* the PubChem CID: a link to PubChem
* xenobiotic metabolism pathway: a link to a WikiPathways describing experimental knowledge about the compound metabolism

Visualize a Structure
---------------------

With the SMILES you got from the compound wiki, you can now visualize this
with the `CDK Depict`_ service.

.. _CDK Depict: https://cdkdepict.cloud.vhp4safety.nl/

Step 3
^^^^^^

Copy/paste the SMILES into the text box and wait for CDK Depict to make a 2D depiction:

.. image:: cdkdepict_vhp.png
   :alt: 2D depictiong of the chemical structure of aflatoxin B1

Note that you can change the depiction style/properties. For example, you can choose to not
abbreviate long chains:

..  image:: cdkdepict_vhp2.png
    :alt: option to do not abbreviate groups

Or to show the CIP R/S labels:

.. image:: cdkdepict_vhp3.png
   :alt: option for R/S labelling

External databases
------------------

Back in the wikibase, we can find links to other databases. The compound
wiki provides links to the following databases. For each we can list the chemical
compounds that have links to those resources:

- ToxBank: general toxicology info (`all ToxBank compounds`_)
- WikiPathways: compound metabolism (`all WikiPathways compounds`_)

.. _all ToxBank compounds: https://compoundcloud.wikibase.cloud/query/#PREFIX%20wd%3A%20%3Chttps%3A%2F%2Fcompoundcloud.wikibase.cloud%2Fentity%2F%3E%0APREFIX%20wdt%3A%20%3Chttps%3A%2F%2Fcompoundcloud.wikibase.cloud%2Fprop%2Fdirect%2F%3E%0A%0ASELECT%20%3Fcmp%20%3FcmpLabel%20%3Fpubchem%20%3Ftoxbank%0A%20%20%20%20%20%20%20%28GROUP_CONCAT%28DISTINCT%20%3FroleLabel%3B%20separator%3D%22%2C%20%22%29%20AS%20%3Froles%29%0AWHERE%20%7B%0A%20%20%3Fcmp%20wdt%3AP13%20%3Fpubchem%20%3B%20wdt%3AP4%20%3Ftoxbank%20.%0A%20%20OPTIONAL%20%7B%20%3Fcmp%20wdt%3AP17%20%3Frole%20.%20%3Frole%20rdfs%3Alabel%20%3FroleLabel%7D%0A%20%20SERVICE%20wikibase%3Alabel%20%7B%20bd%3AserviceParam%20wikibase%3Alanguage%20%22%5BAUTO_LANGUAGE%5D%2Cen%22.%20%7D%0A%7D%20GROUP%20BY%20%3Fcmp%20%3FcmpLabel%20%3Fpubchem%20%3Ftoxbank
.. _all WikiPathways compounds: https://compoundcloud.wikibase.cloud/query/#PREFIX%20wd%3A%20%3Chttps%3A%2F%2Fcompoundcloud.wikibase.cloud%2Fentity%2F%3E%0APREFIX%20wdt%3A%20%3Chttps%3A%2F%2Fcompoundcloud.wikibase.cloud%2Fprop%2Fdirect%2F%3E%0A%0ASELECT%20%3Fcmp%20%3FcmpLabel%20%3Fxenometabolism%0A%20%20%28CONCAT%28%22https%3A%2F%2Fwikipathways.org%2Finstance%2F%22%2C%20str%28%3Fxenometabolism%29%29%20AS%20%3FxenometabolismURL%29%0AWHERE%20%7B%0A%20%20%3Fcmp%20wdt%3AP13%20%3Fpubchem%20%3B%20wdt%3AP19%20%3Fxenometabolism%20.%0A%20%20SERVICE%20wikibase%3Alabel%20%7B%20bd%3AserviceParam%20wikibase%3Alanguage%20%22%5BAUTO_LANGUAGE%5D%2Cen%22.%20%7D%0A%7D%20GROUP%20BY%20%3Fcmp%20%3FcmpLabel%20%3Fxenometabolism

Step 4
^^^^^^

Visit WikiPathways and check the human metabolism of "aflatoxin B1".
The resulting page should look like this:

.. image:: WP699.png

These resources can provide important information, but for new compounds
you mean also need computationally predicted properties. The platform
support this. The following section uses the SOMBIE tool, that predicts
site-of-metabolism properties, starting with the SMILES we get from the
compound wiki.

Identifier Mapping
------------------

The compound wiki also lists a PubChem Compound Identifier ("cid").
The BridgeDb webservice can convert this to identifiers from other
database.

Step 5
^^^^^^

The BridgeDb Webservice has an API call where you can request other
identifiers ("xrefs") for a PubChem CID identifier with the following URL 
pattern: https://bridgedb.cloud.vhp4safety.nl/Human/xrefs/Cpc/186907

Click the link and check in what other databases information is provided
for "aflatoxin B1". The output should look something like this:

.. code-block::

   C00000546	KNApSAcK
   CHEBI:2504	ChEBI
   C06800	KEGG Compound
   DTXSID00873175	EPA CompTox
   186907	PubChem-compound
   OQIQSTLJSLGHID-WNWIJWBNSA-N	InChIKey
   CHEMBL1697694	ChEMBL compound
   DTXSID9020035	EPA CompTox
   1162-65-8	CAS
   162470	Chemspider
   Q4689278	Wikidata
   HMDB0006552	HMDB
   2504	ChEBI
   HMDB06552	HMDB

Metabolite prediction
---------------------

... SOMBIE todo

