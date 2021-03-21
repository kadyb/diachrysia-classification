# Diachrysia classification
This repository contains the data, code, and results for “*How spectral properties and machine learning can categorize twin species - based on Diachrysia genus*” article.

## Dataset
There are two datasets in the `data` directory - the first containing legislative information on moths (`Legislative`), the second containing the measured spectra (`Spectra`).
The files are available in two formats - `.csv` and `.xlsx`.

`Legislative` file contains the following columns:
- **ID** - Individual identifier (*species*-*number*)
- **Species** - *Diachrysia chrysitis* or *Diachrysia stenochrysis*
- **Sex** - *Male* (♂) or *Female* (♀)
- **Year_catch** - year of the moth catch
- **Day_catch** - day of the year when the moth was caught 
- **Locality** - place where the moth was caught
- **UTM_code** - zone in UTM coordinate system
- **Longitude** - east–west position in degrees
- **Latitude** - north–south position in degrees
- **Feature_level** - level of marking the morphological feature, where 1 means weak, 2 means strong, 3 means very strong

`Spectra` file contains the following columns:
 - **ID** - Individual identifier (*species*-*number*)
 - **Species** - *Diachrysia chrysitis* or *Diachrysia stenochrysis*
 - **Scale** - part of the scale on which the spectrometer measurement was made (*Glass* or *Brown*)
 - **400-2100** - spectral band number

## Reproduction
1. Open the `diachrysia-classification.Rproj` project file in [RStudio](https://rstudio.com/).
2. Run `01_randomforest.R` to build classification models, assess the performance of classification at the general and individual level and determine the importance of spectral features.
3. Run `02_KS_test.R` to determine importance of the spectral bands for species discrimination using Kolmogorov–Smirnov test.
4. Run `03_LDA_best_features.R` to determine the most useful spectral bands for species classification using Linear Discriminant Analysis and D-statistic.
5. Run `04_LDA_combinations.R` to determine the minimum set of spectral features to distinguish species with 100% accuracy.

## Results
The code results were saved in `results` directory:
- `ks-test.csv` - importance of the spectral bands for species discrimination determined by D-statistic
- `rf-importance.csv` - average importance of the spectral features for classification in the random forest models
