# QSPRpred App: Predicting Molecular Initiating Event Activation based on chemical structure

**Linde Schoenmaker**

The QSPRpred app offers users a tool to predict the activity of their chemicals of interest for various molecular initiation events (MIEs) from the VHP4Safety case studies. This prediction is done by target-specific, pretrained QSAR models. QSAR models are machine learning models trained to predict properties of chemicals. These models were trained on curated datasets from the Papyrus database.

Depending on the model the readout is either a numeric value or an activity class (active/inactive). In both cases the endpoint is based on the pChEMBL value. This is a negative logarithmic measure for activity and translates to a concentration of 10^-pchembl for a half maximal response. For example, an IC50 measurement of 1nM would have a pChEMBL value of 9. More information about each model can be found in the QMRF document.


## Model Selection and Inputs

The app's initial interface allows users to select a model and specify the chemical(s) of interest (Figure 1). Key model characteristics are shown in each model box. A full description accompanies each model, in the form of a QMRF (a data format intended for summarising and reporting key information on (Q)SAR models) detailing general information, endpoint, algorithm, domain of applicability, goodness-of-fit, predictivity, interpretation and miscellaneous information. Molecules can be either inputted as comma separated SMILES string or using a csv file with a column "SMILES".

![Interface Models](interface_models.png)

_Figure 1: User Interface of the QSPRpred App. The user can select between TRbeta (selected) and TRalpha models and input the desired chemical(s) as SMILES strings._

## Predict MIE

Once the model is selected, the user can initiate the prediction by clicking the *Run Prediction* button. This triggers the execution of the selected QSAR model(s) and generates activity predictions. In addition to the prediction value an indication of the domain of applicability is also always shown. For more information the user can navigate to the "Comprehensive output" tab. Here information on the nearest neighbor from the training set is given; its structure, similarity to the input molecule, measured value and source(s). Furthermore, each prediction is accompanied by a QPRF document (a data format intended for summarising and reporting key information on QSAR model predictions). This document gives information about the input substance, model used, prediction, input, applicability domain and reliability. All information available to the model will be pre-filled out. This document is intended to aid the user but will not be completely filled out.
