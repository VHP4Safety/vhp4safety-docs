# QSPRpred App: Predicting Molecular Initiating Event Activation based on chemical structure

**Linde Schoenmaker**

The QSPRpred app offers users a tool to predict the activity of their chemicals of interest for various molecular initiation events (MIEs) from the VHP4Safety case studies. Specifically, it can be used to perform hazard identification for;

* chemical-induced Parkinson's disease (via binding to the metabotropic glutamate receptors)
* thyroid-mediated neurodevelopmental toxicity (via binding to the thyroid hormone receptors)

This prediction is done by target-specific, pretrained QSAR models. QSAR models are machine learning models trained to predict properties of chemicals. These models were trained on curated datasets from the Papyrus database <a href="https://link.springer.com/article/10.1186/s13321-022-00672-x" target="_blank">(more information Papyrus)</a>.

Depending on the model the readout is either a numeric value or an activity class (active/inactive). In both cases the endpoint is based on the pChEMBL value <a href="https://chembl.gitbook.io/chembl-interface-documentation/frequently-asked-questions/chembl-data-questions#what-is-pchembl" target="_blank">(more information pChEMBL)</a>. This is a negative logarithmic measure for activity and translates to a concentration of 10^-pchembl for a half maximal response. For example, an IC50 measurement of 1nM would have a pChEMBL value of 9. More information about each model can be found in the QMRF document.


## Model Selection and Inputs

- The app’s initial interface allows users to:
  - select a model  
  - specify the chemical(s) of interest (Figure 1)

- Each model box displays key model characteristics.

- A full model description is provided as a QMRF, including:
  - general information  
  - endpoint  
  - algorithm  
  - domain of applicability  
  - goodness-of-fit  
  - predictivity  
  - interpretation  
  - miscellaneous information

- Molecules can be input in two ways:
  - as comma-separated SMILES strings  
  - via a CSV file containing a **“SMILES”** column
  - <a href="https://www.daylight.com/dayhtml/doc/theory/theory.smiles.html" target="_blank">(more information SMILES)</a>

<img src='interface_models.png' alt="drawing" width='500' height='500'>

*Figure 1: User Interface of the QSPRpred App. The user can select between TRbeta (selected) and TRalpha models and input the desired chemical(s) as SMILES strings.*

## Predict MIE

- After selecting a model, the user can start the prediction by clicking **Run Prediction**.
  - This executes the chosen QSAR model(s) and produces activity predictions.
  - Along with the prediction value, an indication of the **domain of applicability** is always shown.

- Additional details are available under the **Comprehensive output** tab, including:
  - information on the nearest neighbor from the training set  
  - its structure  
  - similarity to the input molecule  
  - measured value  
  - source(s)

- Each prediction is also accompanied by a **QPRF document**, which includes:
  - information about the input substance  
  - the model used  
  - the prediction  
  - the input  
  - applicability domain  
  - reliability  
  - (all model-available information is pre-filled, though the document is not fully completed)

- The QPRF is intended to support the user by summarizing and documenting key information about QSAR predictions.

## References

 - <a href="https://chemrxiv.org/engage/chemrxiv/article-details/6926d27065a54c2d4abc69f9" target="_blank">(preprint article about model for chemical-induced Parkinson's disease)</a>
  - <a href="https://lindeschoenmaker.github.io/" target="_blank">(practice exercises)</a>
