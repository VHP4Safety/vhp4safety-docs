
# **cpLogD**: Predicting Water–Octanol Distribution Coefficient (logD) for Chemical Compounds

## Introduction

cpLogD<sup>1</sup> provides a model to predict water–octanol distribution coefficient (logD) for chemical compounds, a proxy for the lipophilicity which is a major determinant of drug properties and overall suitability of drug candidates.

The model is based on data for 1.6 million compounds from the ChEMBL database with available predicted values for ACD/logD. For modeling, a support-vector machine with a linear kernel using conformal prediction methodology was used, outputting prediction intervals at a specified confidence level. Features for chemical structures were Signature Molecule Descriptor calculated with Chemistry Development Kit<sup>2</sup>.

In this tutorial, we show an example to derive an logD prediction for [caffeine](https://cdkdepict.cloud.vhp4safety.nl/depict.html) using its [SMILES](https://en.wikipedia.org/wiki/Simplified_molecular-input_line-entry_system).


## Using cpLogD through a Web Browser

In order to get a depiction of the prediction with a confidence level, one needs to supply at least two parameters:

1. The SMILES for the compound;
2. The confidence level;
3. Width of the image file of the depiction (optional);
4. Height of the image file of the depiction (optional)

In this example, we will use the SMILES for the caffeine, `CN1C=NC2=C1C(=O)N(C(=O)N2C)C`, and the confidence level of `0.7`. 

The (VHP4Safety instance of) API of cpLogD is available at [cplogd.cloud.vhp4safety.nl/api/v2/](https://cplogd.cloud.vhp4safety.nl/api/v2/) (although note that this link does not provide a user interface). Furthermore, one needs to add the term `predictImage` to the URL to derive an image file, so the URL to be used will be `https://cplogd.cloud.vhp4safety.nl/api/v2/predictImage`. Finally, one needs to modify the URL specifically for their request with the parameters they have. 

First, one needs to add the first parameter, the SMILES, to the URL. As aforementioned, in this example, we use `CN1C=NC2=C1C(=O)N(C(=O)N2C)C`. The SMILES needs to be URL-encoded, that is, it cannot be used directly. The encoding can be made by using an URL encoder (see [www.urlencoder.org](https://www.urlencoder.org/) as an example). After the encoding the SMILES will look like `CN1C%3DNC2%3DC1C%28%3DO%29N%28C%28%3DO%29N2C%29C` (see below for an example using the `www.urlencoder.org`). This URL encoded SMILES needs to be added to the URL after `?molecule` parameter. So, the URL will look like `cplogd.cloud.vhp4safety.nl/api/v2/predictImage?molecule=CN1C%3DNC2%3DC1C%28%3DO%29N%28C%28%3DO%29N2C%29C`. Please note that there is a `=` between the parameter name and its value.

<img src='https://raw.githubusercontent.com/VHP4Safety/cloud/main/docs/tutorials/cplogd/urlencoder_example.png' alt="drawing" width='500' height='500'>

Second, the confidence level parameter needs to be added to the URL. This is done by adding first `&` to the URL to indicate another parameter to be added which will be followed by the parameter name `confidence`. Then, one can enter a value for the confidence level parameter followed by a `=`, e.g., `confidence=0.7` where the confidence level is set to 0.7. Therefore., the URL finally will be `cplogd.cloud.vhp4safety.nl/api/v2/predictImage?molecule=CN1C%3DNC2%3DC1C%28%3DO%29N%28C%28%3DO%29N2C%29C&confidence=0.7`. When the URL is entered in a web browser, it should display an image of the compound with a confidence level as below.

<img src='https://raw.githubusercontent.com/VHP4Safety/cloud/main/docs/tutorials/cplogd/caffeine_example.png' alt="drawing">

Finally, the image can be resized by the user by using the last two optional parameters. For instance, the image can be resized to 400 pixels to 400 pixels by using the `imageWidth` and `imageHeight` parameters in the URL. Then, the URL will be `cplogd.cloud.vhp4safety.nl/api/v2/predictImage?molecule=CN1C%3DNC2%3DC1C%28%3DO%29N%28C%28%3DO%29N2C%29C&confidence=0.7&imageWidth=400&imageHeight=400`.


### References

1. Lapins, M., Arvidsson, S., Lampa, S. *et al.* A confidence predictor for logD using conformal regression and a support-vector machine. J Cheminform **10**, 17 (2018). [https://doi.org/10.1186/s13321-018-0271-1](https://doi.org/10.1186/s13321-018-0271-1)
2. [SciLifeLab instance](https://serve.scilifelab.se/models/1)