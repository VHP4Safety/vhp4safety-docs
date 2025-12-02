# AOP Suite Tutorial

A web-based tool for building, visualizing and analyzing Adverse Outcome Pathway (AOP) networks.
Designed for toxicologists who need direct access to AOP-Wiki content for exploratory or analysis workflows
without using code or having to navigate the AOP-Wiki.

---

## 1. Introduction

Adverse Outcome Pathways describe how a chemical interaction at the molecular level (Molecular Initiating Event)
progresses through measurable biological changes (Key Events) to produce an Adverse Outcome.  
AOP knowledge is available through static AOP-Wiki pages or the AOP-Wiki RDF endpoint, but these 
sources do not provide integrated, ready-to-use visualizations or network structures.

AOP Suite addresses this gap. It provides a single interface for querying AOP-Wiki, exploring AOPs through
text search, assembling them into networks and exporting them for downstream analysis.  
It uses:

- **pyAOP** to handle queries and data transformations  
- **AOP-Wiki RDF SPARQL endpoint** for retrieving AOP content

---

## 2. Accessing the Tool

- Browser version: **https://aopsuite.cloud.vhp4safety.nl**  
- Docker deployment: Source code available at **https://github.com/VHP4Safety/AOP-Suite**

No installation is needed for the web version.

---

## 3. Tool Functionalities

---

### 3.1 Free-Text Search of AOPs, MIEs and AOs

**Purpose**  
Search the AOP-Wiki content without navigating the website or writing SPARQL queries.

**How it works**  
The tool converts your free text into a query to the AOP-Wiki RDF endpoint. 
It returns matching AOPs, MIEs or AOs and displays them as lists or network-ready nodes.

**How to use it**  
1. Open the tool.  
2. Go to the **Search** panel.  
3. Enter any term (e.g. “oxidative stress”).  
4. Select whether to search AOPs, MIEs or AOs.  
5. Review the returned table of hits.  
6. Add selected items to your project.

**Example use case**  
Query for any AOP related with Thyroid:
<img width="403" height="497" alt="image" src="https://github.com/user-attachments/assets/d0ec8bb1-0c4a-4a92-b3e2-cb79ac909247" />
And click on `Add to Network`:
<img width="1334" height="740" alt="image" src="https://github.com/user-attachments/assets/b2358951-3004-4bca-806d-7e4bd7fa4b8a" />

---

### 3.2 Building AOP Networks

**Purpose**  
Assemble selected AOPs and Key Events into a visual network.

**How it works**  
The tool retrieves all relationships between selected Key Events and arranges them as directed links
forming an AOP graph.

**How to use it**  
1. After selecting AOPs or KEs from search results, add them to the project.  
2. The tool constructs the network automatically.  
3. Rearrange nodes manually if needed using drag-and-drop.  

**Example use case**  
Screen all AOPs stemming from Thyroid receptor antagonism:
<img width="200" alt="image" src="https://github.com/user-attachments/assets/c2b1b199-dc04-473d-8d36-3f22268acfda" />
<img width="600" alt="image" src="https://github.com/user-attachments/assets/a0d94ca6-34bb-4cf5-8ef4-aeb00c8d6bc2" />
Then look for other MIEs and connected KEs leading to the Cognitive function, decreased AO:
<img width="200" alt="image" src="https://github.com/user-attachments/assets/3b6d6a03-4740-48e7-b758-4267b85c1882" />
Which results in an expanded network:
<img width="600" alt="image" src="https://github.com/user-attachments/assets/d660f9dc-b84d-4817-b96a-6d4e55713c47" />


---

### 3.3 Enriching Networks with External Data

**Purpose**  
Add organ information, developmental stage expression and related molecular entities.

**How it works**  
The tool connects to third-party databases (via pyAOP integrations) and annotates relevant nodes in the network.

**How to use it**  
1. Open the project network.  
2. Activate the **Enrichment** panel.  
3. Select the data types you want to load (organ links, processes, genes).  
4. The tool adds annotations or new nodes where available.  
5. Inspect enriched nodes directly in the network or table view.

**Example use case**  
Identify genes, organs and components associated with a Key Event: click on the KE and on the respective buttons.
<img width="600" alt="image" src="https://github.com/user-attachments/assets/c5d75e23-4773-4f04-bf1d-d4eb0dcee018" />
The tables are also updated:
<img width="6002" alt="image" src="https://github.com/user-attachments/assets/0c74647f-4a2e-4839-928a-ae4283f97052" />


---

### 3.4 Project Management

**Purpose**  
Keep AOP searches, selected nodes and networks grouped in a reproducible session.

**How it works**  
A project stores all queries, imported AOP elements and network states. The tool tracks all actions and can generate a Python script replicating them.

**How to use it**  
1. Create a project when starting work.  
2. Perform searches, selections and network building.  
3. Everything is saved automatically.  
4. Export the network or script when finished.

<img width="600" alt="image" src="https://github.com/user-attachments/assets/ab77d056-139e-4d8b-a601-d16dae58c4c2" />


---

### 3.5 Exporting Results

**Purpose**  
Download networks and tables in formats compatible with standard analysis tools.

**How it works**  
The tool converts internal network objects into formats used by Cytoscape, NDEx, RDF tools or Python workflows.

**How to use it**  
1. Open the **Export** tab.  
2. Choose the desired format:  
   - RDF  
   - Cytoscape  
   - NDEx  
   - Python script  
3. Download the file.

**Example use case**  
Open the network in Cytoscape for layout refinement.

---

## 4. Interpreting the Output

**Outputs**  
- Tables of AOPs, compound interactions, gene expression levels
- Visual network graphs  
- Enrichment annotations (organs, processes, genes)  
- Export files (RDF, NDEx, Cytoscape, Python, queries)

**Meaning of each element**  
- **Node**: An AOP, MIE, KE AO, Gene, Organ, Process, Cell...  
- **Edge**: A documented relationship between nodes
- **Annotations**: External database links for biological context  
- **Generated script**: Step-by-step reproduction of your session

**Interpretation in risk assessment workflows**  
- Use networks to identify relevant biological progressions.  
- Compare enriched nodes with existing toxicity datasets.  
- Use organ and gene annotations to evaluate mechanistic plausibility.

**Caveats**  
- Dependent on completeness of AOP-Wiki, which is constantly evolving.
- External enrichment only appears where mappings exist.  
- Networks reflect curated AOP structure; not predictive models.  
- Visual layout is manual; interpretation does not depend on layout.

---

## 5. Summary / Conclusion

AOP Suite enables direct exploration of AOP-Wiki content, building of AOP networks and biological enrichment without technical skills.
It is most useful during the exploratory phase of hazard assessment when screening pathways, identifying biologically
relevant events or preparing networks for further computational analysis.

Strengths:  
- No coding required  
- Immediate visualization  
- Integrated enrichment  
- Reproducible exports
- Import exports into Cytoscape or NDEx for further analysis  
- (Re)use the generated Python scripts for automated pipelines  
- Review pyAOP and AOP-Wiki RDF documentation for deeper integration  
