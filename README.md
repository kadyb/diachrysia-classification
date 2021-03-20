## Diachrysia moths classification using spectroscopy and machine learning

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
